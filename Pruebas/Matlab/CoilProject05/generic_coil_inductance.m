%clear all; %#ok<CLALL>

% Ruta absoluta a CoilEngine
coilEngineDir = 'C:\Users\Patriciagh\Documents\TFM\Pruebas\Matlab\TMS_Magnetic_Core01\Coil\CoilEngine';

if ~isfolder(coilEngineDir)
    error('No existe la carpeta CoilEngine en:\n%s', coilEngineDir);
end

addpath( genpath(coilEngineDir) );

% Verificación
disp(['Directorio: ' coilEngineDir]);
disp(['meshwire en ruta: ' which('meshwire')]);

% Selecciono tipo de bobina y cargo parámetros del coil
%coil_type = 'bobinaL1';
%coil = getCoilType(coil_type);

t_fall = coil.t_fall;    % Tiempo de bajada (s) - Si la bobina “funciona en la bajada”, entonces 40 µs es el tiempo que tarda la corriente en caer de 0.5 A a 0 A

%% DEFINICIÓN DE LA SEÑAL DE EXCITACIÓN
% Selecciono señal de excitación y cargo parámetros
signal_type = 'cuadrada';
signal = getSignalExcitation(signal_type, t_fall);

I0 = signal.I0;          % Amperes, for magnetic field
f = signal.f;            % Frecuencia del pulso (Hz) - Sólo determina cada cuánto vuelve a repetirse esa bajada, pero no su pendiente
T = signal.T;            % Periodo (s)
dIdt = signal.dIdt;      % Amperes/sec, for electric field for 10 Hz
dIdt = abs(dIdt);        % Magnitud para escalar el campo inducido

%% GENERACIÓN DE LA GEOMETRÍA DE LA BOBINA Y MALLADO DEL ALAMBRE
%%  Parámetros de la primera hélice
turns       = coil.turns;                       %   number of turns 
N           = 600;                              %   subdivisions total (cuántos puntos discretos habrá en la hélice). A mayor N, más suave

% NO SE TOCAN
twist       = 0;                                %   twist per delta theta. Antes había pi/12 (rotación adicional)
theta0      = turns*2*pi;                       %   how many turns (one turn is 2*pi)

%%  Geometría de la primera hélice
wd      = coil.wd;                              %   conductor diameter in m 
radius1 = coil.radius1;                         %   helix radius, m checks
pitch1  = coil.pitch1;                          %   pitch amplitude (separación vertical entre vueltas)

%   Other parameters
M    = 16;              %   number of cross-section subdivisions 
flag = 1;               %   ellipsoidal cross-section    
sk   = 0;               %   surface current distribution (skin layer)

[P1, t1, strcoil1, check] = generateHelixMesh(turns, N, radius1, pitch1, wd, M, flag, sk, twist);

%%  Cálculo de inductancia
mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
prec                        = 1e-4;             % tolerancia numérica para la integral de Neumann
Inductance_wire_1           = bemf6_inductance_neumann_integral(strcoil1, mu0, prec); % En Henrios (H)

%%  Second helix with a larger radius
if coil.turns2 > 0
    turns2       = coil.turns2;
    N2           = 600;
    
    radius2 = coil.radius2;
    pitch2  = coil.pitch2;
     
    [P2, t2, strcoil2, check2] = generateHelixMesh(turns, N, radius2, pitch2, wd, M, flag, sk, twist);
    
    Inductance_wire_2          = bemf6_inductance_neumann_integral(strcoil2, mu0, prec);

    check = max(check, check2);
    %%   Rotate the second helix by 0 deg about the z-axis
    angle           = 0;
    P2              = meshrotate2(P2, [0 0 1], angle);
    strcoil2.Pwire  = meshrotate2(strcoil2.Pwire, [0 0 1], angle);
    
    %%   Construct the entire coil as a combination of the two helix parts
    t2          = t2+size(P1, 1);
    P           = [P1; P2];
    t           = [t1; t2];
    P(:, 2)     = P(:, 2) - min(P(:, 2));

    strcoil2.Ewire          = strcoil2.Ewire+size(strcoil1.Pwire, 1);
    strcoil.Pwire           = [strcoil1.Pwire; strcoil2.Pwire]; 
    strcoil.Ewire           = [strcoil1.Ewire; strcoil2.Ewire];
    strcoil.Swire           = [+strcoil1.Swire; strcoil2.Swire;]; %  do not swap current direction for the second part
    strcoil.Pwire(:, 2)     = strcoil.Pwire(:, 2) - min(strcoil.Pwire(:, 2));

else
    % Si no hay segunda hélice, usamos la primera como resultado final
    P           = P1;
    t           = t1;
    strcoil     = strcoil1;
end

%%   Inductance calculator
clear I;
mu0              = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
eps0             = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
prec             = 1e-4;
Inductance       = bemf6_inductance_neumann_integral(strcoil, mu0, prec);
if check > 3
    disp('Decrease the ratio AvgSegmentLength/AvgSegmentSpacing for the wire mesh. Inductance accuracy cannot be guaranteed.')
