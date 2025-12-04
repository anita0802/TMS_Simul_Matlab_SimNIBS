""" How to run a SimNIBS TMS simulation in Python
    Run with:

    simnibs_python TMS.py
    Copyright (C) 2018 Guilherme B Saturnino
"""
import os
import numpy as np
from simnibs import sim_struct, run_simnibs
import json
from pathlib import Path

with open("D:/psymulator/TMS_Simul_Matlab_SimNIBS/SimNIBS/config.json", "r") as f:
    config = json.load(f)

### General information
S = sim_struct.SESSION()
S.subpath = Path(config["m2m_path"])  # m2m-folder of the subject
S.pathfem = 'tms_simu'  # Directory for the simulation
S.fields = 'eE' #Fields to calculate


## Define the TMS simulation
tms = S.add_tmslist()
tms.fnamecoil = os.path.join(Path(config["tcd_coils"]),'Coilkirlia_5A.tcd')  # Choose a coil model

# Define the coil position
pos = tms.add_position()
# ---- Completely disable automatic direction placement ----
pos.use_direction = False
pos.pos = None
pos.pos_ydir = None
pos.pos_zdir = None

# ---- DO NOT use distance with matsimnibs ----
pos.distance = 0

###-----------------------------------------
### Define coil current
###-----------------------------------------
# Change this when change the coil
pos.didt = 337.8378   # Kirlia 5A, rise time 14.8ms

# If you want to know the rise time of every coil, tr = I/didt
############ 0.5A ############
#pos.didt = 3846.1538        # BobinaL1 0.5A
#pos.didt = 3333.3333        # BobinaL3 0.5A
#pos.didt = 2941.1765        # BobinaL4 0.5A
#pos.didt = 2427.1845        # BobinaL5 0.5A
############ 1A ############
#pos.didt = 7692.3077        # BobinaL1 1A
#pos.didt = 6666.6667        # BobinaL3 1A
#pos.didt = 5882.3529        # BobinaL4 1A
#pos.didt = 4854.3689        # BobinaL5 1A
############ 2A ############
#pos.didt = 15384.6154       # BobinaL1 2A
#pos.didt = 13333.3333       # BobinaL3 2A
#pos.didt = 11764.7059       # BobinaL4 2A
#pos.didt = 9708.7379        # BobinaL5 2A

###-----------------------------------------
### Define coil transform (independent of the mouse)
###-----------------------------------------
# Example: identity rotation (coil straight)
R = np.eye(3)
alpha = np.deg2rad(180)
Rx = np.array([[1,0,0],
               [0,np.cos(alpha), -np.sin(alpha)],
               [0,np.sin(alpha),  np.cos(alpha)]])

Ry = np.array([ np.cos(alpha), 0, np.sin(alpha)],
              [0, 1, 0],
              [-np.sin(alpha), 0, np.cos(alpha)])

Rz = np.array([np.cos(alpha), -np.sin(alpha), 0],
              [np.sin(alpha),  np.cos(alpha), 0],
              [0, 0, 1])
# R = Rx @ Ry @ Rz
R = Rx
# Example: coil center given manually (mm)
tx, ty, tz = 19, 5, 80

# Build transformation matrix
M = np.eye(4)
M[:3, :3] = R
M[:3, 3] = [tx, ty, tz]

# Assign to SimNIBS
pos.matsimnibs = M

# Run Simulation
run_simnibs(S)