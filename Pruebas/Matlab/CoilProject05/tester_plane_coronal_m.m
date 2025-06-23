%   This script accurately computes and displays magnetic field sampled
%   over a surface (coronal plane) due to a coil via the plain FMM method
%
%   Copyright SNM 2018-2021

load coil;
clear pointsXZ;

%  Parameters
mu0     = 1.25663706e-006;  %   magnetic permeability of vacuum(~air)
levels  = 20;               %   number of levels in contour plot
component   = 4;                %   field component to be plotted (1, 2, 3, 4 or x, y, z, total magnitude) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%   Plane window (from xmin to xmax and from zmin to zmax)
scale = 2.0;
Xmin = min(strcoil.Pwire(:, 1));
Xmax = max(strcoil.Pwire(:, 1));
Zmin = min(strcoil.Pwire(:, 3));
Zmax = max(strcoil.Pwire(:, 3));
xmin = scale*Xmin;
xmax = scale*Xmax;
zmin = Zmin - 0.05; %   5 cm down
zmax = 0.02;
Y    = 0.0;          %  position of the XZ plane

%   Plot the plane
f1 = figure;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
patch([xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.25);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);

view(10, 20);
        
%  Nodal points on the surface (MsxMs nodal points)      
Ms = 200;
%   Coronal plane
x = linspace(xmin, xmax, Ms);
z = linspace(zmin, zmax, Ms);
[X, Z]  = meshgrid(x, z);
pointsXZ(:, 1) = reshape(X, 1, Ms^2);
pointsXZ(:, 2) = Y*ones(1, Ms^2);
pointsXZ(:, 3) = reshape(Z, 1, Ms^2);    

%   Field on the surface (XZ or coronal plane, MsxMs nodal points)         
tic
prec         = 1e-4;            %    Precision 
R            = 2;               %    Integration radius 
Hpri         = bemf3_inc_field_magnetic(strcoil, pointsXZ, prec);    
Hsec         = bemf5_volume_field_sa(pointsXZ, cf, P, t, Center, Area, normals, R, prec);
Field        = Hpri + Hsec;   
fieldPlaneTime = toc  

%  Plot field on the surface (coronal plane)
f2          = figure;
if component == 4
    temp      = abs(sqrt(dot(Field, Field, 2)));
else
    temp      = Field(:, component);
end
th1         = 1e5;
th2         = 1e2;
bemf2_graphics_vol_field(temp, th1, th2, levels, x, z);
xlabel('x, m'); ylabel('z, m');
colormap parula; colorbar;
title(strcat('H-field A/m, ', label, '-component in the coronal plane'));

%   Additionally, plot coil cross-section
[edges, TriP, TriM] = mt(strcoil.t);
[Pi, ti, polymask, flag] = meshplaneintXZ(strcoil.P, strcoil.t, edges, TriP, TriM, Y);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 3), 'Color', 'r', 'LineWidth', 2);
    end   
end

%   Additionally, plot core cross-section
[edges, TriP, TriM] = mt(GEOM.t);
[Pi, ti, polymask, flag] = meshplaneintXZ(GEOM.P, GEOM.t, edges, TriP, TriM, Y);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 3), 'Color', 'c', 'LineWidth', 3);
    end   
end

grid on; set(gcf,'Color','White');
axis equal; axis tight; axis([xmin xmax zmin zmax]);
