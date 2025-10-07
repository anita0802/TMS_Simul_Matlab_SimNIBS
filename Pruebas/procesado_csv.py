from pathlib import Path
import pandas as pd
import re

# 1) Carpeta base donde está este script
base_dir = Path(__file__).parent

# 2) Rutas de entrada y salida
input_csv    = base_dir / 'DATASETS DEFINITIVOS' / '2A' / 'coils_dataset_bobinaL5_2A_2025-08-02_11-02-42.csv'
preproc_csv  = base_dir / 'DATASETS DEFINITIVOS' / 'coils_dataset_bobinaL5_2A_2025-08-02_11-02-42_preprocesado.csv'
closest_csv  = base_dir / 'DATASETS DEFINITIVOS' / 'coils_dataset_bobinaL5_2A_2025-08-02_11-02-42_closest.csv'

# 2.1) Extrae FIXED_COIL_TYPE del nombre del archivo
match = re.search(r'bobinaL(\d+)', input_csv.name)
if not match:
    raise ValueError(f"No se ha podido extraer el tipo de bobina de '{input_csv.name}'")
FIXED_COIL_TYPE = int(match.group(1))

# 3) Parámetros (ajusta aquí)
L_target = {
    1: 1.0e-6,
    2: 1.5e-6,
    3: 0.6e-6,
    4: 1.5e-6,
    5: 1.0e-6,
    6: 0.0049e-6,
}
N_CLOSEST       = 1   # Número de filas

# 4) Carga el dataset
df = pd.read_csv(input_csv)

# 5) Sustituye 'bobinaLx' por el número x
df['coil_type'] = (
    df['coil_type']
      .str.extract(r'L(\d+)', expand=False)
      .astype(int)
)

# 6) Redondeo numérico a 9 decimales
cols_to_round = ['pitch1', 'pitch2', 'Lcore', 'r2', 'core_wd', 'Lpri', 'Lsec', 'L']
df[cols_to_round] = df[cols_to_round].round(9)

# 7) Guarda el CSV preprocesado
df.to_csv(preproc_csv, index=False)
print(f"✔ Preprocesado guardado en: {preproc_csv}")

# 8) Filtra el DataFrame por el tipo de bobina elegido
df_ct = df[df['coil_type'] == FIXED_COIL_TYPE].copy()

# 9) Calcula el error absoluto y selecciona las N más pequeñas
target_L = L_target[FIXED_COIL_TYPE]
df_ct['error_abs'] = (df_ct['L'] - target_L).abs()
closest = df_ct.nsmallest(N_CLOSEST, 'error_abs')

# 10) Muestra por pantalla y guarda en CSV
print(f"\nLas {N_CLOSEST} filas de coil_type={FIXED_COIL_TYPE} con L más cercanas a {target_L}:")
print(closest.to_string(index=False))
closest.to_csv(closest_csv, index=False)
print(f"\n✔ Resultado guardado en: {closest_csv}")
