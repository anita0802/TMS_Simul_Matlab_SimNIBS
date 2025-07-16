clear all;
clc;

% Añade rutas
addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject');

% Parámetros de bobina y tipo
coil_type = 'bobinaL6';   % Nombre exacto para generic_coil_inductance
baseCoil  = getCoilType(coil_type);
baseCore  = getCoreType(coil_type);

% Definir rangos según tipo
switch coil_type
    case 'bobinaL6'
        bounds.pitch1 = [0.00007, 0.001];
        bounds.pitch2 = [0.00007, 0.001];
        bounds.Lcore  = [0.00003,0.0035];
        bounds.wire_d = [0.000075,0.0001];
        bounds.r1     = [0.00015, 0.0004];
    % otros casos si es necesario...
    otherwise
        error('Tipo de bobina desconocido');
end

% --- 3) Prepara CSV de salida para escritura incremental ---
filename = 'coils_dataset_adaptive.csv';
if exist(filename,'file')
    movefile(filename, [filename '_backup']);
end
% Abre, escribe cabecera y cierra
fid = fopen(filename,'w');
fprintf(fid, ['coil_type,turns1,turns2,r1,r2,wire_d,' ...
              'pitch1,pitch2,Lcore,Lpri,Lsec,L\n']);
fclose(fid);

% --- 4) Parámetros de muestreo adaptativo ---
tol      = 1e-9;   % subdivide si ΔL > 1 nH
maxDepth = 4;      % profundidad máxima

% --- 5) Contador global de filas ---
row = 0;

% --- 6) Función handle para evaluar y escribir cada muestra ---
eval_L_and_write = @(v) local_eval_and_write(v, baseCoil, baseCore, coil_type, filename);

% --- 7) Ejecutar muestreo adaptativo (escribe al vuelo) ---
adaptive_grid(bounds, tol, maxDepth, eval_L_and_write);
fprintf('Total de muestras escritas: %d\n', row);

%% --- Función auxiliar que evalúa L y escribe fila CSV ---
function Lout = local_eval_and_write(params, baseCoil, baseCore, coil_type, filename)
    % Variables de workspace compartido
    persistent row_counter
    if isempty(row_counter), row_counter = 0; end

    % 1) Monta coil y core con los parámetros
    coil = baseCoil; core = baseCore;
    coil.pitch1   = params(1);
    coil.pitch2   = params(2);
    core.L        = params(3);
    coil.wd       = params(4);
    coil.radius1  = params(5);

    % 2) Llamada a rutina de inductancia
    clear Inductance;
    generic_coil_inductance;  % usa coil_type, coil, core
    Lpri = Inductance.Lpri;
    Lsec = Inductance.Lsec;
    Lout = Inductance.L;      % para que adaptive_grid compare ΔL

    % 3) Incrementa y muestra progreso
    row_counter = row_counter + 1;
    fprintf('Procesando línea %d: L = %.3e H\n', row_counter, Lout);

    % 4) Escribe fila en CSV (modo append)
    fid = fopen(filename,'a');
    fprintf(fid, '%s,%d,%d,%.6e,%.6e,%.6e,%.6e,%.6e,%.6e,%.6e,%.6e,%.6e\n', ...
        coil_type, ...
        coil.turns1, coil.turns2, ...
        coil.radius1, coil.radius2, coil.wd, ...
        coil.pitch1, coil.pitch2, core.L, ...
        Lpri, Lsec, Lout);
    fclose(fid);
end