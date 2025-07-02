%   This is a mesh processor script: it computes basis triangle parameters
%   and necessary potential integrals, and constructs a combined mesh of a
%   multi-object structure (for example, a head or a whole body)
%
%   Copyright SNM/WAW 2017-2020

%clear all; %#ok<CLALL>

if ~isunix
    s = pwd; addpath(strcat(s(1:end-6), '\Engine'));
else
    s = pwd; addpath(strcat(s(1:end-6), '/Engine'));
end

%% Load tissue filenames and tissue display names from index file
index_name = 'tissue_index.txt';
[name, tissue, cond, enclosingTissueIdx] = tissue_index_read(index_name);

%%  Load tissue meshes and combine individual meshes into a single mesh
tic
PP = [];
tt = [];
nnormals = [];
Indicator = [];

%   Combine individual meshes into a single mesh
for m = 1:length(name)
    load(name{m}); 
    P = P;     %  only if the original data were in mm!
    tt = [tt; t+size(PP, 1)];
    PP = [PP; P];
    nnormals = [nnormals; normals];    
    Indicator= [Indicator; repmat(m, size(t, 1), 1)];
    disp(['Successfully loaded file [' name{m} ']']);
end
t = tt;
P = PP;
normals = nnormals;
LoadBaseDataTime = toc

%%  Fix triangle orientation (just in case, optional)
tic
t = meshreorient(P, t, normals);
%%   Process other mesh data
Center      = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :));  %   face centers
Area        = meshareas(P, t);  
SurfaceNormalTime = toc

%%  Assign facet conductivity information
tic
condambient = 0.0; %   air
[contrast, condin, condout] = assign_initial_conductivities(cond, condambient, Indicator, enclosingTissueIdx);
InitialConductivityAssignmentTime = toc

%%  Check for and process triangles that have coincident centroids
tic
disp('Checking combined mesh for duplicate facets ...');
[P, t, normals, Center, Area, Indicator, condin, condout, contrast] = ...
    clean_coincident_facets(P, t, normals, Center, Area, Indicator, condin, condout, contrast);
disp('Resolved all duplicate facets');
N           = size(t, 1);
DuplicateFacetTime = toc

%%   Find topological neighbors
tic
DT = triangulation(t, P); 
tneighbor = neighbors(DT);
% Fix cases where not all triangles have three neighbors
tneighbor = pad_neighbor_triangles(tneighbor);

%%   Save base data
FileName = 'CombinedMesh.mat';
save(FileName, 'P', 't', 'normals', 'Area', 'Center', 'Indicator', 'name', 'tissue', 'cond', 'enclosingTissueIdx', 'condin', 'condout', 'contrast');
ProcessBaseDataTime = toc

%%   Add accurate integration for electric field/electric potential on neighbor facets
%   Indexes into neighbor triangles
numThreads = 15;        %   number of cores to be used
RnumberE        = 4;    %   number of neighbor triangles for analytical integration (fixed, optimized)
ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';           %   do transpose  
[EC, PC, EFX, EFY, EFZ, PF] = meshneighborints(P, t, normals, Area, Center, RnumberE, ineighborE, numThreads);

% %%   Add accurate integration for arbitrary observation surface(s)
% load('obs_surface.mat'); 
% MidP            = 1e-3*MidP; %  only if the original data were in mm!
% ineighborE      = knnsearch(MidP, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
% ineighborE      = ineighborE';           %   do transpose 
% [ESX, ESY, ESZ] = meshneighborintspoints(MidP, P, t, normals, Area, Center, RnumberE, ineighborE, numThreads);
ESX = []; ESY = []; ESZ = []; MidP = [];

tic
NewName  = 'CombinedMeshP.mat';
save(NewName, 'tneighbor',  'EC', 'PC', 'EFX', 'EFY', 'EFZ', 'PF', 'MidP', 'ESX', 'ESY', 'ESZ', '-v7.3');
SaveBigDataTime = toc