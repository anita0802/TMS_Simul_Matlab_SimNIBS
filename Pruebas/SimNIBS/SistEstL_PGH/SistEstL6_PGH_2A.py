"""
Script to create a parametric figure of TMS coil and save it in the tcd format.
The coil is constructed using line segments which reconstruct the windings of the coil.
This is a 4 coil stimulator compound by coils L1
"""

import numpy as np
from simnibs.simulation.tms_coil.tms_coil import TmsCoil

from simnibs.simulation.tms_coil.tms_coil_element import LineSegmentElements
from simnibs.simulation.tms_coil.tms_stimulator import TmsStimulator

# Each function spiral is to create a coil, odds are for core and even for coils
def spiral1_coil1(outer_diam: float, inner_diam: float, wire_diam: float, segment_count: int):
  
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam / 2 - inner_diam / 2) / (wire_diam / 2)
    # Turns of the coil
    N=1
    # Height of the coil (mm)
    h=0.8

    # Evenly spaced angles 
    phi = np.linspace(0, 2*np.pi*N, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam / 2 - wire_diam / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch=-h/(2*np.pi*N) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam3 * np.cos(phi), outer_diam3 * np.sin(phi), pitch*phi]
    )

    return path

def spiral2_coil1(outer_diam2: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam4 / 2 - inner_diam / 2) / (wire_diam2 / 2)
    # Turns of the coil
    N2=2.27486
    # Height of the coil (mm)
    h2=0.5

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam4 / 2 - wire_diam2 / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam2 * np.cos(phi), outer_diam2 * np.sin(phi), pitch2*phi]
    )

    return path

def spiral1_coil2(outer_diam: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam / 2 - inner_diam / 2) / (wire_diam / 2)
    # Turns of the coil
    N=1
    # Height of the coil (mm)
    h=0.8

    # Evenly spaced angles 
    phi = np.linspace(0, 2*np.pi*N, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam / 2 - wire_diam / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch=-h/(2*np.pi*N) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam3 * np.cos(phi), outer_diam3 * np.sin(phi), pitch*phi]
    )

    return path

def spiral2_coil2(outer_diam2: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam4 / 2 - inner_diam / 2) / (wire_diam2 / 2)
    # Turns of the coil
    N2=2.27486
    # Height of the coil (mm)
    h2=0.5

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam4 / 2 - wire_diam2 / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam2 * np.cos(phi), outer_diam2 * np.sin(phi), pitch2*phi]
    )

    return path

def spiral1_coil3(outer_diam: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam / 2 - inner_diam / 2) / (wire_diam / 2)
    # Turns of the coil
    N=1
    # Height of the coil (mm)
    h=0.8

    # Evenly spaced angles 
    phi = np.linspace(0, 2*np.pi*N, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam / 2 - wire_diam / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch=-h/(2*np.pi*N) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam3 * np.cos(phi), outer_diam3 * np.sin(phi), pitch*phi]
    )

    return path

def spiral2_coil3(outer_diam2: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam4 / 2 - inner_diam / 2) / (wire_diam2 / 2)
    # Turns of the coil
    N2=2.27486
    # Height of the coil (mm)
    h2=0.5

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam4 / 2 - wire_diam2 / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam2 * np.cos(phi), outer_diam2 * np.sin(phi), pitch2*phi]
    )

    return path

def spiral1_coil4(outer_diam: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam / 2 - inner_diam / 2) / (wire_diam / 2)
    # Turns of the coil
    N=1
    # Height of the coil (mm)
    h=0.8

    # Evenly spaced angles 
    phi = np.linspace(0, 2*np.pi*N, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam / 2 - wire_diam / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch=-h/(2*np.pi*N) 
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam3 * np.cos(phi), outer_diam3 * np.sin(phi), pitch*phi]
    )

    return path

