"""
Script to create a parametric figure of TMS coil and save it in the tcd format.
The coil is constructed using line segments which reconstruct the windings of the coil.
Adapted to build TWO independent circular coils
"""

import numpy as np
from simnibs.simulation.tms_coil.tms_coil import TmsCoil

from simnibs.simulation.tms_coil.tms_coil_element import LineSegmentElements
from simnibs.simulation.tms_coil.tms_stimulator import TmsStimulator

def spiral_1_coil_helixout(outer_diam_coil_helixout: float, segment_count: int):
    # Turns of the coil
    N=2
    # Height of the coil (mm)
    h=1.62

    #Evenly spaced angles
    phi = np.linspace(2*np.pi*N, 0, segment_count)      # coil
    # Coil pitch
    pitch=-h/(2*np.pi*N)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixout * np.cos(phi), outer_diam_coil_helixout * np.sin(phi), pitch*phi]
    )

    return path

def spiral_1_coil_helixin(outer_diam_coil_helixin: float, segment_count: int):
    # Turns of the coil
    N2=4.5
    # Height of the coil (mm)
    h2=1.62

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)     # coil
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixin * np.cos(phi), outer_diam_coil_helixin * np.sin(phi), pitch2*phi]
    )

    return path

def spiral_1_core(outer_diam_core: float, segment_count: int):
    # Turns of the core
    N3=13        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h3=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N3, 0, segment_count)     # core
    # Coil pitch
    pitch3=-h3/(2*np.pi*N3) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core * np.cos(phi), outer_diam_core * np.sin(phi), pitch3*phi]
    )

    return path

def spiral_1_core_2(outer_diam_core2: float, segment_count: int):
    # Turns of the core
    N4=15        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h4=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N4, 0, segment_count)     # core
    # Coil pitch
    pitch4=-h4/(2*np.pi*N4) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core2 * np.cos(phi), outer_diam_core2 * np.sin(phi), pitch4*phi]
    )

    return path

def spiral_1_core_3(outer_diam_core3: float, segment_count: int):
    # Turns of the core
    N5=15        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h5=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N5, 0, segment_count)     # core
    # Coil pitch
    pitch5=-h5/(2*np.pi*N5) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core3 * np.cos(phi), outer_diam_core3 * np.sin(phi), pitch5*phi]
    )

    return path

def spiral_1_core_4(outer_diam_core4: float, segment_count: int):
    # Turns of the core
    N6=13        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h6=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N6, 0, segment_count)     # core
    # Coil pitch
    pitch6=-h6/(2*np.pi*N6) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core4 * np.cos(phi), outer_diam_core4 * np.sin(phi), pitch6*phi]
    )

    return path

def spiral_2_coil_helixout(outer_diam_coil_helixout: float, segment_count: int):
    # Turns of the coil
    N=2
    # Height of the coil (mm)
    h=1.62

    #Evenly spaced angles
    phi = np.linspace(2*np.pi*N, 0, segment_count)      # coil
    # Coil pitch
    pitch=-h/(2*np.pi*N)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixout * np.cos(phi), outer_diam_coil_helixout * np.sin(phi), pitch*phi]
    )

    return path

def spiral_2_coil_helixin(outer_diam_coil_helixin: float, segment_count: int):
    # Turns of the coil
    N2=4.5
    # Height of the coil (mm)
    h2=1.62

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)     # coil
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixin * np.cos(phi), outer_diam_coil_helixin * np.sin(phi), pitch2*phi]
    )

    return path

def spiral_2_core(outer_diam_core: float, segment_count: int):
    # Turns of the core
    N3=13        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h3=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N3, 0, segment_count)     # core
    # Coil pitch
    pitch3=-h3/(2*np.pi*N3) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core * np.cos(phi), outer_diam_core * np.sin(phi), pitch3*phi]
    )

    return path

def spiral_2_core_2(outer_diam_core2: float, segment_count: int):
    # Turns of the core
    N4=15        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h4=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N4, 0, segment_count)     # core
    # Coil pitch
    pitch4=-h4/(2*np.pi*N4) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core2 * np.cos(phi), outer_diam_core2 * np.sin(phi), pitch4*phi]
    )

    return path

def spiral_2_core_3(outer_diam_core3: float, segment_count: int):
    # Turns of the core
    N5=15        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h5=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N5, 0, segment_count)     # core
    # Coil pitch
    pitch5=-h5/(2*np.pi*N5) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core3 * np.cos(phi), outer_diam_core3 * np.sin(phi), pitch5*phi]
    )

    return path

def spiral_2_core_4(outer_diam_core4: float, segment_count: int):
    # Turns of the core
    N6=13        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h6=0.2           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N6, 0, segment_count)     # core
    # Coil pitch
    pitch6=-h6/(2*np.pi*N6) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core4 * np.cos(phi), outer_diam_core4 * np.sin(phi), pitch6*phi]
    )

    return path

