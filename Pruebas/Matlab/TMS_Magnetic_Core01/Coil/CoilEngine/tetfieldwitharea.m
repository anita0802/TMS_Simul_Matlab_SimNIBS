function TetField = tetfieldwitharea(GEOM, HpriS, cf, Center, Area, EFX, EFY, EFZ, prec)
%   This script does the job
%
%   Copyright SNM 2021

%%   Find the H-field just inside or just outside any model surface
Hadd        = bemf4_surface_field_accurate(cf, Center, Area, EFX, EFY, EFZ, prec);

par = -1;    %      par=-1 -> H-field just inside surface; par=+1 -> E-field just outside surface     
Hplus =  HpriS+ Hadd + par/(2)*normals.*repmat(cf, 1, 3);    %   full field
Hplus = Hplus.*repmat(Area, 1, 3);

par = +1;    %      par=-1 -> H-field just inside surface; par=+1 -> E-field just outside surface     
Hminus =  HpriS+ Hadd + par/(2)*normals.*repmat(cf, 1, 3);    %   full field
Hminus = Hminus.*repmat(Area, 1, 3);

M = length(GEOM.ti);
TetField = zeros(length(GEOM.T), 3);
AreaSum  = zeros(length(GEOM.T), 1);
for m =1:M
    PlusNumber = GEOM.TetP(m);
    MinusNumber = GEOM.TetM(m);
    TetField(PlusNumber, :)  = TetField(PlusNumber, :) + Hplus(m, :);
    TetField(MinusNumber, :) = TetField(MinusNumber, :) + Hminus(m, :);
    AreaSum(PlusNumber)   = AreaSum(PlusNumber) + Area(m);
    AreaSum(MinusNumber)  = AreaSum(MinusNumber) + Area(m);
end
M = length(GEOM.t);
for m =1:M
    PlusNumber = GEOM.TetS(m);   
    TetField(PlusNumber, :)  = TetField(PlusNumber, :) + Hplus(m, :);
    AreaSum(PlusNumber)   = AreaSum(PlusNumber) + Area(m);
end
TetField = TetField./repmat(AreaSum, 1, 3);