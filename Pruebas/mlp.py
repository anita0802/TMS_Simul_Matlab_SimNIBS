import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

# 1. Cargar el archivo CSV
file_path = 'C:/Users/Patriciagh/Documents/TFM/Pruebas/coils_dataset_pruebalines_preprocesado_l6.csv'
df = pd.read_csv(file_path)

# 2. Preparar los datos para el entrenamiento
X = df[['pitch1','pitch2','Lcore','wire_d','r1','coil_type']].values  # Características de entrada
y = df['L'].values.reshape(-1,1)  # Inductancia (valor objetivo)
# Conversión a tensores de Pytorch de tipo float32 para podr entrenar la red
X_t = torch.tensor(X, dtype=torch.float32)
y_t = torch.tensor(y, dtype=torch.float32)
# DataLoader agrupa en lotes de 32 muestras y mezcla el orden en cada época
loader = DataLoader(TensorDataset(X_t,y_t), batch_size=32, shuffle=True)

# 3. Definir el modelo MLP
class MLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(6, 64), nn.ReLU(),    # capa densa: 6→64 neuronas
            nn.Linear(64, 64), nn.ReLU(),   # capa oculta 64→64
            nn.Linear(64, 1)                # capa de salida 64→1 (inductancia estimada)
        )
    def forward(self,x):
        return self.net(x)

# 4. Configuración del entrenamiento
model = MLP()
opt = torch.optim.Adam(model.parameters(), lr=1e-3)     # model.parameters() son los pesos de la red
                                                        # Adam es el optimizador que ajusta esos pesos con tasa de aprendizaje 1e-3
loss_fn = nn.MSELoss()      # error cuadrático medio: mide la distancia entre la predicción y el valor real

# 5. Entrenamiento del modelo MLP
for epoch in range(200):
    for xb, yb in loader:
        pred = model(xb)                 # forward pass, calcula la predicción
        loss = loss_fn(pred, yb)         # cálculo de la pérdida entre pred y yb
        opt.zero_grad()                  # limpia gradientes previos
        loss.backward()                  # backpropagation
        opt.step()                       # actualización de pesos

# 6. Diseño inverso por optimización de entrada: en lugar de aprender pesos, aprendemos los parámetros de entrada que produzcan una inductancia objetiva
# Determinamos el valor de L_target según coil_type
coil_type = 6

if coil_type == 1:
    L_target = 1.0e-6
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
L_target = torch.tensor([[L_target]], dtype=torch.float32)
# Creamos un tensor de parámetros iniciales con gradiente activado
x_inv = torch.randn((1,6), requires_grad=True, dtype=torch.float32)
# Optimizador sobre x_inv
inv_opt = torch.optim.Adam([x_inv], lr=1e-2)
# Bucle de optimización
for i in range(500):
    pred = model(x_inv)                         # predicción para los parámetros actuales
    loss_inv = (pred - L_target).pow(2).mean()  # diferencia cuadrática
    inv_opt.zero_grad(); loss_inv.backward(); inv_opt.step()
    # Clampeo (opcional) para mantener rangos físicos
    with torch.no_grad():
        x_inv[:, :5].clamp_(min=0.0)  # pitch1…radius1 ≥ 0
        x_inv[:, 5].clamp_(1, 6)      # coil_type ∈ [1,6]

# 7. Mostrar resultado
params = x_inv.detach().numpy().reshape(-1)
print("Parámetros de entrada:")
print(f"pitch1  = {params[0]:.10f}")
print(f"pitch2  = {params[1]:.10f}")
print(f"Lcore   = {params[2]:.10f}")
print(f"wd_core = {params[3]:.10f}")
print(f"radius1 = {params[4]:.10f}")
print("Inductancia predicha:", model(x_inv).item())
