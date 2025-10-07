import pandas as pd

# Archivo CSV original (formato inglés: decimal='.', separador de columnas=',')
input_file = "C:/Users/Patriciagh/Documentos/TFM/Pruebas/DATASETS DEFINITIVOS/param/coils_dataset_bobinaL1_corewd.csv"

# # Opción 1: Guardar como CSV con separador ';' (Excel España lo abre bien)
# output_csv = "c:/Users/Patriciagh/Documentos/TFM/Pruebas/DATASETS DEFINITIVOS/05A/coils_dataset_bobinaL1_pitch1_convertido.csv"
# df = pd.read_csv(input_file, sep=",", decimal=".")
# df.to_csv(output_csv, sep=";", decimal=".", index=False)
# print(f"Archivo CSV guardado en: {output_csv}")

# Opción 2: Guardar directamente como Excel (.xlsx)
output_xlsx = "C:/Users/Patriciagh/Documentos/TFM/Pruebas/DATASETS DEFINITIVOS/param/05A_excel/coils_dataset_bobinaL1_corewd_excel.xlsx"
df = pd.read_csv(input_file, sep=",", decimal=".")
df.to_excel(output_xlsx, index=False)
print(f"Archivo Excel guardado en: {output_xlsx}")