function [] = material_export

    mu0  = 1.25663706e-006; 
    h = [0; logspace(0, 6, 100)']; 
    %mucore = core00_material_m3_froe(h);
    %mucore = core00_material_m3_atan(h);
    mucore = core00_material_gen_atan(h);
    %mucore = core00_material_met_froe(h);
    
    b = mu0*mucore.*h; b(1) = 0;
     
    fileID      = fopen('core00_material_gen_atan.tab', 'w');
    string = '"H (A_per_meter)" 	"B (tesla)"';
    fprintf(fileID, '%s\n', string);
    for m = 1:length(h)
        fprintf(fileID, '%f    %f    \n', [h(m) b(m)]);
    end
    fclose(fileID);
end

