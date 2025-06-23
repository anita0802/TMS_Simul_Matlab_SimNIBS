function mucore = core00_material_m3_froe(H)
    % https://www.arnoldmagnetics.com/materials/grain-oriented-electrical-steel-goes/
    % 2 mil 2 kHz
    %   outputs mur for all values of H
    mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
    h           = sqrt(dot(H, H, 2));
    b    = h./(40 + 0.50*h) + mu0*h;
    mucore      = b./(mu0*h);
end