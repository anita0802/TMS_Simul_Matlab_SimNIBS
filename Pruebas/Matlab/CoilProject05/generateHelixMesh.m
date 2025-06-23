function [P, t, strcoil, check] = generateHelixMesh(turns, N, radius, pitch, wd, M, flag, sk, twist)
% Función para generar la malla de una hélice   
    theta = linspace(0, turns*2*pi, N);  % Ángulo en radianes
    delta_theta = theta(2) - theta(1);  % Paso angular

    x = radius * cos(theta);  % Segmento X
    y = radius * sin(theta);  % Segmento Y
    z = zeros(1, N);
    delta = pitch * delta_theta / pi;

    for m = 2:N
        z(m) = z(m-1) + 0.5 * (1 - sign(sin(theta(m)))) * delta;  % Trayectoria de la hélice
    end

    z = smooth(z);  % Suavizado de la trayectoria

    Pcenter(:, 1) = x';
    Pcenter(:, 2) = y';
    Pcenter(:, 3) = z';

    % Crear la malla de la bobina
    [strcoil, check] = meshwire(Pcenter, wd, wd, M, flag, sk, twist);  % Modelo de alambre
    [P, t] = meshsurface(Pcenter, wd, wd, M, flag, twist);  % Malla CAD
end