function test_font_adjuster()
% Usage: test_font_adjuster()
%
% Unit test for font_adjuster.m.
%

  % Start with a default-formatted line plot
  more off
  figure(101);
  clf;
  plot(0:360,sin(2*pi/360*(0:360)),0:360,cos(2*pi/360*(0:360)),'LineWidth',2);
  legend('sin','cos');
  xlabel('Sample Offset'); ylabel('Amplitude'); title('Sine Wave');
  [ti0,la0,tc0,le0,na0] = font_adjuster(gca);

  % Vary the font size of text, one field at a time
  testn = {'ti','la','tc','le'};
  for nn = 1:numel(testn)
    ti = ti0; la = la0; tc = tc0; le = le0; na = na0;
    [ti0,la0,tc0,le0,na0] = font_adjuster(gca,ti0,la0,tc0,le0,na0);
    for kk = 1:20
      cmd = sprintf('%s = %s + 1',testn{nn},testn{nn});
      eval(cmd);
      [ti,la,tc,le,na] = font_adjuster(gca,ti,la,tc,le,na);
      drawnow;
      figure(101);
      pause(0.1);
    end
  end
  [ti,la,tc,le,na] = font_adjuster(gca,ti0+10,la0+10,tc0+10,le0+10,na0);

  % Vary the font name
  if exist('listfonts') == 2
    allfonts = listfonts;
  else
    allfonts = listfonts_local;
  end
  for nn = 1:20
    na = allfonts{nn}
    [ti,la,tc,le,na] = font_adjuster(gca,ti,la,tc,le,na);
    drawnow;
    figure(101);
    pause(0.1);
  end

end % function

% Work-around for GNU Octave releases older than version 7.
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
