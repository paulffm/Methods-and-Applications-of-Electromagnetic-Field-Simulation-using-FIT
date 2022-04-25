clc;clear;close all;
%% Beispielgitter definieren (3D)
xmesh = [1:17];
%xmesh = [1, 3, 5, 7, 9];
ymesh = xmesh;
zmesh = ymesh;

% Erzeugen des Gitters
msh = cartMesh(xmesh, ymesh, zmesh);

% Erzeugen der Matrizen c, s, st und ct
[c, s, st] = geoMats(msh);
ct = c';

% Darstellen der Matrizen mit spy.
figure;
spy(c);
title('Visualisierung der C-Matrix des primaren Gitters.');

figure;
spy(s);
title('Visualisierung der S-Matrix des primaren Gitters.');

figure;
spy(st);
title('Visualisierung der S-Matrix des dualen Gitters.');

figure;
spy(ct);
title('Visualisierung der C-Matrix des dualen Gitters.');

% Speicherbedarf in Byte ermitteln
[x,y] = size(c);
storageC = x*y*8;
storageCsparse = length(find(c ~= 0))*8;
printf('Speicherplatz fuer volle Matrix C: %d Byte\n',storageC);
printf('Speicherplatz fuer Matrix C im sparse-Format: %d Byte\n',storageCsparse);
