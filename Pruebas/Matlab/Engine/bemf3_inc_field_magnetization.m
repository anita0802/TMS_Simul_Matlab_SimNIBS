function Ecore = bemf3_inc_field_magnetization(Voxel, moments, Points, dIdt, I0, mu0, prec)  
%   Computes magnetic vector potential/E-field from the coil via the FMM

%   Copyright SNM 2017-2021

    %  Compute dipole positions and moments    
    segpoints   = Voxel;   
   
     %  Compute and normalize pseudo normal vectors
    nx(:, 1) = +0*moments(:, 1);
    nx(:, 2) = -1*moments(:, 3);
    nx(:, 3) = +1*moments(:, 2);
    ny(:, 1) = +1*moments(:, 3);
    ny(:, 2) = +0*moments(:, 2);
    ny(:, 3) = -1*moments(:, 1);
    nz(:, 1) = -1*moments(:, 2);
    nz(:, 2) = +1*moments(:, 1);
    nz(:, 3) = +0*moments(:, 3);
    const    = mu0*dIdt/I0;

    %   FMM 2019
    srcinfo.nd      = 3;                            %   three charge vectors    
    srcinfo.sources = segpoints';                   %   source points
    targ            = Points';                      %   target points   
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 1;                                    %   potential is evaluated at target points
    srcinfo.dipoles(1, :, :)     = nx.';                             
    srcinfo.dipoles(2, :, :)     = ny.';                             
    srcinfo.dipoles(3, :, :)     = nz.';                       
    U                        = lfmm3d(prec, srcinfo, pg, targ, pgt);
    Ecore(:, 1)               = const*U.pottarg(1, :)/(4*pi);
    Ecore(:, 2)               = const*U.pottarg(2, :)/(4*pi);
    Ecore(:, 3)               = const*U.pottarg(3, :)/(4*pi); 
end

