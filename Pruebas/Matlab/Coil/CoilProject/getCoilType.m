function coil = getCoilType (coil_type) % Devuelve los parámetros de geometría y excitación para cada tipo de bobina
% coil_type: bobinaL1, bobinaL2, bobinaL3, bobinaL4, bobinaL5, bobinaL6
switch coil_type
    case 'bobinaL1'
        coil.t_fall     = 130e-6;          % Tiempo de bajada (s)
        coil.wd         = 0.002;         %0.00075             % Conductor diameter in m
        coil.L          = 1e-6;
        %%  Parámetros y geometría de la primera hélice (radio menor)
        coil.turns1     = 2.5;                        % Number of turns 
        coil.radius1    = 0.002;           % Helix radius, m checks (radius2 - wd)
        coil.pitch1     = 0.0042;           % Pitch amplitude (separación vertical entre vueltas)
        %%  Parámetros y geometría de la segunda hélice (radio mayor)
        coil.turns2     = 1;
        coil.radius2    = 0.0075;
        coil.pitch2     = 0.0055;
    case 'bobinaL2'
        coil.t_fall     = 140e-6;
        coil.wd         = 0.00055;
        coil.L          = 1.5e-6;
        %%  Parámetros y geometría de la primera hélice
        coil.turns1     = 5.5;
        coil.radius1    = 0.004;
        coil.pitch1     = 0.001;
        %%  Parámetros y geometría de la segunda hélice
        coil.turns2     = 0;
        coil.radius2    = 0.005;
        coil.pitch2     = 0.00045;
    case 'bobinaL3'
        coil.t_fall     = 150e-6;
        coil.wd         = 0.00042;
        coil.L          = 0.6e-6;
        %%  Parámetros y geometría de la primera hélice
        coil.turns1     = 4;
        coil.radius1    = 0.00093;
        coil.pitch1     = 0.0008;
        %%  Parámetros y geometría de la segunda hélice
        coil.turns2     = 0.5;
        coil.radius2    = 0.0029;
        coil.pitch2     = 0.00064;
    case 'bobinaL4'
        coil.t_fall     = 170e-6;
        coil.wd         = 0.00035;      %0.00018
        coil.L          = 1.5e-6;
        %%  Parámetros y geometría de la primera hélice
        coil.turns1     = 4.5;
        coil.radius1    = 0.00075;
        coil.pitch1     = 0.00039;
        %%  Parámetros y geometría de la segunda hélice
        coil.turns2     = 2;
        coil.radius2    = 0.00125;
        coil.pitch2     = 0.0006;
    case 'bobinaL5'
        coil.t_fall     = 206e-6;
        coil.wd         = 0.00012;
        coil.L          = 1e-6;
        %%  Parámetros y geometría de la primera hélice
        coil.turns1     = 5;
        coil.radius1    = 0.00065;
        coil.pitch1     = 0.001;
        %%  Parámetros y geometría de la segunda hélice
        coil.turns2     = 2.5;
        coil.radius2    = 0.0012;
        coil.pitch2     = 0.001;
    case 'bobinaL6'
        coil.t_fall     = 160e-6;
        coil.wd         = 0.00007;
        coil.L          = 0.0049e-6;
        %%  Parámetros y geometría de la primera hélice
        coil.turns1      = 1;
        coil.radius1    = 0.0004;
        coil.pitch1     = 0.00075;
        %%  Parámetros y geometría de la segunda hélice
        coil.turns2     = 0;
        coil.radius2    = 0.004;    % indiferente
        coil.pitch2     = 0.00002;  % indiferente
    otherwise
        error('getCoilType:unknownType', 'Tipo de bobina "%s" no reconocido.', coil_type);
end
end
