%Skript zur Ueberpruefung der Orthogonalitaet

clc;clear all;close all;

% Setzen der parameter n, ord, bc, L
n=6;
ord=2;
bc=0;
L=1;

% Erstellen der CC matrix
cc = createCC(n,ord,bc);

% Gitterschrittweite bestimmen
dx = L/n;

% Loesen der Eigenwertgleichung mit solveCC
[kx,modes] = solveCC(cc,dx);

% Ueberpruefung der Orthogonalitaet der Eigenvektoren

%Multipliziere modes' mit modes alle Elemente abgesehen der Hauptdia
%gonalen muessen 0 sein.
isOrth = modes'*modes;

figure(1)
set(gca,"fontsize",20);
imagesc(isOrth);
print -depsc check_orth.eps
