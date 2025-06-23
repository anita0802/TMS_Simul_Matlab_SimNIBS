function Moments = bemf3_inc_field_core_moments(c, c0, P, t, Center, Area, normals, strcoil, mu0, GEOM, mucore, R, prec)   
%   This script accurately computes all voxel dipole moments within the
%   magnetic core
%
%   Copyright SNM 2021    
    %   Find H total at voxels first
    Hpri           = (1/mu0)*bemf3_inc_field_magnetic(strcoil, GEOM.CenterT, mu0, prec);    
    Hsec           = (1/mu0)*bemf5_volume_field_magnetic(GEOM.CenterT, c, P, t, Center, Area, normals, R, prec);
    Htotal         = Hpri + Hsec;
    %  Correct the error inside the core next (all voxels are inside)
    Hinf           = (1/mu0)*bemf5_volume_field_magnetic(GEOM.CenterT, c0, P, t, Center, Area, normals, R, prec);
    Herr           = Hpri + Hinf; 
    Htotal         = Htotal - Herr;   
    %  Now find accurate magnetization    
    Magn           = (mucore - 1)*Htotal;    
    Moments        = GEOM.VolumeT.*Magn; 
end