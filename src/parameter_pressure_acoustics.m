%% =======================================================================
%% ACOUSTIC PARAMETERS FOR AIR AT STANDARD CONDITIONS
%% =======================================================================
%% This file defines the basic acoustic properties of air and the
%% frequency range for the analysis.
%%
%% Standard conditions: 20°C, 1 atm, dry air
%% =======================================================================

% Air density at standard conditions [kg/m³]
rho0 = 1.2;

% Speed of sound in air at standard conditions [m/s]
c0 = 343;

% Frequency vector for analysis [Hz]
% Range: 50-6000 Hz with 10 Hz increments
% Note: Analysis is optimized for frequencies <= 2000 Hz
Ve_freq = [50:10:6000]';

% Angular frequency [rad/s]
Ve_omega = 2*pi*Ve_freq;

% Acoustic wave number in air [rad/m]
Ve_k = Ve_omega./c0;

%% End of acoustic parameters
