addpath('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/CoilProject05');

coilName = 'bobinaL1';
baseCoil     = getCoilType(coilName);
baseCore     = getCoreType(coilName);

if ~ischar(coilName) || ~ismember(coilName, {'bobinaL1', 'bobinaL2', 'bobinaL3', 'bobinaL4', 'bobinaL5', 'bobinaL6'})
    error('coilName is not valid or recognized.');
end

p1_min = NaN; p1_max = NaN;
p2_min = NaN; p2_max = NaN;
Lc_min = NaN; Lc_max = NaN;

switch coilName
    case 'bobinaL1'
        p1_min = 0.00075;   p1_max = 0.002;
        p2_min = 0.00075;   p2_max = 0.002;
        Lc_min = 0.001;     Lc_max = 0.003;
    case 'bobinaL2'
        p1_min = 0.0004;    p1_max = 0.005;
        p2_min = 0.0004;    p2_max = 0.005;
        Lc_min = 0.0035;    Lc_max = 0.0065;
    case 'bobinaL3'
        p1_min = 0.00042;   p1_max = 0.004;
        p2_min = 0.00042;   p2_max = 0.004;
        Lc_min = 0.0025;    Lc_max = 0.0055;
    case 'bobinaL4'
        p1_min = 0.0001;    p1_max = 0.006;
        p2_min = 0.0001;    p2_max = 0.006;
        Lc_min = 0.0005;    Lc_max = 0.0025;
    case 'bobinaL5'
        p1_min = 0.00018;   p1_max = 0.0015;
        p2_min = 0.00018;   p2_max = 0.0015;
        Lc_min = 0.0005;    Lc_max = 0.0035;
    case 'bobinaL6'
        p1_min = 0.00007;   p1_max = 0.001;
        p2_min = 0.00007;   p2_max = 0.001;
        Lc_min = 0.0005;    Lc_max = 0.0015;
    otherwise
        warning('Bobina no reconocia')
end

rng(42);  % semilla fija para reproducibilidad
numSamples = 20;
X = lhsdesign(numSamples,3);   % 20×3 valores en (0,1)

allRows = cell(numSamples, 12);

for i = 1:numSamples

    coil = baseCoil;
    core = baseCore;
    pitch1 = p1_min + (p1_max - p1_min)*X(i,1);
    pitch2 = p2_min + (p2_max - p2_min)*X(i,2);
    Lcore  = Lc_min + (Lc_max - Lc_min)*X(i,3);
    
    coil.pitch1 = pitch1;
    coil.pitch2 = pitch2;
    core.L      = Lcore;

    clear Inductance

    generic_coil_inductance
    Lpri = Inductance.Lpri;
    Lsec = Inductance.Lsec;
    L    = Inductance.L;

    allRows{i, 1}  = coilName;
    allRows{i, 2}  = coil.turns;
    allRows{i, 3}  = coil.turns2;
    allRows{i, 4}  = coil.radius1;
    allRows{i, 5}  = coil.radius2;
    allRows{i, 6}  = coil.wd;
    allRows{i, 7}  = pitch1;
    allRows{i, 8}  = pitch2;
    allRows{i, 9}  = Lcore;
    allRows{i,10}  = Lpri;
    allRows{i,11}  = Lsec;
    allRows{i,12}  = L;
end

T = cell2table(allRows, 'VariableNames', {'coil_type', 'turns', 'turns2', 'r1', 'r2', 'wire_d', 'pitch1','pitch2','Lcore','Lpri', 'Lsec', 'L'});

writetable(T, 'coils_dataset_20lines_l1.csv', 'WriteVariableNames', true);
disp('CSV generado: coils_dataset_20lines_l1.csv');
format long
disp(T);
