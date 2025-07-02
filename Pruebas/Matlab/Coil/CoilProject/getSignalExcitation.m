function signal = getSignalExcitation(signal_type, t_fall)
% signal_type: sinusoidal, cuadrada
signal.I0 = 0.5;                       %   Amperes, for magnetic field
switch signal_type
    case 'sinusoidal'
        signal.dIdt = 2*pi*0.5*0.5;            %   Amperes/sec (2*pi*I0/period), for electric field for 10 kHz
    case 'cuadrada'
        signal.f = 10;             % Frecuencia del pulso (Hz) - Sólo determina cada cuánto vuelve a repetirse esa bajada, pero no su pendiente
        signal.T = 1/signal.f;            % Periodo (s)
        signal.t_fall = t_fall;
        signal.dIdt = -signal.I0/signal.t_fall;      % If we are working with a square signal, we have to use the variation
    otherwise
        error('signal:unknownType', 'Señal de excitación "%s" no reconocida.', signal_type);
end
end