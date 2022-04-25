clc; clear all; close all;


figure(1)

[X1,Y1,Z1,normal1,stlname1] = read_stl('zylinder.stl');
patch(X1,Y1,Z1,'m');

title('Cylinder',"fontsize",20);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
view(40,30);
set(gca,"fontsize",20);
print -depsc cylinder.eps

figure(2)
[X2,Y2,Z2,normal2,stlname2] = read_stl('w210.stl');
patch(X2,Y2,Z2,'c');

title('Car',"fontsize",20);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
view(-40,30);
set(gca,"fontsize",20);
print -depsc car.eps
