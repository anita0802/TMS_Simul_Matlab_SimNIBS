%   This script accurately computes and displays magnetic field sampled
%   over a surface (sagittal plane) due to a coil via the plain FMM method
%
%   Copyright SNM 2018-2020

load coil;
clear pointsYZ;

%  Parameters
mu0     = 1.25663706e-006;  %   magnetic permeability of vacuum(~air)
levels  = 20;               %   number of levels in contour plot
component   = 4;                %   field component to be plotted (1, 2, 3, 4 or x, y, z, total magnitude) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%   Plane window (from xmin to xmax and from zmin to zmax)
scale = 2.0;
Ymin = min(strcoil.Pwire(:, 2));
Ymax = max(strcoil.Pwire(:, 2));
Zmin = min(strcoil.Pwire(:, 3));
Zmax = max(strcoil.Pwire(:, 3));
ymin = scale*Ymin;
ymax = scale*Ymax;
zmin = Zmin - 0.05; %   5 cm down
zmax = 0.02;
X    = 0.0;          %  position of the YZ plane

%   Plot the plane
f1 = figure;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
patch([X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.25);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);

view(10, 20);
        
%  Nodal points on the surface (MsxMs nodal points)      
Ms = 200;
%   Sagittal plane
y = linspace(ymin, ymax, Ms);
z = linspace(zmin, zmax, Ms);
[Y, Z]  = meshgrid(y, z);
pointsYZ(:, 1) = X*ones(1, Ms^2);
pointsYZ(:, 2) = reshape(Y, 1, Ms^2);
pointsYZ(:, 3) = reshape(Z, 1, Ms^2);        

%   Field on the surface (YZ or sagittal plane, MsxMs nodal points)         
tic
prec         = 1e-4;            %    Precision 
R            = 2;               %    Integration radius  
Hpri         = bemf3_inc_field_magnetic(strcoil, pointsYZ, prec);    
Hsec         = bemf5_volume_field_sa(pointsYZ, cf, P, t, Center, Area, normals, R, prec);
Field        = Hpri + Hsec; 
fieldPlaneTime = toc  

%  Plot field on the surface (sagittal plane)
f2          = figure;
if component == 4
    temp      = abs(sqrt(dot(Field, Field, 2)));
else
    temp      = Field(:, component);
end
th1         = 1e5;
th2         = 1e2;
bemf2_graphics_vol_field(temp, th1, th2, levels, y, z);
xlabel('y, m'); ylabel('z, m');
colormap parula; colorbar;
title(strcat('H-field A/m, ', label, '-component in the sagittal plane'));

%   Additionally, plot coil cross-section
[edges, TriP, TriM] = mt(strcoil.t);
[Pi, ti, polymask, flag] = meshplaneintYZ(strcoil.P, strcoil.t, edges, TriP, TriM, X);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 2), Pi([i1 i2], 3), 'Color', 'r', 'LineWidth', 2);
    end   
end

%   Additionally, plot core cross-section
[edges, TriP, TriM] = mt(GEOM.t);
[Pi, ti, polymask, flag] = meshplaneintYZ(GEOM.P, GEOM.t, edges, TriP, TriM, X);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 2), Pi([i1 i2], 3), 'Color', 'c', 'LineWidth', 3);
    end   
end

grid on; set(gcf,'Color','White');
axis equal; axis([ymin ymax zmin zmax]);