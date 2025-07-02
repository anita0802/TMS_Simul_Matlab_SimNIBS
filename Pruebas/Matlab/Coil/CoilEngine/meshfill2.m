function [P, t, nodesadded] = meshfill2(p, e)
    %   Creates an inner mesh dt for an arbitrarily oriented planar polygon
    %   Inputs:
    %   p       - polygon in 3D, [:,3]
    %   e       - polygon connectivity     
    %   Outputs:
    %   dt          - output mesh
    %   nodesadded  - number of added nodes
    %   Copyright SNM 2018-2021
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Obtain equation of the plane: ax+by+cz = d
    %   Obtain the normal vector
    center      = mean(p, 1);
    vector1     = p(e(1, 1), :) - center;
    vector2     = p(e(1, 2), :) - center;
    normal      = cross(vector1, vector2);   
    normal      = normal/norm(normal);
    a = normal(1); b = normal(2); c = normal(3); d = dot(normal, p(1, :));
    %   Indentify the best base plane for the projection and then project
    [dummy, index]      = max(abs(normal));
    if index ==1  projection = [2 3]; end;    %   to do 2D Delaunay
    if index ==2  projection = [1 3]; end;    %   to do 2D Delaunay
    if index ==3  projection = [1 2]; end;    %   to do 2D Delaunay
    pp = p(:, projection);   
    %   Create filling grid in the projection plane (called xy)
    temp            = pp(e(:, 1), :) - pp(e(:, 2), :);
    AvgEdgeLength   = mean(sqrt(dot(temp, temp, 2)));
    AvgEdgeLength   = AvgEdgeLength/2;          %   refine a bit
    x               = [min(pp(:, 1)):AvgEdgeLength:max(pp(:, 1))];
    y               = [min(pp(:, 2)):AvgEdgeLength:max(pp(:, 2))];    
    k = 1;
    for m = 1:length(x)
        for n = 1:length(y)
            Pfill(k, :)= [x(m) y(n)];
            k = k + 1;
        end
    end
    %   Keep grid nodes within the polygon only
    in      = inpolygon(Pfill(:, 1), Pfill(:, 2), pp(:, 1), pp(:, 2));
    Pfill(~in, :) = [];
    %   Eliminate nodes that are close to the boundary
    temp1    = 0.5*(pp(e(:, 1), :) + pp(e(:, 2), :));     %   edge centers
    temp2    = pp;                                       %   boundary nodes
    remove = [];
    for m = 1:size(Pfill, 1)
        dist1 = temp1 - repmat(Pfill(m, :), size(temp1, 1), 1);
        dist1 = sqrt(dot(dist1, dist1, 2));
        dist2 = temp2 - repmat(Pfill(m, :), size(temp2, 1), 1);
        dist2 = sqrt(dot(dist2, dist2, 2));
        if min(dist1)<AvgEdgeLength/2 | min(dist2)<AvgEdgeLength/2
            remove = [remove m];
        end
    end
    Pfill(remove, :) = [];
    %   Construct the full set of nodes in the "xy" plane
    P2           = [pp; Pfill];
    nodesadded  = size(Pfill, 1);   
    %   Apply Delaunay triangulation
    dt          = delaunayTriangulation(P2);  %   2D Delaunay
    t           = dt.ConnectivityList;
    %   Add third coordinate (project back)
    if index ==1  
       P(:, 2) = P2(:, 1);
       P(:, 3) = P2(:, 2);
       P(:, 1) =(d - b*P(:, 2) - c*P(:, 3))/a;
    end
    if index ==2          
       P(:, 1) = P2(:, 1);
       P(:, 3) = P2(:, 2);
       P(:, 2) =(d - a*P(:, 1) - c*P(:, 3))/b;
    end
    if index ==3  
       P(:, 1) = P2(:, 1);
       P(:, 2) = P2(:, 2);
       P(:, 3) =(d - a*P(:, 1) - b*P(:, 2))/c;
    end   
end
    