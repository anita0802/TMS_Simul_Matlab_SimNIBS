function signal = getSignalExcitation(signal_type, t_rise, I0, f)
% signal_type: Sinusoidal, Square
signal.I0 = I0;                                 % Excitation current (A)
signal.f = f;                                   % Pulse frequency (Hz)
signal.T = 1/signal.f;                          % Period (s)
signal.t_rise = t_rise;

switch signal_type
    case 'Sinusoidal'
        signal.dIdt = 2*pi*signal.I0*f;         % (A/s)
    case 'Square'
        signal.dIdt = -signal.I0/signal.t_rise; % (A/s)
    otherwise
        error('signal:unknownType', 'Unrecognized excitation signal "%s".', signal_type);
end
end