import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
from scipy.optimize import differential_evolution

# 1. Cargar el archivo CSV
file_path = 'C:/Users/Patriciagh/Documents/TFM/Pruebas/coils_dataset_100lines_preprocesado_l3.csv'
df = pd.read_csv(file_path)

# 2. Preparar los datos para el entrenamiento
X = df[['pitch1', 'pitch2', 'Lcore', 'coil_type']]  # Características de entrada
y = df['L']  # Inductancia (valor objetivo)

# 3. Entrenamiento del modelo Random Forest
X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.2, random_state=42)
rf = RandomForestRegressor(n_estimators=200, max_depth=12, random_state=0)
rf.fit(X_tr, y_tr)
y_pred = rf.predict(X_te)

# 4. Calcular el error absoluto medio en el conjunto de prueba
mae = mean_absolute_error(y_te, y_pred)
print(f"MAE en test: {mae:.4f} H")

# 5. Función de pérdida para optimización inversa
def loss(vars):
    p1, p2, Lc = vars
    coil_type = 1

    # Determinamos el valor de L_target según coil_type
    if coil_type == 1:
        L_target = 1e-6
    elif coil_type == 2:
        L_target = 1.5e-6
    elif coil_type == 3:
        L_target = 0.6e-6
    elif coil_type == 4:
        L_target = 1.5e-6
    elif coil_type == 5:
        L_target = 1.0e-6
    elif coil_type == 6:
        L_target = 0.0049e-6

    # Crear un array de características para la predicción
    X_pred = pd.DataFrame([[p1, p2, Lc, coil_type]])

    # Predecir la inductancia con el modelo Random Forest
    Lpred = rf.predict(X_pred)[0]

    # Función de pérdida: diferencia cuadrada entre la inductancia predicha y L_target
    return (Lpred - L_target)**2

# 6. Uso del modelo para encontrar los parámetros para L_target
p1_min, p1_max = df['pitch1'].min(), df['pitch1'].max()
p2_min, p2_max = df['pitch2'].min(), df['pitch2'].max()
Lc_min, Lc_max = df['Lcore'].min(), df['Lcore'].max()

# Establecer los límites para los parámetros
bounds = [(p1_min, p1_max), (p2_min, p2_max), (Lc_min, Lc_max)]

# Ejecutar la optimización para encontrar los mejores parámetros
res = differential_evolution(loss, bounds, polish=True)

# Obtener los valores optimizados
opt_p1, opt_p2, opt_Lc = res.x

# Predicción de la inductancia para los parámetros optimizados
coil_type = 1

# Obtener las columnas de entrada del DataFrame original
columns = X.columns

# Crear un DataFrame con las características predichas y los nombres de las columnas correctas
X_pred_optimized_df = pd.DataFrame([[opt_p1, opt_p2, opt_Lc, coil_type]], columns=columns)

# Realizar la predicción
predicted_L = rf.predict(X_pred_optimized_df)[0]

# Imprimir resultados
print(f"Óptimos encontrados:")
print(f"  pitch1 = {opt_p1:.10f} mm")
print(f"  pitch2 = {opt_p2:.10f} mm")
print(f"  Lcore  = {opt_Lc:.10f} mm")
print(f"  Inductancia predicha = {predicted_L:.10f} H")

# Crear un archivo de texto con los resultados
with open('C:/Users/Patriciagh/Documents/TFM/Pruebas/Resultados/optimized_results_l3.txt', 'w') as file:
    file.write(f"Óptimos encontrados:\n")
    file.write(f"  pitch1 = {opt_p1:.3f} mm\n")
    file.write(f"  pitch2 = {opt_p2:.3f} mm\n")
    file.write(f"  Lcore  = {opt_Lc:.3f} mm\n")
    file.write(f"  Inductancia predicha = {predicted_L:.4e} H\n")