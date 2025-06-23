function TetField = tetfieldwithoutarea(GEOM, HpriS, cf, Center, Area, normals, EFX, EFY, EFZ, prec)
%   This script does the job
%
%   Copyright SNM 2021

%%   Find the H-field just inside or just outside any model surface
Hadd        = bemf4_surface_field_accurate(cf, Center, Area, EFX, EFY, EFZ, prec);

par = -1;    %      par=-1 -> H-field just inside surface; par=+1 -> E-field just outside surface     
Hplus =  HpriS+ Hadd + par/(2)*normals.*repmat(cf, 1, 3);    %   full field

par = +1;    %      par=-1 -> H-field just inside surface; par=+1 -> E-field just outside surface     
Hminus =  HpriS+ Hadd + par/(2)*normals.*repmat(cf, 1, 3);    %   full field

M = length(GEOM.ti);
TetField = zeros(length(GEOM.T), 3);
for m =1:M
    PlusNumber = GEOM.TetP(m);
    MinusNumber = GEOM.TetM(m);
    TetField(PlusNumber, :)  = TetField(PlusNumber, :) + Hplus(m, :);
    TetField(MinusNumber, :) = TetField(MinusNumber, :) + Hminus(m, :);
end
M = length(GEOM.t);
for m =1:M
    PlusNumber = GEOM.TetS(m);   
    TetField(PlusNumber, :)  = TetField(PlusNumber, :) + Hplus(m, :);
end
TetField = TetField/4;