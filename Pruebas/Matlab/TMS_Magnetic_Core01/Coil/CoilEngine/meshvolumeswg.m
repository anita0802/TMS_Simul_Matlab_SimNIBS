function GEOM = meshvolumeswg(P, T)
    %   Outputs SWG basis functions into structure GEOM 
    %   P is the global (full) set of nodes 
    %
    %   SNM 2021

    tic
    T               = sort(T, 2);
    TetrahedraTotal = size(T, 1);

    %%  Find all inner facets ti (with TetP, TetM) and all boundary facets t (with TetS) of the tetrahedral mesh
    tic
    facesup             = [T(:,[1 2 3]); T(:,[1 2 4]); T(:,[1 3 4]); T(:,[2 3 4])];           %  All faces duplicated
    f1                  = sort(facesup, 2);                                                   %  All faces now in same order 
    [faces, eia(:,1)]   = unique(f1, 'rows');                           %  eia(:,1) contains the row in f1 that was chosen for faces
    [~, eia(:,2)]       = unique(f1, 'last', 'rows');                   %  eia(:,2) contains the other row in f1 for the same faces
    e2t                 = mod(eia-1,size(T, 1))+1;                      %  since "facesup" contains four copies of T, mod makes the translation
    e2t                 = sort(e2t, 2);                                 %  Put the lowest index tet into TetP
    e2tnondup           = e2t(:, 1) ~= e2t(:, 2);                       %  Indexes into faces that are attached to two tets
    e2tdup              = e2t(:, 1) == e2t(:, 2);                       %  Indexes into faces that are attached to only one tet
    ti                  = faces(e2tnondup, :);                          %  Inner faces
    t                   = faces(e2tdup, :);                             %  Boundary faces
    etemp               = e2t(e2tdup, :);                               %  For TetS (only duplicated)
    TetS                = etemp(:, 1);                                  %  Indexes into TetS for boundary faces (those are single plus tets)
    etemp               = e2t(e2tnondup, :);                            %  For TetP, TetM (never duplicated)
    TetP                = etemp(:, 1);                                  %  Indexes into TetP for inner faces
    TetM                = etemp(:, 2);                                  %  Indexes into TetM for inner faces
    
    %%  Compute mesh parameters
    CenterT             = meshtetcenter(P, T);
    VolumeT             = tetvol(P, T);
    normals             = meshnormals(P, t);                            %   Normal vectors of boundary facets (non-corrected)
    Area                = meshareas(P, t);                              %   Find areas of boundary faces
    Areai               = meshareas(P, ti);                             %   Find areas of inner faces
    Center              = meshtricenter(P, t);                          %   Find centers of boundary faces
    Centeri             = meshtricenter(P, ti);                         %   Find centers of inner faces    
    
    %%  Correct normal surface vectors and fix surface triangle orientation
    for m = 1:size(t, 1)
        vector          = Center(m, :) - CenterT(TetS(m), :);
        factor          = sign(dot(normals(m, :), vector));
        normals(m, :)   = factor*normals(m, :);
    end
    t  = meshreorient(P, t, normals);    

    %%   Assign normal vectors for inner facets (from TetP to TetM)
    normalsi = meshnormals(P, ti);
    for m = 1:size(ti, 1)
        vector          = CenterT(TetM(m), :) - CenterT(TetP(m), :);
        factor          = sign(dot(normalsi(m, :), vector));
        normalsi(m, :)  = factor*normalsi(m, :);
    end
    FastTime = toc

    %%  Define and save surface and volume structure GEOM in meters
    GEOM.P          = P;
    GEOM.T          = T;
    GEOM.CenterT    = CenterT;
    GEOM.VolumeT    = VolumeT;
    GEOM.t          = t; 
    GEOM.ti         = ti;   
    GEOM.Area       = Area;
    GEOM.Areai      = Areai;    
    GEOM.Center     = Center; 
    GEOM.Centeri    = Centeri; 
    GEOM.TetS       = TetS;
    GEOM.TetP       = TetP;
    GEOM.TetM       = TetM;    
    GEOM.normals    = normals;
    GEOM.normalsi   = normalsi;
end