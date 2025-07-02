%% 
%   This script computes the induced magnetic surface charge density for a
%   magnetic core due to a coil via a BEM/FMM iterative solution with accurate
%   surface neighbor integration. Linear magnetostatics
%
%   Copyright SNM 2021

%%  Give mucore
mucore = core00_Material(eps);

%%  Parameters of the iterative solution
iter         = 30;              %    Maximum possible number of iterations in the solution 
relres       = 1e-12;           %    Minimum acceptable relative residual 
weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
prec         = 1e-4;            %    Precision   

%%  Independent variables
M   = size(GEOM.t, 1);          %   number of surface (boundary) facets
N   = size(GEOM.ti, 1);         %   number of surface (inner) facets or the number of SWGs 

%%  Primary field (compute pointwise)
tic 
FpriP       = bemf3_inc_field_magnetic(strcoil, P(1:max(max(GEOM.t)), :), prec);                      %   Primary field anywhere at surface nodes
FpriS       = 1/3*(FpriP(GEOM.t(:, 1), :) + FpriP(GEOM.t(:, 2), :) + FpriP(GEOM.t(:, 3), :));       %   Pimary field at the centers of surface facets
PriFieldTime = toc

%%  Linear GMRES surface/volume iterative solution for infinite linear mu
h           = waitbar(0.5, 'Please wait - Running GMRES');  
contrast    = [ones(M, 1)];                                   %  Local contrast 
b           = 2*(contrast.*sum(GEOM.normals.*FpriS, 2));
MATVEC      = @(c0) bemf4_surface_field_lhs(c0, GEOM.Center, GEOM.Area, contrast, GEOM.normals, weight, EC0, prec);
[c0, its, resvec] = fgmres(MATVEC, b, relres, 'restart', iter, 'x0', b, 'tol_exit', relres);
close(h);
cf0 = [c0; zeros(N, 1)];

%%  Linear GMRES surface/volume iterative solution for linear mu
h           = waitbar(0.5, 'Please wait - Running GMRES');  
contrast    = [(mucore-1)/(mucore+1)*ones(M, 1)];                                   %  Local contrast 
b           = 2*(contrast.*sum(GEOM.normals.*FpriS, 2));
MATVEC      = @(c) bemf4_surface_field_lhs(c, GEOM.Center, GEOM.Area, contrast, GEOM.normals, weight, EC0, prec);
[c, its, resvec] = fgmres(MATVEC, b, relres, 'restart', iter, 'x0', b, 'tol_exit', relres);
close(h);
cf = [c; zeros(N, 1)];

%%  Output convergence data
%  Plot GMRES convergence history
figure
resvec = resvec/resvec(1);
semilogy(resvec, '-o'); grid on;
title('Relative residual of the iterative solution');
xlabel('Iteration number');
ylabel('Relative residual');

%%  Check charge conservation law (optional)
e.conservation_law_error = sum(cf.*Area)/sum(abs(cf).*Area)

%%  Check the residual of the integral equation (optional)
e.relative_residual = resvec(end)

%%  Check average mucore
e.MEANMUCORE = mean(mucore)

%%   Compute core elementary moments m (magnetization times volume) for every tetrahedron for A
% c-c0 is the contribution of corrected charges and the incident field
h               = waitbar(0.5, 'Please wait - Computing moments');
tic
Htotal          = bemf5_volume_field_sv(GEOM.CenterT, cf-cf0, P, t, Center, Area, ESX, ESY, ESZ, prec);
Magnetization   = (mucore - 1)*Htotal;                                      %   Magnetization per unit volume
Moments         = GEOM.VolumeT.*Magnetization;                              %   Total moments per every tetrahedron    
MomentsTime = toc
close(h)

%%  Inductance calculation
Inductance.Lpri             = bemf6_inductance_neumann_integral(strcoil, mu0, prec);
Bpri                        = mu0*bemf3_inc_field_magnetic(strcoil, GEOM.CenterT, prec);            %  Incident coil field
Esec                        = 0.5*sum(dot(Moments, Bpri, 2));                                       % since volume is is already included in the Moments 
Inductance.Lsec             = 2*Esec/(strcoil.I0)^2;
Inductance.L                = Inductance.Lpri + Inductance.Lsec;
Inductance

%%  Update coil structure by appending magnetic core data and save in the main Coil folder
strcoil.CenterT  = GEOM.CenterT;
strcoil.Moments = Moments;
strcoil.CoreP   = P;
strcoil.Coret   = t;
save('coil', 'strcoil');

