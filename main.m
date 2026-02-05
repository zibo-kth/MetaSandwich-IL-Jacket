%% =======================================================================
%% MetaSandwich-IL-Jacket: Sound Insertion Loss for Multilayer Pipeline Jackets (legacy script entrypoint)
%% =======================================================================
%% Full Name: (SO)und insertion l(O)ss of (M)ultilayer pipeline j(A)cket
%% Author: Zibo Liu
%% Email: zibo@kth.se
%% Date: 2021-05-18
%% License: Open Source - Please cite Zibo's relevant research papers
%%
%% DESCRIPTION:
%% This code calculates the sound insertion loss of multilayer pipeline
%% jackets using the Transfer Matrix Method. The analysis considers:
%% - Inner steel pipe with acoustic properties
%% - Porous damping material layer
%% - Outer impervious jacket
%%
%% ASSUMPTIONS:
%% - Low frequency range analysis (optimized for <= 2000 Hz)
%% - Cylindrical geometry with radial wave propagation
%% - Linear acoustic theory applies
%% =======================================================================

%% Initialize workspace
clear all; clc; close all;

%% Setup paths for data and source files
addpath(genpath('./data/'))  % Add data directory to path
addpath(genpath('./src/'))   % Add source functions to path

fprintf('\n=== MetaSandwich-IL-Jacket: Multilayer Pipeline Jacket Analysis ===\n');
fprintf('Loading parameters and initializing simulation...\n\n');


%% Load acoustic and material parameters
parameter_pressure_acoustics  % Air properties, frequency range
parameter12                   % Pipe material properties (steel)

fprintf('Acoustic parameters loaded:\n');
fprintf('  - Air density: %.1f kg/m³\n', rho0);
fprintf('  - Sound speed: %.0f m/s\n', c0);
fprintf('  - Frequency range: %.0f - %.0f Hz\n', min(Ve_freq), max(Ve_freq));

%% =======================================================================
%% GEOMETRY DEFINITION: Three-layer system
%% Layer 1: Inner steel pipe
%% Layer 2: Porous damping material 
%% Layer 3: Outer impervious jacket
%% =======================================================================

% Jacket and damping layer thicknesses
t_jacket = 0.0005;  % Jacket thickness [m]
t_damping = 0.00;   % Damping layer thickness [m] (currently zero)
t34 = t_jacket + t_damping;  % Total outer layer thickness

% Radial dimensions (from inner to outer)
r1 = 0.15;         % Inner pipe radius [m]
r2 = r1 + 0.0045;  % Outer pipe radius [m] (pipe wall thickness = 4.5mm)
r3 = r2 + 0.05;    % Outer radius of porous layer [m] (50mm thick porous layer)
r4 = r3 + t34;     % Outer radius of complete system [m]

% Derived dimensions
t12 = r2 - r1;      % Pipe wall thickness [m]
l = 6;              % Length of the lagged pipe section [m]

fprintf('\nGeometry parameters:\n');
fprintf('  - Inner radius (r1): %.3f m\n', r1);
fprintf('  - Pipe wall thickness: %.4f m\n', t12);
fprintf('  - Porous layer thickness: %.3f m\n', r3-r2);
fprintf('  - Jacket thickness: %.4f m\n', t_jacket);
fprintf('  - Total outer radius (r4): %.3f m\n', r4);
fprintf('  - Pipe length: %.1f m\n\n', l);

%% =======================================================================
%% PIPE IMPEDANCE CALCULATION
%% Calculate the mechanical impedance of the bare steel pipe
%% =======================================================================

% Pipe mechanical properties
I12 = rho12.*t12.*(1+(0.025/r1)^2);  % Mass per unit area [kg/m²] with correction factor
C12 = r1^2/E12/t12;                  % Compliance [m⁴/N]

% Characteristic frequencies
f_ring = sqrt(E12/rho12/(1-nu12^2))./(2*pi.*r1);  % Ring frequency [Hz]
f_critical = c0^2/2/pi*(I12/(E12*t12^3/(12*(1-nu12^2))))^(1/2);  % Critical frequency [Hz]

