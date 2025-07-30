function core = getCoreType (core_type) % Devuelve los parámetros del core para cada tipo de bobina
% core_type: bobinaL1, bobinaL2, bobinaL3, bobinaL4, bobinaL5, bobinaL6
switch core_type
    case 'bobinaL1'
        core.L      = 0.002;
        core.wd     = 0.0001;
    case 'bobinaL2'
        core.L      = 0.0058;
        core.wd     = 0.0001;
    case 'bobinaL3'
        core.L      = 0.003;
        core.wd     = 0.00055;
    case 'bobinaL4'
        core.L      = 0.0015;
        core.wd     = 0.000116;
    case 'bobinaL5'
        core.L      = 0.0001;
        core.wd     = 0.00012;
    case 'bobinaL6'
        core.L      = 0.00013;
        core.wd     = 0.00002;
    otherwise
        error('getCoreType:unknownType', 'Tipo de bobina "%s" no reconocido.', core_type);
end
end
