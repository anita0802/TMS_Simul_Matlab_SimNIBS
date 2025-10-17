""" How to run a SimNIBS TMS simulation in Python
    Run with:

    simnibs_python TMS.py
    Copyright (C) 2018 Guilherme B Saturnino
"""
import os
from simnibs import sim_struct, run_simnibs

import json
from pathlib import Path

with open("config.json", "r") as f:
    config = json.load(f)

### General information
S = sim_struct.SESSION()
S.subpath = Path(config["m2m_mouse_path"]) # m2m-folder of the subject
S.pathfem = 'tms_simu'  # Directory for the simulation
S.fields = 'eE' #Fields to calculate

## Define the TMS simulation
tms = S.add_tmslist()
tms.fnamecoil = os.path.join('commercial_coils','tcd','CoilL1_1A.tcd')  # Choose a coil model

# Define the coil position
pos = tms.add_position()
pos.pos_ydir = [0,1,0]  #Orientation of the coil
pos.distance = 100  #Distance from coil surface to cortex surface (mm) || negativo porque la normal apunta hacia dentro del cráneo

############ 0.5A ############
#pos.didt = 3846.1538        # BobinaL1 0.5A
#pos.didt = 3333.3333        # BobinaL3 0.5A
#pos.didt = 2941.1765        # BobinaL4 0.5A
#pos.didt = 2427.1845        # BobinaL5 0.5A
############ 1A ############
#pos.didt = 7692.3077        # BobinaL1 1A
#pos.didt = 6666.6667        # BobinaL3 1A
pos.didt = 5882.3529        # BobinaL4 1A
#pos.didt = 4854.3689        # BobinaL5 1A
############ 2A ############
#pos.didt = 15384.6154       # BobinaL1 2A
#pos.didt = 13333.3333       # BobinaL3 2A
#pos.didt = 11764.7059       # BobinaL4 2A
#pos.didt = 9708.7379        # BobinaL5 2A


# Define el punto de anclaje de la bobina - centro de la bobina antes de separarlo de la superficie del cerebro
pos.centre = [0,5.3,26.9361]

# Run Simulation
run_simnibs(S)