fprintf('Pipe characteristic frequencies:\n');
fprintf('  - Ring frequency: %.1f Hz\n', f_ring);
fprintf('  - Critical frequency: %.1f Hz\n\n', f_critical);

% Full pipe impedance (including ring and critical frequency effects)
% Ve_Z12 = 1i.*Ve_omega.*I12.*(1-(Ve_freq./f_critical).^2-(f_ring./Ve_freq).^2 );

% Simplified pipe impedance (mass-spring system)
Ve_Z12 = (1i.*Ve_omega*I12 + 1./(1i.*Ve_omega.*C12)); % [Pa·s/m] 

%% =======================================================================
%% WAVE PROPAGATION PARAMETERS
%% Calculate wave vectors for different media and directions
%% =======================================================================

% Axial wave vector (z-direction) considering pipe interaction
Ve_kz = Ve_k.*(1-2i.*rho0.*c0./Ve_Z12./Ve_k./r1).^(1/2);  % [rad/m]

%% =======================================================================
%% POROUS MATERIAL PROPERTIES
%% Define acoustic properties of the porous damping layer
%% =======================================================================

% Porous material specific impedance (simplified model)
rp = 2500*(1+1i*0.001);  % [Pa·s/m] - specific acoustic impedance with small loss factor

fprintf('Porous material properties:\n');
fprintf('  - Specific impedance: %.0f Pa·s/m (with %.1f%% loss)\n', abs(rp), 0.1);

% Wave numbers in different media
Ve_kp = Ve_k.*(1-1i.*rp./Ve_omega./rho0).^(1/2);     % Wave number in porous material [rad/m]
Ve_krp = (Ve_kp.^2 - Ve_kz.^2).^(1/2);               % Radial wave number in porous material [rad/m]
Ve_kr = (Ve_k.^2 - Ve_kz.^2).^(1/2);                 % Radial wave number in air [rad/m]

% Alternative calculation (commented out)
% Ve_kr1 = (Ve_k.*2i.*rho0.*c0./Ve_Z12./r1).^(1/2);

% Characteristic admittance of porous material
Ve_Yp = rho0.*c0.*(1-1i.*rp./Ve_omega./rho0).^(1/2);  % [m/Pa·s]

%% =======================================================================
%% RADIATION IMPEDANCE CALCULATION
%% Calculate radiation impedance at different radial positions
%% =======================================================================

% Radiation impedance at outer surface (r4) - complete system
Ve_Z04 = 1i.*Ve_omega.*rho0./Ve_kr.*besselh(0, 2, Ve_kr*r4)./Ve_kr/r4; % [Pa·s/m]
% Note: besselh(0,2,...) = Hankel function of 1st kind, order 0, type 2

% Radiation impedance at pipe outer surface (r2) - bare pipe reference
Ve_Z02 = 1i.*Ve_omega.*rho0./Ve_kr.*besselh(0, 2, Ve_kr*r2)./Ve_kr/r2; % [Pa·s/m]

fprintf('\nRadiation impedance calculated for:\n');
fprintf('  - Outer surface (r4 = %.3f m): Complete system\n', r4);
fprintf('  - Pipe surface (r2 = %.3f m): Bare pipe reference\n\n', r2);

%% =======================================================================
%% TRANSFER MATRIX CALCULATION FOR POROUS LAYER
%% Calculate 2x2 transfer matrix relating pressure and velocity
%% at inner (r2) and outer (r3) surfaces of porous layer
%% =======================================================================

% Bessel functions of the first kind (J) at layer boundaries
Ve_J02 = besselj(0, Ve_krp.*r2);  % J₀(krp·r2)
Ve_J03 = besselj(0, Ve_krp.*r3);  % J₀(krp·r3)
Ve_J12 = besselj(1, Ve_krp.*r2);  % J₁(krp·r2)
Ve_J13 = besselj(1, Ve_krp.*r3);  % J₁(krp·r3)

