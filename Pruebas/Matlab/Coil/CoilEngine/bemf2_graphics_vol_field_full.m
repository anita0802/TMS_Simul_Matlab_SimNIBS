function bemf2_graphics_vol_field_full(Field, Label, component, countXZ, EofXZ, PofXZ, strcoil, x, z, Y, xmin, xmax, zmin, zmax, th1, th2)
%   Volume field graphics:  plot a field quantity temp in the observation
%   plane using a planar contour plot.
%
%   temp - quantity to plot
%   Copyright SNM 2017-2020

    %%  Plot thefield in the cross-section
    string      = ['x' 'y' 'z' 't'];
    label       = string(component);
        
    figure;
    % Contour plot
    if component == 4
        temp      = abs(sqrt(dot(Field, Field, 2)));
    else
        temp      = abs(Field(:, component));
    end
    levels      = 25;
    bemf2_graphics_vol_field(temp, th1, th2, levels, x, z);

    xlabel('Distance x, mm');
    ylabel('Distance z, mm');
    title([Label, label, '-component in the XZ plane.']);

    % Core boundaries
    color   = prism(10); color(1, :) = [1 1 1]; color(4, :) = [0 1 1];
    for m = countXZ
        edges           = EofXZ{m};              %   this is for the contour
        points          = [];
        points(:, 1)    = +PofXZ{m}(:, 1);       %   this is for the contour  
        points(:, 2)    = +PofXZ{m}(:, 3);       %   this is for the contour
        patch('Faces', edges, 'Vertices', points, 'EdgeColor', color(m, :), 'LineWidth', 3.0);    %   this is contour plot
    end

    %   Additionally, plot coil cross-section
    [edges, TriP, TriM] = mt(strcoil.t);
    [Pi, ti, polymask, flag] = meshplaneintXZ(strcoil.P, strcoil.t, edges, TriP, TriM, Y);
    if flag % intersection found                
        for n = 1:size(polymask, 1)
            i1 = polymask(n, 1);
            i2 = polymask(n, 2);
            line(1e3*Pi([i1 i2], 1), 1e3*Pi([i1 i2], 3), 'Color', 'w', 'LineWidth', 2.0);
        end   
    end

    % General settings 
    axis 'equal';  axis 'tight';     
    colormap jet; colorbar;
    axis([xmin xmax zmin zmax]);
    line(mean([xmin xmax]), mean([zmin, zmax]), 'Marker', 'o', 'MarkerFaceColor', 'm', 'MarkerSize', 12); 
    grid off; set(gcf,'Color','White');

end