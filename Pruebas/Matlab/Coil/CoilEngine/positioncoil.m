function [strcoil, handle] = positioncoil(strcoil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ)
    %%   Define coil position: rotate and then tilt and move the entire coil as appropriate
    
    %   Step 1 Rotate the coil about its axis as required (pi/2 - anterior; 0 - posterior)
    coilaxis        = [0 0 1];
    strcoil.Pwire   = meshrotate2(strcoil.Pwire, coilaxis, theta);
    strcoil.P       = meshrotate2(strcoil.P, coilaxis, theta);
    strcoil.CoreP   = meshrotate2(strcoil.CoreP, coilaxis, theta);

    %   Step 2 Tilt the coil axis with direction vector Nx, Ny, Nz as required
    strcoil.Pwire   = meshrotate1(strcoil.Pwire, Nx, Ny, Nz);
    strcoil.P       = meshrotate1(strcoil.P, Nx, Ny, Nz);
    strcoil.CoreP   = meshrotate1(strcoil.CoreP, Nx, Ny, Nz);


    %   Step 3 Move the coil as required
    strcoil.Pwire(:, 1)   = strcoil.Pwire(:, 1) + MoveX;
    strcoil.Pwire(:, 2)   = strcoil.Pwire(:, 2) + MoveY;
    strcoil.Pwire(:, 3)   = strcoil.Pwire(:, 3) + MoveZ;

    strcoil.P(:, 1)   = strcoil.P(:, 1) + MoveX;
    strcoil.P(:, 2)   = strcoil.P(:, 2) + MoveY;
    strcoil.P(:, 3)   = strcoil.P(:, 3) + MoveZ;
    
    strcoil.CoreP(:, 1)   = strcoil.CoreP(:, 1) + MoveX;
    strcoil.CoreP(:, 2)   = strcoil.CoreP(:, 2) + MoveY;
    strcoil.CoreP(:, 3)   = strcoil.CoreP(:, 3) + MoveZ;
    
    handle          = [1 0 0];
    coilaxis        = [0 0 1];
    handle          = meshrotate2(handle, coilaxis, theta);
    handle          = meshrotate1(handle, Nx, Ny, Nz);
    handle          = handle/norm(handle);
end

