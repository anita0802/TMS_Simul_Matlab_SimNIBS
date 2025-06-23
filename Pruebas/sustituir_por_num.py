import os
import pandas as pd
from sklearn.preprocessing import LabelEncoder

coil_type = {
    'bobinaL1': 1,
    'bobinaL2': 2,
    'bobinaL3': 3,
    'bobinaL4': 4,
    'bobinaL5': 5,
    'bobinaL6': 6,
}

def sustituir_nombres_por_numeros(dataframe, columna):
    dataframe[columna] = dataframe[columna].replace(coil_type)
    return dataframe
    

# Lee el dataset
data = pd.read_csv('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/CoilProject05/coils_dataset_20lines_l1.csv')

# Aplica la función para sustituir los nombres por números en la columna "nombres"
data = sustituir_nombres_por_numeros(data, 'coil_type')

# Guarda el dataset con los nombres sustituidos por números en un nuevo archivo CSV
data.to_csv('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/CoilProject05/coils_dataset_20lines_preprocesado_l1.csv', index=False)