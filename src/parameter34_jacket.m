%% =======================================================================
%% OUTER JACKET AND DAMPING LAYER MATERIAL PROPERTIES
%% =======================================================================
%% This file defines the material properties for the outer impervious
%% jacket and any additional damping layers in the multilayer system.
%% =======================================================================

% Jacket material density [kg/m³]
% Typical value for polymer/rubber jacket material
rho_jacket = 2.7677e+03;

% Damping layer density [kg/m³]
% Currently set to a specific value for the damping layer
% Can be modified to include viscoelastic damping materials
rho_damping = 1750;

%% Material notes:
% - Jacket provides impervious barrier and mass loading
% - Damping layer (when present) adds viscoelastic losses
% - Combined mass affects overall system impedance

%% End of jacket material parameters
