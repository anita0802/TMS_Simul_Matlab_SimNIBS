""" How to run a SimNIBS TMS simulation in Python
    Run with:

    simnibs_python TMS.py
    Copyright (C) 2018 Guilherme B Saturnino
"""
import os
import glob
import nibabel as nib
from simnibs import sim_struct, run_simnibs
from simnibs.mesh_tools.mesh_io import read_msh
from simnibs.simulation.biot_savart import calc_B


import json
from pathlib import Path

with open("config.json", "r") as f:
    config = json.load(f)

### General information
S = sim_struct.SESSION()
S.subpath = Path(config["m2m_path"])  # m2m-folder of the subject
S.pathfem = 'tms_simu'  # Directory for the simulation
S.fields = 'eEjJ' #Fields to calculate


## Define the TMS simulation
tms = S.add_tmslist()
tms.fnamecoil = os.path.join('commercial_coils', 'tcd', 'CoilL1_2A.tcd')  # Choose a coil model

# Define the coil position
pos = tms.add_position()
pos.pos_ydir = [1.0,0.0,1.0]  #Orientation of the coil
pos.distance = -17.4  #Distance from coil surface to cortex surface (mm)

pos.centre = [0.0,15.0,99.0]        # SisEstLX
#pos.centre = [0.0,26.497,99.0]      # BobinaL1
#pos.centre = [0.0,22.842,99.0]      # BobinaL2
#pos.centre = [0.0,20.259,99.0]      # BobinaL3
#pos.centre = [0.0,17.7185,99.0]     # BobinaL4
#pos.centre = [0.0,21.551,99.0]      # BobinaL5
#pos.centre = [0.0,16.0035,99.0]     # BobinaL6

#pos.distance = -13.1  #Distance from coil surface to cortex surface (mm)
#pos.distance = -17.4  #Distance from coil surface to cortex surface (mm)
pos.didt = 125.6637061 #Define the value of didt

# Run Simulation
run_simnibs(S)

''' Añadido PGH '''

'''
calc_B_command = f"calc_B -i {simulation_file} -r {reference_file} -o {output_file}"
os.system(calc_B_command)



# -----------------------------------------------------------------------------
# Automatización: buscar el archivo .msh que contiene el campo 'J'
# -----------------------------------------------------------------------------
def find_msh_with_J(directory):
    msh_files = glob.glob(os.path.join(directory, '*.msh'))
    for file in msh_files:
        try:
            m = read_msh(file)
            if 'J' in m.field.keys():
                print("Archivo encontrado:", file)
                return file
        except Exception as e:
            print("Error al leer", file, ":", e)
            continue
    return None

simulation_file = find_msh_with_J(S.pathfem)
if simulation_file is None:
    raise IOError("No se encontró ningún archivo .msh con el campo 'J' en " + S.pathfem)

# -----------------------------------------------------------------------------
# Cálculo del campo magnético (B) usando calc_B
# -----------------------------------------------------------------------------

# Seleccionar la imagen de referencia: se recomienda usar la T1
reference_file = os.path.join(S.subpath, 'T1.nii.gz')
ref_img = nib.load(reference_file)
affine = ref_img.affine
nvox = ref_img.shape
if len(nvox) == 2:
    nvox = nvox + (1,)

# Leer la malla con el campo J
m = read_msh(simulation_file)
if 'J' not in m.field.keys():
    raise IOError("El archivo seleccionado no contiene el campo 'J'.")

# Calcular el campo magnético B
B = calc_B(m.field['J'], nvox, affine, calc_res=2.0, mask=True)

# Guardar el resultado en un archivo NIfTI
output_file = os.path.join(S.pathfem, 'B.nii.gz')
img_B = nib.Nifti1Pair(B, affine)
img_B.header.set_xyzt_units('mm')
img_B.set_qform(affine)
img_B.update_header()
nib.save(img_B, output_file)

print("El campo magnético se ha guardado en:", output_file)

import nibabel as nib
import matplotlib.pyplot as plt
b_img = nib.load(os.path.join(S.pathfem, 'B.nii.gz'))
B_data = b_img.get_fdata()
slice_index = B_data.shape[2] // 2
plt.figure(figsize=(8,6))
plt.imshow(B_data[:, :, slice_index, 0].T, origin='lower', cmap='viridis')
plt.title('Componente X del campo magnético (rebanada central)')
plt.xlabel('x')
plt.ylabel('y')
plt.colorbar(label='T (Tesla)')
plt.show()

'''