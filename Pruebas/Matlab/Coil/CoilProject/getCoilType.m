function coil = getCoilType (coil_type) % Devuelve los parámetros de geometría y excitación para cada tipo de bobina
% coil_type: bobinaL1, bobinaL2, bobinaL3, bobinaL4, bobinaL5, bobinaL6
switch coil_type
    case 'bobinaL1'
        coil.t_fall     = 130e-6;
        coil.wd         = 0.00075;
        coil.h          = 0.0056;
        coil.L          = 1e-6;
        %%  Parámetros y geometría de la hélice exterior (radio mayor)
        coil.turns1     = 1;
        coil.radius1    = 0.00325;
        coil.pitch1     = 0.0055;
        %%  Parámetros y geometría de la hélice interior (radio menor)
        coil.turns2     = 2.5;
        coil.radius2    = 0.002;
        coil.pitch2     = 0.0042;
    case 'bobinaL2'
        coil.t_fall     = 140e-6;
        coil.wd         = 0.00045;
        coil.h          = 0.0056;
        coil.L          = 1.5e-6;
        %%  Parámetros y geometría de la hélice exterior
        coil.turns1     = 5.5;
        coil.radius1    = 0.0025;
        coil.pitch1     = 0.001;
        %%  Parámetros y geometría de la hélice interior
        coil.turns2     = 0;
        coil.radius2    = 0;    % indiferente
        coil.pitch2     = 0;    % indiferente
    case 'bobinaL3'
        coil.t_fall     = 150e-6;
        coil.wd         = 0.00042;
        coil.h          = 0.0023;
        coil.L          = 0.6e-6;
        %%  Parámetros y geometría de la hélice exterior
        coil.turns1     = 0.5;
        coil.radius1    = 0.0028;
        coil.pitch1     = 0.00064;
        %%  Parámetros y geometría de la hélice interior
        coil.turns2     = 4;
        coil.radius2    = 0.00093;
        coil.pitch2     = 0.0008;
    case 'bobinaL4'
        coil.t_fall     = 170e-6;
        coil.wd         = 0.0002;
        coil.h          = 0.0018;
        coil.L          = 1.5e-6;
        %%  Parámetros y geometría de la hélice exterior
        coil.turns1     = 2;
        coil.radius1    = 0.00125;
        coil.pitch1     = 0.0009;
        %%  Parámetros y geometría de la hélice interior
        coil.turns2     = 4.5;
        coil.radius2    = 0.00075;
        coil.pitch2     = 0.00039;
    case 'bobinaL5'
        coil.t_fall     = 206e-6;
        coil.wd         = 0.00012;
        coil.h          = 0.001;
        coil.L          = 1e-6;
        %%  Parámetros y geometría de la hélice exterior
        coil.turns1     = 2.5;
        coil.radius1    = 0.0012;
        coil.pitch1     = 0.001;
        %%  Parámetros y geometría de la hélice interior
        coil.turns2     = 5;
        coil.radius2    = 0.00065;
        coil.pitch2     = 0.001;
    case 'bobinaL6'
        coil.t_fall     = 160e-6;
        coil.wd         = 0.00007;
        coil.h          = 0.0008;
        coil.L          = 0.0049e-6;
        %%  Parámetros y geometría de la hélice exterior
        coil.turns1      = 1;
        coil.radius1    = 0.0003;
        coil.pitch1     = 0.00075;
        %%  Parámetros y geometría de la hélice interior
        coil.turns2     = 0;
        coil.radius2    = 0;    % indiferente
        coil.pitch2     = 0;    % indiferente
    otherwise
        error('getCoilType:unknownType', 'Tipo de bobina "%s" no reconocido.', coil_type);
end
end
