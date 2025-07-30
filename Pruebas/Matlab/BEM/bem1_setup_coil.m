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

%%  Position coil
%   Give the target point (mm)
TARGET(1, :) = [0 -15 16]; %[1.5+15 -17.0 18.5]13
ANGLE(1)     = +0.0;
ANGLE(2)     = -pi/6;
ANGLE(3)     = -pi/3;
ANGLE(4)     = -0.0;
ANGLE(5)     = +pi/6;
ANGLE(6)     = +pi/4;

Target  = 1e-3*TARGET(1, :);       %    in meters
theta   = ANGLE(1);                %    in radians  
mindist = 10e-3;                   %    in meters, min dist from coil to skin  

%%  Define normal axis of the coil, [Nx, Ny, Nz], and its position
center                              = Center(Indicator == 1, :);
Nx = 0; Ny = 0; Nz = 1; MoveX = Target(1, 1); MoveY = Target(1, 2); MoveZ = Target(1, 3);
[strcoil, handle]                   = positioncoil(strcoil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ);

%%  Head graphics
tissue_to_plot = 'Skin';
t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)
str.EdgeColor = 'none'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, t0, str);
camlight; lighting phong;
title(strcat('Total number of facets: ', num2str(size(t, 1))));     

%% Coil graphics    
hold on;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 1);

%%  Core graphics
if size(fields(strcoil), 1)>7
    str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
    bemf2_graphics_base(strcoil.CoreP, strcoil.Coret, str);
end
%camlight; lighting phong;

%% Line graphics (optional)
%   Give the target point (m) on gray matter interface (optional)
bemf1_graphics_lines(Nx, Ny, Nz, MoveX, MoveY, MoveZ, Target, handle, 'xyz');

%%  General settings
axis 'equal';  axis 'tight';   
daspect([1 1 1]);
set(gcf,'Color','White');

axis off; view(180, 0);

% Find nearest intersections of the coil centerline w tissues
%  Ray parameters (in mm here)
orig = 1e3*[MoveX MoveY MoveZ];             %   ray origin
dir  = -[Nx Ny Nz]/norm([Nx Ny Nz]);        %   ray direction
dist = 1000;                                %   ray length (finite segment, in mm here)

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