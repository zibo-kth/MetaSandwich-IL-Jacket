function savefigure(path_png, path_eps, path_fig, filename)
%SAVEFIGURE Save current figure in multiple formats.
%
% NOTE: This helper existed without a terminating `end`, which can break
% Octave parsing depending on version/settings.

set(findobj('type','axes'),...
    'ticklength',[0.015,0.037],...
    'xcolor','k',...
    'ycolor','k',...
    'xminortick','on',...
    'yminortick','on',...
    'linewidth',1.25);

print(filename,'-dpng','-r800');
filenamepng = strcat(filename, '.png');
movefile(filenamepng, path_png);

print(filename,'-depsc');
filenameeps = strcat(filename, '.eps');
movefile(filenameeps, path_eps);

savefig(filename);
filenamefig = strcat(filename, '.fig');
movefile(filenamefig, path_fig);

end

