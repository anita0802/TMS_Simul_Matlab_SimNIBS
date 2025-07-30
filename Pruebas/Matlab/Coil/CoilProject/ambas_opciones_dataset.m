addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject');

clear all;
clc;

coil_type = 'bobinaL2';

if ~ischar(coil_type) || ~ismember(coil_type, {'bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5', 'bobinaL6'})
    error('coilName is not valid or recognized.');
end

baseCoil     = getCoilType(coil_type);
baseCore     = getCoreType(coil_type);

coil          = baseCoil;
core          = baseCore;

% Definir parámetros de la bobina
coil.h = baseCoil.h;
coil.turns1 = baseCoil.turns1;
coil.turns2 = baseCoil.turns2;
coil.radius1 = baseCoil.radius1;
coil.radius2 = baseCoil.radius2;

% Relaciones generales para definir los rangos
p1_min = (coil.h - coil.h*0.1) / coil.turns1;
p1_max = (coil.h + coil.h*0.1) / coil.turns1;

p2_min = (coil.h - coil.h*0.1) / coil.turns2;
p2_max = (coil.h + coil.h*0.1) / coil.turns2;

Lc_min = coil.h*0.1;
Lc_max = coil.h + coil.h*0.1;

r2_min = coil.radius1*1/4;
r2_max = coil.radius1 - coil.wd;

% Número de iteraciones por parámetro (nº combinaciones: N1*N2*N3*N4*N5)
N = 5;
N1 = N;
N2 = N;
N3 = N;
N4 = N;
N5 = N;

if coil.turns2 > 0
    wdc_min = coil.radius2*0.05;
    wdc_max = coil.radius2 - coil.wd;
    N2 = N;
    N4 = N;
else 
    wdc_min = coil.radius1*0.05;
    wdc_max = coil.radius1 - coil.wd;
    N2 = 0;
    N4 = 0;
end

pitch1_valores   = linspace(p1_min,     p1_max,     N1);
pitch2_valores   = linspace(p2_min,     p2_max,     N2);
Lcore_valores    = linspace(Lc_min,     Lc_max,     N3);
radius2_valores  = linspace(r2_min,     r2_max,     N4);
wd_core_valores  = linspace(wdc_min,    wdc_max,    N5);


% Archivo de salida (dataset generado)
% Obtener fecha y hora actual como string
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
% Crear ruta del archivo con timestamp
filename = sprintf('coils_dataset_%s_%s.csv', coil_type, timestamp);

