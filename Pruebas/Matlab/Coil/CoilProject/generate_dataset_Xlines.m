addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject');

clear all;

coil_type = 'bobinaL6';
baseCoil     = getCoilType(coil_type);
baseCore     = getCoreType(coil_type);

if ~ischar(coil_type) || ~ismember(coil_type, {'bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5', 'bobinaL6'})
    error('coilName is not valid or recognized.');
end

p1_min = NaN;   p1_max = NaN;
p2_min = NaN;   p2_max = NaN;
Lc_min = NaN;   Lc_max = NaN;
wdc_min = NaN;  wdc_max= NaN;
r1_min = NaN;   r1_max = NaN;

switch coil_type
    case 'bobinaL1'
        p1_min = 0.00075;   p1_max = 0.005;
        p2_min = 0.00075;   p2_max = 0.005;
        Lc_min = 0.001;     Lc_max = 0.008;       % altura bobina L1 6.6mm
        wdc_min = 0.0035;    wdc_max= 0.004;
        r1_min = 0.0045;    r1_max = 0.006;
    case 'bobinaL2'
        p1_min = 0.00045;   p1_max = 0.005;
        p2_min = 0.00045;   p2_max = 0.005;
        Lc_min = 0.001;     Lc_max = 0.004;        % altura bobina L2 5.8mm
        wdc_min = 0.00055;   wdc_max= 0.00085;
        r1_min = 0.0009;    r1_max = 0.003;
    case 'bobinaL3'
        p1_min = 0.00042;   p1_max = 0.004;
        p2_min = 0.00042;   p2_max = 0.004;
        Lc_min = 0.0001;    Lc_max = 0.006;        % altura bobina L3 4.5mm
        wdc_min = 0.00055;  wdc_max= 0.00075;
        r1_min = 0.0008;    r1_max = 0.002;
    case 'bobinaL4'
        p1_min = 0.0001;    p1_max = 0.006;
        p2_min = 0.0001;    p2_max = 0.006;
        Lc_min = 0.0001;    Lc_max = 0.003;        % altura bobina L4 1.8mm
        wdc_min = 0.00065;   wdc_max= 0.0008;
        r1_min = 0.00085;   r1_max = 0.001;
    case 'bobinaL5'
        p1_min = 0.00018;   p1_max = 0.0015;
        p2_min = 0.00018;   p2_max = 0.0015;
        Lc_min = 0.0001;    Lc_max = 0.0035;        % altura bobina L5 2mm
        wdc_min = 0.00025;  wdc_max= 0.0006;
        r1_min = 0.00065;   r1_max = 0.001;
    case 'bobinaL6'
        p1_min = 0.00007;   p1_max = 0.001;
        p2_min = 0.00007;   p2_max = 0.001;
        Lc_min = 0.00003;   Lc_max = 0.0035;        % altura bobina L6 1.6mm
        wdc_min = 0.000075;  wdc_max= 0.0001;
        r1_min = 0.00015;   r1_max = 0.0004;
    otherwise
        warning('Bobina no reconocia')
end

N1 = 5;
N2 = 1;
N3 = 5;
N4 = 5;
N5 = 5;

pitch1_valores   = linspace(p1_min,     p1_max,     N1);
pitch2_valores   = linspace(p2_min,     p2_max,     N2);
Lcore_valores    = linspace(Lc_min,     Lc_max,     N3);
wd_core_valores  = linspace(wdc_min,    wdc_max,    N4);
radius1_valores  = linspace(r1_min,     r1_max,     N5);

numRows = N1*N2*N3*N4*N5;

allRows = cell(numRows, 12);

filename = 'coils_dataset_pruebalines_l6.csv';
if exist(filename,'file')
    % Descompone ruta, nombre y extensión
    [pathstr, name, ext] = fileparts(filename);
    % Construye nombre de copia
    copiaName = fullfile(pathstr, [name '_copia' ext]);
    % Renombra el fichero original
    movefile(filename, copiaName);
end

row = 0;
for i = 1:N1
  for j = 1:N2
    for k = 1:N3
      for l = 1:N4
        for m = 1:N5
          row = row + 1;
      
          % Asigna parámetros a la estructura
          coil          = baseCoil;
          core          = baseCore;
          coil.pitch1   = pitch1_valores(i);
          coil.pitch2   = pitch2_valores(j);
          core.L        = Lcore_valores(k);
          core.wd       = wd_core_valores(l);
          coil.radius1  = radius1_valores(m);
    
          % Llamada a tu rutina de inductancia
          clear Inductance
          generic_coil_inductance
          Lpri = Inductance.Lpri;
          Lsec = Inductance.Lsec;
          L    = Inductance.L;
          
          fprintf('Procesando línea %d/%d...\n', row, N1*N2*N3*N4*N5);

          % crea una tabla de una sola fila con los valores
            rowT = table( ...
              {coil_type}, coil.turns1, coil.turns2, coil.radius1, coil.radius2, ...
              coil.wd, coil.pitch1, coil.pitch2, core.L, Lpri, Lsec, L, ...
              'VariableNames', {'coil_type','turns1','turns2','r1','r2','wire_d','pitch1','pitch2','Lcore','Lpri','Lsec','L'} ...
            );
            
            if row == 1
              % la primera fila crea el CSV con nombres de variable
              writetable(rowT, filename);
            else
              % las siguientes filas se añaden sin repetir cabecera
              writetable(rowT, filename, ...
                'WriteMode','append', ...
                'WriteVariableNames', false);
            end
        end
      end
    end
  end
end