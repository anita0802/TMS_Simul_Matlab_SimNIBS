function [pnext, angle] = meshrotate3(pprev, pnext, UnitPathVector, angleold)
%   Anti-twist: aligns two subsequent cross-sections by rotating the new
%   one
%   angle is the resulting rotation angle
%
%   Copyright SNM 2021
    N           = 1001; %    the larger the better
    theta       = linspace(angleold-pi/6, angleold+pi/6, N); 
    distance    = zeros(N, 1);
    for n = 1:N
        temp                = meshrotate2(pnext, UnitPathVector, theta(n));
        temp                = pprev-temp;
        distance(n)         = mean(sum(temp.*temp, 2));                 
    end
    [~, index]  = min(distance);    
    angle       = theta(index);
    pnext       = meshrotate2(pnext, UnitPathVector, angle); 

end