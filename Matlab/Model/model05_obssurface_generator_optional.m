%   This script computes all nodes of the midsurface (or any other surface) between GM and WM
%
%   Copyright SNM/WAW 2021

%clear all; %#ok<CLALL>
if ~isunix
    s = pwd; addpath(strcat(s(1:end-6), '\Engine'));
else
    s = pwd; addpath(strcat(s(1:end-6), '/Engine'));
end

name = '131722';

GMname      = strcat(name, '_gm.mat');
GM          = load(GMname);
GMCenter    = meshtricenter(GM.P, GM.t);

WMname      = strcat(name, '_wm.mat');
WM          = load(WMname);
WMCenter    = meshtricenter(WM.P, WM.t);

MidP    = zeros(size(GMCenter));

%   Do WM subdivision
[coeffS, weightsS, IndexS]  = tri(6);
Center_subdiv               = zeros(IndexS*size(WM.t, 1), 3);
P1                          = WM.P(WM.t(:,1), :);
P2                          = WM.P(WM.t(:,2), :);
P3                          = WM.P(WM.t(:,3), :);

for j = 1:IndexS
    currentIndices                   = ([1:size(WM.t, 1)] - 1)*IndexS + j; 
    Center_subdiv(currentIndices, :) = coeffS(1, j)*P1 + coeffS(2, j)*P2 + coeffS(3, j)*P3;
end

wneighbor = knnsearch(Center_subdiv, GMCenter,  'k', 1);   % [1:GM, 1]
GWdist    = GMCenter - Center_subdiv(wneighbor, :);
alpha     = 0.8;            %   weight or relative distance parameter
GWdist    = sqrt(dot(GWdist, GWdist, 2));
MidP      = alpha*GMCenter + (1-alpha)*Center_subdiv(wneighbor, :);   %   change this if necessary

save('obs_surface.mat', 'MidP', 'GWdist');
MEANDIST = mean(GWdist)
MINDIST = min(GWdist)