end

%% Guardado de resultados
strcoil.I0      = I0;       % Añade al struct strcoil los parámetros de corriente y la malla CAD
strcoil.dIdt    = dIdt;
strcoil.P       = P;
strcoil.t       = t;
save('coil', 'strcoil');    % Guarda todo en coil.mat, listo para cargarlo en otros scripts

%% %% %% %% %% %% %% %% %% %% %% %%
%% GENERACIÓN DE LA GEOMETRÍA DEL NÚCLEO
% Selecciono tipo de bobina y cargo parámetros del core
%core_type = 'bobinaL1';
%core = getCoreType(core_type);

%   The brick centerline is given first
par = linspace(0, 1, 600);
L   = core.L;                       %   cylinder height in m
x = L*par;                          %   segment
y = 0*par;                          %   segment

%   Other parameters
d    = core.d;      %   conductor diameter in m
M    = 32;          %   number of cross-section subdivisions 
flag = 1;           %   circular cross-section    

%   Create surface CAD model
Pcenter(:, 1) = x';
Pcenter(:, 2) = y';
Pcenter(:, 3) = 0;
[P, t, normals]     = meshsurface(Pcenter, d, d, M, flag, 0);  % CAD mesh
P                   = meshrotate2(P, [0 1 0], pi/2);
normals             = meshrotate2(normals, [0 1 0], pi/2);
P(:, 3)             = P(:, 3) - mean(P(:, 3));

%   Create volume CAD model (overwrite the previous surface CAD model)
%   Important: nodes of surface facets are automatically placed up front
grade = 1.0e-3;  %   mesh resolution in meters
[P, t, normals, T] = meshvolume(P, t, grade);

%   Create expanded volume SWG basis function CAD model (overwrite
%   the previous volume CAD model)
GEOM = meshvolumeswg(P, T); %   Creates structure GEOM with all necessary parameters

save('core.mat', 'GEOM');
%% Load core 
name{1}     = 'core.mat'; load(name{1}); 
P           = GEOM.P;
t           = [GEOM.t; GEOM.ti];
normals     = [GEOM.normals; GEOM.normalsi];
Indicator   = ones(size(t, 1), 1);
Area        = [GEOM.Area; GEOM.Areai];
Center      = [GEOM.Center; GEOM.Centeri];

%%  Fix triangle orientation (just in case, optional)
tic
t = meshreorient(P, t, normals);
ProcessingTime  = toc

%%   Add accurate integration for field/potential on neighbor facets
%   Indexes into neighbor triangles
RnumberE        = 32;    %   number of neighbor triangles for analytical integration (fixed, optimized)
numThreads      = 4;
parpool(numThreads);
ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';           %   do transpose  
[EC, PC, EFX, EFY, EFZ, PF] ...
                    = meshneighborints(P, t, normals, Area, Center, RnumberE, ineighborE);
