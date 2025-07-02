function [P, E] = bemf4_surface_field_electric_accurate(c, Center, Area, EFX, EFY, EFZ, PF, prec)
%   This function computes CONTINUOUS electric field and the full potential
%   on a surface facet due to charges on ALL OTHER facets including
%   accurate neighbor integrals. Self-terms causing discontinuity may not
%   be included for electric field
%   To obtain the true field/potential, divide the result(s) by eps0;
%   Copyright SNM 2017-2021    
   
    %  FMM 2020   
    %----------------------------------------------------------------------
    %   Fields plus potentials of surface charges
    %   FMM plus correction
    tic
    const           = 1/(4*pi);    
    pg              = 2;
    srcinfo.sources = Center';
    srcinfo.charges = (c.*Area)';
    U               = lfmm3d(prec, srcinfo, pg);
    P               = +U.pot';
    E              = -U.grad'; 
    %   Correction
    E(:, 1) = E(:, 1) + EFX*c;
    E(:, 2) = E(:, 2) + EFY*c;
    E(:, 3) = E(:, 3) + EFZ*c;
    P       = P       + PF*c;
      
    E = const*E;
    P = const*P;
    toc 
    
end
