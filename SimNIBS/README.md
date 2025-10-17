Steps to execute SimNIBS scripts:

1. Execute python setup_env.py: this file will create the .tcd coils. It is importante to execute it always before working with the coils. This will use your version of SimNIBS to create the coils, whatever that version was.

2. Modify the path to m2m_ernie or m2m_ernie_mouse folder in the config.json. You can find the files in the web, but if you don't find you can contact me at anacp@b105.upm.es.

3.  After a simulation, you can execute clean folder.py every time you need a new simulation.

3. When you are finishing, you can clean the folders of coils and simulations with clean_coils.py and clean_folder.py.

Simulation files: 
- TMS_human_stimulation.py
- TMS_mouse_stimulation.py
- TMS_human_Jfield_config.py

Coils can be found in commercial_coils folder, individual prototypes, and in commercial_coils_systems, group of coils.