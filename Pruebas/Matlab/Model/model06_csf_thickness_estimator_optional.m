%   This script computes all nodes of the midsurface (or any other surface) between GM and CSF
%
%   Copyright SNM/WAW 2021

clear all; %#ok<CLALL>
if ~isunix
    s = pwd; addpath(strcat(s(1:end-6), '\Engine'));
else
    s = pwd; addpath(strcat(s(1:end-6), '/Engine'));
end

name = '131722';

GMname      = strcat(name, '_gm.mat');
GM          = load(GMname);
GMCenter    = meshtricenter(GM.P, GM.t);

CSFname      = strcat(name, '_csf.mat');
CSF          = load(CSFname);
CSFCenter    = meshtricenter(CSF.P, CSF.t);

MidP    = zeros(size(GMCenter));

%   Do CSF subdivision
[coeffS, weightsS, IndexS]  = tri(6);
Center_subdiv               = zeros(IndexS*size(CSF.t, 1), 3);
P1                          = CSF.P(CSF.t(:,1), :);
P2                          = CSF.P(CSF.t(:,2), :);
P3                          = CSF.P(CSF.t(:,3), :);

for j = 1:IndexS
    currentIndices                   = ([1:size(CSF.t, 1)] - 1)*IndexS + j; 
    Center_subdiv(currentIndices, :) = coeffS(1, j)*P1 + coeffS(2, j)*P2 + coeffS(3, j)*P3;
end

wneighbor = knnsearch(Center_subdiv, GMCenter,  'k', 1);   % [1:GM, 1]
GWdist    = GMCenter - Center_subdiv(wneighbor, :);
GWdist    = sqrt(dot(GWdist, GWdist, 2));

MEANDIST = mean(GWdist)
MINDIST = min(GWdist)