ineighborE      = knnsearch(GEOM.Center, GEOM.Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';           %   do transpose  
[EC0, PC0, EFX0, EFY0, EFZ0, PF0] ...
                    = meshneighborints(P, GEOM.t, GEOM.normals, GEOM.Area, GEOM.Center, RnumberE, ineighborE);

%%   Add accurate integration for arbitrary observation points
MidP            = GEOM.CenterT;
ineighborE      = knnsearch(MidP, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';           %   do transpose 
[ESX, ESY, ESZ] = meshneighborintspoints(MidP, P, t, normals, Area, Center, RnumberE, ineighborE);
delete(gcp('nocreate'));

save ProcessedCore P t normals Indicator Area Center eps0 mu0 GEOM EC0 EFX0 EFY0 EFZ0 EC EFX EFY EFZ ESX ESY ESZ %Neighbors

%%  Load base coil data
if exist('strcoil', 'var')
    clear strcoil;
end
load coil.mat;       

%%  Load base core data
load ProcessedCore;

%%   Coil graphics
figure;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
view(10, 20);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);
camlight; lighting phong;

%%  General settings
axis 'equal';  axis 'tight';   
daspect([1 1 1]);
set(gcf,'Color','White');
axis off; view(10, 20);

%%  Parameters of the iterative solution
iter         = 16;              %    Maximum possible number of iterations in the solution 
relres       = 1e-12;           %    Minimum acceptable relative residual 
weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
prec         = 1e-4;            %    Precision   

%%  Independent variables
M   = size(GEOM.t, 1);          %   number of surface (boundary) facets
N   = size(GEOM.ti, 1);         %   number of surface (inner) facets or the number of SWGs 
NT  = size(GEOM.T, 1);          %   number of tetrahedra in the mesh
cf  = zeros(M+N, 1);            %   density of surface charges + coefficients of SWG bases

%%  Primary field (compute pointwise)
FpriP       = bemf3_inc_field_magnetic(strcoil, P, prec);                           %   Primary field anywhere at all nodes
FpriS       = 1/3*(FpriP(t(:, 1), :) + FpriP(t(:, 2), :) + FpriP(t(:, 3), :));      %   Pimary field at the centers of all facets

%%  Nonlinear GMRES surface/volume iterative solution (no cf0 correction here)
h               = waitbar(0.5, 'Please wait - Running GMRES'); 
NonlinearIters  = 50;
alpha           = 0.975;
clear           contrasterror;
clear           chargeerror;
Hpri            = bemf3_inc_field_magnetic(strcoil, GEOM.CenterT, prec);    %   Primary coil field at T centers
% Selecciono tipo de material y lo cargo
material_type = 'm3_atan';
mucore          = core00_Material(Hpri, material_type);                                    %   Initial mucore at all T centers
contrastS       = (mucore(GEOM.TetS) - 1)./(mucore(GEOM.TetS) + 1);                                         %   Local initial contrast for surface facets        
contrastV       = (mucore(GEOM.TetP) - mucore(GEOM.TetM))./(mucore(GEOM.TetP) + mucore(GEOM.TetM));         %   Local initial contrast for inner facets
contrast        = [contrastS; contrastV];                                                                   %   Local initial contrast for all facets
for m = 1:NonlinearIters    
    b                   = 2*(contrast.*sum(normals.*FpriS, 2));   
    MATVEC              = @(cf) bemf4_surface_field_lhs(cf, Center, Area, contrast, normals, weight, EC, prec);
    [cf, flag, rres, its, resvec] = gmres(MATVEC, b, [], relres, iter, [], [], b);         
    if m>1
        contrasterror(m-1)  = norm(contrastold - contrast)/norm(contrast);
        chargeerror(m-1)    = norm(cfold - cf)/norm(cf); 
        semilogy(contrasterror, '-*r'); hold on; semilogy(chargeerror, '-ob'); grid on; 
        title('Nonlinear iterations: rel. delta mur (red), rel. delta magn. charge (blue)'); xlabel('iteration number'); drawnow;
    end    
    contrastold      = contrast; 
    mucoreold        = mucore;
    cfold            = cf;
    %   Update mucore and assign new contrasts
    Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec); 
    HtotalF         = tetfieldwithoutarea(GEOM, FpriS, cf, Center, Area, normals, EFX, EFY, EFZ, prec);    
    Htotal          = alpha*Htotal+(1-alpha)*HtotalF;    
    mucore          = core00_Material(Htotal, material_type);    
    contrastS       = (mucore(GEOM.TetS) - 1)./(mucore(GEOM.TetS) + 1);                                         %   Local contrast for surface facets        
    contrastV       = (mucore(GEOM.TetP) - mucore(GEOM.TetM))./(mucore(GEOM.TetP) + mucore(GEOM.TetM));         %   Local contrast for inner facets
    contrast        = [contrastS; contrastV];
    if m>1&&chargeerror(end)<1e-3
        disp('Charge error is less than 0.1%');
        break;
   end 
end
close(h);

%%  Check charge conservation law (optional)
e.conservation_law_error = sum(cf.*Area)/sum(abs(cf).*Area);

%%  Check the residual of the integral equation (optional)
e.relative_residual = resvec(end);

%%  Check average mucore
e.MEANMUCORE = mean(mucore); e;

%%   Compute core elementary moments m (magnetization times volume) for every tetrahedron for A
Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec);
mucore          = core00_Material(Htotal, material_type);                                  %   Relative local mucore 
Magnetization   = (mucore - 1).*Htotal;                                     %   Magnetization per unit volume
Moments         = GEOM.VolumeT.*Magnetization;                              %   Total moments per every tetrahedron    
MomentsTime = toc;

%%  Inductance calculation
Inductance = struct();
Inductance.Lpri    = bemf6_inductance_neumann_integral(strcoil, mu0, prec);
Bpri               = mu0*bemf3_inc_field_magnetic(strcoil, GEOM.CenterT, prec);            %  Incident coil field
Esec               = 0.5*sum(dot(Moments, Bpri, 2));                                       % since volume is is already included in the Moments 
Inductance.Lsec    = 2*Esec/(strcoil.I0)^2;
Inductance.L       = Inductance.Lpri + Inductance.Lsec;
Inductance

%%  Update coil structure by appending magnetic core data and save in the main Coil folder
strcoil.CenterT  = GEOM.CenterT;
strcoil.Moments = Moments;
strcoil.CoreP   = P;
strcoil.Coret   = t;
save('coil', 'strcoil');

%% COMPROBACIÓN DE INDUCTANCIA
% Inductance_Expected = coil.L;
% tolerance = 3e-8;
% if abs(Inductance.L - Inductance_Expected) < tolerance
%     disp('La inductancia calculada SÍ coincide con la esperada.');
%     disp(['Valor calculado: ', num2str(Inductance.L), ' H']);
%     disp(['Valor esperado: ', num2str(Inductance_Expected), ' H']);
% else
%     disp('La inductancia calculada NO coincide con la esperada.');
%     disp(['Valor calculado: ', num2str(Inductance.L), ' H']);
%     disp(['Valor esperado: ', num2str(Inductance_Expected), ' H']);
% end