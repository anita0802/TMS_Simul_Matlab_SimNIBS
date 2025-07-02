%   This script accurately computes and displays electric field (-dA/dt = -dIdt*A/I0) sampled on
%   a line via the FMM method with accurate neighbor integration
%
%   Copyright SNM 2021

load coil;

%%  Post processing parameters
component   = 4;        %   field component to be plotted (1, 2, 3 or x, y, z, or 4 - total) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%%  Define dimensionless radius of the integration sphere (for precise integration near boundaries)
R = 5;

%%  Define nodal points along the line (1xM nodal points), in meters   
M = 301;
temp      = linspace(-0.05, 0.05, M);
clear pointsline;
pointsline(1:M, 1) = 0;
pointsline(1:M, 2) = 0;
pointsline(1:M, 3) = temp';   

%%  Find the E-field (-dA/dt)
mucore         = cond(1);
tic
Etotal = bemf3_inc_field_electric_core(strcoil, pointsline, mu0, Moments, GEOM, prec);
%Etotal = - Etotal;  %   Assign a negative current direction here for a better plot
planeTime = toc

%%  Assign object types to observation points and eliminate the inaccurate E-field within the core
obsPointCore = assign_tissue_type_volume(pointsline, GEOM.normals, GEOM.Center, Indicator(1:length(GEOM.t)));
in              = obsPointCore > 0;    
out             = obsPointCore == 0; 
Etotal(in, :)   = 0; 

%%   Plot the line in 3D
f1 = figure;
hold on;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
plot3(pointsline(:, 1), pointsline(:, 2), pointsline(:, 3), '-r', 'lineWidth', 2);
view(10, 20);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);
camlight; lighting phong;

%%  Graphics for the line
f2 = figure;
hold on;
arg = pointsline(:, 3);
plot(arg, +Etotal(:, 1), '-r', 'LineWidth', 2); 
plot(arg, +Etotal(:, 2), '-m', 'LineWidth', 2); 
plot(arg, +Etotal(:, 3), '-b', 'LineWidth', 2); 
grid on;

title('Line field E (-dA/dt) in V/m, red:Ex, magenta:Ey, blue:Ez,');
xlabel('Distance z along the curve, m');
ylabel('Electric field, E');
set(gcf,'Color','White');