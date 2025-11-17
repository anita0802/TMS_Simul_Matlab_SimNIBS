How to simnibs 4.5.0:

1. Downloader the Windows installer and execute it.
2. Open Simnibs command prompt.
3. Create a folder for place the coils and the m2m files.
4. Execute setup_env.py to generate the needed files for simulations.
5. Execute the stimulation file using the SimNIBS prompt from the stimulation file path.
    5.1. Go to the m2m files folder.
    5.2. Execute "python path_to_your_code/stimulation_file.py"

Known mistakes: 
- zlib and uncompress errors: re-generate the coils and the files created with other simNIBS version or computer. Executing setup_env.py will fix the problem.

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

**TO DO list**
- Change the name of the coil files.