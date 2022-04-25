% Methode zur Erstellung der Materialmatrix Meps.
%
% Eingabe 
% DAt           Die DAt Matrix
% Deps          Die Deps Matrix
% DS			Die DS Matrix

% Rückgabe 
% Meps          Die Materialmatrix Meps mit Länge 3*np


function [ Meps ] = createMeps( DAt, Deps, DS )

% ein Einzeiler :)
  Meps = DAt * Deps * nullInv(DS);
end