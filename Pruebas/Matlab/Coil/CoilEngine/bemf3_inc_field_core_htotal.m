function Htotal = bemf3_inc_field_core_htotal(c, c0, P, t, Center, Area, normals, strcoil, mu0, Points, R, prec)   
%   This script accurately computes Htotal at any points within the volume
%   due to surface charges plus the incident field
%
%   Copyright SNM 2021    
    %   Find H total at voxels first
    Hpri           = (1/mu0)*bemf3_inc_field_magnetic(strcoil, Points, mu0, prec);    
    Hsec           = (1/mu0)*bemf5_volume_field_magnetic(Points, c, P, t, Center, Area, normals, R, prec);
    Htotal         = Hpri + Hsec;
    %  Correct the error inside the core next (all voxels are inside)
    Hinf           = (1/mu0)*bemf5_volume_field_magnetic(Points, c0, P, t, Center, Area, normals, R, prec);
    Herr           = Hpri + Hinf; 
    Htotal         = Htotal - Herr;   
end