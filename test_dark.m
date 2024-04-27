% Test dark themed plots

close all

plot([(1:10)' (10:-1:1)'],'o-');
grid on
legend('this','that')
xlabel('blivit')
ylabel('barvid')
title('This and That')
drawnow
pause(1)
dark
pause(2)

close all
stem([(1:10)' (10:-1:1)'],'o-','MarkerFaceColor','k')
grid on
legend('this','that')
xlabel('blivit')
ylabel('barvid')
title('This and That')
drawnow
pause(1)
dark
pause(2)

close all
barh([(1:10)' (10:-1:1)']);
grid on
legend('this','that')
xlabel('blivit')
ylabel('barvid')
title('This and That')
drawnow
pause(1)
dark
pause(2)

close all
bar([(1:10)' (10:-1:1)']);
grid on
legend('this','that')
xlabel('blivit')
ylabel('barvid')
title('This and That')
drawnow
pause(1)
dark('bp')
pause(2)

close all
m = -0.4;
b = 10;
b1 = 6;
x1 = 100*rand(100,1);
y1 = m*x1 + b1 + randn(100,1);
b2 = 14;
x2 = 100*rand(100,1);
y2 = m*x2 + b2 + randn(100,1);
x = (0:99)';
y = m*x + b;
plot(x1,y1,'.',x2,y2,'.','MarkerSize',10);
hold on; plot(x,y,'--','LineWidth',2);
legend('this','that')
xlabel('blivit')
ylabel('barvid')
title('This and That')
grid on;
drawnow
pause(1)
dark
pause(2)

close all
t = 0:pi/50:10*pi;
st = sin(t);
ct = cos(t);
plot3(st,ct,t)
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('3-d plot')
pause(1)
dark
pause(2)

close all
Z = 10 + peaks;
surf(Z)
hold on
imagesc(Z)
grid off
hold off
xlabel('X')
ylabel('Y')
zlabel('Z')
title('3-d plot on top of imagesc')
colorbar;
pause(1)
dark
