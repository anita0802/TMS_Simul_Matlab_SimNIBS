function [P, t, normals, strcoil, check] = meshextrudeall(Pcenter, P0, e0, t0, sk)
%   Outputs a 2-manifold P, t surface mesh resulting from sweeping the
%   cross-section mesh P0, e0, t0
%   along an arbitrary curve/path. The curve could be either open or closed
%   (torus). In the last case, the start point and the end point must coincide. 
%   Inputs: 
%   Pcenter - centerline of the conductor in 3D [:, 3];
%   P0, e0, t0 - cross-sectional mesh cross-section); 
%   Outputs: 
%   P  -  P-aray of surface mesh vertices 
%   t  - array of surface triangular facets 
%
%   SNM 2018-2021
    
    %%  Preparation of the path
    Nodes           = size(Pcenter, 1); 
    Closed          = norm(Pcenter(1, :)-Pcenter(end, :))/norm(Pcenter(1, :))<1e-9;
    PathVector      = Pcenter(2:end, :) - Pcenter(1:end-1, :);  
    
    %%  Preparation of the mesh - SURFACE MODEL
    NE              = size(e0, 1);              %   number of nodes/edges in the cross-section, global for the entire code
    BorderIndex     = max(max(e0));
    BorderNodes     = P0(1:BorderIndex, :);     %   nodes for the border edges, global for the entire code
    NB              = size(BorderNodes, 1);     %   How many are border nodes
    added           = size(P0, 1) - NB;         %   How many nodes were added
    
    %%   Preparation of the mesh - WIRE MODEL  
    %   The base array of triangle centers in the xy plane is initialized.
    %   Then, it will be rotated/moved
    edges0          = meshconnee(t0); 
    areas           = meshareas(P0, t0);   
    BaseNodes       = meshtricenter(P0, t0);      
    if sk == 0
       weights      = areas/sum(areas);  % uniform curent distribution/weights       
    else
        at    = meshconnet(t0, edges0, "nonmanifold"); % triangles attached to every edge
        tborder = [];
        for m = 1:length(at)
            if at{m}(2)==0
                tborder = [tborder at{m}(1)];
            end
        end
        weights     = areas(tborder)/sum(areas(tborder));
        BaseNodes   = BaseNodes(tborder, :); 
    end
    NBA             = size(BaseNodes, 1);     %   How many are border nodes
      
    %%   Start with bottom - SURFACE MODEL
    t               = []; 
    UnitPathVector  = PathVector(1, :) + Closed*PathVector(end, :);
    UnitPathVector  = UnitPathVector/norm(UnitPathVector);  
    pbottom         = meshrotate1(BorderNodes, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3)); 
    pbottom         = pbottom + repmat(Pcenter(1, :), NB, 1);   %  put the mesh in the right position
    P               = pbottom; 
    ptopold         = pbottom; 
    angle           = zeros(Nodes-1, 1);
    
    %%   Start with bottom - WIRE MODEL
    points          = meshrotate1(BaseNodes, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3)); 
    points          = points + repmat(Pcenter(1, :), NBA, 1);   %  put the mesh in the right position        
    wires           = size(BaseNodes, 1);
    Pwire           = zeros((Nodes-0)*wires, 3);
    Ewire           = zeros((Nodes-1)*wires, 2);
    Swire           = repmat(weights, Nodes-1, 1);    
    arg             = zeros(Nodes, wires);
    
    %%   Create surface mesh - SURFACE MODEL - running array is "top"
    for m = 1:Nodes - 1
        if m < Nodes - 1            
            UnitPathVector      = PathVector(m, :) + PathVector(m+1, :);    %   this works better
        else
            UnitPathVector      = PathVector(end, :);                       %   the final extrapolation 
        end
        UnitPathVector      = UnitPathVector/norm(UnitPathVector);             
        ptop                = meshrotate1(BorderNodes, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3));                         
        [ptop, angle(m+1)]  = meshrotate3(ptopold, ptop, UnitPathVector, angle(m));                 
        ptopold             = ptop;
        ptop                = ptop + repmat(Pcenter(m+1, :), NB, 1);   %    put the mesh in the right position
        if (m==Nodes-1)&Closed 
            ptop = pbottom; 
        end  
        P                   = [P; ptop];               
        %   Local connectivity map: bottom to top
        t1(:, 1:2)      = e0;                        %   Lower nodes        
        t1(:, 3)        = e0(:, 1) + NE;             %   Upper node
        t2(:, 2:-1:1)   = e0       + NE;             %   Upper nodes
        t2(:, 3)        = e0(:, 2);                  %   Lower node
        ttemp           = [t1; t2];
        t               = [t; ttemp+NE*(m-1)];     
    end
    %%   Create wire mesh - WIRE MODEL - running array is "points" 
    for m = 1:Nodes
        arg(m, :)       = [1:wires]+(m-1)*wires;
        if m >1
            if m <Nodes
                UnitPathVector      = PathVector(m-1, :) + PathVector(m, :);
            else
                UnitPathVector      = PathVector(end, :);
            end           
            UnitPathVector  = UnitPathVector/norm(UnitPathVector);               
            points          = meshrotate1(BaseNodes, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3)); 
            points          = meshrotate2(points, UnitPathVector, angle(m));
            points          = points + repmat(Pcenter(m, :), NBA, 1);   %  put the mesh in the right position                              
            Ewire(arg(m-1, :), :)   = [arg(m-1, :); arg(m, :)]'; 
        end
        Pwire(arg(m, :), :)     = points;
    end

    %%   Add caps for a non-closed conductor
    if ~Closed  
        %   Add nodes/triangles for the start cap                
        UnitPathVector          = PathVector(1, :)/norm(PathVector(1, :));
        pstart                  = meshrotate1(P0, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3)); 
        pstart                  = pstart + repmat(Pcenter(1, :), size(P0, 1), 1);   %  put the mesh in the right position        
        tcapstart               = t0;                 
        NodesSides              = size(P, 1)-NE;
        for m = 1:size(tcapstart, 1)
            index               = find(tcapstart(m, :)>NE);
            for n = 1:size(index, 2)
                tcapstart(m, index(n)) = tcapstart(m, index(n)) + NodesSides;    
            end
        end
        P           = [P; pstart(NE+1:end, :)];
        t           = [tcapstart; t];  
        %   Add nodes/triangles for the end cap
        UnitPathVector          = PathVector(end, :)/norm(PathVector(end, :));
        pend                    = meshrotate1(P0, UnitPathVector(1), UnitPathVector(2), UnitPathVector(3));
        pend                    = meshrotate2(pend, UnitPathVector, angle(end));
        pend                    = pend + repmat(Pcenter(end, :), size(P0, 1), 1);   %  put the mesh in the right position
        tcapend                 = t0;
        NodesSides1             = size(P, 1)-NE-added;
        NodesSides2             = size(P, 1)-NE;
        for m = 1:size(tcapend, 1)
            index               = find(t0(m, :)<=NE);
            for n = 1:size(index, 2)
                tcapend(m, index(n)) = tcapend(m, index(n)) + NodesSides1;    
            end
            index               = find(t0(m, :)>NE);
            for n = 1:size(index, 2)
                tcapend(m, index(n)) = tcapend(m, index(n)) + NodesSides2;    
            end    
        end
        %   Renumerate the top (the rest is fine)        
        P        = [P; pend(NE+1:end, :)];
        t        = [t; tcapend];    
    end
    
    %%   Condition the final surface mesh
    [P, t]          = fixmesh(P, t);
    %   Find the normal vectors
    normals         = - meshnormals(P, t);
    %   Fix triangle orientation (just in case, optional)
    t               = meshreorient(P, t, normals);
    
    %%   Condition the final wire mesh
    strcoil.Pwire = Pwire; strcoil.Ewire = Ewire; strcoil.Swire = Swire;    
    %   Check surface/wire mesh quality
    edges                   = Pwire(Ewire(:, 1), :) - Pwire(Ewire(:, 2), :);
    AvgSegmentLength        = mean(sqrt(dot(edges, edges, 2)));   % average edge length        = mean(sqrt(dot(edges, edges, 2)));     % average edge length
    AvgSegmentSpacing       = mean(sqrt(areas));                    % average edge length
    check                   = AvgSegmentLength/AvgSegmentSpacing;   
end

