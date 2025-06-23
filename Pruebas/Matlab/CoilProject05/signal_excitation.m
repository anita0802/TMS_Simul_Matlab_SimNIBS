function signal = getSignalExcitation(signal_type)
switch signal_type
    case 'sinusoidal'
        signal.dIdt = 2*pi*0.5*0.5;            %   Amperes/sec (2*pi*I0/period), for electric field for 10 kHz
    case 'cuadrada'
        signal.f = 10;             % Frecuencia del pulso (Hz) - Sólo determina cada cuánto vuelve a repetirse esa bajada, pero no su pendiente
        signal.T = 1/f;            % Periodo (s)
        dIdt = -I0/t_fall;          % Amperes/sec, for electric field for 10 Hz
        dIdt = abs(dIdt);           % Magnitud para escalar el campo inducido
    otherwise
        error('mucore:unknownType', 'Tipo de material "%s" no reconocido.', material_type);
end
end