###############################################################
###  FULLY INTEGRATED SIMNIBS TMS + J-FIELD + B-FIELD + 3D  ###
###############################################################

import os
import glob
import json
from pathlib import Path
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
import meshio
import pyvista as pv
from simnibs import sim_struct, run_simnibs
from simnibs.mesh_tools.mesh_io import read_msh
from simnibs.simulation.biot_savart import calc_B
from simnibs.mesh_tools import mesh_io
import simnibs
from scipy.spatial import cKDTree

################################################################
# Load config
################################################################
with open("D:/psymulator/TMS_Simul_Matlab_SimNIBS/SimNIBS/config.json", "r") as f:
    config = json.load(f)

################################################################
# 1. Prepare SimNIBS simulation
################################################################
S = sim_struct.SESSION()
m2m_dir = Path(config["m2m_path"])
S.subpath = m2m_dir
# REQUIRED for TMS simulation (this is the tetrahedral mesh!)
S.fnamehead = str(m2m_dir / "ernie.msh")
S.pathfem = 'tms_simu'
S.fields = 'eEjJ'   # <— J-field requested

tms = S.add_tmslist()
tms.fnamecoil = os.path.join(Path(config["tcd_coils"]), 'Coilkirlia_5A.tcd')

pos = tms.add_position()
pos.pos_ydir = [1.0, 0.0, 1.0]
pos.distance = -17.4
pos.centre   = [19, 5, 80]
pos.didt     = 337.8378

################################################################
# 2. Run the simulation
################################################################
run_simnibs(S)
# Robust loader + B-from-centroids block
def choose_msh_file(outdir):
    # prefer explicit scalar.msh in tms_simu; ignore .msh.opt
    files = glob.glob(os.path.join(outdir, "*.msh"))
    # remove .msh.opt entries (they may appear if named that way)
    files = [f for f in files if not f.endswith(".msh.opt")]
    if not files:
        raise FileNotFoundError("No .msh files found in " + outdir)
    # prefer scalar.msh if present
    for f in files:
        if "scalar" in os.path.basename(f).lower():
            return f
    # otherwise return first .msh
    return files[0]

# 1) pick the .msh (not .msh.opt)
simulation_file = choose_msh_file(S.pathfem)
print("Using mesh file:", simulation_file)

# 2) try to read it
m = mesh_io.read_msh(simulation_file)
print("Read mesh OK. Fields:", list(m.field.keys()))

# 3) get node coordinates
# try common attributes
try:
    nodes = np.asarray(m.nodes)  # sometimes this works
except Exception:
    # try attributes used by some simnibs builds
    try:
        nodes = np.asarray(m.nodes.node_coord)
    except Exception:
        raise RuntimeError("Cannot obtain node coordinates from mesh object.")

print("Nodes shape:", nodes.shape)

# 4) get tetrahedra (try several extraction methods)
def extract_tets_from_mesh(m):
    # method A: m.elm.elm_data blocks (SimNIBS 4.x style)
    try:
        if hasattr(m.elm, "elm_data") and m.elm.elm_data is not None:
            for block in m.elm.elm_data:
                # Gmsh type 4 == tetra in Gmsh v2
                if block.get("elm_type", None) in (4, "4"):
                    tets = np.asarray(block["nodes"], dtype=np.int64)
                    # convert to 0-based if appears 1-based
                    if tets.min() > 0:
                        tets = tets - 1
                    return tets
    except Exception as e:
        print("elm_data route failed:", e)

    # method B: attribute m.tetra or m.elm.tetra (older/other API)
    try:
        if hasattr(m, "tetra"):
            t = np.asarray(m.tetra, dtype=np.int64)
            if t.size and t.ndim == 2:
                if t.min() > 0:
                    t = t - 1
                return t
        if hasattr(m.elm, "tetra"):
            t = np.asarray(m.elm.tetra, dtype=np.int64)
            if t.size and t.ndim == 2:
                if t.min() > 0:
                    t = t - 1
                return t
    except Exception as e:
        print("m.tetra / m.elm.tetra route failed:", e)

    # method C: indexing_nr or node_number arrays
    try:
        # some builds store indexing_nr as shape (nElements, nodes_per_element)
        if hasattr(m.elm, "indexing_nr"):
            arr = np.asarray(m.elm.indexing_nr, dtype=np.int64)
            if arr.ndim == 2:
                if arr.min() > 0:
                    arr = arr - 1
                # try to detect tetra (4 columns)
                if arr.shape[1] == 4:
                    return arr
        if hasattr(m.elm, "node_number"):
            arr = np.asarray(m.elm.node_number, dtype=np.int64)
            if arr.ndim == 2:
                if arr.min() > 0:
                    arr = arr - 1
                if arr.shape[1] == 4:
                    return arr
    except Exception as e:
        print("indexing_nr / node_number route failed:", e)

    # nothing found
    return None

