function mucore = core00_Material(H, material_type)
% material_type: m3_atan, m3_froe, gen_atan, met_froe
switch material_type
    case 'm3_atan'
        mucore = core00_material_m3_atan(H);   % acero M3 modelado con una función de tipo arcotangente
    case 'm3_froe'
        mucore = core00_material_m3_froe(H);   % acero M3 modelado con la ley de Froelich
    case 'gen_atan'
        mucore = core00_material_gen_atan(H);  % no corresponde a ningún material concreto, modelo genérico con parámetros “universales” con una función de tipo arcotangente
    case 'met_froe'
        mucore = core00_material_met_froe(H);  % metglas modelado con la ley de Froelich
    otherwise
        error('mucore:unknownType', 'Tipo de material "%s" no reconocido.', material_type);
end
end