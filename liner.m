function wout = liner(width,figno)
% Usage: wout = liner(width,figno)
%
%  Read and adjust line properties.
%
%   width....................array of linewidths to apply, if empty
%                            line widths are not modified
%   figno....................optional figure number, if omitted liner
%                            operates on the current figure
%   wout.....................array of line widths, after any changes
%                            made by liner
%
%  Notes:
%   1. Supported plot types
%      2-d line plots (plot command)
%      3-d line plots (plot3 command)
%      semilog plots
%      stem plots (stem command)
%
%

    if nargin < 2
        figno = get(ancestor(gca, 'figure'), 'Number');
    end
    if nargin < 1
        width = [];
    end
    all_axes = findobj(figure(figno), 'Type', 'axes');

    wout = [];
    for kk = 1:numel(all_axes)
        ax = all_axes(kk);
        axes(ax);
        lines = get(ax,'Children');
        for jj = 1:numel(lines)
            if ~isprop(lines(jj), 'LineWidth')
                continue
            end
            if ~isempty(width)
                win = width(rem(jj-1,numel(width)) + 1);
                set(lines(jj),'LineWidth',win);
            end
            wout = [wout get(lines(jj),'LineWidth')];
        end
    end

end % main function
