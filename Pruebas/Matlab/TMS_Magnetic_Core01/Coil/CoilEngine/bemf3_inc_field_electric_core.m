function Etotal = bemf3_inc_field_electric_core(strcoil, Points, mu0, Moments, GEOM, prec)   
%   This script accurately computes the E-field (-dA/dt)
%   with a magnetic core 
%
%   Copyright SNM 2021
    %   Find two contributions to magnetic vector potential and E-field
    Ecoil          = bemf3_inc_field_electric(strcoil, Points, mu0, prec);   
    Ecore          = bemf3_inc_field_magnetization(GEOM, Moments, Points, strcoil.dIdt, strcoil.I0, mu0, prec);
    Etotal         = Ecoil + Ecore;   
end