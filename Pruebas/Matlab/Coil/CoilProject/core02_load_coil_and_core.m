%   This script load metal core mesh and displays
%   the resulting coil-core geometry
%
%   Copyright SNM/WAW 2017-2021

clear all;  %#ok<CLALL>

%%  Load path
if ~isunix
    s = pwd; addpath(strcat(s(1:end-13), '\CoilEngine'));   
else
    s = pwd; addpath(strcat(s(1:end-13), '/CoilEngine'));  
end

%%  Load base coil data
if exist('strcoil', 'var')
    clear strcoil;
end
load coil.mat;       

%%  Load base core data
load ProcessedCore;

%%   Coil graphics
figure;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
view(10, 20);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);
camlight; lighting phong;

%%  General settings
axis 'equal';  axis 'tight';   
daspect([1 1 1]);
set(gcf,'Color','White');
axis off; view(10, 20);
