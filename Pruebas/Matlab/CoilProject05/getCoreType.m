function core = getCoreType (core_type) % Devuelve los parámetros del core para cada tipo de bobina
% core_type: bobinaL1, bobinaL2, bobinaL3, bobinaL4, bobinaL5, bobinaL6
switch core_type
    case 'bobinaL1'
        core.L    = 0.0026099754;
        core.d    = 0.00075;
    case 'bobinaL2'
        core.L    = 5.8e-3;
        core.d    = 0.0004;
    case 'bobinaL3'
        core.L    = 4.5e-3;
        core.d    = 0.00042;
    case 'bobinaL4'
        core.L    = 1.8e-3;
        core.d    = 0.0001246525;
    case 'bobinaL5'
        core.L    = 2e-3;
        core.d    = 0.00012;
    case 'bobinaL6'
        core.L    = 1e-3;
        core.d    = 0.00007;
    otherwise
        error('getCoreType:unknownType', 'Tipo de bobina "%s" no reconocido.', core_type);
end
end
