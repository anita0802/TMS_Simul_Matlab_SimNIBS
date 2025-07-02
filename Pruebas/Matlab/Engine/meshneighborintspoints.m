function [ESX, ESY, ESZ] = meshneighborintspoints(Points, P, t, normals, Area, Center, RnumberE, ineighborE, numThreads)
%   Accurate integration for electric field/electric potential on neighbor facets
%   Copyright SNM 2017-2020
    tic 
    N = size(t, 1);
    %   For every triangle we define RnumberE neighbor points from array Points 
    integralxe      = zeros(RnumberE, N);    %   exact Ex integrals for array of neighbor triangles 
    integralye      = zeros(RnumberE, N);    %   exact Ey integrals for array of neighbor triangles 
    integralze      = zeros(RnumberE, N);    %   exact Ez integrals for array of neighbor triangles 
    integralpe      = zeros(RnumberE, N);    %   exact potential integrals for array of neighbor triangles 

    integralxc      = zeros(RnumberE, N);    %   center-point Ex integrals for array of neighbor triangles 
    integralyc      = zeros(RnumberE, N);    %   center-point Ey integrals for array of neighbor triangles 
    integralzc      = zeros(RnumberE, N);    %   center-point Ez integrals for array of neighbor triangles 
    integralpc      = zeros(RnumberE, N);    %   center-point potential integrals for array of neighbor triangles 

    %   Main loop for analytical double integrals (parallel, 24 workers)
    %   This is the loop over columns of the system matrix
    tic
    parpool(numThreads);
    parfor n = 1:N                  %   inner integral; (n =1 - first column of the system matrix, etc.)        
        r1      = P(t(n, 1), :);    %   [1x3]
        r2      = P(t(n, 2), :);    %   [1x3]
        r3      = P(t(n, 3), :);    %   [1x3]  
        index   = ineighborE(:, n); %   those are non-zero rows of the system matrix for given n
        ObsPoints   = Points(index, :);    %   to compute RnumberE integrals numerically at Points
        I           = zeros(RnumberE, 3);           %   for rhe field
        IP          = zeros(RnumberE, 1);           %   for the potential
        %   Accurate electric-field integrals
        J = potint2(r1, r2, r3, normals(n, :), ObsPoints); %   Outer integral is computed analytically, for all inner IntPoints    
        integralxe(:, n) = -J(:, 1);    %   accurate integrals, entries of non-zero rows of n-th column
        integralye(:, n) = -J(:, 2);    %   accurate integrals, entries of non-zero rows of n-th column
        integralze(:, n) = -J(:, 3);    %   accurate integrals, entries of non-zero rows of n-th column  
        %   Center-point electric-field integrals
        temp    = repmat(Center(n, :), RnumberE, 1) - ObsPoints; %   these are distances to the observation points
        DIST    = sqrt(dot(temp, temp, 2));                             %   single column   
        I       = Area(n)*temp./repmat(DIST.^3, 1, 3);                  %   center-point integral, standard format            
        integralxc(:, n) = -I(:, 1);    %   center-point integrals, entries of non-zero rows of n-th column
        integralyc(:, n) = -I(:, 2);    %   center-point integrals, entries of non-zero rows of n-th column
        integralzc(:, n) = -I(:, 3);    %   center-point integrals, entries of non-zero rows of n-th column        
        %   Accurate electric-potential integrals
        [JP, ~] = potint(r1, r2, r3, normals(n, :), ObsPoints);     %   JP was calculated without the area Area(n)         
        integralpe(:, n) = +JP;                     %   accurate integrals (here is without the area!)        
        %   Center-point electric-potential integrals         
        IPC     = Area(n)./DIST;                                        %   center-point integral, standard format 
        integralpc(:, n) = +IPC;                                        %   center-point approximation
    end 
    delete(gcp('nocreate'));    
    MainLoopParallelTime = toc
    
    integralxe      = integralxe - integralxc;    %   combined Ex integrals for array of neighbor triangles 
    integralye      = integralye - integralyc;    %   combined Ey integrals for array of neighbor triangles 
    integralze      = integralze - integralzc;    %   combined Ez integrals for array of neighbor triangles 
    integralpe      = integralpe - integralpc;    %   combined potential integrals for array of neighbor triangles   
    
    ii  = ineighborE;
    jj  = repmat([1:N], RnumberE, 1);
    ESX  = sparse(ii, jj, integralxe);               
    ESY  = sparse(ii, jj, integralye);               
    ESZ  = sparse(ii, jj, integralze);                 
end