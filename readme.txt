INSTRUCCIONES PARA LA EJECUCIÓN DE ARCHIVOS (Opciones separadas por rayas)

-----------------------------------------------------------------------------------------
Para ajustar los parámetros del coil y del core en los siguientes archivos respectivamente:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getCoilType.m
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getCoreType.m

La definición de las señales de excitación puede verse en:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getSignalExcitation.m

La definición de los materiales puede verse en:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/getMaterial.m
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
Para crear una bobina en Matlab, ejecutar el siguiente archivo una vez estén los parámetros del coil y core ajustados:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/coil_inductance_PGH.m
Antes de ejecutar, hay que indicar:
  --> El tipo de bobina ('bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5' o 'bobinaL6') en las líneas 10 y 11.
  --> El tipo de señal de excitación ('sinusoidal' o 'cuadrada') en la línea 20.
  --> El tipo de material ('m3_atan', 'm3_froe', 'gen_atan', 'met_froe') en la línea 318.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
1)
Para generar un dataset, ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/generate_dataset_Xlines.m
Antes de ejecutar, hay que indicar:
  --> El path en la línea 1.
  --> El tipo de bobina ('bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5' o 'bobinaL6') en la línea 3.
  --> El número de líneas que se quiera que tenga el dataset en la línea 45.
  --> El nombre del dataset creado ('coils_dataset_Xlines_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]) en las líneas 85 y 86.
  --> El tipo de señal de excitación ('sinusoidal' o 'cuadrada') en la línea 9 y el tipo de material ('m3_atan', 'm3_froe', 'gen_atan', 'met_froe') en la línea 293 del archivo generic_coil_inductance.m en la misma ruta.

2)
Para preprocesar el dataset generado, ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/sustituir_por_num.py
Antes de ejecutar, hay que indicar:
  --> El nombre del dataset creado anteriormente ('coils_dataset_Xlines_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]) tras su ruta, en la línea 20.
  --> El nombre del dataset preprocesado ('coils_dataset_Xlines_preprocesado_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]) tras su ruta, en la línea 26.

3)
Para aplicar el algoritmo de Random Forest al dataset proprocesado y obtener una combinación de valores de pitch1, pitch2 y Lcore que permitan obtener el valor de inductancia deseado, ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/random_forest.py
Antes de ejecutar, hay que indicar:
  --> La ruta del csv en la línea 9.
  --> El nombre del documento de texto donde se van a guardar los resultados obtenidos, con su ruta, en la línea 88.
-----------------------------------------------------------------------------------------
