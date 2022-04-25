% Aufgabe 10

% Skript, das die diskreten Felder a) und b) mithilfe eines Vektor-
% feldes visualisiert.
% Verwendet werden die Methoden aus den vorherigen Aufgabe.
clc; clear; close all;
%% Aufgabe 9
% Beispielgitter erzeugen (3D)
xmesh = [1, 4, 7];
ymesh = [1, 3, 7, 8];
zmesh = [1, 2, 5, 6, 8];
%% msh struct berechnen
msh = cartMesh(xmesh, ymesh, zmesh);

%% anonymous function der beiden gegebenen Felder bestimmen
% f1 = 
% f2 = 
f1 = @(x,y,z) ( [5/2, -1.3, 2] );
f2 = @(x,y,z) ( [0, 3*sin(pi/(max(xmesh)-min(xmesh)))*(x-min(xmesh)), 0] );

%% Bogengröße der beiden Felder mithilfe von impField bestimmen
fbow1 = impField( msh, f1 );
fbow2 = impField( msh, f2 );

%% diskretes Feld fbow mithilfe von plotArrowfield plotten
figure;
plotEdgeVoltage(msh, fbow1);
xlabel('x'); ylabel('y'); zlabel('z');

figure;
plotEdgeVoltage(msh, fbow2);
xlabel('x'); ylabel('y'); zlabel('z');
#print -depsc V2D10.eps