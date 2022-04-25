% Methode zur Berechnung der DA oder DAt Matrix. Die Berechnung beider Matrizen
% erfolgt analog. Daher koennen mit dieser Methode beide Matrizen berechnet
% werden. Falls DSt als Matrix uebergeben wird, entsteht DAt, falls DS als
% Matrix übergeben wird, entsteht DA.
%
% Eingabe
% DS               Matrix DS oder DSt, erzeugt von createDS
% 
% Rückgabe
% DA               Matrix DA oder DAt, je nach Eingabe.

function [ DA ] = createDA( DS )

% Anzahl der Punkte
np = size(DS,1)/3;

%% Berechnen der Flächen in xyz-Richtung
DSdiag =diag(DS);

DSx = DSdiag(1:np);
DSy = DSdiag(np+1:2*np);
DSz = DSdiag(2*np+1:3*np);

for i=1:np
  Ax(i) =DSy(i)*DSz(i);
  Ay(i) =DSx(i)*DSz(i);
  Az(i) =DSx(i)*DSy(i);
end

Ax=Ax.';
Ay=Ay.';
Az=Az.';

% Zusammenfügen zur Gesamtmatrix DA bzw. DAt
DA = spdiags( [Ax; Ay; Az], 0, 3*np, 3*np);

end