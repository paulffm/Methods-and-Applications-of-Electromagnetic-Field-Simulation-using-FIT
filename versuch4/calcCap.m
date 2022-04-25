%   Methode zur Berechnung der Kapazitaet eines Plattenkondensators
%
%   Eingabe
%   msh           kartesisches Gitter, wie es von cartMesh erzeugt wird.
%   ebow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefuellt mit den elektrischen Gitterspannungen.
%   dbow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefuellt mit den elektrischen Gitterfluessen
% 
%   Rueckgabe
%   cap           Die Kapazitaet  des Kondensators

function cap = calcCap( msh, ebow, dbow )

% Berechnen der elektrischen Spannung zwischen den Platten
% line gibt den Integrationspfad an, wobei hier entlang der y-Achse
% integriert wird, da die Platten in der XZ-Ebene liegen

% Eine Beschreibung der Argumente von intEdge ist in intEdge.m zu finden
% line.u = 
% line.v = 
% line.w = 
% line.length = 
% line.normal = 
  line.u = 1;
  line.v = 1;
  line.w = 1;
  line.length = msh.ny-1;
  line.normal = [0 1 0];
U = intEdge(msh, ebow, line);

% Berechnen der Ladung auf den Kondensatorplatten mit dem Gauss'schen 
% Gesetz, surface gibt die Integrationsflaeche an, die hier in y-Richtung
% gerichtet ist. Eine Beschreibung der Argumente von intSurf ist in intSurf.m zu finden.
% surface.ul = 
% surface.uh = 
% surface.vl = 
% surface.vh = 
% surface.normal = 
% surface.w = 

  surface.ul = 1;
  surface.uh = msh.nx;
  surface.vl = 1;
  surface.vh = msh.nz;
  surface.normal = [0 1 0];
  surface.w = ceil(msh.ny/2);
    
Q = intSurf(msh, dbow, surface);

% Berechnen der Kapazitaet aus Q und U
% cap =
cap = Q/U;
end
