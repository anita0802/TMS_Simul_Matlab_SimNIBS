import os
import shutil
import glob

def main():
    # 🔹 Patrones o rutas a borrar (pueden incluir comodines)
    patterns = [
        "tms_simu",
    ]

    for pattern in patterns:
        for path in glob.glob(pattern):
            if os.path.isfile(path):
                os.remove(path)
                print(f"🗑️ Archivo eliminado: {path}")
            elif os.path.isdir(path):
                shutil.rmtree(path)
                print(f"🧹 Carpeta eliminada: {path}")

    print("✅ Limpieza completada.")

if __name__ == "__main__":
    main()
