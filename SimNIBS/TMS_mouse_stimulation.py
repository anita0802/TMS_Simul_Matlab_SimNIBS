""" How to run a SimNIBS TMS simulation in Python
    Run with:

    simnibs_python TMS.py
"""
import os
import numpy as np
from simnibs import sim_struct, run_simnibs
import json
from pathlib import Path

# Load config file
with open("D:/psymulator/TMS_Simul_Matlab_SimNIBS/SimNIBS/config.json", "r") as f:
    config = json.load(f)

###-----------------------------------------
### Create session
###-----------------------------------------
S = sim_struct.SESSION()
S.subpath = Path(config["m2m_mouse_path"])
S.pathfem = 'tms_simu'
S.fields = 'eE'

###-----------------------------------------
### Add TMS simulation
###-----------------------------------------
tms = S.add_tmslist()
tms.fnamecoil = os.path.join(Path(config["tcd_coils"]), 'Coilkirlia_5A.tcd')

###-----------------------------------------
### Create position
###-----------------------------------------
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

###-----------------------------------------
### Define coil transform (independent of the mouse)
###-----------------------------------------
# Example: identity rotation (coil straight)
R = np.eye(3)
alpha = np.deg2rad(100)
Rx = np.array([[1,0,0],
               [0,np.cos(alpha), -np.sin(alpha)],
               [0,np.sin(alpha),  np.cos(alpha)]])
R = Rx
# Example: coil center given manually (mm)
tx, ty, tz = 0, 1.91, 46.5

# Build transformation matrix
M = np.eye(4)
M[:3, :3] = R
M[:3, 3] = [tx, ty, tz]

# Assign to SimNIBS
pos.matsimnibs = M

###-----------------------------------------
### Run simulation
###-----------------------------------------
run_simnibs(S)
