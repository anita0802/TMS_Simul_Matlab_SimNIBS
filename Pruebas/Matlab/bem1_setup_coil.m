%   This script assigns coil position, dIdt (for electric field), I0 (for
%   magnetic field), and displays the resulting head-coil geometry.
%
%   Copyright SNM/WAW 2017-2021

%%  Load base coil data, define coil excitation/position
if exist('strcoil', 'var')
    clear strcoil;
end
load('C:/Users/Patriciagh/Documents/TFM/Pruebas/Matlab/Coil/CoilProject/coil.mat');      
%strcoil.Moments = 0*strcoil.Moments; % remove core effect and see what happens

strcoil.dIdt = dIdt;    % dIdt lo defines antes, con getSignalExcitation
strcoil.I0   = I0;      % I0 también lo tienes de signal.I0
fprintf('El valor de I0 es: %.4f\n', strcoil.I0);
fprintf('El valor de dIdt es: %.4f\n', strcoil.dIdt);

%%  Position coil
%   Give the target point (mm)
TARGET(1, :) = [0 -19.5 13.9];
ANGLE(1)     = +0.0;
ANGLE(2)     = -pi/6;
ANGLE(3)     = -pi/3;
ANGLE(4)     = -0.0;
ANGLE(5)     = +pi/6;
ANGLE(6)     = +pi/4;

Target  = 1e-3*TARGET(1, :);       %    in meters
theta   = ANGLE(1);                %    in radians  

%%  Define normal axis of the coil, [Nx, Ny, Nz], and its position
center = Center(Indicator == 1, :);
% Orientación de la bobina con respecto al cerebro
Nx     = 0;
Ny     = 0;
Nz     = 1; % Bobina sobre el cerebro
% MoveX  = Target(1, 1);
% MoveY  = Target(1, 2);
% MoveZ  = Target(1, 3);

%%%%%%%%%%%%%%%%%%%%%%%%%
%coreCenter0 = mean(strcoil.coreP, 1);   % 1x3: [cx, cy, cz] en metros

% Ejes de la bobina
coilAxis = [Nx, Ny, Nz] / norm([Nx, Ny, Nz]);

% Vértices originales del core (antes de mover nada)
Pcore0 = strcoil.CoreP;   

% Proyección sobre el eje para encontrar el extremo inferior
proj0 = Pcore0 * coilAxis';
[~, idxMin0] = min(proj0);
lower0 = Pcore0(idxMin0, :);   % 1x3: extremo inferior original

MoveX = Target(1) - lower0(1);
MoveY = Target(2) - lower0(2);
MoveZ = Target(3) - lower0(3);
%%%%%%%%%%%%%%%%%%%%%%%%%

[strcoil, handle] = positioncoil(strcoil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ);

%%%%%%%%%%%%%%%%%%%%%%%%%
Pcore = strcoil.CoreP;         % core ya movido
proj1 = Pcore * coilAxis';
[~, idxMin1] = min(proj1);
lower1 = Pcore(idxMin1, :);    % extremo inferior nuevo

% Dibujamos cruz verde en Target y círculo azul en lower1 (deberían coincidir)
hold on
plot3(Target(1), Target(2), Target(3), 'xg', 'MarkerSize',12,'LineWidth',2);
plot3(lower1(1), lower1(2), lower1(3), 'ob', 'MarkerSize',12,'LineWidth',2);

fprintf('Coordenadas del extremo inferior del core de la bobina en: [%.4f, %.4f, %.4f] m\n', lower1);
%%%%%%%%%%%%%%%%%%%%%%%%

%%  Head graphics
tissue_to_plot = 'Skin';
t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)
str.EdgeColor = 'none'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, t0, str);
camlight; lighting phong;
title(strcat('Total number of facets: ', num2str(size(t, 1))));     

%%  Coil graphics    
hold on;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 1);

%%  Core graphics
if size(fields(strcoil), 1)>7
    str.EdgeColor = 'y'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
    bemf2_graphics_base(strcoil.CoreP, strcoil.Coret, str);
end
%camlight; lighting phong;

%% Line graphics (optional)
%   Give the target point (m) on gray matter interface (optional)
%bemf1_graphics_lines(Nx, Ny, Nz, MoveX, MoveY, MoveZ, Target, handle, 'xyz');

%%%%%%%%%%%%%%%%%%%%%%%%
bemf1_graphics_lines(Nx, Ny, Nz, lower1(1), lower1(2), lower1(3), lower1, handle, 'xyz');
%%%%%%%%%%%%%%%%%%%%%%%%

%%  General settings
axis 'equal';  axis 'tight';   
daspect([1 1 1]);
set(gcf,'Color','White');

axis off; view(180, 0);

% % Find nearest intersections of the coil centerline w tissues
% %  Ray parameters (in mm here)
% orig = 1e3*[MoveX MoveY MoveZ];             %   ray origin
% dir  = -[Nx Ny Nz]/norm([Nx Ny Nz]);        %   ray direction
% dist = 1000;                                %   ray length (finite segment, in mm here)
% 
% intersections_to_find = tissue(1);
% for m = 1:length(intersections_to_find)
%     k = find(strcmp(intersections_to_find{m}, tissue));
%     disp(intersections_to_find{m});
%     S = load(name{k});
% 
%     d = meshsegtrintersection(orig, dir, dist, S.P, S.t);
%     IntersectionPoint = min(d(d>0))
%     if ~isempty(IntersectionPoint)
%         Position = orig + dir*IntersectionPoint;
%     end
%     sprintf(newline);
% end

disp('FIN BEM1')