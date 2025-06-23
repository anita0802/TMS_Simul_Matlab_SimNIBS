%   This script computes the induced magnetic surface charge density for a
%   magnetic core due to a coil via a BEM/FMM iterative solution with accurate
%   surface neighbor integration
%
%   Copyright SNM 2021

%%  Parameters of the iterative solution
iter         = 16;              %    Maximum possible number of iterations in the solution 
relres       = 1e-12;           %    Minimum acceptable relative residual 
weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
prec         = 1e-4;            %    Precision   

%%  Independent variables
M   = size(GEOM.t, 1);          %   number of surface (boundary) facets
N   = size(GEOM.ti, 1);         %   number of surface (inner) facets or the number of SWGs 
NT  = size(GEOM.T, 1);          %   number of tetrahedra in the mesh
cf  = zeros(M+N, 1);            %   density of surface charges + coefficients of SWG bases

%%  Primary field (compute pointwise)
FpriP       = bemf3_inc_field_magnetic(strcoil, P, prec);                           %   Primary field anywhere at all nodes
FpriS       = 1/3*(FpriP(t(:, 1), :) + FpriP(t(:, 2), :) + FpriP(t(:, 3), :));      %   Pimary field at the centers of all facets

%%  Nonlinear GMRES surface/volume iterative solution (no cf0 correction here)
h               = waitbar(0.5, 'Please wait - Running GMRES'); 
NonlinearIters  = 50;
alpha           = 0.975;
clear           contrasterror;
clear           chargeerror;
Hpri            = bemf3_inc_field_magnetic(strcoil, GEOM.CenterT, prec);    %   Primary coil field at T centers
mucore          = core00_Material(Hpri);                                    %   Initial mucore at all T centers
contrastS       = (mucore(GEOM.TetS) - 1)./(mucore(GEOM.TetS) + 1);                                         %   Local initial contrast for surface facets        
contrastV       = (mucore(GEOM.TetP) - mucore(GEOM.TetM))./(mucore(GEOM.TetP) + mucore(GEOM.TetM));         %   Local initial contrast for inner facets
contrast        = [contrastS; contrastV];                                                                   %   Local initial contrast for all facets
for m = 1:NonlinearIters    
    b                   = 2*(contrast.*sum(normals.*FpriS, 2));   
    MATVEC              = @(cf) bemf4_surface_field_lhs(cf, Center, Area, contrast, normals, weight, EC, prec);
    [cf, flag, rres, its, resvec] = gmres(MATVEC, b, [], relres, iter, [], [], b);         
    if m>1
        contrasterror(m-1)  = norm(contrastold - contrast)/norm(contrast);
        chargeerror(m-1)    = norm(cfold - cf)/norm(cf); 
        semilogy(contrasterror, '-*r'); hold on; semilogy(chargeerror, '-ob'); grid on; 
        title('Nonlinear iterations: rel. delta mur (red), rel. delta magn. charge (blue)'); xlabel('iteration number'); drawnow;
    end    
    contrastold      = contrast; 
    mucoreold        = mucore;
    cfold            = cf;
    %   Update mucore and assign new contrasts
    Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec); 
    HtotalF         = tetfieldwithoutarea(GEOM, FpriS, cf, Center, Area, normals, EFX, EFY, EFZ, prec);    
    Htotal          = alpha*Htotal+(1-alpha)*HtotalF;    
    mucore          = core00_Material(Htotal);    
    contrastS       = (mucore(GEOM.TetS) - 1)./(mucore(GEOM.TetS) + 1);                                         %   Local contrast for surface facets        
    contrastV       = (mucore(GEOM.TetP) - mucore(GEOM.TetM))./(mucore(GEOM.TetP) + mucore(GEOM.TetM));         %   Local contrast for inner facets
    contrast        = [contrastS; contrastV];
    if m>1&&chargeerror(end)<1e-3
        disp('Charge error is less than 0.1%');
        break;
   end 
%    if m>2&&chargeerror(end)>chargeerror(end-1)
%         disp('Charge error saturated');
%         break;
%    end 
end
close(h);

%%  Output convergence data
%  Plot GMRES convergence history
figure
resvec = resvec/resvec(1);
semilogy(resvec, '-o'); grid on;
title('Relative residual of the iterative solution');
xlabel('Iteration number');
ylabel('Relative residual');

%%  Check charge conservation law (optional)
e.conservation_law_error = sum(cf.*Area)/sum(abs(cf).*Area);

%%  Check the residual of the integral equation (optional)
e.relative_residual = resvec(end);

%%  Check average mucore
e.MEANMUCORE = mean(mucore); e

%%   Compute core elementary moments m (magnetization times volume) for every tetrahedron for A
Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec);
mucore          = core00_Material(Htotal);                                  %   Relative local mucore 
Magnetization   = (mucore - 1).*Htotal;                                     %   Magnetization per unit volume
Moments         = GEOM.VolumeT.*Magnetization;                              %   Total moments per every tetrahedron    
MomentsTime = toc

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
