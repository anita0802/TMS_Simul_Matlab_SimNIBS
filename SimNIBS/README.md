**How to simnibs 4.5.0**
03/12/2025
1. Downloader the Windows installer and execute it.
2. Open Simnibs command prompt.
3. Create a folder for place the coils and the m2m files.
4. Execute setup_env.py to generate the needed files for simulations.
5. Execute the stimulation file using the SimNIBS prompt from the stimulation file path or Visual Studio Code using "simnibs_python".
    5. 1. Go to the m2m files folder.
    5. 2. Execute "python path_to_your_code/stimulation_file.py" (SimNIBS prompt) 
    5. 3. Execute "simnibs_python path_to_your_code/stimulation_file.py" (Visual Studio Code terminal) 

*Known mistakes*
- zlib and uncompress errors: re-generate the coils and the files created with other simNIBS version or computer. Executing setup_env.py will fix the problem.

**Steps to execute SimNIBS scripts**

1. Execute python setup_env.py: this file will create the .tcd coils. It is importante to execute it always before working with the coils. This will use your version of SimNIBS to create the coils, whatever that version was. 
*"C:\Users\anacp\SimNIBS-4.1\psymulator\simnibs> simnibs_python  D:\psymulator\TMS_Simul_Matlab_SimNIBS\SimNIBS\setup_env.py"*

2. Modify the path to m2m_ernie or m2m_ernie_mouse folder in the config.json. You can find the files in the web, but if you don't find, contact me at anacp@b105.upm.es.

3. "C:\Users\anacp\SimNIBS-4.1\psymulator\simnibs> simnibs_python  *"D:\psymulator\TMS_Simul_Matlab_SimNIBS\SimNIBS\TMS_human_stimulation.py"*

4.  After a simulation, you must execute clean folder.py every time you need a new simulation.
*"C:\Users\anacp\SimNIBS-4.1\psymulator\simnibs> simnibs_python  D:\psymulator\TMS_Simul_Matlab_SimNIBS\SimNIBS\clean_folder.py"*

5. When you are finishing, you can clean the folders of coils and simulations with clean_coils.py.
*"C:\Users\anacp\SimNIBS-4.1\psymulator\simnibs> simnibs_python  D:\psymulator\TMS_Simul_Matlab_SimNIBS\SimNIBS\clean_coils.py"*

Simulation files: 
- TMS_human_stimulation.py
- TMS_mouse_stimulation.py
- TMS_human_Jfield_config.py

Coils can be found in commercial_coils folder, for individual prototypes, and in commercial_coils_systems, for group of coils. 

03/12/2025
**New features**
- FULLY INTEGRATED SIMNIBS TMS + J-FIELD + B-FIELD + 3D
    - Compute B-field using Biot–Savart law
    - Show central slice of Bx
    - 3D visualizarion with pyvista
        - 3D (A) — Show |J| on the mesh
        - 3D (B) — Show magnitude of B-field in 3D
**KNOWN ISSUES**
There are two engine folders. Engine folder for bem files and engine folder for coil and core creation. They have same names and similar files but their functions are not the same internally. 

JField error: 
Using mesh file: C:\Users\anacp\SimNIBS-4.5\tms_simu\ernie_TMS_1-0001_Coilkirlia_5A_scalar.msh
Read mesh OK. Fields: ['E', 'magnE', 'J', 'magnJ']
Nodes shape: ()
No tets in scalar.msh — trying original head mesh: C:\Users\anacp\SimNIBS-4.5\m2m_ernie\ernie.msh
Traceback (most recent call last):
  File "D:\psymulator\TMS_Simul_Matlab_SimNIBS\SimNIBS\TMS_human_Jfield_config.py", line 164, in <module>
    raise RuntimeError("No tetrahedra found in head mesh either.")
RuntimeError: No tetrahedra found in head mesh either.