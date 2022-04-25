%   Aufgabe 6
%
%   Erstellt einen Graphen, in dem die Kapazitaet der Kondensatorkon-
%   figuration e) ueber der Anzahl der Gitterpunkte np aufgetragen ist.

%   Sie koennen nahezu analog zu Aufgabe 5 vorgehen. Sie muessen die
%   Berechnung noch auf das Kovergenzverhalten hinsichtlich des Gitters
%   anpassen. Sie benoetigen daher die Kapazitaet. Berechnen Sie diese
%   mit calcCap(msh, ebow, dbow).
clc;clear;close all;
% Parameter und Initialisierungen
N = 50;
stuetzstellen = 5:2:(N+5);
cap = zeros(N/2+1,1);
nrgridpoints = zeros(N/2+1,1);

for i = 1:length(stuetzstellen)
    
    n = stuetzstellen(i);
    
    % Erstellen des kartesischen Gitters mit cartMesh
    xmesh = linspace(0,1,n);
    ymesh = linspace(0,1,n);
    zmesh = linspace(0,1,5);
    msh = cartMesh(xmesh,ymesh,zmesh);
	
    % Berechnen der Permittivitaet mit boxMesher
    % defaultvalue = 
    % ...
    
    defaultvalue = 1;
    boxesE(1).box = [1, msh.nx, 1, msh.ny, 1, msh.nz];
    boxesE(1).value = 1;

    boxesPotE(1).box = [1, msh.nx, 1, 1, 1, msh.nz];
    boxesPotE(1).value = 0;
    boxesPotE(2).box = [1, floor(msh.nx/2), floor(msh.ny/2), msh.ny, 1, msh.nz];
    boxesPotE(2).value = 1;
    boxesPotE(3).box = [ceil(msh.nx/2), msh.nx, msh.ny, msh.ny, 1, msh.nz];
    boxesPotE(3).value = 1;
    
    eps = boxMesher(msh, boxesE, defaultvalue);
    
    % Erstellen des Potentialvektors mit den eingepraegten Potentialen (auch mit boxMesher)
    % ...
    pot = boxMesher(msh, boxesPotE, NaN);
    % Berechnen der Feldverteilung
    bc = 0;
    q = zeros(msh.np, 1);
    [phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q, bc);
    
    % Berechnen und speichern der Kapazitaet
    cap(i) = calcCap(msh, ebow, dbow);
	
    % Anzahl der Gitterpunkte speichern
    % nrgridpoints(i) = 
    nrgridpoints(i) = 3*n;
end

% Plot
figure(1); clf;
plot(nrgridpoints, cap, 'b.-', 'LineWidth', 2);
xlabel('Anzahl der Punkte np');
ylabel('Numerisch berechnete Kapazitaet des Kondensators / F');
set(gca,"fontsize",20);
#%print -depsc V4D6.eps
