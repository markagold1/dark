# Easily create dark-themed plots in MATLAB and GNU Octave

DARK converts standard light-themed plots to a dark color scheme. DARK is easy to use, simply run the command "dark" and the current plot will be rendered in a dark theme. DARK is compatible with MATLAB and GNU Octave.

DARK uses only native functions common to MATLAB and GNU Octave without any dependencies on toolboxes or packages. Because of this it will likely run on most any version. It has been tested with MATLAB versions R2019b, R2020b, R2022b, and R2023b as well as GNU Octave versions 3.8.2, 4.4.0, 5.2.0, 6.4.0, 8.3.0, and 9.1.0. DARK has been tested on Windows 10 and Linux distros running Centos7, RHEL 8, and Ubuntu 22.04.

UNDARK is included to restore a dark-themed plot back to its standard light theme. Simply run the command "undark" and the current plot will be rendered in its standard light theme. In short UNDARK undoes DARK.

# Files
* dark.m - Converts plots to a dark color theme
* undark.m - Converts dark theme plots back to the standard light theme
* test_dark.m - Tests dark.m with several plot types
* test_undark.m - Tests undark.m with several plot types

![Sample plot 1](./images/example1.PNG "Sample plot 1")

![Sample plot 2](./images/example2.PNG "Sample plot 2")

# Examples
### 1. Make a simple dark themed line plot

~~~~
plot(1:10); dark
~~~~

### 2. Convert an annotated multi-data-series bar plot to a dark theme. Draw blue bars for the first series and peach bars for the second.

~~~~
bar([(1:10)' (10:-1:1)']);
grid on;
legend('this','that','Location','North');
xlabel('Blivit');
ylabel('Barvid');
title('This and That');
dark('bp')
~~~~

> Written with [StackEdit](https://stackedit.io/).
