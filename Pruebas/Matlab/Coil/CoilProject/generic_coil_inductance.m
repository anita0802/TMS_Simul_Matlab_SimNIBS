% Ruta absoluta a CoilEngine
coilEngineDir = 'C:\Users\Patriciagh\Documents\TFM\Pruebas\Matlab\Coil\CoilEngine';

if ~isfolder(coilEngineDir)
    error('No existe la carpeta CoilEngine en:\n%s', coilEngineDir);
end

addpath( genpath(coilEngineDir) );

%% DEFINICIÓN DE LA SEÑAL DE EXCITACIÓN
% Selecciono señal de excitación y cargo parámetros
signal_type = 'cuadrada';
%t_fall = coil.t_fall;    % Tiempo de bajada (s) - Si la bobina “funciona en la bajada”, entonces 40 µs es el tiempo que tarda la corriente en caer de 0.5 A a 0 A
signal = getSignalExcitation(signal_type, coil.t_fall);

I0 = signal.I0;          % Amperes, for magnetic field
f = signal.f;            % Frecuencia del pulso (Hz) - Sólo determina cada cuánto vuelve a repetirse esa bajada, pero no su pendiente
T = signal.T;            % Periodo (s)
dIdt = abs(signal.dIdt);    % Amperes/sec, for electric field for 10 Hz

%% GENERACIÓN DE LA GEOMETRÍA DE LA BOBINA Y MALLADO DEL ALAMBRE
%%  Parámetros de la primera hélice
turns1       = coil.turns1;                     %   number of turns 
N           = 1000;                             %   subdivisions total (cuántos puntos discretos habrá en la hélice). A mayor N, más suave
twist       = 0;                                %   twist per delta theta. Antes había pi/12 (rotación adicional)

%%  Geometría de la primera hélice
wd      = coil.wd;                              %   conductor diameter in m 
radius1 = coil.radius1;                         %   helix radius, m checks
pitch1  = coil.pitch1;                          %   pitch amplitude (separación vertical entre vueltas)

% generate helix mesh
theta0 = turns1*2*pi;               %   how many turns (one turn is 2*pi)
theta  = linspace(0, theta0, N);    % Ángulo en radianes
delta  = theta(2) - theta(1);       % Paso angular

x = radius1 * cos(theta);    % 1xN
y = radius1 * sin(theta);
z = zeros(N,1);              % Nx1
stepZ = pitch1 * delta / pi;

for m = 2:N
    z(m) = z(m-1) + 0.5 * (1 - sign(sin(theta(m)))) * stepZ;
end

% Suavizado de la trayectoria
z = smooth(z);                % Nx1

%   Centerline
Pcenter1 = [x', y', z - 0.0009];  % Nx3

% Other parameters
M    = 16;
flag = 1;
sk   = 0;

% Crear la malla de la bobina
[strcoil1, check1] = meshwire(Pcenter1, wd, wd, M, flag, sk, twist);
[P1, t1]           = meshsurface(Pcenter1, wd, wd, M, flag, twist);

%%  Cálculo de inductancia
mu0 = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
prec = 1e-4;             % tolerancia numérica para la integral de Neumann
Inductance_wire_1 = bemf6_inductance_neumann_integral(strcoil1, mu0, prec) % En Henrios (H)

%% === Creación y centrado de hélice 2 - interna (si existe) ===
if coil.turns2 > 0
    turns2 = coil.turns2;
    radius2= coil.radius2;
    pitch2 = coil.pitch2;

    % Generate helix mesh
    theta0 = turns2*2*pi;
    theta  = linspace(0, theta0, N);
    delta  = theta(2) - theta(1);

    x2 = radius2 * cos(theta);
    y2 = radius2 * sin(theta);
    z2 = zeros(N,1);
    stepZ2 = pitch2 * delta / pi;

    for m = 2:N
        z2(m) = z2(m-1) + 0.5 * (1 - sign(sin(theta(m)))) * stepZ2;
    end

    z2 = smooth(z2);

    % Centerline
    Pcenter2 = [x2', y2', z2 - 0.0009];

    % Crear la malla de la bobina
    [strcoil2, check2] = meshwire(Pcenter2, wd, wd, M, flag, sk, twist);
    [P2, t2]          = meshsurface(Pcenter2, wd, wd, M, flag, twist);

    % Cálculo de la inductancia
    Inductance_wire_2 = bemf6_inductance_neumann_integral(strcoil2, mu0, prec);
    %figure; bemf1_graphics_coil_CAD(P2,t2,0); view(0,0); camlight; lighting phong; axis off;

    % Unir y centrar ambas hélices
    %%   Construct the entire coil as a combination of the two helix parts
    t2 = t2 + size(P1,1);
    P  = [P1; P2];
    t  = [t1; t2];

    % Unir y centrar ambas hélices
    centerY = mean([min(P(:,2)), max(P(:,2))]);
    P(:,2)  = P(:,2) - centerY;

    % Combinar malla de cable y centrar
    strcoil2.Ewire = strcoil2.Ewire + size(strcoil1.Pwire,1);
    strcoil.Pwire  = [strcoil1.Pwire; strcoil2.Pwire];
    strcoil.Ewire  = [strcoil1.Ewire; strcoil2.Ewire];
    strcoil.Swire  = [strcoil1.Swire; strcoil2.Swire];
    wireY = strcoil.Pwire(:,2);
    wireCtr = mean([min(wireY), max(wireY)]);
    strcoil.Pwire(:,2) = wireY - wireCtr;
