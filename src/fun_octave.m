function [Ve_freq_octave, Ve_STL_octave] = fun_octave(Ma)
%% =======================================================================
%% OCTAVE BAND ANALYSIS FUNCTION
%% =======================================================================
%% Converts narrow-band insertion loss data to octave band representation
%% for smoother visualization and comparison with experimental data.
%%
%% INPUTS:
%%   Ma - Matrix [frequency, insertion_loss] where:
%%        Ma(:,1) = frequency vector [Hz]
%%        Ma(:,2) = insertion loss [dB]
%%
%% OUTPUTS:
%%   Ve_freq_octave - Octave band center frequencies [Hz]
%%   Ve_STL_octave  - Octave band insertion loss values [dB]
%%
%% METHOD:
%% 1. Convert dB losses to power transmission coefficients
%% 2. Average power over octave bands using fun_narrow_to_one_third_octave
%% 3. Convert back to dB scale
%% =======================================================================

% Reference incident power [W] - normalized reference value
Winc = 9.5198e-4;

% Convert insertion loss [dB] to power transmission coefficients [-]
% Formula: W_trans = W_inc * 10^(-IL/10)
Ve_Wtrans_narrow = 10.^(log10(Winc) - Ma(:,2)./10);

% Average power over octave bands
[Ve_freq_octave, Ve_Wtrans_octave] = fun_narrow_to_one_third_octave(Ma(:,1), Ve_Wtrans_narrow);

% Convert back to insertion loss [dB]
% Formula: IL = 10*log10(W_inc/W_trans)
Ve_STL_octave = 10*(log10(Winc) - log10(Ve_Wtrans_octave));

end