%   This script computes the induced surface charge density for an
%   inhomogeneous multi-tissue object in an external time-varying magnetic
%   field due to a coil via a BEM/FMM iterative solution with accurate
%   neighbor integration
%
%   Copyright SNM/WAW 2017-2020

%%  Parameters of the iterative solution
iter         = 25;              %    Maximum possible number of iterations in the solution 
relres       = 1e-3;            %    Minimum acceptable relative residual 
weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
prec         = 1e-4;            %    FMM Precision (high!)

%%  Right-hand side b of the matrix equation Zc = b. Compute pointwise
%   Surface charge density is normalized by eps0: real charge density is eps0*c
tic
EincP    = bemf3_inc_field_electric_core(strcoil, P, mu0, prec);        %  Incident coil field
Einc     = 1/3*(EincP(t(:, 1), :) + EincP(t(:, 2), :) + EincP(t(:, 3), :));
b        = 2*(contrast.*sum(normals.*Einc, 2));                         %  Right-hand side of the matrix equation
IncFieldTime = toc

%%  GMRES iterative solution (native MATLAB GMRES is used)
h           = waitbar(0.5, 'Please wait - Running GMRES');  
%   MATVEC is the user-defined function of c equal to the left-hand side of the matrix equation LHS(c) = b
MATVEC = @(c) bemf4_surface_field_lhs(c, Center, Area, contrast, normals, weight, EC, prec);     
%   Use custom GMRES (MATLAB GMRES gives the identical solution for a given # of iterations)
[c, its, resvec] = fgmres(MATVEC, b, relres, 'restart', iter, 'x0', b, 'tol_exit', relres);
close(h);

%%  Plot convergence history
figure; 
resvec = [1; resvec];
semilogy(resvec, '-o'); grid on;
title('Relative residual of the iterative solution');
xlabel('Iteration number');
ylabel('Relative residual');

%%  Check charge conservation law (optional)
conservation_law_error = sum(c.*Area)/sum(abs(c).*Area)

%%  Check the residual of the integral equation
relative_residual = resvec(end)

%%  Save solution data (surface charge density, principal value of surface field)
save('output_charge_solution', 'c', 'Einc', 'resvec', 'conservation_law_error');