row = 0;
if coil.turns2 > 0
    numRows = N1*N2*N3*N4*N5;
    for i = 1:N1
      for j = 1:N2
        for k = 1:N3
          for l = 1:N4
            for m = 1:N5
              row = row + 1;
          
              % Asigna parámetros a la estructura
              coil.pitch1   = pitch1_valores(i);
              coil.pitch2   = pitch2_valores(j);
              core.L        = Lcore_valores(k);
              coil.radius2  = radius2_valores(l);
              core.wd       = wd_core_valores(m);
    
              % Calcula 'height_max_actual'
              height_max_actual = max(coil.pitch1*coil.turns1, coil.pitch2*coil.turns2);

              % Llamada a tu rutina de inductancia
              clear Inductance
              generic_coil_inductance
              Lpri = Inductance.Lpri;
              Lsec = Inductance.Lsec;
              L    = Inductance.L;
              
              fprintf('Procesando línea %d/%d...\n', row, N1*N2*N3*N4*N5);
    
              % crea una tabla de una sola fila con los valores
                rowT = table( ...
                  {coil_type}, coil.turns1, coil.turns2, height_max_actual, coil.radius1, ...
                  coil.pitch1, coil.pitch2, core.L, coil.radius2, core.wd, Lpri, Lsec, L, ...
                  'VariableNames', {'coil_type','turns1','turns2','height','r1','pitch1','pitch2','Lcore','r2','core_wd','Lpri','Lsec','L'} ...
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
else
    numRows = N1*N3*N5;
    for i = 1:N1
       for k = 1:N3
            for m = 1:N5
              row = row + 1;
          
              % Asigna parámetros a la estructura
              coil.pitch1   = pitch1_valores(i);
              core.L        = Lcore_valores(k);
              core.wd       = wd_core_valores(m);
        
              % Calcula 'height_max_actual'
              height_max_actual = coil.pitch1*coil.turns1;
        
              % Llamada a tu rutina de inductancia
              clear Inductance
              generic_coil_inductance
              Lpri = Inductance.Lpri;
              Lsec = Inductance.Lsec;
              L    = Inductance.L;
              
              fprintf('Procesando línea %d/%d...\n', row, N1*N3*N5);
        
              % crea una tabla de una sola fila con los valores
                rowT = table( ...
                  {coil_type}, coil.turns1, height_max_actual, coil.radius1, ...
                  coil.pitch1, core.L, core.wd, Lpri, Lsec, L, ...
                  'VariableNames', {'coil_type','turns1','height','r1','pitch1','Lcore','core_wd','Lpri','Lsec','L'} ...
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject');

clear all;
clc;

coil_type = 'bobinaL1';

if ~ischar(coil_type) || ~ismember(coil_type, {'bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5', 'bobinaL6'})
    error('coilName is not valid or recognized.');
end

baseCoil     = getCoilType(coil_type);
baseCore     = getCoreType(coil_type);

coil          = baseCoil;
core          = baseCore;

% Definir parámetros de la bobina
coil.h = baseCoil.h;
coil.turns1 = baseCoil.turns1;
coil.turns2 = baseCoil.turns2;
coil.radius1 = baseCoil.radius1;
coil.radius2 = baseCoil.radius2;

% Relaciones generales para definir los rangos
p1_min = (coil.h - coil.h*0.1) / coil.turns1;
p1_max = (coil.h + coil.h*0.1) / coil.turns1;

p2_min = (coil.h - coil.h*0.1) / coil.turns2;
p2_max = (coil.h + coil.h*0.1) / coil.turns2;

Lc_min = coil.h*0.1;
Lc_max = coil.h + coil.h*0.1;

r2_min = coil.radius1*1/4;
r2_max = coil.radius1 - coil.wd;

wdc_min = coil.radius2*0.05;
wdc_max = coil.radius2 - coil.wd;

% Número de iteraciones por parámetro (nº combinaciones: N1*N2*N3*N4*N5)
N = 5;
N1 = N;
N2 = N;
N3 = N;
N4 = N;
N5 = N;

pitch1_valores   = linspace(p1_min,     p1_max,     N1);
pitch2_valores   = linspace(p2_min,     p2_max,     N2);
Lcore_valores    = linspace(Lc_min,     Lc_max,     N3);
radius2_valores  = linspace(r2_min,     r2_max,     N4);
wd_core_valores  = linspace(wdc_min,    wdc_max,    N5);

numRows = N1*N2*N3*N4*N5;

allRows = cell(numRows, 13);

% Archivo de salida (dataset generado)
% Obtener fecha y hora actual como string
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
% Crear ruta del archivo con timestamp
filename = sprintf('coils_dataset_%s_%s.csv', coil_type, timestamp);

row = 0;
for i = 1:N1
  for j = 1:N2
    for k = 1:N3
      for l = 1:N4
        for m = 1:N5
          row = row + 1;
      
          % Asigna parámetros a la estructura
          coil.pitch1   = pitch1_valores(i);
          coil.pitch2   = pitch2_valores(j);
          core.L        = Lcore_valores(k);
          coil.radius2  = radius2_valores(l);
          core.wd       = wd_core_valores(m);

          % Calcula 'height_max_actual'
          height_max_actual = max(coil.pitch1*coil.turns1, coil.pitch2*coil.turns2);
    
          % Llamada a tu rutina de inductancia
          clear Inductance
          generic_coil_inductance
          Lpri = Inductance.Lpri;
          Lsec = Inductance.Lsec;
          L    = Inductance.L;
          
          fprintf('Procesando línea %d/%d...\n', row, N1*N2*N3*N4*N5);

          % crea una tabla de una sola fila con los valores
            rowT = table( ...
              {coil_type}, coil.turns1, coil.turns2, height_max_actual, coil.radius1, ...
              coil.pitch1, coil.pitch2, core.L, coil.radius2, core.wd, Lpri, Lsec, L, ...
              'VariableNames', {'coil_type','turns1','turns2','height','r1','pitch1','pitch2','Lcore','r2','core_wd','Lpri','Lsec','L'} ...
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