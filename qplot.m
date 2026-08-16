function [AX,UI] = qplot()

    [AX, UI] = init_gui();

end % main function

function [AX,UI] = init_gui()
    global AX
    global UI

    % Initialize
    scrnSz = get(groot,'ScreenSize');
    scrn.wd = scrnSz(3);
    scrn.ht = scrnSz(4);
    gui = 9999;
    UI.gui = gui;
    fontSize = 14;
    bottom = 89;
    vert_delta = -6.5;
    crt_vert = bottom;
    txt_left = 2;
    txt_width = 25;
    txt_ht = 6;
    txt_rt = 50;
    mnu_left = 35;
    mnu_width = 60;
    mnu_ht = 6;
    chk_width = 25;
    chk_ht = 6;
    chk_rt = 50;
    rb_left = 7;
    rb_mid =  45;
    rb_rt =  75;
    rb_width =  40;
    rb_ht =  10-2;
    btn_left = 25;
    btn_width = 50;
    btn_ht = 6; 
    hlp_left = 2;
    hlp_width = 6;
    hlp_ht = 6;
    frm_width = 26;
    frm_btm = 10;
    frm_ht = 60;
    fig = figure(gui);
    set(gui,'name','QPlot 1.0','numbertitle','off');
    set(gui,'MenuBar','none','ToolBar','none','DockControls','off');
    UI.fig = fig;

    % GUI position vector P: [left, bottom, width, height]
    if scrn.ht > 1500
        % hard-coded for 4K displays with high DPI scaling ratio
        P = [2 2 10 30]/100;
    else
        % works well for 1080p and lower
        P = [txt_left, frm_btm, frm_width, frm_ht]/100;
    end
    set(fig, 'Units', 'normalized', 'Position', P);
    movegui(fig);

    % figure list
    [fignums, fh] = populate_figure_list();

    % figure list popup widget
    figtext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Figure: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    figList = uicontrol('style','popupmenu','units','normalized', ... 
                         'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',fignums, ...
                         'FontSize',fontSize);
    UI.figList = figList;
    list = get(UI.figList,'String');
    if isempty(list{1})
        crt_fignum = set_default_figure(1);
    else
        crt_fignum = get(fh(get(figList,'Value')),'Number');
    end

    % initialize current figure, then select gui as current
    figure(crt_fignum);
    AX = gca;
    set(figList,'Callback', @(src, event) cb_dispatcher(src,'set_figure_number'));
    figure(gui);

    crt_vert = crt_vert + vert_delta;

    % font list popup widget
    % [left, bottom, width, height]
    fonttext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Font: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    % font list
    if exist('listfonts') == 2
        allfonts = listfonts;
    else
        allfonts = listfonts_local;
    end
    fontList = uicontrol('style','popupmenu','units','normalized', ... 
                         'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',allfonts, ...
                         'FontSize',fontSize, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_fontname'));
    crt_font = get(AX,'FontName');
    ix = find(strcmpi(allfonts,crt_font),1);
    set(fontList,'Value',ix);
    UI.fontList = fontList;

    crt_vert = crt_vert + 1.1 * vert_delta;

    % font size popup widgets
    [ti,la,tc,le,na] = font_adjuster(AX);
    sizetext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Size', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    crt_vert = crt_vert + vert_delta;

    % title font size
    titltext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Title: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    titlsizes_n = shiftdim(1:100);
    titlsizes_s = num2str(titlsizes_n);
    titlSzList = uicontrol('style','popupmenu','units','normalized', ... 
                         'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',titlsizes_s, ...
                         'FontSize',fontSize, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_title_fontsize'));
    crtTitlSz = round(ti); %get(get(AX,'Title'),'FontSize');
    ix = find(titlsizes_n == round(crtTitlSz),1);
    set(titlSzList,'Value',ix);
    UI.titlSzList = titlSzList;

    crt_vert = crt_vert + vert_delta;

    % labels font size
    labltext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','XY Labels: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    lablsizes_n = shiftdim(1:100);
    lablsizes_s = num2str(lablsizes_n);
    lablSzList = uicontrol('style','popupmenu','units','normalized', ... 
                         'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',lablsizes_s, ...
                         'FontSize',fontSize, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_label_fontsize'));
    crtXlablSz = round(la); %get(get(AX,'Xlabel'),'FontSize');
    crtYlablSz = round(la); %get(get(AX,'Ylabel'),'FontSize');
    ix = find(lablsizes_n == round(crtXlablSz),1);
    set(lablSzList,'Value',ix);
    UI.lablSzList = lablSzList;

    crt_vert = crt_vert + vert_delta;

    % ticks font size
    tckstext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Ticks: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    tcksizes_n = shiftdim(1:100);
    tcksizes_s = num2str(tcksizes_n);
    tcksSzList = uicontrol('style','popupmenu','units','normalized', ... 
                         'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',tcksizes_s, ...
                         'FontSize',fontSize, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_ticks_fontsize'));
    crtXTcksSz = round(tc); %get(get(AX,'XAxis'),'FontSize');
    crtYTcksSz = round(tc); %get(get(AX,'YAxis'),'FontSize');
    ix = find(tcksizes_n == round(crtXTcksSz),1);
    set(tcksSzList,'Value',ix);
    UI.tcksSzList = tcksSzList;

    crt_vert = crt_vert + vert_delta;

    % legend font size
    lgndtext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Legend: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    lgndsizes_n = shiftdim(1:100);
    lgndsizes_s = num2str(lgndsizes_n);
    lgndSzList = uicontrol('style','popupmenu','units','normalized', ... 
                           'position',[mnu_left crt_vert mnu_width mnu_ht]/100,'String',lgndsizes_s, ...
                           'FontSize',fontSize, ...
                           'Callback', @(src, event) cb_dispatcher(src,'set_legend_fontsize'));
    props = get(AX);
    if isfield(props,'Legend')
        crtLgnd = get(AX,'Legend');
    elseif isfield(props,'__legend_handle__')
        crtLgnd = get(AX,'__legend_handle__'); % gnu octave v5.2
    else
        crtLgnd = '';
    end
    if ~isempty(crtLgnd)
        crtLgndSz = round(le); %get(crtLgnd,'FontSize');
        ix = find(lgndsizes_n == crtLgndSz,1);
        set(lgndSzList,'Value',ix);
    end
    UI.lgndSzList = lgndSzList;

    crt_vert = crt_vert + 1.1 * vert_delta;

    % Styles
    styletext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Style', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    stylebold = uicontrol('style','text','units','normalized', ... 
                         'position',[mnu_left crt_vert txt_width txt_ht]/100,'String','Bold', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    styleital = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_rt crt_vert txt_width txt_ht]/100,'String','Italic', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    crt_vert = crt_vert + vert_delta;

    % title style checkbox widget
    titlbox  = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Title: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    titlBold = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[mnu_left crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_title_bold'));
    titlItal = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[chk_rt crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_title_italic'));
    if strcmpi(get(get(AX,'Title'),'FontWeight'),'bold')
        set(titlBold,'Value', 1);
    else
        set(titlBold,'Value', 0);
    end
    if strcmpi(get(get(AX,'Title'),'FontAngle'),'normal')
        set(titlItal,'Value', 0);
    else
        set(titlItal,'Value', 1);
    end
    UI.titlBold = titlBold;
    UI.titlItal = titlItal;
    set_title_bold(UI.titlBold);
    set_title_italic(UI.titlItal);
    crt_vert = crt_vert + vert_delta;

    % labels style checkbox widget
    lablbox  = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','XY Labels: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    lablBold = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[mnu_left crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_label_bold'));
    lablItal = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[chk_rt crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_label_italic'));
    UI.lablBold = lablBold;
    UI.lablItal = lablItal;
    set_label_bold(UI.lablBold);
    set_label_italic(UI.lablItal);
    crt_vert = crt_vert + vert_delta;

    % legend style checkbox widget
    lgndbox  = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert txt_width txt_ht]/100,'String','Legend: ', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    lgndBold = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[mnu_left crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_legend_bold'));
    lgndItal = uicontrol('style','checkbox','units','normalized', ... 
                         'position',[chk_rt crt_vert chk_width chk_ht]/100, ...
                         'Callback', @(src, event) cb_dispatcher(src,'set_legend_italic'));
    UI.lgndBold = lgndBold;
    UI.lgndItal = lgndItal;
    set_legend_bold(UI.lgndBold);
    set_legend_italic(UI.lgndItal);
    crt_vert = crt_vert + 1.1 * vert_delta;

    % Themes
    themetext = uicontrol('style','text','units','normalized', ... 
                         'position',[txt_left crt_vert+1 txt_width txt_ht]/100,'String','Theme', ...
                         'HorizontalAlignment','Left', ...
                         'FontSize',fontSize);
    crt_vert = crt_vert + 0.9 * vert_delta;

    % radio button widgets for normal, dark, and hand themes
    rbnorm = uicontrol('style', 'radiobutton', ...
                       'units', 'normalized', ...
                       'position', [rb_left crt_vert rb_width rb_ht]/100, ...
                       'String',' Normal', ...
                       'Value',1, ...
                       'FontSize',fontSize);
    rbdark = uicontrol('style', 'radiobutton', ...
                       'units', 'normalized', ...
                       'position', [rb_mid crt_vert rb_width rb_ht]/100, ...
                       'String',' Dark', ...
                       'Value',0, ...
                       'FontSize',fontSize);
    rbhand = uicontrol('style', 'radiobutton', ...
                       'units', 'normalized', ...
                       'position', [rb_rt crt_vert rb_width rb_ht]/100, ...
                       'String',' Hand', ...
                       'Value',0, ...
                       'FontSize',fontSize);
    set(rbnorm, 'Callback', @(src, event) cb_dispatcher(src, 'set_theme', rbnorm, rbdark, rbhand));
    set(rbdark, 'Callback', @(src, event) cb_dispatcher(src, 'set_theme', rbdark, rbnorm, rbhand));
    set(rbhand, 'Callback', @(src, event) cb_dispatcher(src, 'set_theme', rbhand, rbnorm, rbdark));
    UI.rbnorm = rbnorm;
    UI.rbdark = rbdark;
    UI.rbhand = rbhand;
    update_theme();

    crt_vert = crt_vert + vert_delta;

    % refresh button widget - scans for open figures - consider eliminating
    refreshbtn = uicontrol('style', 'pushbutton', ...
                           'units', 'normalized', ...
                           'position', [btn_left crt_vert btn_width btn_ht]/100, ...
                           'String',' Update Figure List ', ...
                           'Value',1, ...
                           'FontSize',fontSize);
    set(refreshbtn, 'Callback', @(src, event) cb_dispatcher(src, 'refresh'));

    % help button widget
    helpbtn = uicontrol('style', 'pushbutton', ...
                           'units', 'normalized', ...
                           'position', [hlp_left crt_vert hlp_width hlp_ht]/100, ...
                           'String',' ? ', ...
                           'Value',1, ...
                           'FontSize',fontSize);
    set(helpbtn, 'Callback', @(src, event) cb_dispatcher(src, 'display_help'));

    set(UI.gui, 'Units', 'normalized', 'Position', P);
    movegui(fig);

    figure(crt_fignum);
    P

end % main function

% dispatcher
function cb_dispatcher(src,fcn,varargin)
    global AX
    global UI

    if strcmpi(fcn,'set_figure_number')
        strlist = cell2mat(get(src,'String'));
        ix = get(src,'Value');
        new_fignum = str2num(strlist(ix));
        refresh_figure_list(new_fignum);
    else
    refresh_figure_list();
    end

    if numel(varargin) == 3
        clicked_btn = varargin{1};
        other_btn = varargin{2};
        other_other_btn = varargin{3};
    else
        clicked_btn = 0;
        other_btn = 0;
        other_other_btn = 0;
    end

    figHandles = findall(groot, 'Type', 'figure');
    if numel(figHandles) == 1
        set_default_figure(1);
        return
    end

    % Functions not requiring pre axis updates
    ok = 1;
    if strcmpi(fcn,'set_theme')
        set_theme(src,clicked_btn,other_btn,other_other_btn);
    elseif strcmpi(fcn,'refresh')
        refresh();
    elseif strcmpi(fcn,'set_figure_number')
        set_figure_number(src);
    elseif strcmpi(fcn,'display_help')
        display_help();
    else
        ok = 0;
    end
    if ok
        return
    end

    [figno, figha] = get_figure_number();
    figarray = findobj(figha,'Type','axes');

    % Functions requiring per axis updates
    for kk = 1:numel(figarray)
        AX = figarray(kk);
        switch lower(fcn)
            case 'set_fontname'
                set_fontname(src);
            case 'set_title_fontsize'
                set_title_fontsize(src);
            case 'set_label_fontsize'
                set_label_fontsize(src);
            case 'set_ticks_fontsize'
                set_ticks_fontsize(src);
            case 'set_legend_fontsize'
                set_legend_fontsize(src);
            case 'set_title_bold'
                set_title_bold(src);
            case 'set_title_italic'
                set_title_italic(src);
            case 'set_label_bold'
                set_label_bold(src);
            case 'set_label_italic'
                set_label_italic(src);
            case 'set_legend_bold'
                set_legend_bold(src);
            case 'set_legend_italic'
                set_legend_italic(src);
            otherwise
                fprintf(2,'Unknown callback function %s.\n', fcn);
        end
    end
    figure(get_fignum_from_ax(AX));
end % function


% setters
function set_figure_number(src)
    global AX
    global UI

    figstr = get(src,'String');
    fignum = str2num(figstr{get(src,'Value')});
    figure(fignum);
    AX = gca;
    UI.figList = src;
    refresh();

end % function

function set_fontname(src)
    global AX
    global UI

    namestr = get(src,'String');
    name = namestr{get(src,'Value')};
    [ti,la,tc,le,na] = font_adjuster(AX);
    if ~strcmpi(na,name), na = name; end
    [ti,la,tc,le,na] = font_adjuster(AX, ti, la, tc, le, na);
    UI.fontList = src;

end % function

function set_title_fontsize(src)
    global AX
    global UI

    titl = get(src,'Value');
    [ti,la,tc,le,na] = font_adjuster(AX);
    if titl ~= ti, ti = titl; end
    [ti,la,tc,le,na] = font_adjuster(AX, ti, la, tc, le, na);
    UI.titlSzList = src;

end % function

function set_label_fontsize(src)
    global AX
    global UI

    labl = get(src,'Value');
    [ti,la,tc,le,na] = font_adjuster(AX);
    if labl ~= la, la = labl; end
    [ti,la,tc,le,na] = font_adjuster(AX, ti, la, tc, le, na);
    UI.lablSzList = src;

end % function

function set_ticks_fontsize(src)
    global AX
    global UI

    tcks = get(src,'Value');
    [ti,la,tc,le,na] = font_adjuster(AX);
    if tcks ~= tc, tc = tcks; end
    [ti,la,tc,le,na] = font_adjuster(AX, ti, la, tc, le, na);
    UI.tcksSzList = src;

end % function

function set_legend_fontsize(src)
    global AX
    global UI

    lgnd = get(src,'Value');
    [ti,la,tc,le,na] = font_adjuster(AX);
    if lgnd ~= le, le = lgnd; end
    [ti,la,tc,le,na] = font_adjuster(AX, ti, la, tc, le, na);
    UI.lgndSzList = src;

end % function

function set_title_bold(src)
    global AX
    global UI

    if get(src,'Value')
        set(get(AX,'Title'),'FontWeight','Bold');
    else
        set(get(AX,'Title'),'FontWeight','Normal');
    end
    UI.titBold = src;

end % function

function set_title_italic(src)
    global AX
    global UI

    if get(src,'Value')
        set(get(AX,'Title'),'FontAngle','Italic');
    else
        set(get(AX,'Title'),'FontAngle','normal');
    end
    UI.titItal = src;

end % function

function set_label_bold(src)
    global AX
    global UI

    if get(src,'Value')
        set(get(AX,'Xlabel'),'FontWeight','Bold');
        set(get(AX,'Ylabel'),'FontWeight','Bold');
    else
        set(get(AX,'Xlabel'),'FontWeight','Normal');
        set(get(AX,'Ylabel'),'FontWeight','Normal');
    end
    UI.lablBold = src;

end % function

function set_label_italic(src)
    global AX
    global UI

    if get(src,'Value')
        set(get(AX,'Xlabel'),'FontAngle','Italic');
        set(get(AX,'Ylabel'),'FontAngle','Italic');
    else
        set(get(AX,'Xlabel'),'FontAngle','normal');
        set(get(AX,'Ylabel'),'FontAngle','normal');
    end
    UI.lablItal = src;

end % function

function set_legend_bold(src)
    global AX
    global UI

    props = get(AX);
    if isfield(props,'Legend')
        crtLgnd = get(AX,'Legend');
    elseif isfield(props,'__legend_handle__')
        crtLgnd = get(AX,'__legend_handle__');
    else
        crtLgnd = '';
    end
    if ~isempty(crtLgnd)
        val = get(src,'Value');
        if val
            set(crtLgnd,'FontWeight','Bold');
        else
            set(crtLgnd,'FontWeight','Normal');
        end
    end
    UI.lgndBold = src;

end % function

function set_legend_italic(src)
    global AX
    global UI

    props = get(AX);
    if isfield(props,'Legend')
        crtLgnd = get(AX,'Legend');
    elseif isfield(props,'__legend_handle__')
        crtLgnd = get(AX,'__legend_handle__');
    else
        crtLgnd = '';
    end
    if ~isempty(crtLgnd)
        val = get(src,'Value');
        if val
            set(crtLgnd,'FontAngle','Italic');
        else
            set(crtLgnd,'FontAngle','normal');
        end
    end
    UI.lgndItal = src;

end % function

function set_theme(src,clicked_btn,other_btn,other_other_btn)
    global AX
    global UI

    % Force the clicked button to stay selected
    set(clicked_btn, 'Value', 1);
    
    % Deselect the other button
    set(other_btn, 'Value', 0);
    
    % Deselect the other button
    set(other_other_btn, 'Value', 0);
    
    % Print the current selection to the command window
    %disp(['Selected: ' get(clicked_btn, 'String')]);

    figno = get_figure_number();
    str = strtrim(get(clicked_btn, 'String'));
    if strcmpi(str,'normal')
        undark(figno);
        UI.rbnorm = src;
    elseif strcmpi(str,'dark')
        dark([],figno);
        UI.rbdark = src;
    elseif strcmpi(str,'hand')
        hand([],figno);
        UI.rbhand = src;
    end
    refresh();
end % function

function display_help()

    [fp,fn,fx] = fileparts(which('qplot'));
    helpfile = sprintf('file://%s',[fp '/help.html']);
    helpfile = strrep(helpfile,'\','/');
    web(helpfile,'-browser')

end % function

function [figno, figha] = get_figure_number()
    global AX
    global UI

    figha = get(AX,'Parent');
    figno = get(figha,'Number');
end % function

function update_theme()
    global AX
    global UI

    CANVAS_RGB = [220 243 182]/256;
    figcolor = get(AX,'Color');
    if all(figcolor == 0)
        % dark theme
        set(UI.rbnorm,'Value',0)
        set(UI.rbdark,'Value',1)
        set(UI.rbhand,'Value',0)
    elseif all(abs(figcolor - CANVAS_RGB) < 1e-6)
        % hand theme
        set(UI.rbnorm,'Value',0)
        set(UI.rbdark,'Value',0)
        set(UI.rbhand,'Value',1)
    else
        % normal theme
        set(UI.rbnorm,'Value',1)
        set(UI.rbdark,'Value',0)
        set(UI.rbhand,'Value',0)
    end
end % function

function refresh()
    global AX
    global UI

    figure(UI.gui);
        cla;
        axis off;
    refresh_figure_list()

    % return if there are no plot windows
    %if isempty(UI.figList.String{1})
    figstr = get(UI.figList,'String');
    if isempty(figstr{1})
        crt_fignum = set_default_figure(1);
        return
    end

    [ti,la,tc,le,na] = font_adjuster(AX);
    ti = round(ti); la = round(la); tc = round(tc); le = round(le);
    fontstr = get(UI.fontList,'String');
    ix = find(strcmpi(fontstr,na));
    set(UI.fontList,'Value',ix);
    set(UI.titlSzList,'Value',ti);
    set(UI.lablSzList,'Value',la);
    set(UI.tcksSzList,'Value',tc);
    if le
        set(UI.lgndSzList,'Value',le);
    end
    if strcmpi(get(get(AX,'Title'),'FontWeight'),'bold')
        set(UI.titlBold,'Value', 1);
    else
        set(UI.titlBold,'Value', 0);
    end
    if strcmpi(get(get(AX,'Title'),'FontAngle'),'normal')
        set(UI.titlItal,'Value', 0);
    else
        set(UI.titlItal,'Value', 1);
    end
    if strcmpi(get(get(AX,'Xlabel'), 'FontWeight'),'bold')
        set(UI.lablBold,'Value', 1);
    else
        set(UI.lablBold,'Value', 0);
    end
    set_label_bold(UI.lablBold);
    if strcmpi(get(get(AX,'Xlabel'), 'FontAngle'),'normal')
        set(UI.lablItal,'Value', 0);
    else
        set(UI.lablItal,'Value', 1);
    end
    props = get(AX);
    if isfield(props,'Legend')
        crtLgnd = get(AX,'Legend');
    elseif isfield(props,'__legend_handle__')
        crtLgnd = get(AX,'__legend_handle__');
    else
        crtLgnd = '';
    end
    if ~isempty(crtLgnd)
        if strcmpi(get(crtLgnd,'FontWeight'),'bold')
            set(UI.lgndBold,'Value', 1);
        else
            set(UI.lgndBold,'Value', 0);
        end
        if strcmpi(get(crtLgnd,'FontAngle'),'normal')
            set(UI.lgndItal,'Value', 0);
        else
            set(UI.lgndItal,'Value', 1);
        end
    end
    update_theme();

end % function

function refresh_figure_list(fignum)
    global AX
    global UI

    [fignums, fh] = populate_figure_list();
    if nargin == 1
        crt_fignum = fignum;
    else
    crt_fignum = get_fignum_from_ax(AX);
    end
    if ~isempty(crt_fignum)
        figstr = num2str(crt_fignum);
        strlist = cell2mat(get(UI.figList,'String'));
        ix = find(strlist == figstr);
        new_fignum = str2num(strlist(ix));
        set(UI.figList,'String',fignums(:));
        set(UI.figList,'Value',ix);
        figure(new_fignum);
        AX = gca;
    elseif ~isempty(fignums) && ~isempty(fignums{1})
        figstr = fignums{1};
        new_fignum = str2num(figstr);
        set(UI.figList,'String',fignums(:));
        set(UI.figList,'Value',1);
        figure(new_fignum);
        AX = gca;
    else
        crt_fignum = set_default_figure(1);
    end

end % function

function [fignums, fh] = populate_figure_list()
    if isoctave
        [fignums, fh] = go_populate_figure_list();
    else
        [fignums, fh] = ml_populate_figure_list();
    end
end % function

function [fignums, fh] = go_populate_figure_list()

    % figure list
    figHandles_unsorted = findobj('Type', 'figure');
    figHandles = sort_fig_handles(figHandles_unsorted);
    fh = figHandles([figHandles(:)] ~= 9999);
    fignums = cellstr(num2str(fh));

end % function

function [fignums, fh] = ml_populate_figure_list()

    % figure list
    figHandles_unsorted = findobj('Type', 'figure');
    figHandles = sort_fig_handles(figHandles_unsorted);
    fh = figHandles([figHandles(:).Number] ~= 9999);
    fignums = cellstr(num2str([figHandles([figHandles(:).Number] ~= 9999).Number].'));

end % function

function fh = sort_fig_handles(fh)
    hnums = nan(numel(fh),1);
    for kk = 1:numel(hnums)
        hnums(kk) = get(fh(kk),'Number');
    end
    [b,I] = sort(hnums);
    fh = fh(I);
end % function

function fignum = get_fignum_from_ax(ax)
    fignum = get(ancestor(ax, 'figure'), 'Number');
end % function

function fignum = set_default_figure(fignum)
    global AX
    global UI

    if nargin == 0
        fignum = 1;
    end
    figure(fignum);
    AX = gca;
    set(UI.figList,'String',{'1'});
    set(UI.figList,'Value',1);

end % function

function y = isoctave()
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
end % function