def spiral2_coil4(outer_diam2: float, inner_diam: float, wire_diam: float, segment_count: int):
   
    # Calculates the maximal spiral angle
    phi_max = 2 * np.pi * (outer_diam4 / 2 - inner_diam / 2) / (wire_diam2 / 2)
    # Turns of the coil
    N2=2.27486
    # Height of the coil (mm)
    h2=0.5

    # Evenly spaced angles
    phi = np.linspace(2*np.pi*N2, 0, segment_count)
    # Calculates the radius of every line segment in the spiral
    radius_loop = outer_diam4 / 2 - wire_diam2 / 2 * phi / (2 * np.pi)
    # Coil pitch
    pitch2=-h2/(2*np.pi*N2)
    # Calculates the cartesian coordinates of the spiral
    path = np.array(
        [outer_diam2 * np.cos(phi), outer_diam2 * np.sin(phi), pitch2*phi]
    )

    return path

def figure_of_8_wire_path(
    wire_diam: float,
    wire_diam2: float,
    segment_count: int,
    segment_count2: int,
    segment_count3: int,
    connection_segment_count: int,
    outer_diam: float,
    outer_diam2: float,
    outer_diam3: float,
    outer_diam4: float,
    inner_diam: float,
    element_distance: float,
    winding_casing_distance: float,
):
   
    # Generate the spirals of the coils
    path = spiral1_coil1(outer_diam, inner_diam, wire_diam, segment_count)
    spiral_1 = (
        path + np.array((0, 1.0035, -winding_casing_distance))[:, None] # Global position of the first coil
    )

    path = spiral2_coil1(outer_diam2, inner_diam, wire_diam, segment_count)
    spiral_2 = np.fliplr(
        path + np.array((0, 1.0035, -winding_casing_distance))[:, None] # Global position of the first core
    )

    path = spiral1_coil2(outer_diam, inner_diam, wire_diam, segment_count2)
    spiral_3 = np.fliplr(
        path + np.array((0.971, 0, -winding_casing_distance))[:, None] # Global position of the second coil
    )

    path = spiral2_coil2(outer_diam2, inner_diam, wire_diam, segment_count)
    spiral_4 = np.fliplr(
        path + np.array((0.971, 0, -winding_casing_distance))[:, None] # Global position of the second core
    )
    path = spiral1_coil3(outer_diam, inner_diam, wire_diam, segment_count)
    spiral_5 = (
        path + np.array((-0.971, 0, -winding_casing_distance))[:, None] # Global position of the third coil
    )

    path = spiral2_coil3(outer_diam2, inner_diam, wire_diam, segment_count)
    spiral_6 = np.fliplr(
        path + np.array((-0.971, 0, -winding_casing_distance))[:, None] # Global position of the third core
    )

    path = spiral1_coil4(outer_diam, inner_diam, wire_diam, segment_count)
    spiral_7 = np.fliplr(
        path + np.array((0, -1.0035, -winding_casing_distance))[:, None]  # Global position of the fourth coil
    )

    path = spiral2_coil4(outer_diam2, inner_diam, wire_diam, segment_count)
    spiral_8 = np.fliplr(
        path + np.array((0, -1.0035, -winding_casing_distance))[:, None] # Global position of the fourth core
    )

    return np.concatenate(
        (
            spiral_8,
            spiral_7,
            spiral_6,
            spiral_5,
            spiral_4,
            spiral_3,
            spiral_2,
            spiral_1,
        ),
        axis=1,
    ).T


# Set up coil parameters
wire_diam = 0.4
wire_diam2 = 0.07
segment_count = 600
segment_count2 = 600
segment_count3 = 1000
connection_segment_count = 20
inner_diam = 0.02
outer_diam = 2.9 
outer_diam2 = 10
outer_diam3= 0.4
outer_diam4= 2
element_distance = 0
winding_casing_distance = 0.5


wire_path = figure_of_8_wire_path(
    wire_diam,
    wire_diam2,
    segment_count,
    segment_count2,
    segment_count3,
    connection_segment_count,
    outer_diam,   
    outer_diam2,
    outer_diam3,
    outer_diam4,
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
tms_coil.write("SisEstL6_PGH_2A.tcd")
