"""
Script to create a parametric figure of TMS coil and save it in the tcd format.
The coil is constructed using line segments which reconstruct the windings of the coil.
"""

import numpy as np
from simnibs.simulation.tms_coil.tms_coil import TmsCoil

from simnibs.simulation.tms_coil.tms_coil_element import LineSegmentElements
from simnibs.simulation.tms_coil.tms_stimulator import TmsStimulator

# Each function spiral is to create a coil, odds are for core and even for coils
def spiral(outer_diam: float, inner_diam: float, wire_diam: float, segment_count: int):
    # Turns of the coil
    N=4.5
    # Height of the coil (mm)
    h=1.8

    #Evencly spaced angles
    phi = np.linspace(0, 2*np.pi*N, segment_count)
    # Coil pitch
    pitch=-h/(2*np.pi*N) 
    path = np.array(
        [outer_diam * np.cos(phi), outer_diam * np.sin(phi), pitch*phi]
    )

    return path

def spiral2(outer_diam2: float, inner_diam: float, wire_diam: float, segment_count: int):
    # Turns of the coil
    N2=18.059
    # Height of the coil (mm)
    h2=8 
    
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
    pitch2=-h2/(2*np.pi*N2) 
    path = np.array(
        [outer_diam2 * np.cos(phi), outer_diam2 * np.sin(phi), pitch2*phi]
    )

    return path

def figure_of_wire_path(
    wire_diam: float,
    segment_count: int,
    outer_diam: float,
    outer_diam2: float,
    inner_diam: float,
    element_distance: float,
    winding_casing_distance: float,
):
    
    # Generate the spirals of the coils
    path = spiral(outer_diam, inner_diam, wire_diam, segment_count)
    spiral_1 = (
        path + np.array((-element_distance / 2, 0, -winding_casing_distance))[:, None] # Global position of the  coil
    )

    path = spiral2(outer_diam2, inner_diam, wire_diam, segment_count)
    spiral_2 = np.fliplr(
        path + np.array((-element_distance / 2, 0, -winding_casing_distance))[:, None] # Global position of the core
    )

    return np.concatenate(
        (          
            spiral_2,
            spiral_1,
        ),
        axis=1,
    ).T


# Set up coil parameters
wire_diam = 0.4
segment_count = 600
outer_diam = 2.9 
outer_diam2 = 10
inner_diam = 0.02
element_distance = 0
winding_casing_distance = 0.5


wire_path = figure_of_wire_path(
    wire_diam,
    segment_count,
    outer_diam,   
    outer_diam2,
    inner_diam,
    element_distance,
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
tms_coil.write("BobinaL3_PGH_2A.tcd")
