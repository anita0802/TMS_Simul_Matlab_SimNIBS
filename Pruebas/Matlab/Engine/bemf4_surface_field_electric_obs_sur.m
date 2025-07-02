function E = bemf4_surface_field_electric_obs_sur(Points, c, P, t, Center, Area, ESX, ESY, ESZ, prec)
%   Computes electric field for an array Points anywhere in space using
%   precomputed neighbor integrals assembled in sparse matrices
%
%   Copyright SNM 2017-2021
    
    %   FMM 2019
    srcinfo.sources = Center';                      %   source points
    targ            = Points';                      %   target points     
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 2;                                    %   field and potential are evaluated at target points
    srcinfo.charges = c.'.*Area';                   %   charges
    U               = lfmm3d(prec, srcinfo, pg, targ, pgt);
    E               = -U.gradtarg'/(4*pi); 
    
   %   Correction
    const = 4*pi; 
    E(:, 1) = E(:, 1) + ESX*c/const;
    E(:, 2) = E(:, 2) + ESY*c/const;
    E(:, 3) = E(:, 3) + ESZ*c/const;
end