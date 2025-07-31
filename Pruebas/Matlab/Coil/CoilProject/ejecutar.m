%% ejecutar.m

addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject');

clear all;
clc;

coil_type = 'bobinaL6';
core_type     = coil_type;
signal_type   = 'cuadrada';
material_type = 'm3_froe';

if ~ischar(coil_type) || ~ismember(coil_type, {'bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5', 'bobinaL6'})
    error('coilName is not valid or recognized.');
end

% generate_dataset_Xlines
% generate_dataset_Xlines_ejecucion2


% 3) Llamada a la función
coil_inductance_PGH
 
% 
% 
% core04_surface_field_b
% core04_surface_field_c
% core05_line_field_electric1
% core05_line_field_electric2
% core05_line_field_magnetic
% 
% cd ../../
% 
% close all;
% 
% % bem_PGH
% bem0_load_model
% bem1_setup_coil
% bem2_charge_engine
% %bem3_surface_field_c
% bem3_surface_field_e
% bem4_define_planes
% bem5_volume_XZ
% bem5_volume_YZ
% 
% %%
% % Crear carpeta si no existe
% output_folder = 'Figuras Bobina L4.3';
% if ~exist(output_folder, 'dir')
%     mkdir(output_folder);
% end
% 
% % Obtener todas las figuras abiertas
% figs = findall(0, 'Type', 'figure');
% 
% % Guardarlas una por una
% for i = 1:length(figs)
%     figure(figs(i)); % Asegurar que esté activa
%     filename = fullfile(output_folder, sprintf('figura_%02d.png', i));
%     exportgraphics(figs(i), filename, 'Resolution', 300);
% end
% 
% cd Coil\CoilProject\