def figure_of_wire_path(
    segment_count: int,
    outer_diam_coil_helixout: float,
    outer_diam_coil_helixin: float,
    outer_diam_core: float,
    outer_diam_core2: float,
    outer_diam_core3: float,
    outer_diam_core4: float,
    winding_casing_distance: float,
    y_off: float,
):
    
    # Generate the spirals of the coils spiral 1
    # coil_helixout
    path = spiral_1_coil_helixout(outer_diam_coil_helixout, segment_count)
    spiral_1_1 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position of the coil_helixout

    # coil_helixin
    path = spiral_1_coil_helixin(outer_diam_coil_helixin, segment_count)
    spiral_1_2 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position of the coil_helixin

    # core
    path = spiral_1_core(outer_diam_core, segment_count)
    #spiral_3 = np.fliplr(path + np.array((0, 0, -winding_casing_distance))[:, None]) # Global position for the core
    spiral_1_3 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_1_core_2(outer_diam_core2, segment_count)
    spiral_1_4 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_1_core_3(outer_diam_core3, segment_count)
    spiral_1_5 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_1_core_4(outer_diam_core4, segment_count)
    spiral_1_6 = path + np.array((0, +y_off, -winding_casing_distance))[:, None] # Global position for the core

    # Generate the spirals of the coils spiral 2
    # coil_helixout
    path = spiral_2_coil_helixout(outer_diam_coil_helixout, segment_count)
    spiral_2_1 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position of the coil_helixout

    # coil_helixin
    path = spiral_2_coil_helixin(outer_diam_coil_helixin, segment_count)
    spiral_2_2 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position of the coil_helixin

    # core
    path = spiral_2_core(outer_diam_core, segment_count)
    #spiral_3 = np.fliplr(path + np.array((0, 0, -winding_casing_distance))[:, None]) # Global position for the core
    spiral_2_3 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_2_core_2(outer_diam_core2, segment_count)
    spiral_2_4 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_2_core_3(outer_diam_core3, segment_count)
    spiral_2_5 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_2_core_4(outer_diam_core4, segment_count)
    spiral_2_6 = path + np.array((0, -y_off, -winding_casing_distance))[:, None] # Global position for the core

    # Alineación
    def anclar_final_en_z(spiral, z_objetivo):
        return spiral + np.array((0, 0, z_objetivo - spiral[2, -1]))[:, None]

    z_end = spiral_1_1[2, -1]
    spiral_1_1 = anclar_final_en_z(spiral_1_1, z_end)
    spiral_1_2 = anclar_final_en_z(spiral_1_2, z_end)
    spiral_1_3 = anclar_final_en_z(spiral_1_3, z_end)
    spiral_1_4 = anclar_final_en_z(spiral_1_4, z_end)
    spiral_1_5 = anclar_final_en_z(spiral_1_5, z_end)
    spiral_1_6 = anclar_final_en_z(spiral_1_6, z_end)
    spiral_2_1 = anclar_final_en_z(spiral_2_1, z_end)
    spiral_2_2 = anclar_final_en_z(spiral_2_2, z_end)
    spiral_2_3 = anclar_final_en_z(spiral_2_3, z_end)
    spiral_2_4 = anclar_final_en_z(spiral_2_4, z_end)
    spiral_2_5 = anclar_final_en_z(spiral_2_5, z_end)
    spiral_2_6 = anclar_final_en_z(spiral_2_6, z_end)

    # Construir un wire_path por bobina y devolver ambos
    wire_path_1 = np.concatenate(
        (spiral_1_1, spiral_1_2, spiral_1_3, spiral_1_4, spiral_1_5, spiral_1_6), axis=1
    ).T

    wire_path_2 = np.concatenate(
        (spiral_2_1, spiral_2_2, spiral_2_3, spiral_2_4, spiral_2_5, spiral_2_6), axis=1
    ).T
    return wire_path_1, wire_path_2

# Set up coil parameters
segment_count = 1000
radius_coil_helixout = 0.00125
radius_coil_helixin  = 0.000681
radius_core = 0.0005
outer_diam_core2 = 0.00035*1000
outer_diam_core3 = 0.00025*1000
outer_diam_core4 = 0.0001*1000

outer_diam_coil_helixout = radius_coil_helixout*1000  # mm
outer_diam_coil_helixin = radius_coil_helixin*1000    # mm
outer_diam_core = radius_core*1000                    # mm                  # PARÁMETRO QUE SE PUEDE VARIAR
winding_casing_distance = 0.5

separation_mm = 3.0
y_off = separation_mm / 2.0


wire_path_1, wire_path_2 = figure_of_wire_path(
    segment_count,
    outer_diam_coil_helixout,
    outer_diam_coil_helixin,   
    outer_diam_core,
    outer_diam_core2,
    outer_diam_core3,
    outer_diam_core4,
    winding_casing_distance,
    separation_mm,
)

# The limits of the a field of the coil, used for the transformation into nifti format
limits = [[-300.0, 300.0], [-200.0, 200.0], [-100.0, 300.0]]
# The resolution used when sampling to transform into nifti format
resolution = [2, 2, 2]

# Creating a example stimulator with a name, a brand and a maximum dI/dt
stimulator = TmsStimulator("Example Stimulator", "Example Stimulator Brand", 122.22e6)

# Creating the line segments from a list of wire path points
line_element_1 = LineSegmentElements(stimulator, wire_path_1, name="Coil_1")
line_element_2 = LineSegmentElements(stimulator, wire_path_2, name="Coil_2")

# Creating the TMS coil with its element, a name, a brand, a version, the limits and the resolution
tms_coil = TmsCoil(
    [line_element_1, line_element_2], "Two Coils System", "Example Coil Brand", "V1.0", limits, resolution
)

# Generating a coil casing that has a specified distance from the coil windings
tms_coil.generate_element_casings(
    winding_casing_distance, winding_casing_distance / 2, False
)

# Write the coil to a tcd file
tms_coil.write("tcd/SisEstL4_val_PGH_1A.tcd")