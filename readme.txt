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
  --> El tipo de bobina ('bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5' o 'bobinaL6') en "coil_type = ...".
  --> El tipo de señal de excitación ('sinusoidal' o 'cuadrada') en "signal_type = ...".
  --> El tipo de material ('m3_atan', 'm3_froe', 'gen_atan', 'met_froe') en "material_type = ...".
-----------------------------------------------------------------------------------------

---- OPCIÓN 1 ----
-----------------------------------------------------------------------------------------
1)
Para generar un dataset, ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/generate_dataset_Xlines.m
Antes de ejecutar, hay que indicar:
  --> El path.
  --> El tipo de bobina ('bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5' o 'bobinaL6').
  --> El rango para los distintos parámetros en función de la bobina utilizada.
  --> Se utiliza linespace para generar las líneas del dataset, por tanto hay que indicar el valor de N1, N2, N3, N4 y N5, en función del número de puntos equiespaciados que se deseen para cada parámetro dentro del rango de valores especificado.
  --> El nombre del dataset creado ('coils_dataset_Xlines_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]).
  --> El tipo de señal de excitación ('sinusoidal' o 'cuadrada') y el tipo de material ('m3_atan', 'm3_froe', 'gen_atan', 'met_froe') en el archivo generic_coil_inductance.m en la misma ruta.

2)
El preprocesdo de los datasets consiste en sustituir el nombre de la bobina por su número correspondiente, y por otro lado, recortar el número de decimales para los parámetros: 'pitch1', 'pitch2', 'Lcore', 'Lpri', 'Lsec', 'L'. Se puede adaptar según los parámetros de los que se desee recortar el número de decimales. También se puede ajustar el número de decimales.

Para preprocesar el dataset generado, ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/preprocesado.py
Antes de ejecutar, hay que indicar:
  --> El nombre del dataset creado anteriormente ('coils_dataset_Xlines_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]) tras su ruta.
  --> El nombre del dataset preprocesado ('coils_dataset_Xlines_preprocesado_lY.csv', siendo X el número de líneas e Y el tipo de bobina [1, 2, 3, 4, 5, 6]) tras su ruta.

3)
Se han diseñado dos algoritmos para predecir el valor de los parámetros en función de la inductancia objetivo:
  3.1)
  Para aplicar el algoritmo de Random Forest al dataset proprocesado y obtener una combinación de valores de             'pitch1','pitch2','Lcore','wire_d' y 'r1' que permitan obtener el valor de inductancia deseado, ejecutar el siguiente   archivo:
  - C:/Users/Patriciagh/Documents/TFM/Pruebas/random_forest.py
  Antes de ejecutar, hay que indicar:
    --> La ruta del csv.
    --> El nombre del documento de texto donde se van a guardar los resultados obtenidos, con su ruta.
  3.2)
  Para aplicar el algoritmo de Perceptrón Multicapa (MLP) al dataset proprocesado y obtener una combinación de valores de 'pitch1','pitch2','Lcore','wire_d' y 'r1' que permitan obtener el valor de inductancia deseado, ejecutar el siguiente archivo:
  - C:/Users/Patriciagh/Documents/TFM/Pruebas/mlp.py
  Antes de ejecutar, hay que indicar:
    --> La ruta del csv.
-----------------------------------------------------------------------------------------

---- OPCIÓN 2 ----
-----------------------------------------------------------------------------------------
Estoy trabajando en este nuevo script, aún no es funcional.
Ejecutar el siguiente archivo:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/new_dataset.m
Antes de ejecutar, hay que indicar:
  --> El path.
  --> El tipo de bobina ('bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5' o 'bobinaL6').

Este script llama a su vez a:
- C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/adaptive_grid.m

La funcionalidad final de estos archivos es generar un dataset basado en la tendencia de 'L' en función de la evolución de los distintos parámetros que se van variando. De esta forma, se añaden más puntos donde se observe un cambio más significativo en el valor de L.
No estoy convencida aún de que esto sea útil, estoy probando pero tengo que darle más vueltas. Esto básicamente sirve para reducir el número de iteraciones que generen resultados muy similares, aprovechando para incrementar las iteraciones en intervalos donde el valor de 'L' varíe significativamente, es decir, cubrir mejor el espacio por así decirlo.
-----------------------------------------------------------------------------------------
