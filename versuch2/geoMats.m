% Aufgabe 4

% Methode zur Berechnung der C, S und St (S-Schlange) Matrizen
%
% Eingabe
% msh        Die Datenstruktur, die mit cartMesh erzeugt werden kann
%
% Rueckgabe
% c           Die C-Matrix des primaeren Gitters
% s           Die S-Matrix des primaeren Gitters
% st          Die S-Matrix des dualen Gitters
clc;clear all;close all; 
function [ c, s, st ] = geoMats( msh )

% Bestimmen von Mx, My, Mz sowie np aus struct msh
Mx = msh.Mx; My = msh.My; Mz = msh.Mz;
np = msh.np;

% Px Matrix erzeugen
Px = sparse(np,np);
for row = 1:size(Px,1)
  for col = 1:size(Px,2)
    if row == col
      Px(row,col) = -1;
    
    elseif col == row + Mx
      Px(row,col) = 1;
    
    else
      Px(row,col) = 0;
    end
  end  
end

% Py-Matrix erzeugen
Py = sparse(np,np);
for row = 1:size(Py,1)
  for col = 1:size(Py,2)
    if row == col
      Py(row,col) = -1;
    
    elseif col == row + My
      Py(row,col) = 1;
    
    else
      Py(row,col) = 0;
    end
  end  
end

% Pz-Matrix erzeugen
Pz = sparse(np,np);
for row = 1:size(Pz,1)
  for col = 1:size(Pz,2)
    if row == col
      Pz(row,col) = -1;
    
    elseif col == row + Mz
      Pz(row,col) = 1;
    
    else
      Pz(row,col) = 0;
    end
  end  
end

% Matrix derselben Groesse, gefuellt mit Nullen
null = sparse(np,np);

% Aufbau der C, S und St Matrizen aus den P-Matrizen
c  = [ [null,-Pz,Py] ; [Pz,null,-Px] ; [-Py,Px,null]];
s = [Px,Py,Pz];
st = [-Px', -Py', -Pz'];
end
xmesh = [1, 4];
ymesh = xmesh;
zmesh = xmesh;
msh = cartMesh(xmesh,ymesh,zmesh);
[c,s,st] = geoMats(msh);