else
    % Si no hay segunda hélice, usamos la primera como resultado final
    P       = P1;
    t       = t1;
    strcoil = strcoil1;
end

coilZ    = [min(P(:,3)), max(P(:,3))];   % límites Z de la bobina
coilMinZ = coilZ(1);        % guarda este valores para usarlos en la generación del core

%%   Inductance calculator
clear I;
Inductance       = bemf6_inductance_neumann_integral(strcoil, mu0, prec);

% if check > 3
%     disp('Decrease the ratio AvgSegmentLength/AvgSegmentSpacing for the wire mesh. Inductance accuracy cannot be guaranteed.')
% end

%% Guardado de resultados
strcoil.I0      = I0;       % Añade al struct strcoil los parámetros de corriente y la malla CAD
strcoil.dIdt    = dIdt;
strcoil.P       = P;
strcoil.t       = t;
save('coil', 'strcoil');    % Guarda todo en coil.mat, listo para cargarlo en otros scripts

%% %% %% %% %% %% %% %% %% %% %% %%
%% GENERACIÓN DE LA GEOMETRÍA DEL NÚCLEO
%% === Generación y centrado automático del núcleo ===
par = linspace(0,1,100);
L   = core.L;
x   = L * par;

%   Create surface CAD model
Pcenter = [x', zeros(length(x),1), zeros(length(x),1)];

[Pc, tc, normals] = meshsurface(Pcenter, core.wd, core.wd, 32, 1, 0);
Pc = meshrotate2(Pc, [0 1 0], pi/2);
normals = meshrotate2(normals, [0 1 0], pi/2);
Pc(:,3) = Pc(:,3) - mean(Pc(:,3));

% calcular límites Z del core
coreZ   = [min(Pc(:,3)), max(Pc(:,3))];

% Alineación por la base (mínimos)
offsetZ= coilMinZ - coreZ(1);

% aplicar desplazamiento automático
Pc(:,3)= Pc(:,3) + offsetZ;

%   Create volume CAD model (overwrite the previous surface CAD model)
%   Important: nodes of surface facets are automatically placed up front
% Intentamos primero con grade = 1e-3, y si falla, usamos 1e-4

% grade  = 1e-4;  %   mesh resolution in meters
% [Pv, tv, normalsV, T] = meshvolume(Pc, tc, grade);
% Intentamos primero con grade = 1e-3, y si falla, usamos 1e-4
grades = [1e-3, 1e-4, 1e-5];
success = false;
for g = grades
    try
        grade = g;
        [Pv, tv, normalsV, T] = meshvolume(Pc, tc, grade);
        success = true;
        fprintf('meshvolume OK con grade = %.0e\n', grade);
        break
    catch ME
        warning('meshvolume falló con grade=%.0e: %s', g, ME.message);
    end
end

if ~success
    warning('meshvolume falló para todos los valores de grade posibles.');
end

%   Create expanded volume SWG basis function CAD model (overwrite
%   the previous volume CAD model)
GEOM = meshvolumeswg(Pv, T); %   Creates structure GEOM with all necessary parameters

%figure; bemf1_graphics_coil_CAD(GEOM.P, GEOM.t, 1); camlight; lighting phong; view(-140,40); axis off;

save('core.mat','GEOM');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Define EM constants
eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
mu0         = 31.82776031e-006;  %   Magnetic permeability of vacuum(~air) 1.25663706e-006

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

% parpool(numThreads);
% Intentar arrancar pool paralelo; si falla, seguimos en secuencial
try
    % Solo creamos uno nuevo si no hay un pool ya abierto
    p = gcp('nocreate');
    if isempty(p)
        % Usa el perfil local por defecto o especifica 'Processes'
        parpool('local', numThreads);
    elseif p.NumWorkers ~= numThreads
        delete(p);
        parpool('local', numThreads);
    end
catch ME
    warning('No se pudo iniciar parpool con %d workers: %s\nContinuando en modo secuencial.', ...
            numThreads, ME.message);
end

% --- superficie exterior ---
nCenters = size(Center, 1);
kE = min(RnumberE, nCenters);
if kE < RnumberE
    warning('Solo hay %d centros de superficie; reduciendo vecinos a %d.', nCenters, kE);
end
ineighborE = knnsearch(Center, Center, 'k', kE)';   
[EC, PC, EFX, EFY, EFZ, PF] = meshneighborints(P, t, normals, Area, Center, kE, ineighborE);

% --- superficie interna (GEOM.Center) ---
nTetCenters = size(GEOM.Center, 1);
kE0 = min(RnumberE, nTetCenters);
if kE0 < RnumberE
    warning('Solo hay %d centros de tetraedros; reduciendo vecinos a %d.', nTetCenters, kE0);
end
ineighborE = knnsearch(GEOM.Center, GEOM.Center, 'k', kE0)';   
[EC0, PC0, EFX0, EFY0, EFZ0, PF0] = meshneighborints(P, GEOM.t, GEOM.normals, GEOM.Area, GEOM.Center, kE0, ineighborE);

%   Add accurate integration for arbitrary observation points
% --- observación en puntos T (MidP) ---
MidP = GEOM.CenterT;
nMidP = size(MidP, 1);
kT = min(RnumberE, nMidP);
if kT < RnumberE
    warning('Solo hay %d puntos T; reduciendo vecinos a %d.', nMidP, kT);
end
ineighborE = knnsearch(MidP, Center, 'k', kT)';   
[ESX, ESY, ESZ] = meshneighborintspoints(MidP, P, t, normals, Area, Center, kT, ineighborE);

delete(gcp('nocreate'));

save ProcessedCore P t normals Indicator Area Center eps0 mu0 GEOM EC0 EFX0 EFY0 EFZ0 EC EFX EFY EFZ ESX ESY ESZ %Neighbors

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
material_type = 'm3_froe';
mucore          = getMaterial(Hpri, material_type);                                    %   Initial mucore at all T centers
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
        %semilogy(contrasterror, '-*r'); hold on; semilogy(chargeerror, '-ob'); grid on; 
        %title('Nonlinear iterations: rel. delta mur (red), rel. delta magn. charge (blue)'); xlabel('iteration number'); % drawnow;
    end    
    contrastold      = contrast; 
    mucoreold        = mucore;
    cfold            = cf;
    %   Update mucore and assign new contrasts
    Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec); 
    HtotalF         = tetfieldwithoutarea(GEOM, FpriS, cf, Center, Area, normals, EFX, EFY, EFZ, prec);    
    Htotal          = alpha*Htotal+(1-alpha)*HtotalF;    
    mucore          = getMaterial(Htotal, material_type);    
    contrastS       = (mucore(GEOM.TetS) - 1)./(mucore(GEOM.TetS) + 1);                                         %   Local contrast for surface facets        
    contrastV       = (mucore(GEOM.TetP) - mucore(GEOM.TetM))./(mucore(GEOM.TetP) + mucore(GEOM.TetM));         %   Local contrast for inner facets
    contrast        = [contrastS; contrastV];
    if m>1&&chargeerror(end)<1e-3
        disp('Charge error is less than 0.1%');
        break;
   end 
end
close(h);

% %%   Coil graphics
% figure;
% bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
% view(10, 20);
% 
% %%  Core graphics
% str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
% bemf2_graphics_base(P, GEOM.t, str);
% camlight; lighting phong;
% 
% %%  General settings
% axis 'equal';  axis 'tight';   
% daspect([1 1 1]);
% set(gcf,'Color','White');
% axis off; view(10, 20);

%%  Check charge conservation law (optional)
e.conservation_law_error = sum(cf.*Area)/sum(abs(cf).*Area);

%%  Check the residual of the integral equation (optional)
e.relative_residual = resvec(end);

%%  Check average mucore
e.MEANMUCORE = mean(mucore); e;

%%   Compute core elementary moments m (magnetization times volume) for every tetrahedron for A
Htotal          = Hpri + bemf5_volume_field_sv(GEOM.CenterT, cf, P, t, Center, Area, ESX, ESY, ESZ, prec);
mucore          = getMaterial(Htotal, material_type);                                  %   Relative local mucore 
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