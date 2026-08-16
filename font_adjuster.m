function [ti,la,tc,le,na] = font_adjuster(ax,titl,labls,tcks,legnd,name)
% Usage: [ti,la,tc,le,na] = font_adjuster(ax,titl,labls,tcks,legnd,name)
%
% Easily set and adjust plot fonts.
%
%  Inputs:
%    ax..........axis object (obtain using gca function)
%    titl........font size of title (points)
%    labls.......font size of x- and y-axis labls (points)
%    tcks........font size of x- and y-tick labls (points)
%    legnd.......font size of legend (points)
%    name........font name (character array)
%
%  Outputs
%    ti..........new font size of title (points)
%    la..........new font size of x- and y-axis labls (points)
%    tc..........new font size of x- and y-tick labls (points)
%    le..........new font size of legend (points)
%    na..........new font name (character array)
%
% Notes:
%   (1) Setting any font size input to 0 will leave it unchanged
%   (2) Setting font name to 0 or '' leaves it unchanged
%
% Example 1: Set title font size to 24 points, axis labels to 20 points,
%            axis tick numbers to 12 points, and legend to 14 points.
%    plot(0:360,sin(2*pi/360*(0:360)),0:360,cos(2*pi/360*(0:360)));
%    legend('sin','cos');
%    xlabel('Sample Offset'); ylabel('Amplitude'); title('Sine Wave');
%    [ti,la,tc,le,na] = font_adjuster(gca,24,20,12,14);
%
% Example 2: Adjust title, ticks, and labels by -4 points
%    % get the current values:
%    [ti,la,tc,le,na] = font_adjuster(gca);
%    % adjust them:
%    [ti,la,tc,le,na] = font_adjuster(gca,ti-4,la-4,tc-4,le-4);
%
% Example 3: Change the font to the first available font.
%    % get the current values:
%    [ti,la,tc,le,na] = font_adjuster(gca);
%    % change only the font name
%    allfonts = listfonts; newfont = allfonts{1};
%    [ti,la,tc,le,na] = font_adjuster(gca,ti,la,tc,le,newfont);
%

    if nargin > 0
        if nargin < 6, name  = 0; end
        if nargin < 5, legnd = 0; end
        if nargin < 4, tcks  = 0; end
        if nargin < 3, labls = 0; end
        if nargin < 2, titl  = 0; end

        if ~isoctave()
           [ti,la,tc,le,na] = ml_do_adjust(ax,titl,labls,tcks,legnd,name);
        else
           [ti,la,tc,le,na] = go_do_adjust(ax,titl,labls,tcks,legnd,name);
        end
    end
end % main function


% MATLAB font adjust implementation
function [ti,la,tc,le,na] = ml_do_adjust(ax,titl,labls,tcks,legnd,name)

    if ischar(name) && ~isempty(name)
        if exist('listfonts') == 2
            allfonts = listfonts;
        else
            allfonts = listfonts_local;
        end
        if any(strcmpi(allfonts,name))
            ax.FontName = name;
        elseif ~strcmp(name,'*')
            fprintf(2,'Font ''%s'' not found. Use listfonts() to see available fonts.\n',name);
        end
    end

    if ~titl
        titl = ax.Title.FontSize;
    end
    if ~tcks
        tcks = ax.XAxis.FontSize;
    end
    if ~labls
        labls = ax.XLabel.FontSize;
    end

    ax.Title.FontSize = titl;
    ax.XAxis.FontSize = tcks;
    ax.YAxis.FontSize = tcks;
    ax.XLabel.FontSize = labls;
    ax.YLabel.FontSize = labls;

    if isempty(ax.Legend),
        legnd = 0;
        le = 0;
    else
        if legnd > 0, ax.Legend.FontSize = legnd; end
        le = ax.Legend.FontSize;
    end
    %if titl || labls || tcks, ax.FontWeight = 'bold'; end

    ti = ax.Title.FontSize;
    la = ax.XLabel.FontSize;
    tc = ax.XAxis.FontSize;
    na = ax.FontName;

end % function


% GNU Octave font adjust implementation
function [ti,la,tc,le,na] = go_do_adjust(ax,titl,labls,tcks,legnd,name)

    props = get(ax);
    if isfield(props,'__legend_handle__')
        lh = get(ax,'__legend_handle__');
    else
        lh = [];
    end
    if isempty(lh)
        legnd = 0;
        le = 0;
        lh = 0;
    else
        le = get(lh,'FontSize');
        if legnd > 0
            set(lh,'FontSize',legnd);
        else
            set(lh,'FontSize',le);
        end
        le = get(lh,'FontSize');
    end

    if ischar(name) && ~isempty(name)
        if exist('listfonts') == 2
            allfonts = listfonts;
        else
            allfonts = listfonts_local;
        end
        if any(strcmpi(allfonts,name))
            set(ax,'FontName',name);
            if lh, set(lh,'Fontname', name); end
        elseif ~strcmp(name,'*')
            fprintf(2,'Font ''%s'' not found. Use listfonts() to see availalbe fonts.\n',name);
        end
    end

    if ~titl
        titl = get(get(ax,'title'), 'fontsize');
    end
    if ~tcks
        tcks = get(ax,'fontsize');
    end
    if ~labls
        labls = get(get(ax,'xlabel'), 'fontsize');
    end

    set(ax,'fontSize',tcks);
    tc = get(ax,'fontsize');
    set(get(ax, 'title'), 'fontsize', titl);
    set(get(ax,'xlabel'), 'FontSize', labls);
    set(get(ax,'ylabel'), 'FontSize', labls);
    if lh, set(lh,'FontSize',le); end

    ti = get(get(ax,'title'), 'fontsize');
    la = get(get(ax,'xlabel'), 'fontsize');
    na = get(ax,'fontname');

end % function

function y = isoctave
    y = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end % function

function allfonts = listfonts_local
    if ~ispc
        % linux and macos
        [status, output] = system("fc-list : family | sort | uniq");
        allfonts = strsplit(output, '\n');
    else
        % windows
        cmd = 'powershell -Command "Add-Type -AssemblyName System.Drawing; [System.Drawing.Text.InstalledFontCollection]::new().Families.Name"';
        [status, output] = system(cmd);
        allfonts = strsplit(output(1:end-1), '\n');
    end
end