tets = extract_tets_from_mesh(m)
if tets is None:
    # If no tets in scalar.msh, try using the original head mesh (ernie.msh)
    head_msh = os.path.join(S.subpath, "ernie.msh")
    if os.path.exists(head_msh):
        print("No tets in scalar.msh — trying original head mesh:", head_msh)
        m_head = mesh_io.read_msh(head_msh)
        tets = extract_tets_from_mesh(m_head)
        if tets is None:
            raise RuntimeError("No tetrahedra found in head mesh either.")
        else:
            # use nodes from head mesh
            nodes = np.asarray(m_head.nodes)
            print("Using head mesh nodes and tetrahedra.")
    else:
        raise RuntimeError("No tetrahedra found and head mesh not available.")

print("Tetra count:", tets.shape[0])

# 5) obtain J ElementData (volume) if present
J_field_name = None
for k in m.field.keys():
    if "j" in k.lower():
        J_field_name = k
        break

if J_field_name is None:
    # maybe scalar.msh contained surface fields; check .opt or head outputs
    print("No J field in", simulation_file, ". Searching for other .msh in directory...")
    # look for any other .msh (maybe volume result)
    for f in glob.glob(os.path.join(S.pathfem, "*.msh")):
        if f == simulation_file:
            continue
        try:
            mm = mesh_io.read_msh(f)
            if any("j" in kk.lower() for kk in mm.field.keys()):
                m = mm
                J_field_name = next(kk for kk in mm.field.keys() if "j" in kk.lower())
                print("Found J in fallback file:", f)
                break
        except Exception:
            continue

if J_field_name is None:
    raise RuntimeError("Could not find any J field across .msh files in " + S.pathfem)

print("Using J field:", J_field_name)
J_elementdata = m.field[J_field_name]

# convert element data to numpy array
try:
    J_vals = np.array(J_elementdata.value)
except Exception:
    try:
        J_vals = np.asarray(J_elementdata)
    except Exception as e:
        raise RuntimeError("Cannot convert J ElementData to numpy: " + str(e))

# reshape if flat
if J_vals.ndim == 1:
    if J_vals.size % 3 != 0:
        raise RuntimeError("J vector length not divisible by 3")
    J_vals = J_vals.reshape(-1, 3)

print("J_vals shape:", J_vals.shape)

# If number of J elements equals number of tets -> good
if J_vals.shape[0] == tets.shape[0]:
    print("J provided per tetrahedron.")
    J_per_tet = J_vals
else:
    # maybe J is per surface element; we will map to tetrahedron centroids (nearest)
    print("J length differs from tetra count: J_len=", J_vals.shape[0], "n_tets=", tets.shape[0])
    # compute centroids
    tet_coords = nodes[tets]
    centroids = tet_coords.mean(axis=1)
    # get element positions where J was defined (try reading element centers of m if possible)
    # For surface J, extract element barycenters from m.elm data where element type is triangle (2)
    surface_centers = None
    for block in getattr(m.elm, "elm_data", []):
        if block.get("elm_type", None) in (2, "2"):
            surf_nodes = np.asarray(block["nodes"], dtype=np.int64)
            if surf_nodes.min() > 0:
                surf_nodes = surf_nodes - 1
            surf_centroids = nodes[surf_nodes].mean(axis=1)
            surface_centers = surf_centroids
            break
    if surface_centers is None:
        # fallback: use node coordinates (not ideal)
        surface_centers = nodes
    # build KDTree on surface centers, map each tet centroid to nearest surface element index,
    # then assign that J vector to the tet (nearest neighbour mapping)
    tree = cKDTree(surface_centers)
    dists, idx = tree.query(centroids)
    # if J_vals length equals surface_centers length, good
    if J_vals.shape[0] == surface_centers.shape[0]:
        J_per_tet = J_vals[idx]
        print("Mapped surface J -> tetra via nearest neighbor.")
    else:
        # if mismatch still, try mapping using nodes or fail
        print("Unable to reliably map J to tetrahedra automatically. J len:", J_vals.shape[0], 
              " surface centers len:", surface_centers.shape[0])
        raise RuntimeError("Cannot map J to tetrahedra automatically; inspect file contents manually.")

# 6) compute centroids (if not computed earlier)
tet_coords = nodes[tets]
centroids = tet_coords.mean(axis=1)

# 7) compute B at centroids using your coil and current
coil = simnibs.Coil()
coil.from_file(tms.fnamecoil)
I = 5.0  # set to coil current you used in simulation (A)

print("Computing B at", centroids.shape[0], "centroids (this may take some seconds)...")
B_centroids = calc_B(coil, pts=centroids, current=I)
print("B computed, shape:", B_centroids.shape)