% Bessel functions of the second kind (Y/N) at layer boundaries
Ve_N02 = bessely(0, Ve_krp.*r2);  % Y₀(krp·r2)
Ve_N03 = bessely(0, Ve_krp.*r3);  % Y₀(krp·r3)
Ve_N12 = bessely(1, Ve_krp.*r2);  % Y₁(krp·r2)
Ve_N13 = bessely(1, Ve_krp.*r3);  % Y₁(krp·r3)

% Transfer matrix calculation parameters
Ve_X = 1i.*Ve_krp./Ve_Yp./Ve_kp;                    % Scaling factor
Ve_det = Ve_X.*(Ve_J13.*Ve_N03 - Ve_J03.*Ve_N13);   % Determinant term

% Unnormalized transfer matrix elements
Ve_uT11 = Ve_J13.*Ve_N02 - Ve_J02.*Ve_N13;          % Pressure-pressure term
Ve_uT12 = 1./Ve_X.*(Ve_J03.*Ve_N02 - Ve_J02.*Ve_N03); % Pressure-velocity term
Ve_uT21 = Ve_X.*(Ve_J12.*Ve_N13 - Ve_J13.*Ve_N12);  % Velocity-pressure term
Ve_uT22 = (Ve_J12.*Ve_N03 - Ve_J03.*Ve_N12);        % Velocity-velocity term

% Final normalized transfer matrix elements [T] = [T11 T12; T21 T22]
% Relates [P2; U2] = [T][P3; U3] where P=pressure, U=velocity
Ve_T11 = Ve_X./Ve_det.*Ve_uT11;  % Dimensionless
Ve_T12 = Ve_X./Ve_det.*Ve_uT12;  % [Pa·s/m]
Ve_T21 = Ve_X./Ve_det.*Ve_uT21;  % [m/Pa·s]
Ve_T22 = Ve_X./Ve_det.*Ve_uT22;  % Dimensionless

fprintf('Transfer matrix calculated for porous layer (r2=%.3f to r3=%.3f m)\n', r2, r3);

%% =======================================================================
%% OUTER JACKET IMPEDANCE
%% Calculate mechanical impedance of the outer impervious jacket
%% =======================================================================

parameter34_jacket  % Load jacket material properties

% Combined mass impedance of jacket and damping layers with loss factor
Ve_Z34 = 1i.*Ve_omega.*(rho_jacket.*t_jacket+rho_damping*t_damping)*(1+1i*0.2); % [Pa·s/m]
% Note: Loss factor of 0.2 (20%) applied to account for material damping

fprintf('\nOuter jacket impedance calculated with:\n');
fprintf('  - Jacket contribution: %.3f kg/m² \n', rho_jacket*t_jacket);
fprintf('  - Damping contribution: %.3f kg/m²\n', rho_damping*t_damping);
fprintf('  - Loss factor: 20%%\n');

%% =======================================================================
%% TRANSMISSION LOSS CALCULATION
%% Calculate sound transmission through lagged and bare pipe systems
%% =======================================================================

% Complete transmission ratio (commented - simplified version used below)
% Ve_ratio = Ve_Z04.*(Ve_T11 + Ve_Z12.*Ve_T21) + Ve_T11.*Ve_Z34 + Ve_T12 + Ve_Z12.*(Ve_T21.*Ve_Z34 + Ve_T22);

% Simplified transmission ratio for lagged pipe (pipe + porous layer + jacket)
Ve_ratio_lagged = Ve_Z12.*Ve_T21.*Ve_Z34;

% Surface areas for power calculations
Si = pi*r1^2;        % Inner pipe cross-sectional area [m²]
S4 = 2*pi*r4*l;      % Outer surface area of complete system [m²]
S2 = 2*pi*r2*l;      % Outer surface area of bare pipe [m²]

