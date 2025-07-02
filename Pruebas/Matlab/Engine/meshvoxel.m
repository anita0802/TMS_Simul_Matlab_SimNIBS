function [Voxel, Volume] = meshvoxel(P, t, normals, M) 
%   Create a uniform voxel grid within a shell with volume Volume per voxel

x               = linspace(min(P(:, 1)), max(P(:, 1)), M);
y               = linspace(min(P(:, 2)), max(P(:, 2)), M);
z               = linspace(min(P(:, 3)), max(P(:, 3)), M);

Voxel           = zeros(M^3, 3); 

k = 1;          %  count
for m = 1:M
    for n = 1:M
        for p = 1:M
            Voxel(k, :) = [x(m) y(n) z(p)];
            k = k + 1;
        end
    end
end

Center  = meshtricenter(P, t);
in      = assign_tissue_type_volume(Voxel, normals, Center, ones(size(t, 1), 1));
Voxel   = Voxel(in == 1, :);
Volume  = (x(2)-x(1))*(y(2)-y(1))*(z(2)-z(1));


