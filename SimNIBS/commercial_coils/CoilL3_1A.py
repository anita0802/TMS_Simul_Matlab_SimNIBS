"""
Script to create a parametric figure of TMS coil and save it in the tcd format.
The coil is constructed using line segments which reconstruct the windings of the coil.
"""

import numpy as np
from simnibs.simulation.tms_coil.tms_coil import TmsCoil

from simnibs.simulation.tms_coil.tms_coil_element import LineSegmentElements
from simnibs.simulation.tms_coil.tms_stimulator import TmsStimulator

def spiral_coil_helixout(outer_diam_coil_helixout: float, segment_count: int):
    # Turns of the coil
    N=0.5
    # Height of the coil (mm)
    h=2.07

    #Evenly spaced angles
    phi = np.linspace(2*np.pi*N, 0, segment_count)      # coil
    # Coil pitch
    pitch=-h/(2*np.pi*N)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixout * np.cos(phi), outer_diam_coil_helixout * np.sin(phi), pitch*phi]
    )

    return path

def spiral_coil_helixin(outer_diam_coil_helixin: float, segment_count: int):
    # Turns of the coil
    N2=4
    # Height of the coil (mm)
    h2=2.068

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)     # coil
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixin * np.cos(phi), outer_diam_coil_helixin * np.sin(phi), pitch2*phi]
    )

    return path

def spiral_core(outer_diam_core: float, segment_count: int):
    # Turns of the core
    N3=7        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h3=1           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N3, 0, segment_count)     # core
    # Coil pitch
    pitch3=-h3/(2*np.pi*N3) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core * np.cos(phi), outer_diam_core * np.sin(phi), pitch3*phi]
    )

    return path

def spiral_core_2(outer_diam_core2: float, segment_count: int):
    # Turns of the core
    N4=9        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h4=0.75           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N4, 0, segment_count)     # core
    # Coil pitch
    pitch4=-h4/(2*np.pi*N4) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core2 * np.cos(phi), outer_diam_core2 * np.sin(phi), pitch4*phi]
    )

    return path

def spiral_core_3(outer_diam_core3: float, segment_count: int):
    # Turns of the core
    N5=9        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h5=0.75           # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N5, 0, segment_count)     # core
    # Coil pitch
    pitch5=-h5/(2*np.pi*N5) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core3 * np.cos(phi), outer_diam_core3 * np.sin(phi), pitch5*phi]
    )

    return path

def spiral_core_4(outer_diam_core4: float, segment_count: int):
    # Turns of the core
    N6=7        # PARÁMETRO QUE SE PUEDE VARIAR
    # Height of the core (mm)
    h6=1           # PARÁMETRO QUE SE PUEDE VARIAR

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
):
    
    # Generate the spirals of the coils
    # coil_helixout
    path = spiral_coil_helixout(outer_diam_coil_helixout, segment_count)
    spiral_1 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position of the coil_helixout

    # coil_helixin
    path = spiral_coil_helixin(outer_diam_coil_helixin, segment_count)
    spiral_2 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position of the coil_helixin

    # core
    path = spiral_core(outer_diam_core, segment_count)
    #spiral_3 = np.fliplr(path + np.array((0, 0, -winding_casing_distance))[:, None]) # Global position for the core
    spiral_3 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_core_2(outer_diam_core2, segment_count)
    spiral_4 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_core_3(outer_diam_core3, segment_count)
    spiral_5 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position for the core

    # core
    path = spiral_core_4(outer_diam_core4, segment_count)
    spiral_6 = path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position for the core

    def anclar_final_en_z(spiral, z_objetivo):
        return spiral + np.array((0, 0, z_objetivo - spiral[2, -1]))[:, None]

    z_end = spiral_1[2, -1]
    spiral_1 = anclar_final_en_z(spiral_1, z_end)
    spiral_2 = anclar_final_en_z(spiral_2, z_end)
    spiral_3 = anclar_final_en_z(spiral_3, z_end)
    spiral_4 = anclar_final_en_z(spiral_4, z_end)
    spiral_5 = anclar_final_en_z(spiral_5, z_end)
    spiral_6 = anclar_final_en_z(spiral_6, z_end)

    return np.concatenate(
        (          
            spiral_2,
            spiral_1,
            spiral_3,
            spiral_4,
            spiral_5,
            spiral_6
        ),
        axis=1,
    ).T


# Set up coil parameters
segment_count = 1000
radius_coil_helixout = 0.0028
radius_coil_helixin  = 0.0007
radius_core = 0.0004
outer_diam_core2 = 0.0003*1000
outer_diam_core3 = 0.0002*1000
outer_diam_core4 = 0.0001*1000

outer_diam_coil_helixout = radius_coil_helixout*1000  # mm
outer_diam_coil_helixin = radius_coil_helixin*1000    # mm
outer_diam_core = radius_core*1000                    # mm                  # PARÁMETRO QUE SE PUEDE VARIAR
winding_casing_distance = 0.5


wire_path = figure_of_wire_path(
    segment_count,
    outer_diam_coil_helixout,
    outer_diam_coil_helixin,   
    outer_diam_core,
    outer_diam_core2,
    outer_diam_core3,
    outer_diam_core4,
    winding_casing_distance,
)

# The limits of the a field of the coil, used for the transformation into nifti format
limits = [[-300.0, 300.0], [-200.0, 200.0], [-100.0, 300.0]]
# The resolution used when sampling to transform into nifti format
resolution = [2, 2, 2]

# Creating a example stimulator with a name, a brand and a maximum dI/dt
stimulator = TmsStimulator("Example Stimulator", "Example Stimulator Brand", 122.22e6)

# Creating the line segments from a list of wire path points
line_element = LineSegmentElements(stimulator, wire_path, name="Coil")
# Creating the TMS coil with its element, a name, a brand, a version, the limits and the resolution
tms_coil = TmsCoil(
    [line_element], "Example Coil", "Example Coil Brand", "V1.0", limits, resolution
)

# Generating a coil casing that has a specified distance from the coil windings
tms_coil.generate_element_casings(
    winding_casing_distance, winding_casing_distance / 2, False
)

# Write the coil to a tcd file
tms_coil.write("tcd/BobinaL3_ratón_PGH_1A.tcd")