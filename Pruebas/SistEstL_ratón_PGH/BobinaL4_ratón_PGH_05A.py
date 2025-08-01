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
    N=2
    # Height of the coil (mm)
    h=1.20

    #Evenly spaced angles
    phi = np.linspace(2*np.pi*N, 0, segment_count)
    # Coil pitch
    pitch=-h/(2*np.pi*N)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_coil_helixout * np.cos(phi), outer_diam_coil_helixout * np.sin(phi), pitch*phi]
    )

    return path

def spiral_coil_helixin(outer_diam_coil_helixin: float, segment_count: int):
    # Turns of the coil
    N2=4.5
    # Height of the coil (mm)
    h2=1.76

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
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
    h3=1.5            # PARÁMETRO QUE SE PUEDE VARIAR

    # Evenly spaced angles
    phi = np.linspace(0, 2*np.pi*N3, segment_count)
    # Coil pitch
    pitch2=-h3/(2*np.pi*N3) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam_core * np.cos(phi), outer_diam_core * np.sin(phi), pitch2*phi]
    )

    return path

def figure_of_wire_path(
    segment_count: int,
    outer_diam_coil_helixout: float,
    outer_diam_coil_helixin: float,
    outer_diam_core: float,
    winding_casing_distance: float,
):
    
    # Generate the spirals of the coils
    path = spiral_coil_helixout(outer_diam_coil_helixout, segment_count)
    spiral_1 = (
        path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position of the  coil_helixout
    )

    path = spiral_coil_helixin(outer_diam_coil_helixin, segment_count)
    spiral_2 = (
        path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position of the  coil_helixin
    )

    path = spiral_core(outer_diam_core, segment_count)
    spiral_3 = np.fliplr(
        path + np.array((0, 0, -winding_casing_distance))[:, None] # Global position of the core
    )

    return np.concatenate(
        (          
            spiral_2,
            spiral_1,
            spiral_3
        ),
        axis=1,
    ).T


# Set up coil parameters
segment_count = 1000
radius_coil_helixout = 0.00125
radius_coil_helixin  = 0.00075
radius_core          = 0.00050          # PARÁMETRO QUE SE PUEDE VARIAR
outer_diam_coil_helixout = 2*radius_coil_helixout*1000  # mm
outer_diam_coil_helixin = 2*radius_coil_helixin*1000    # mm
outer_diam_core = 2*radius_core*1000                    # mm
winding_casing_distance = 0.5


wire_path = figure_of_wire_path(
    segment_count,
    outer_diam_coil_helixout,
    outer_diam_coil_helixin,   
    outer_diam_core,
    winding_casing_distance,
)

# The limits of the a field of the coil, used for the transformation into nifti format
limits = [[-300.0, 300.0], [-200.0, 200.0], [-100.0, 300.0]]
# The resolution used when sampling to transform into nifti format
resolution = [2, 2, 2]

# Creating a example stimulator with a name, a brand and a maximum dI/dt
stimulator = TmsStimulator("Example Stimulator", "Example Stimulator Brand", 122.22e6)

# Creating the line segments from a list of wire path points
line_element = LineSegmentElements(stimulator, wire_path, name="Figure_of_8")
# Creating the TMS coil with its element, a name, a brand, a version, the limits and the resolution
tms_coil = TmsCoil(
    [line_element], "Example Coil", "Example Coil Brand", "V1.0", limits, resolution
)

# Generating a coil casing that has a specified distance from the coil windings
tms_coil.generate_element_casings(
    winding_casing_distance, winding_casing_distance / 2, False
)

# Write the coil to a tcd file
tms_coil.write("BobinaL4_ratón_PGH_05A.tcd")