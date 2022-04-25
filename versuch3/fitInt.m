% Methode zur Interpolation des diskreten elektrischen Feldes eBow auf die
% Punkte des kartesischen Gitters.
%
% Eingabe
% msh                Das kartesische Gitter als msh, erzeugt von cartMesh
% eBow               Das diskrete elektrische Feld auf den Kanten des
%                    Gitters, sortiert nach kanonischer Indizierung
% 
% Rückgabe
% meshP              Das reduzierte, kartesische Gitter mesh, bei dem 1. und letzter Punkt fehlen
% eField             Das elektrische Feld, interpoliert auf die Punkte des
%                    reduzierten primären Gitters

function [ meshP, eField ] = fitInt( msh, eBow )

% Spezifikationen des kartesischen Gitters
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np=nx*ny*nz;
% Kantenlängen bestimmen
[DS, ~] = createDS(msh);
DSd=diag(DS);
dx=DSd(1:np);
dy=DSd(np+1:2*np);
dz=DSd(2*np+1:3*np);
% Berechnen der Bogenwerte in X,Y,Z-Richtung
eEdgeX = eBow(1:np);
eEdgeY = eBow(np+1:2*np);
eEdgeZ = eBow(2+np+1:3*np);

%% Interpolation des E-Feldes
eX = zeros(np,1);
eY = zeros(np,1);
eZ = zeros(np,1);
for k = 1:nz
    for j = 1:ny
        for i = 1:nx
            % Berechnung des kanonischen Index
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
            if (j==1)
              eY(n) = eEdgeY(n)/dy(n);
            elseif (j==ny)
              eY(n) = eEdgeY(n-My)/dy(n-My);
            else
              eY(n) = ( (eEdgeY(n-My)/dy(n-My)) * dy(n) + (eEdgeY(n)/dy(n)) * dy(n-My) ) / (dy(n-My)+dy(n) );
            end
            
            % x-Richtung
            if or( (j==1), (j==ny), (k==1), (k==nz) )
              eX(n) = 0;
            elseif (i==1)
              eX(n) = eEdgeX(n)/dx(n);
            elseif (i==nx)
              eX(n) = eEdgeX(n-Mx)/dx(n-Mx);
            else
              eX(n) = ( (eEdgeX(n-Mx)/dx(n-Mx)) * dx(n) + (eEdgeX(n)/dx(n)) * dx(n-Mx) ) / ( dx(n-Mx)+dx(n) );
            end
            
            % z-Richtung
            if or( (i==1), (i==nx), (j==1), (j==ny) )
              eZ(n) = 0;
            elseif (k==1)
              eZ(n) = eEdgeZ(n)/dz(n);
            elseif (k==nz)
              eZ(n) = eEdgeZ(n-Mz)/dz(n-Mz);
            else
              eZ(n) = ( (eEdgeZ(n-Mz)/dz(n-Mz)) * dz(n) + (eEdgeZ(n)/dz(n)) * dz(n-Mz) ) / (dz(n-Mz)+dz(n) );
            end
      end
   end
end

eField = [eX, eY, eZ];

% meshP ist das reduzierte Gitter, das heißt ohne 1. und letzten Punkt
meshP = cartMesh(msh.xmesh(2:end-1), msh.ymesh(2:end-1), msh.zmesh(2:end-1));
