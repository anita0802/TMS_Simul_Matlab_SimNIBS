addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/CoilProject05');  % donde están tus .m

% Lista de tipos y rangos
coilNames = {'bobinaL1','bobinaL2','bobinaL3','bobinaL4','bobinaL5','bobinaL6'};

ranges = {
  [0.00075 0.002;         0.00075 0.002;        0.001 0.003     ],    % BobinaL1: [pitch1; pitch2; core_length]
  [0.0004 0.005;          0.0004 0.005;         0.0035 0.0065   ],    % BobinaL2
  [0.00042 0.004;         0.00042 0.004;        0.0025 0.0055   ],    % BobinaL3
  [0.00018 0.0015;        0.00018 0.0015;       0.0005 0.0025   ],    % BobinaL4
  [0.00018 0.002;         0.00018 0.002;        0.0005 0.0035   ],    % BobinaL5
  [0.00007 0.001;         0.00007 0.001;        0.0005 0.0015   ],    % BobinaL6
};

allRows = {};

rng(42);
N = 3;

try
    % Bucle que recorre todas las bobinas
    for k = 1:numel(coilNames)                  
      coil = getCoilType(coilNames{k});   % devuelve struct
      core = getCoreType(coilNames{k});   % devuelve struct
      R = ranges{k};
      name = coilNames{k};
    
      p1 = R(1,1) + diff(R(1,:)).*rand(N,1);
      p2 = R(2,1) + diff(R(2,:)).*rand(N,1);
      Lc = R(3,1) + diff(R(3,:)).*rand(N,1);
    
      for i = 1:N
        fprintf('Bobina %s: iter %d/%d\n', name, i, N);
        drawnow;
        coil.pitch1 = p1(i);
        coil.pitch2 = p2(i);
        core.L      = Lc(i);
    
        % Si coil_inductance_PGH.m es un script que espera variables
        % coil y core en el workspace, simplemente lo ejecutas:
        generic_coil_inductance
        
        % Asumimos que el script deja en el workspace una variable L
        allRows(end+1,:) = {coilNames{k}, coil.turns, coil.turns2, coil.radius1, coil.radius2, coil.wd, p1(i), p2(i), Lc(i), Inductance.L};
    
      end
    end
catch ME
  warning('Se interrumpió en %s: %s', ME.identifier, ME.message);
end

[nRows, nCols] = size(allRows);
fprintf('allRows tiene %d filas y %d columnas\n', nRows, nCols);

T = cell2table(allRows, 'VariableNames',{'coil_type','turns', 'turns2', 'r1','r2','wire_d', 'pitch1','pitch2','Lcore','Lsim'});
writetable(T,'coils_dataset.csv');
disp('CSV generado: coils_dataset.csv');
disp(T);