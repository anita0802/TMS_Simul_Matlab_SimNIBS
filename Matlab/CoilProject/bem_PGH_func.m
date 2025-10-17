function bem_PGH(coil_pos_coordinates_X, coil_pos_coordinates_Y, coil_pos_coordinates_Z, cross_section_plane, cross_section_pos_X, cross_section_pos_Y, cross_section_pos_Z)
    load('coil_inductance_workspace.mat');

    cd ../../
    bem0_load_model
    
    coilPosCoord_X = coil_pos_coordinates_X;
    coilPosCoord_Y = coil_pos_coordinates_Y;
    coilPosCoord_Z = coil_pos_coordinates_Z;

    bem1_setup_coil
    bem2_charge_engine
    bem3_surface_field_c
    bem3_surface_field_e

    crossSectionPlane = cross_section_plane;
    crossSectionPos_X = cross_section_pos_X;
    crossSectionPos_Y = cross_section_pos_Y;
    crossSectionPos_Z = cross_section_pos_Z;

    bem4_define_planes

    if strcmpi(crossSectionPlane, 'Coronal')
        bem5_volume_XZ
    elseif strcmpi(crossSectionPlane, 'Sagittal')
        bem5_volume_YZ
    end
end