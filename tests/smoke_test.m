% Smoke test for MetaSandwich-IL-Jacket (Octave/MATLAB)

fprintf('Running MetaSandwich-IL-Jacket smoke test...\n');
addpath(genpath(pwd));

% If there is a callable function, test it. Otherwise test that main script exists.
assert(exist('main.m','file')==2);
assert(exist('MetaSandwich_IL_Jacket_Main.m','file')==2);

fprintf('OK. Entry points exist.\n');
