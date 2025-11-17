import os
import subprocess
import itertools

def run_scripts_in_folder(folder, coil_labels, current_labels, extra_labels=None):
    """Ejecuta los scripts dentro de una carpeta según los patrones definidos."""
    print(f"\nEntrando en carpeta: {folder}")
    os.chdir(folder)

    # Si hay una variable extra, usar producto triple
    if extra_labels:
        combos = itertools.product(coil_labels, current_labels, extra_labels)
    else:
        combos = itertools.product(coil_labels, current_labels)

    for combo in combos:
        if extra_labels:
            coil, current, extra = combo
            script_name = f"Coil{coil}_{extra}_{current}.py"
        else:
            coil, current = combo
            script_name = f"Coil{coil}_{current}.py"

        if not os.path.exists(script_name):
            print(f"No encontrado: {script_name}")
            continue

        print(f"Ejecutando: {script_name}")
        try:
            subprocess.run(["python", script_name], check=True)
        except subprocess.CalledProcessError:
            print(f"Error ejecutando {script_name}")

    os.chdir("..")
    print(f"Finalizado en {folder}")

def main():
    # 🔹 Patrones comunes
    coil_labels = ["L1", "L3", "L4", "L5", "kirlia"]
    current_labels = ["05A", "1A", "2A", "5A"]

    # 🔹 Configuración por carpeta
    folders_config = [
        # Carpeta normal
        {"name": "commercial_coils", "extra_labels": None},

        # Carpeta con una variable adicional (por ejemplo, frecuencias o modos)
        {"name": "commercial_coils_systems", "extra_labels": ["x2"]}
    ]

    for config in folders_config:
        folder = config["name"]
        extra_labels = config.get("extra_labels")

        if os.path.exists(folder):
            run_scripts_in_folder(folder, coil_labels, current_labels, extra_labels)
        else:
            print(f"Carpeta no encontrada: {folder}")

    print("\nTodos los scripts fueron ejecutados correctamente.")

if __name__ == "__main__":
    main()
