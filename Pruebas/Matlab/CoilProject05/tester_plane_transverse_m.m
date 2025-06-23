%   This script accurately computes and displays magnetic field sampled
%   over a surface (transverse plane) due to a coil via the plain FMM method
%
%   Copyright SNM 2018-2021

load coil;
clear pointsXY;

%  Parameters
mu0     = 1.25663706e-006;  %   magnetic permeability of vacuum(~air)
levels  = 20;               %   number of levels in contour plot
component   = 4;            %   field component to be plotted (1, 2, 3, 4 or x, y, z, total magnitude) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%   Plane window (from xmin to xmax and from zmin to zmax)
xmin = -0.0225;
xmax = +0.0225;
ymin = -0.0200;
ymax = +0.0200;
Z    = -0.0015;          %  position of the XY plane

%   Plot the plane
f1 = figure;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
patch([xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.25);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);

view(10, 20);
        
%  Nodal points on the surface (MsxMs nodal points)      
Ms = 250;
%   Coronal plane
x = linspace(xmin, xmax, Ms);
y = linspace(ymin, ymax, Ms);
[X, Y]  = meshgrid(x, y);
pointsXY(:, 1) = reshape(X, 1, Ms^2);
pointsXY(:, 2) = reshape(Y, 1, Ms^2);    
pointsXY(:, 3) = Z*ones(1, Ms^2);  

%   Field on the surface (XY or transverse plane, MsxMs nodal points)         
tic
prec         = 1e-4;            %    Precision 
Hpri         = bemf3_inc_field_magnetic(strcoil, pointsXY, prec);    
Hsec         = bemf5_volume_field_sa(pointsXY, cf, P, t, Center, Area, normals, R, prec);
Field        = Hpri + Hsec; 
fieldPlaneTime = toc  

%  Plot field on the surface (transverse plane)
f2      = figure;
if component == 4
    temp      = abs(sqrt(dot(Field, Field, 2)));
else
    temp      = Field(:, component);
end
th1     = 0.75*max(temp);             
th2     = 2*min(temp);        
temp(1) = th1;
bemf2_graphics_vol_field(temp, th1, th2, levels, x, y);
xlabel('x, m'); ylabel('z, m');
colormap parula; colorbar;
title(strcat('H-field A/m, ', label, '-component in the transverse plane'));

%   Additionally, plot coil cross-section
[edges, TriP, TriM] = mt(strcoil.t);
[Pi, ti, polymask, flag] = meshplaneintXY(strcoil.P, strcoil.t, edges, TriP, TriM, Z);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 2), 'Color', 'r', 'LineWidth', 2);
    end   
end

%   Additionally, plot core cross-section
[edges, TriP, TriM] = mt(GEOM.t);
[Pi, ti, polymask, flag] = meshplaneintXY(GEOM.P, GEOM.t, edges, TriP, TriM, Z);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 2), 'Color', 'c', 'LineWidth', 3);
    end   
end

grid on; set(gcf,'Color','White');
axis equal; axis tight;