# 8) voxelize into T1 grid (nearest centroid)
reference_file = os.path.join(S.subpath, 'T1.nii.gz')
ref_img = nib.load(reference_file)
affine = ref_img.affine
nvox = ref_img.shape[:3]

X, Y, Z = np.meshgrid(np.arange(nvox[0]), np.arange(nvox[1]), np.arange(nvox[2]), indexing='ij')
vox_coords = np.vstack([X.ravel(), Y.ravel(), Z.ravel(), np.ones(X.size)])
world_coords = (affine @ vox_coords)[:3].T
tree = cKDTree(centroids)
_, idx_vox = tree.query(world_coords)
B_vol_flat = B_centroids[idx_vox]
B_vol = B_vol_flat.reshape(nvox + (3,))

# save
out_file = os.path.join(S.pathfem, "B_from_centroids.nii.gz")
nib.save(nib.Nifti1Image(B_vol, affine), out_file)
print("Saved B voxel file:", out_file)

################################################################
# 7. Show central slice of Bx
################################################################
b_img = nib.load(output_file)
B_data = b_img.get_fdata()
slice_index = B_data.shape[2] // 2

plt.figure(figsize=(8,6))
plt.imshow(B_data[:, :, slice_index, 0].T, origin='lower', cmap='viridis')
plt.title('B-field: X component (central slice)')
plt.colorbar(label='Tesla')
plt.tight_layout()
plt.show()

################################################################
# 8. ---------- 3D VISUALIZATION WITH PYVISTA ----------
################################################################

print("\nLaunching 3D visualization...")

from simnibs.mesh_tools import read_msh

# --- 1) Read the mesh ---
m = read_msh(simulation_file)

# --- 2) Get node coordinates ---
nodes = np.array(m.nodes)

# --- 3) Get tetrahedral elements ---
# In SimNIBS 4.1, the "tets" are usually stored in m.tetra or m.elm
# We'll try m.tetra
try:
    tets = np.array(m.tetra)  # shape (nTets, 4)
except AttributeError:
    raise RuntimeError("Cannot access tetrahedral elements in this SimNIBS mesh.")

# --- 4) Build PyVista connectivity ---
n_tets = tets.shape[0]
cells_pv = np.hstack([
    np.full((n_tets, 1), 4, dtype=np.int64),  # 4 nodes per tetra
    tets.astype(np.int64)
]).flatten()

cell_types = np.full(n_tets, 10, dtype=np.uint8)  # VTK_TETRA = 10

pv_mesh = pv.UnstructuredGrid(cells_pv, cell_types, nodes)

# --- 5) Get J-field ---
J_field_name = None
for k in m.field.keys():
    if k.lower() in ["j", "magnj", "|j|", "jmag", "j_abs"]:
        J_field_name = k
        break

if J_field_name is None:
    raise RuntimeError("Could not find J-field in mesh fields!")

J_data = m.field[J_field_name]
J_array = np.array(J_data.value)
if J_array.ndim == 1:
    J_array = J_array.reshape(-1, 3)

J_magnitude = np.linalg.norm(J_array, axis=1)

# --- 6) Attach J magnitude as cell data ---
if pv_mesh.n_cells == J_magnitude.shape[0]:
    pv_mesh.cell_data["J_magnitude"] = J_magnitude
else:
    print("Warning: number of cells and J elements differ, skipping cell data.")

# --- 7) Visualize ---
pv_mesh.plot(scalars="J_magnitude", cmap="viridis", show_edges=True)

########### 3D (A) — Show |J| on the mesh ############
pv_mesh.cell_data["magnJ"] = magnJ

plotter1 = pv.Plotter(title="|J| magnitude field")
plotter1.add_mesh(
    pv_mesh,
    scalars="magnJ",
    cmap="turbo",
    opacity=0.8,
    show_edges=False
)
plotter1.add_axes()
plotter1.show_grid()
plotter1.show()

########### 3D (B) — Show magnitude of B-field in 3D ############

# Build a PyVista structured grid for B
Bx = B[...,0]
By = B[...,1]
Bz = B[...,2]
Bmag = np.sqrt(Bx**2 + By**2 + Bz**2)

X, Y, Z = np.meshgrid(
    np.arange(nvox[0]),
    np.arange(nvox[1]),
    np.arange(nvox[2]),
    indexing='ij'
)

grid = pv.StructuredGrid(X, Y, Z)
grid["Bmag"] = Bmag.flatten(order="F")

plotter2 = pv.Plotter(title="|B| magnitude field")
plotter2.add_volume(
    grid,
    scalars="Bmag",
    cmap="viridis",
    opacity="sigmoid"
)
plotter2.add_axes()
plotter2.show()

################################################################
print("\nDone.")
################################################################
