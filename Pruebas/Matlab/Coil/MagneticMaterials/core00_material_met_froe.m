function mucore = core00_material_met_froe(H)
    %   METGLAS at <=5 kHz
    %   From METGLAS® 2605-SA1 core Datasheet. U.S. Department of Energy - National Energy Technology Laboratory. June 2018. 
    %   Online: https://www.netl.doe.gov/sites/default/files/netl-file/METGLAS-2605-SA1-Core-Datasheet_approved%5B1%5D.pdf
    %   outputs mur for all values of H
    mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
    h           = sqrt(dot(H, H, 2));
    b    = h./(80 + 0.82*h) + mu0*h;
    mucore      = b./(mu0*h);
end