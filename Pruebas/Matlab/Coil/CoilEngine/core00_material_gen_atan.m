function mucore = core00_material_gen_atan(H)
    %BH curve - general (smooth)
    %   outputs mur for all values of H
    mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
    h           = sqrt(dot(H, H, 2));
    b           = 2.5*atan(h/2e3)/(pi/2) + mu0*h;
    mucore      = b./(mu0*h);
    %mu0  = 1.25663706e-006; H = logspace(0, 7, 100)'; mucore = core00_Material(H); loglog(H, mucore, '-*'); grid on; B = mu0*mucore.*H;          
end