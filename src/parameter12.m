%% =======================================================================
%% PIPE MATERIAL PROPERTIES (STEEL)
%% =======================================================================
%% This file defines the mechanical properties of the steel pipe wall.
%% These parameters are used to calculate the pipe's acoustic impedance
%% and dynamic response characteristics.
%% =======================================================================

% Steel density [kg/m³]
% Typical value for structural steel
rho12 = 7800; 

% Complex Young's modulus [Pa]
% Real part: Elastic modulus (20 GPa)
% Imaginary part: Structural damping (0.2% loss factor)
E12 = 2e10*(1+1i*0.002);

% Poisson's ratio [-]
% Typical value for steel (dimensionless)
nu12 = 0.27;

%% Material property summary
% These properties define:
% - Mass loading effects (rho12)
% - Stiffness characteristics (E12)
% - Lateral strain coupling (nu12)
% - Internal material damping (imaginary part of E12)

%% End of pipe material parameters
