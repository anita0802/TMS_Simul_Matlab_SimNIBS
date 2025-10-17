INSTRUCTIONS FOR EXECUTING FILES (Options separated by dashes)

-----------------------------------------------------------------------------------------
To adjust the coil and core parameters in the following files respectively:
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/getCoilType.m
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/getCoreType.m

The definition of the excitation signals can be found in:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getSignalExcitation.m

The definition of the materials can be found in:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getMaterial.m
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

To create a coil in Matlab, run the following file once the coil and core parameters have been set:
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/coil_inductance_PGH.m
Before running, you must specify:
  --> The type of coil (‘coilL1’, ‘coilL2’, ‘coilL3’, ‘coilL4’, ‘coilL5’, or ‘coilL6’) in “coil_type = ...”.
  --> The type of excitation signal (‘sinusoidal’ or ‘square’) in “signal_type = ...”.
  --> The type of material (‘m3_atan’, ‘m3_froe’, ‘gen_atan’, ‘met_froe’) in “material_type = ...”.
-----------------------------------------------------------------------------------------

---- OPTION 1 ----
-----------------------------------------------------------------------------------------
1)
To generate a dataset, run the following file:
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/generate_dataset_Xlines.m
Before running, you must specify:
  --> The path.
  --> The type of coil (‘coilL1’, ‘coilL2’, ‘coilL3’, ‘coilL4’, ‘coilL5’, or ‘coilL6’).
  --> The range for the different parameters depending on the coil used.
  --> Linespace is used to generate the lines of the dataset, so you must specify the value of N1, N2, N3, N4, and N5, depending on the number of equispaced points desired for each parameter within the specified range of values.
  --> The name of the dataset created (‘coils_dataset_Xlines_lY.csv’, where X is the number of lines and Y is the coil type [1, 2, 3, 4, 5, 6]).
  --> The excitation signal type (‘sinusoidal’ or ‘square’) and the material type (‘m3_atan’, ‘m3_froe’, ‘gen_atan’, ‘met_froe’) in the generic_coil_inductance.m file in the same path.

2)
The preprocessing of the datasets consists of replacing the name of the coil with its corresponding number and, on the other hand, trimming the number of decimal places for the parameters: ‘pitch1’, ‘pitch2’, ‘Lcore’, ‘Lpri’, ‘Lsec’, ‘L’. It can be adapted according to the parameters for which you want to trim the number of decimal places. The number of decimal places can also be adjusted.

To preprocess the generated dataset, run the following file:
- C:/Users/Patriciagh/Documents/TFM/Tests/preprocessing.py
Before running, you must specify:
  --> The name of the previously created dataset (‘coils_dataset_Xlines_lY.csv’, where X is the number of lines and Y is the type of coil [1, 2, 3, 4, 5, 6]) after its path.
  --> The name of the preprocessed dataset (‘coils_dataset_Xlines_preprocesado_lY.csv’, where X is the number of lines and Y is the type of coil [1, 2, 3, 4, 5, 6]) after its path.

3)
Two algorithms have been designed to predict the value of the parameters based on the target inductance:
3.1)
To apply the Random Forest algorithm to the preprocessed dataset and obtain a combination of values for ‘pitch1’, ‘pitch2’, ‘Lcore’, ‘wire_d’, and ‘r1’ that allow the desired inductance value to be obtained, run the following file:
  - C:/Users/Patriciagh/Documents/TFM/Tests/random_forest.py
  Before running, you must indicate:
    --> The path of the csv.
    --> The name of the text document where the results obtained will be saved, with its path.

 3.2)
  To apply the Multilayer Perceptron (MLP) algorithm to the preprocessed dataset and obtain a combination of values for ‘pitch1’, ‘pitch2’, ‘Lcore’, ‘wire_d’, and ‘r1’ that allow the desired inductance value to be obtained, run the following file:
  - C:/Users/Patriciagh/Documents/TFM/Tests/mlp.py
  Before executing, you must indicate:
    --> The path to the csv file.
-----------------------------------------------------------------------------------------

---- OPTION 2 ----
-----------------------------------------------------------------------------------------
I am working on this new script, it is not yet functional.
Run the following file:
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/new_dataset.m
Before running, you must indicate:
  --> The path.
  --> The coil type (‘coilL1’, ‘coilL2’, ‘coilL3’, ‘coilL4’, ‘coilL5’, or ‘coilL6’).

This script in turn calls:
- C:/Users/Patriciagh/Documents/TFM/Tests/Matlab/Coil/CoilProject/adaptive_grid.m

The ultimate purpose of these files is to generate a dataset based on the trend of ‘L’ as a function of the evolution of the different parameters that are being varied. In this way, more points are added where a more significant change in the value of L is observed.
I'm not yet convinced that this is useful; I'm testing it, but I need to think about it some more. This basically serves to reduce the number of iterations that generate very similar results, taking advantage of this to increase the iterations in intervals where the value of ‘L’ varies significantly, that is, to better cover the space, so to speak.