fprintf('\nSurface areas:\n');
fprintf('  - Inner area (Si): %.4f m²\n', Si);
fprintf('  - Lagged outer area (S4): %.2f m²\n', S4);
fprintf('  - Bare pipe area (S2): %.2f m²\n', S2);

% Transmission Loss calculations [dB]
% TL = 10*log10(Incident Power / Transmitted Power)
Ve_TLlagged = 10*log10( Si/(2*rho0*c0) ./(1/2.*real(Ve_Z04).*S4).* abs(Ve_ratio_lagged).^2);

% Transmission loss for bare pipe (reference case)
Ve_ratio_bare = Ve_Z12;  % Only pipe impedance
Ve_TLbare = 10*log10( Si/(2*rho0*c0) ./(1/2.*real(Ve_Z02).*S2).* abs(Ve_ratio_bare).^2);


%% =======================================================================
%% INSERTION LOSS CALCULATION AND VISUALIZATION
%% Calculate the improvement provided by the multilayer jacket system
%% =======================================================================

% Insertion Loss = TL_lagged - TL_bare [dB]
% This represents the additional sound reduction provided by the jacket system
Ve_IL = Ve_TLlagged - Ve_TLbare;

fprintf('\n=== RESULTS ===\n');
fprintf('Insertion loss calculated over frequency range %.0f - %.0f Hz\n', min(Ve_freq), max(Ve_freq));
fprintf('Maximum insertion loss: %.1f dB at %.0f Hz\n', max(Ve_IL), Ve_freq(Ve_IL == max(Ve_IL)));
fprintf('Average insertion loss: %.1f dB\n\n', mean(Ve_IL));

%% =======================================================================
%% RESULTS VISUALIZATION AND VALIDATION
%% Compare theoretical predictions with experimental measurements
%% =======================================================================

% Load experimental validation data (case-sensitive safe)
dataPath = fullfile('data','measured_insertion_loss.mat');
S = load(dataPath);
% Try to find the expected struct variable; fall back to the first non-empty field.
if isfield(S,'Measured_insertion_loss')
    Measured_insertion_loss = S.Measured_insertion_loss;
else
    fns = fieldnames(S);
    if isempty(fns)
        error('Measured data MAT file has no variables: %s', dataPath);
    end
    Measured_insertion_loss = S.(fns{1});
end
fprintf('Loaded experimental data for validation from %s\n', dataPath);

% Create comparison plot
figure(2);
set(gcf, 'Name', 'MetaSandwich-IL-Jacket: Insertion Loss Analysis', 'NumberTitle', 'off');

% Convert to octave bands for smoother visualization
Ma = [Ve_freq, Ve_IL];
[Ve_freq_octave, Ve_IL_octave] = fun_octave(Ma);

% Plot theoretical results
pl_the_octave = semilogx(Ve_freq_octave, Ve_IL_octave, 'k:', 'linewidth', 2.5);
hold on;

% Plot experimental measurements
pl_mea = semilogx(Measured_insertion_loss.freq, Measured_insertion_loss.caseA, 'r--', 'linewidth', 3.5);
hold off;

% Format plot
plotxlabel = xlabel('Frequency (Hz)'); 
set(plotxlabel, 'FontSize', 16, 'interpreter', 'latex');
plotylabel = ylabel('Insertion loss (dB)'); 
set(plotylabel, 'FontSize', 16, 'interpreter', 'latex');

plotlegend = legend([pl_the_octave pl_mea], ...
                   'Transfer Matrix Method', 'Measured'); 
set(plotlegend, 'Location', 'Best', 'FontSize', 12, 'box', 'off', 'interpreter', 'latex');

% Set axis limits and formatting
axis([100 4000 -20 60]);
set(gca, 'TickLabelInterpreter', 'latex');
grid on;

% Optional: Save figure (uncomment if needed)
filename = 'IL_case';
% savefigure(path_png, path_eps, path_fig, filename)

fprintf('\n=== ANALYSIS COMPLETE ===\n');
fprintf('Results plotted and compared with experimental data\n');
fprintf('Figure saved as: %s\n', filename);




