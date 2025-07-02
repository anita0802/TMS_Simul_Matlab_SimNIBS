%   This is a mesh processor script: it computes basis triangle parameters
%   and necessary potential integrals, and constructs a combined mesh of a
%   multi-object structure. In this case, it handles magnetic materials
%
%   Copyright SNM/WAW 2017-2021

clear all; %#ok<CLALL>

if ~isunix
    s = pwd; addpath(strcat(s(1:end-13), '\CoilEngine'));   
else
    s = pwd; addpath(strcat(s(1:end-13), '/CoilEngine'));  
end

%%  Define EM constants
eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
mu0         = 31.82776031e-006;  %   Magnetic permeability of vacuum(~air) 1.25663706e-006

%% Load core 
name{1}     = 'core.mat'; load(name{1}); 
P           = GEOM.P;
t           = [GEOM.t; GEOM.ti];
normals     = [GEOM.normals; GEOM.normalsi];
Indicator   = ones(size(t, 1), 1);
Area        = [GEOM.Area; GEOM.Areai];
Center      = [GEOM.Center; GEOM.Centeri];

%%  Fix triangle orientation (just in case, optional)
tic
t = meshreorient(P, t, normals);
ProcessingTime  = toc

%%   Add accurate integration for field/potential on neighbor facets
%   Indexes into neighbor triangles
RnumberE        = 32;    %   number of neighbor triangles for analytical integration (fixed, optimized)
numThreads      = 4;
parpool(numThreads);
    ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
    ineighborE      = ineighborE';           %   do transpose  
    [EC, PC, EFX, EFY, EFZ, PF] ...
                    = meshneighborints(P, t, normals, Area, Center, RnumberE, ineighborE);
    ineighborE      = knnsearch(GEOM.Center, GEOM.Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
    ineighborE      = ineighborE';           %   do transpose  
    [EC0, PC0, EFX0, EFY0, EFZ0, PF0] ...
                    = meshneighborints(P, GEOM.t, GEOM.normals, GEOM.Area, GEOM.Center, RnumberE, ineighborE);

    %%   Add accurate integration for arbitrary observation points
    MidP            = GEOM.CenterT;
    ineighborE      = knnsearch(MidP, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
    ineighborE      = ineighborE';           %   do transpose 
    [ESX, ESY, ESZ] = meshneighborintspoints(MidP, P, t, normals, Area, Center, RnumberE, ineighborE);
delete(gcp('nocreate'));

%%  Tet neighbors
%TR                  = triangulation(GEOM.T, P);
%Neighbors           = neighbors(TR);
%temp                = [1:length(Neighbors)]';
%index                = isnan(Neighbors(:, 1));
%Neighbors(index, 1)  = temp(index);
%index                = isnan(Neighbors(:, 2));
%Neighbors(index, 2)  = temp(index);
%index                = isnan(Neighbors(:, 3));
%Neighbors(index, 3)  = temp(index);
%index                = isnan(Neighbors(:, 4));
%Neighbors(index, 4)  = temp(index);

save ProcessedCore P t normals Indicator Area Center eps0 mu0 GEOM EC0 EFX0 EFY0 EFZ0 EC EFX EFY EFZ ESX ESY ESZ %Neighbors
