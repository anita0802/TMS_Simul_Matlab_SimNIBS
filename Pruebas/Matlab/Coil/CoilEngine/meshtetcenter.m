function C = meshtetcenter(P, T) 
%   SYNTAX
%   C = meshtricenter(P, t) 
%   DESCRIPTION
%   This function returns tet centers (a Nx3 array)
    C   = 1/4*(P(T(:, 1), :) + P(T(:, 2), :) + P(T(:, 3), :) + P(T(:, 4), :));
end
   
    
