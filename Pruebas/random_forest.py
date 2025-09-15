import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
#from sklearn.metrics import mean_absolute_error
from scipy.optimize import differential_evolution

# 1. Cargar el archivo CSV
file_path = 'coils_dataset_bobinaL4_05A_2025-07-30_22-21-47_preprocesado.csv'
df = pd.read_csv(file_path)

# 2. Preparar los datos para el entrenamiento
# Incluir nuevos parámetros: r1, r2, core_wd, turns1, turns2
features = ['coil_type', 'turns1', 'turns2', 'r1', 'pitch1', 'pitch2', 'Lcore', 'r2', 'core_wd']
X = df[features]
y = df['L']  # Inductancia objetivo

# Convertir coil_type a variables dummy
X = pd.get_dummies(X, columns=['coil_type'], drop_first=True)

# 3. Entrenamiento del modelo Random Forest
X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.2, random_state=42)
rf = RandomForestRegressor(n_estimators=200, max_depth=12, random_state=0)
rf.fit(X_tr, y_tr)
y_pred = rf.predict(X_te)

# 5. Función de pérdida para optimización inversa
def loss(vars, fixed_features, rf_model, dummy_columns):
    # vars: [p1, p2, Lc, r1, wd]
    p1, p2, Lc, r2, wd = vars
    # fixed_features: dict con valores de r2, turns1, turns2, coil_type
    feat = {
        'turns1': fixed_features['turns1'],
        'turns2': fixed_features['turns2'],
        'r1': fixed_features['r1'],
        'pitch1': p1,
        'pitch2': p2,
        'Lcore': Lc,
        'r2': r2,
        'core_wd': wd,
    }

    # Añadir coil_type dummy
    for col in dummy_columns:
        feat[col] = 1 if col == f"coil_type_{fixed_features['coil_type']}" else 0

    X_pred = pd.DataFrame([feat])[rf_model.feature_names_in_]
    Lpred = rf_model.predict(X_pred)[0]
    # Definir L_target según coil_type
    L_target_map = {
        1: 1e-6,
        2: 1.5e-6,
        3: 0.6e-6,
        4: 1.5e-6,
        5: 1.0e-6,
        6: 0.0049e-6,
    }
    L_target = L_target_map[fixed_features['coil_type']]
    return (Lpred - L_target)**2

# 6. Preparar parámetros para optimización
fixed = {
    'coil_type': 4,
    'r1': df['r1'].iloc[0],
    'turns1': df['turns1'].iloc[0],
    'turns2': df['turns2'].iloc[0],
}

bounds = [
    (df['pitch1'].min(), df['pitch1'].max()),
    (df['pitch2'].min(), df['pitch2'].max()),
    (df['Lcore'].min(), df['Lcore'].max()),
    (df['r2'].min(), df['r2'].max()),
    (df['core_wd'].min(), df['core_wd'].max()),
]

dummy_cols = [c for c in X.columns if c.startswith('coil_type_')]

res = differential_evolution(
    loss,
    bounds,
    args=(fixed, rf, dummy_cols),
    polish=True,
    popsize=15,
    tol=1e-6
)

opt_p1, opt_p2, opt_Lc, opt_r2, opt_wd = res.x

# 7. Predicción con parámetros óptimos
best_features = {
    'pitch1': opt_p1,
    'pitch2': opt_p2,
    'Lcore': opt_Lc,
    'r2': opt_r2,
    'r1': fixed['r1'],
    'core_wd': opt_wd,
    'turns1': fixed['turns1'],
    'turns2': fixed['turns2'],
}
for col in dummy_cols:
    best_features[col] = 1 if col == f"coil_type_{fixed['coil_type']}" else 0

X_opt = pd.DataFrame([best_features])[rf.feature_names_in_]
predicted_L = rf.predict(X_opt)[0]

print("Óptimos encontrados:")
print(f"  pitch1    = {opt_p1:.10f} mm")
print(f"  pitch2    = {opt_p2:.10f} mm")
print(f"  Lcore     = {opt_Lc:.10f} mm")
print(f"  r2        = {opt_r2:.10f} mm")
print(f"  core_wd   = {opt_wd:.10f} mm")
print(f"  Inductancia predicha = {predicted_L:.10e} H")

# Guardar resultados en un archivo de texto
out_path = 'C:/Users/Patriciagh/Documents/TFM/Pruebas/Resultados/optimized_results_l3.txt'
with open(out_path, 'w') as file:
    file.write("Óptimos encontrados:\n")
    file.write(f"  pitch1    = {opt_p1:.4f} mm\n")
    file.write(f"  pitch2    = {opt_p2:.4f} mm\n")
    file.write(f"  Lcore     = {opt_Lc:.4f} mm\n")
    file.write(f"  r2        = {opt_r2:.4f} mm\n")
    file.write(f"  core_wd   = {opt_wd:.4f} mm\n")
    file.write(f"  Inductancia predicha = {predicted_L:.4e} H\n")

#  8) Encuentra las filas reales más cercanas a L_target
L_target_map = {
    1: 1e-6,
    2: 1.5e-6,
    3: 0.6e-6,
    4: 1.5e-6,
    5: 1.0e-6,
    6: 0.0049e-6,
}
L_target = L_target_map[ fixed['coil_type'] ]

df_ct = df[df['coil_type'] == fixed['coil_type']].copy()
df_ct['error_abs'] = (df_ct['L'] - L_target).abs()
closest = df_ct.nsmallest(10, 'error_abs')   # las 10 más cercanas

cols = ['turns1','turns2','r1','pitch1','pitch2',
        'Lcore','r2','core_wd','L','error_abs']
print("\nFilas del CSV más cercanas a L_target:")
print( closest[cols].to_string(index=False) )