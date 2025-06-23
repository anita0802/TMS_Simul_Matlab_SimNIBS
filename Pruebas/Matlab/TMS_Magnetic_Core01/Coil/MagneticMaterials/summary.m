%%  Comparative performance of three materials

%%  Metglas
mu0         = 1.25663706e-006;              %   Magnetic permeability of vacuum(~air)
figure;
h    = [1.000 10.00  100.0 1000.0 10000 1.0e5];
mur  = [1.2e4 1.05e4 4.0e3 1.0e3 1.1e2  13.00];
loglog(h, mur, '-*r'); grid on; hold on;
h    = logspace(0, 8, 1000)';
mucoreMET = core00_material_met_froe(h);
loglog(h, mucoreMET, '-b'); 
title('Anhysteretic (absolute) relative permeability as function of field stength at <5 kHz - Metglas')

dmudh       = 1e6*mu0*diff(mucoreMET)./diff(h);
MAXMetGlas = max(abs(dmudh))                %   in mucroHenry per Ampere


%%  M3 steel atan
%   Plots
figure
h       = [1 6  12  25   55.4  57.5  60.7  63.6  97.3  273 1e3  1e4       1e5   1e6  1e7  1e8];
mur     = [7284 7284 7284 7284 7284 9844 13400  15400 12300 4998 1620 200 18    3    1.25   1];
h0      = [55.4  57.5  60.7  63.6  97.3  273];
mur0    = [7284 9844 13400  15400 12300 4998];
loglog(h, mur, '-*r'); grid on; hold on;
loglog(h0, mur0, '-dr', 'LineWidth', 2);
h       = logspace(0, 8, 1000)';
mucoreM3 = core00_material_m3_atan(h);
loglog(h, mucoreM3, '-b', 'LineWidth', 1.5);
title({'Anhysteretic relative permeability as function of field stength at 2 kHz - M3';...
      'thick red: relative premeability from datasheet obtained as bmax./hmax/mu0';...
      'thin red curve: an attempt to extrapolate data';...
      'blue - inverse tangent approximation b = 1.5*atan(h/1e2) + mu0*h'});

dmudh       = 1e6*mu0*diff(mucoreM3)./diff(h);
MAXM3 = max(abs(dmudh))                %   in mucroHenry per Ampere

%%  M3 steel froe
%   Plots
figure
h       = [1 6  12  25   55.4  57.5  60.7  63.6  97.3  273 1e3  1e4       1e5   1e6  1e7  1e8];
mur     = [7284 7284 7284 7284 7284 9844 13400  15400 12300 4998 1620 200 18    3    1.25   1];
h0      = [55.4  57.5  60.7  63.6  97.3  273];
mur0    = [7284 9844 13400  15400 12300 4998];
loglog(h, mur, '-*r'); grid on; hold on;
loglog(h0, mur0, '-dr', 'LineWidth', 2);
h       = logspace(0, 8, 1000)';
mucoreM3 = core00_material_m3_froe(h);
loglog(h, mucoreM3, '-b', 'LineWidth', 1.5);
title({'Anhysteretic relative permeability as function of field stength at 2 kHz - M3 _Froelich';...
      'thick red: relative premeability from datasheet obtained as bmax./hmax/mu0';...
      'thin red curve: an attempt to extrapolate data';...
      'blue - Froelich'});
  
dmudh       = 1e6*mu0*diff(mucoreM3)./diff(h);
MAXM3 = max(abs(dmudh))                %   in mucroHenry per Ampere

% %%  M3 steel corrected (Martin)
% mu0     = 1.25663706e-006;              %   Magnetic permeability of vacuum(~air)
% hmax    = [55.4   57.5  60.7  63.6  97.3  273];
% bmax    = [0.502 0.703  1.01  1.21  1.50  1.70];
% mur     = bmax./hmax/mu0;
% loglog(hmax, mur, '-*b'); grid on;
% mur     = [7211   9729  13241  15140  12268  4955];
% %   Checks!!

%%  Generic and all together
figure
h           = logspace(0, 8, 1000)';
mucoreG      = core00_material_gen_atan(h);
loglog(h, mucoreG, '-r'); hold on;
loglog(h, mucoreM3, '-g'); hold on;
loglog(h, mucoreMET, '-b'); hold on;
title('Anhysteretic (absolute) relative permeability as function of field stength - Generic')

dmudh       = 1e6*mu0*diff(mucoreG)./diff(h);
MAXGeneric = max(abs(dmudh))                %   in mucroHenry per Ampere

