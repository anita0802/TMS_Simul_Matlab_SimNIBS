function [Nx, Ny, Nz, MoveX, MoveY, MoveZ] = positionsulcus(strcoil, Target, theta, mindist, center)
%   Sulcus aligned coil positioning
    face                = knnsearch(center, Target, 'k', 1);
    Targets             = center(face, :);
    dir                 = (Targets - Target)/norm(Targets - Target);
    temp                = dir/dir(3);               %   normalization, Nz will always be 1
    Nx                  = temp(1);
    Ny                  = temp(2);
    Nz                  = temp(3);  
    %   assure minimum distance from coil to skin 
    N                   = 40;
    dist                = linspace(mindist/2, 3*mindist, N);
    for m = 1:N
        MoveX               = Targets(1) + dist(m)*dir(1);      %   away from skin
        MoveY               = Targets(2) + dist(m)*dir(2);      %   away from skin
        MoveZ               = Targets(3) + dist(m)*dir(3);      %   away from skin
        [strcoil1, ~] = positioncoil(strcoil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ);        
        [~, DIST]  = knnsearch(center, strcoil1.P, 'k', 1);
         MinCoilToSkin = min(DIST);
         if (MinCoilToSkin > mindist)
             break
         end
    end   
    
end