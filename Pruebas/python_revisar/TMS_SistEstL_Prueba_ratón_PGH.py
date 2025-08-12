""" How to run a SimNIBS TMS simulation in Python
    Run with:

    simnibs_python TMS.py
    Copyright (C) 2018 Guilherme B Saturnino
"""
import os
from simnibs import sim_struct, run_simnibs

### General information
S = sim_struct.SESSION()
S.subpath = 'm2m_ernie_mouse'  # m2m-folder of the subject
S.pathfem = 'tms_simu'  # Directory for the simulation
S.fields = 'eE' #Fields to calculate


## Define the TMS simulation
tms = S.add_tmslist()
tms.fnamecoil = os.path.join('SistEstL_ratón_PGH','BobinaL4_ratón_PGH_05A.tcd')  # Choose a coil model

# Define the coil position
pos = tms.add_position()
pos.pos_ydir = [1.0,0.0,1.0]  #Orientation of the coil
pos.distance = -0.6  #Distance from coil surface to cortex surface (mm) || negativo porque la normal apunta hacia dentro del cráneo

#pos.didt = 3846.1538        # BobinaL1 0.5A
pos.didt = 2941.1765        # BobinaL4 0.5A

# Define el punto de anclaje de la bobina - centro de la bobina antes de separarlo de la superficie del cerebro
pos.centre = [0,5.4,26.9361]     # BobinaL4

# Run Simulation
run_simnibs(S)