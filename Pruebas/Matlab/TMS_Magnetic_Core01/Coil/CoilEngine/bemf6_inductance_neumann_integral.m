function L = bemf6_inductance_neumann_integral(strcoil, mu0, prec)    
%   Computes Neumann integral - self inductance L - using FMM. Array
%   strcoil.Swire (a set of im) is by definition normalized in such a way
%   that the total coil curent is 1 A. Variable strcol.I0 is not used here.
%   Branches or forks of current are allowed (they should be accounted for
%   in the coil generator itself)
%
%   Copyright SNM 2020-2021

    %   Compute pseudo potentials             
    segvector   =     (strcoil.Pwire(strcoil.Ewire(:, 2), :) - strcoil.Pwire(strcoil.Ewire(:, 1), :)).*repmat(strcoil.Swire, 1, 3);
    segpoints   = 0.5*(strcoil.Pwire(strcoil.Ewire(:, 1), :) + strcoil.Pwire(strcoil.Ewire(:, 2), :));
    
    PseudoQx    = segvector(:, 1);
    PseudoQy    = segvector(:, 2);
    PseudoQz    = segvector(:, 3);        
    const       = mu0/(4*pi);  % normalization    
     
    %   FMM 2020
    srcinfo.nd      = 3;                            %   three charge vectors    
    srcinfo.sources = segpoints';                   %   source points   
    pg      = 1;                                    %   potential is evaluated at sources  
    srcinfo.charges(1, :)    = PseudoQx.';     %   charges
    srcinfo.charges(2, :)    = PseudoQy.';     %   charges
    srcinfo.charges(3, :)    = PseudoQz.';     %   charges
    U                        = lfmm3d(prec, srcinfo, pg);
    neumann(:, 1)               = const*U.pot(1, :)';
    neumann(:, 2)               = const*U.pot(2, :)';
    neumann(:, 3)               = const*U.pot(3, :)'; 
    L = sum(sum(neumann.*segvector, 2), 1);     
end
