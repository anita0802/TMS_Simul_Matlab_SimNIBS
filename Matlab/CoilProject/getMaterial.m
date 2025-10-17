function mucore = getMaterial(H, material_type)
% material_type: m3_atan, m3_froe, gen_atan, met_froe
switch material_type
    case 'm3_atan'
        mucore = core00_material_m3_atan(H);   % M3 steel modeled with an arctangent function
    case 'm3_froe'
        mucore = core00_material_m3_froe(H);   % M3 steel modeled using Froelich's law
    case 'gen_atan'
        mucore = core00_material_gen_atan(H);  % Does not correspond to any specific material, 
                                               % generic model with “universal” parameters 
                                               % with an arctangent function
    case 'met_froe'
        mucore = core00_material_met_froe(H);  % Metglas modeled with Froelich's law
    otherwise
        error('mucore:unknownType', 'Unrecognized material type "%s".', material_type);
end
end