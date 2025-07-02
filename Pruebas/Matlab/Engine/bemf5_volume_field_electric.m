function E = bemf5_volume_field_electric(Points, c, P, t, Center, Area, normals, R, prec)
%   Computes electric field for an array Points anywhere in space (line,
%   surface, volume). This field is due to surface charges at triangular
%   facets only. Includes accurate neighbor triangle integrals for
%   points located close to a charged surface.   
%   R is the dimensionless radius of the precise-integration sphere
%
%   Copyright SNM 2017-2020
%   R = is the local radius of precise integration in terms of average triangle size
    
    %   FMM 2019
    srcinfo.sources = Center';                      %   source points
    targ            = Points';                      %   target points    
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 2;                                    %   field and potential are evaluated at target points
    srcinfo.charges = c.'.*Area';                   %   charges
    U               = lfmm3d(prec, srcinfo, pg, targ, pgt);
    E               = -U.gradtarg'/(4*pi);  
    
    %   Undo the effect of the m-th triangle charge on neighbors and
    %   add precise integration instead  
    %   Contribution of the charge of triangle m to the field at all points is sought        
    M = size(Center, 1);      
    const = 4*pi;    
    Size  = mean(sqrt(Area));
    ineighborlocal   = rangesearch(Points, Center, R*Size, 'NSMethod', 'kdtree'); % over triangles: M by X  
    for m =1:M
        index       = ineighborlocal{m};  % index into points that are close to triangle m   
        if ~isempty(index)
            temp        = repmat(Center(m, :), length(index), 1) - Points(index, :);   %   these are distances to the observation points
            DIST        = sqrt(dot(temp, temp, 2));                                    %   single column                
            I           = Area(m)*temp./repmat(DIST.^3, 1, 3);                         %   center-point integral, standard format    
            E(index, :) = E(index, :) - (- c(m)*I/const);         
            r1      = P(t(m, 1), :);    %   row
            r2      = P(t(m, 2), :);    %   row
            r3      = P(t(m, 3), :);    %   row           
            I       = potint2(r1, r2, r3, normals(m, :), Points(index, :));     %   analytical precise integration MATLAB
            E(index, :)= E(index, :) + (- c(m)*I/const);
        end    
    end                        
end