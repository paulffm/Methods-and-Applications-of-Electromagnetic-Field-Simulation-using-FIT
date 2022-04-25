% Aufgabe 9

% Methode zur Bestimmung der elektrischen Gitterspannungen 
% aus einem kontinuierlichen E-Feld 
%
% Eingabe
% msh             Struktur, wie sie mit cartMesh erzeugt werden kann
% field           Das konitnuierliche elektrische Feld als anonyme 
%                 Funktion. Die Funktion muss von der Form 
%                 @(r) fx(r)*([1,0,0])+fy(r)*([0,1,0])+fz(r)*([0,0,1])
%                 sein, wobei r ein dreidimensionaler Vektor ist.
%
% Rueckgabe
% fieldBow        Vektor mit den Gitterspannungen, sortiert nach dem 
%                 kanonischen Indizierungsschema fuer Kanten

function [ fieldBow ] = impField( msh, field )

% Gittereigenschaften aus struct holen
np = msh.np;
nx = msh.nx; ny = msh.ny; nz = msh.nz;
Mx = msh.Mx; My = msh.My; Mz = msh.Mz;
xmesh = msh.xmesh; ymesh = msh.ymesh; zmesh = msh.zmesh;

% Bogenspannungsvektor initieren
fieldBow = zeros(3*np,1);

% Schleife über alle Punkte
for i=1:nx
    for j=1:ny
        for k=1:nz
            % kanonischen Index n bestimmen
            n = 1+(i-1)*Mx + (j-1)*My + (k-1)*Mz;
            
            % x-, y- und z-Koordinate des Gitterpunktes bestimmen
            x = xmesh(i);
            y = ymesh(j);
            z = zmesh(k);
            
           
            % Bogenwert für x-Kante mit Index n
            if i<nx
              edgMX = ( x + xmesh(i+1) )/2;
              edgLX =   xmesh(i+1) - x;
            end
            fieldBow(n) = field(edgMX,y,z)(1) * edgLX;
            
            % Bogenwert für y-Kante mit Index n
            if j<ny
              edgMY = ( y + ymesh(j+1) )/2;
              edgLY =   ymesh(j+1) - y;
            end
            fieldBow(n+np) = field(x,edgMY,z)(2) * edgLY;
            
            % Bogenwert für z-Kante mit Index n
            if k<nz
              edgMZ = ( z + zmesh(k+1) )/2;
              edgLZ = zmesh(k+1) - z;
            end
            fieldBow(n+2*np) = field(x,y,edgMZ)(3) * edgLZ;
            
        end
    end
end
end

