%%L4
clear all;
coil_Magnetic_Core_Rat_L4
core00_Rect_L4
core01_process_core
core02_load_coil_and_core
core03_charge_engine_linear
core03_charge_engine_nonlinear

%    Lpri: 1.0392e-06
%    Lsec: 4.6299e-07
%    L: 1.5022e-06

%%

clear all;
clc;

%cd Coil\CoilProject\

coil_inductance_PGH
core04_surface_field_b
core04_surface_field_c
core05_line_field_electric1
core05_line_field_electric2
core05_line_field_magnetic

cd ../../

% bem_PGH
bem0_load_model
bem1_setup_coil
bem2_charge_engine
bem3_surface_field_c
bem3_surface_field_e
bem4_define_planes
bem5_volume_XZ
bem5_volume_YZ

%%
% Crear carpeta si no existe
output_folder = 'Figuras Bobina L3';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Obtener todas las figuras abiertas
figs = findall(0, 'Type', 'figure');

% Guardarlas una por una
for i = 1:length(figs)
    figure(figs(i)); % Asegurar que esté activa
    filename = fullfile(output_folder, sprintf('figura_%02d.png', i));
    exportgraphics(figs(i), filename, 'Resolution', 300);
end


%% L4 1A
coil_Magnetic_Core_Rat_L4_1A
core00_Rect_L4_1A
core01_process_core
core02_load_coil_and_core
core03_charge_engine_linear
core03_charge_engine_nonlinear

%        Lpri: 1.0392e-06
%    Lsec: 4.6790e-07
%       L: 1.5071e-06

%% L1
%cd C:\Users\anacp\psymulator\coil_building\Coil\CoilProject05

clear all;
coil_Magnetic_Core_Rat_L1
core00_Rect_L1
core01_process_core
core02_load_coil_and_core
core03_charge_engine_linear
core03_charge_engine_nonlinear

%            Lpri: 8.5635e-07
%    Lsec: 2.2727e-07
%       L: 1.0836e-06

%% L1 1A
cd C:\Users\anacp\psymulator\coil_building\Coil\CoilProject05

coil_Magnetic_Core_Rat_L1_1A
core00_Rect_L1_1A
core01_process_core
core02_load_coil_and_core
core03_charge_engine_linear
core03_charge_engine_nonlinear

%        Lpri: 1.0113e-06
%    Lsec: 1.2147e-08
%       L: 1.0235e-06

%-- Common
core04_surface_field_b
core04_surface_field_c
core05_line_field_electric1
core05_line_field_electric2
core05_line_field_magnetic

cd ../../

bem0_load_model
bem1_setup_coil
bem2_charge_engine
bem3_surface_field_c
bem3_surface_field_e
bem4_define_planes
bem5_volume_XZ
