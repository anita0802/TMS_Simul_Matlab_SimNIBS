%   This script accurately computes and displays electric field sampled
%   over a surface (transverse plane) due to a coil via the plain FMM method
%
%   Copyright SNM 2018-2021

load coil;
clear pointsXY;

%  Parameters
mu0     = 1.25663706e-006;  %   magnetic permeability of vacuum(~air)
levels  = 20;               %   number of levels in contour plot
component   = 4;                %   field component to be plotted (1, 2, 3, 4 or x, y, z, total magnitude) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%   Plane window (from xmin to xmax and from zmin to zmax)
factor = 1.0;
xmin = -0.0225*factor;
xmax = +0.0225*factor;
ymin = -0.0200* factor;
ymax = +0.0200*factor;
Z    = -0.0010;          %  position of the XY plane
        
%  Nodal points on the surface (MsxMs nodal points)      
Ms = 200;
%   Coronal plane
x = linspace(xmin, xmax, Ms);
y = linspace(ymin, ymax, Ms);
[X, Y]  = meshgrid(x, y);
pointsXY(:, 1) = reshape(X, 1, Ms^2);
pointsXY(:, 2) = reshape(Y, 1, Ms^2);    
pointsXY(:, 3) = Z*ones(1, Ms^2);  

%   Rotate the coil/core as appropriate about the z-axis
theta = 120/180*pi;

strcoiltemp         = strcoil;
GEOMtemp            = GEOM;
Momentstemp         = Moments;

strcoiltemp.P       =  meshrotate2(strcoil.P, [0 0 1], theta);
strcoiltemp.Pwire   =  meshrotate2(strcoil.Pwire, [0 0 1], theta);
GEOMtemp.Center     =  meshrotate2(GEOM.Center, [0 0 1], theta);
GEOMtemp.P          =  meshrotate2(GEOM.P, [0 0 1], theta);
GEOMtemp.CenterT    =  meshrotate2(GEOM.CenterT, [0 0 1], theta);
GEOMtemp.normals    =  meshrotate2(GEOM.normals, [0 0 1], theta);
Momentstemp         =  meshrotate2(Momentstemp, [0 0 1], theta);

%%   Plot the plane
f1 = figure;
bemf1_graphics_coil_CAD(strcoiltemp.P, strcoiltemp.t, 0);
patch([xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.25);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(GEOMtemp.P, GEOMtemp.t, str);
view(10, 20);

%%   Field on the surface (XY or transverse plane, MsxMs nodal points)         
tic
prec         = 1e-4;            %    Precision 
Field 	     = bemf3_inc_field_electric_core(strcoiltemp, pointsXY, mu0, Momentstemp, GEOMtemp, prec);
fieldPlaneTime = toc  

%%  Assign object types to observation points and eliminate the inaccurate E-field within the core
obsPointCore = assign_tissue_type_volume(pointsXY, GEOMtemp.normals, GEOMtemp.Center, Indicator(1:length(GEOMtemp.t)));
in              = obsPointCore > 0;    
out             = obsPointCore == 0; 
Field(in, :)   = 0; 

%%  Plot field on the surface (transverse plane)
f2          = figure;
if component == 4
    temp      = abs(sqrt(dot(Field, Field, 2)));
else
    temp      = Field(:, component);
end
th1         = max(temp)
th2         = min(temp)
bemf2_graphics_vol_field(temp, th1, th2, levels, x, y);
xlabel('x, m'); ylabel('y, m');
colormap parula; colorbar;
title(strcat('E-field V/m, ', label, '-component in the transverse plane'));

%%   Additionally, plot coil cross-section
[edges, TriP, TriM] = mt(strcoiltemp.t);
[Pi, ti, polymask, flag] = meshplaneintXY(strcoiltemp.P, strcoiltemp.t, edges, TriP, TriM, Z);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 2), 'Color', 'r', 'LineWidth', 2);
    end   
end

%%   Additionally, plot core cross-section
[edges, TriP, TriM] = mt(GEOMtemp.t);
[Pi, ti, polymask, flag] = meshplaneintXY(GEOMtemp.P, GEOMtemp.t, edges, TriP, TriM, Z);
if flag % intersection found                
    for n = 1:size(polymask, 1)
        i1 = polymask(n, 1);
        i2 = polymask(n, 2);
        line(Pi([i1 i2], 1), Pi([i1 i2], 2), 'Color', 'c', 'LineWidth', 3);
    end   
end

grid on; set(gcf,'Color','White');
axis equal; axis tight;
