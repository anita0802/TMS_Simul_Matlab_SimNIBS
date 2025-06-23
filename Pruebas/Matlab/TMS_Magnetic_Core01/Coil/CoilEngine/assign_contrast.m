function [contrast, parin, parout] = assign_contrast(par, parambient, Indicator, enclosingObjectIdx)
%   This function assigns material parameters
%   par: Interior patameter 
%   parambient: Parameter of the medium exterior to the outermost object
%   Indicator: for each facet, stores the identifier of the object to which that facet belongs
%   enclosingObjectIdx: for each object, stores the identifier of that object's assumed exterior object

%   Copyright WAW/SNM 2020

    parout = zeros(1, length(par));
    parin = zeros(1, length(par));
    Contrast = zeros(1, length(par));
    %For each Object, assign the default par inside and outside
    for j=1:length(par)
        if(enclosingObjectIdx(j) == 0)
            parout(j) = parambient;
        else
            parout(j) = par(enclosingObjectIdx(j));
        end

        parin(j) = par(j);
        Contrast(j) = (parin(j) - parout(j))/(parin(j) + parout(j));
    end
    Contrast(isnan(Contrast)) = 0; %Air/Air boundaries produce NaNs

    %   Define array of contrasts for every triangular facet 
    contrast = zeros(size(Indicator, 1), 1);
    parin   = zeros(size(Indicator, 1), 1);
    parout  = zeros(size(Indicator, 1), 1);

    for m = 1:length(Contrast)
        contrast(Indicator==m)  = Contrast(m);
        parin(Indicator==m)    = parin(m);
        parout(Indicator==m)   = parout(m);
    end
end