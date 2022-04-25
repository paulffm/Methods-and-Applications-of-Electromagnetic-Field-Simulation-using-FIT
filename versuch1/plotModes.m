%Skript zur Darstellung der ersten beiden Eigenmoden. Verwendet createCC 
%(Erstellung der Systemmatrix) und solveCC (Loesen des Eigenwertproblems).
clc;close all;clear all;
% setzen der parameter n, ord, bc, L
n=100;
ord=4;
bc=1;
L=5;

% Erstellen der CC matrix
[cc] = createCC(n,ord,bc);
% Gitterschrittweite bestimmen
dx = L/n;
% Loesen der Eigenwertgleichung mit solveCC
[kx,modes] = solveCC(cc,dx);
% Sonderbetrachtung fuer magnetische Randbedingungen
if bc==2
    % Loesche ersten Mode, denn er ist nur die statische Loesung (konstant)
    modes = modes(:,2:size(modes,2));
end

% x-Koordinaten fuer jede Stuetzstelle in einen Vektor schreiben
x = 0:dx:L-dx;

% Grundmode und 2.Mode plotten
figure(1)
hold all
plot(x,modes(:,1));
plot(x,modes(:,2));
hold off
legend({'erster Mode','zweiter Mode'},'Location','Southeast')
xlabel('x in m')
ylabel('Amplitude E-Feld (ohne Einheit)')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
set(gca,"fontsize",20);
print -depsc modes.eps
