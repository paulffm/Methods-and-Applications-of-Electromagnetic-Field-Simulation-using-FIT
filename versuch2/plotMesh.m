% Aufgabe 2

% Methode zum Plotten des mit cartMesh erzeugten kartesischen Gitters.
%
% Eingabe
% msh           Struktur, wie sie mit cartMesh erzeugt werden kann.
function [  ] = plotMesh( msh )

  % Zuweisen von nx, nz, nz, xmesh, ymesh und zmesh
  nx = msh.nx; ny = msh.ny; nz = msh.nz;
  xmesh = msh.xmesh; ymesh = msh.ymesh; zmesh = msh.zmesh;

  % Zeichnen aller Kanten mithilfe einer Dreifachschleife
  figure;
  for i=1:nx
      for j=1:ny
          for k=1:nz
              % x-Kante zeichnen, falls keine Geisterkante vorliegt
              if i<nx
                line( [xmesh(i) xmesh(i+1)] , [ymesh(j) ymesh(j)] , [zmesh(k) zmesh(k)]);
              end
              % y-Kante zeichnen, falls keine Geisterkante vorliegt
              if j<ny
                line( [xmesh(i) xmesh(i)] , [ymesh(j) ymesh(j+1)] , [zmesh(k) zmesh(k)]);
              end
              % z-Kante zeichnen, falls keine Geisterkante vorliegt
              if k<nz
                line( [xmesh(i) xmesh(i)] , [ymesh(j) ymesh(j)] , [zmesh(k) zmesh(k+1)]);
              end
          end
      end
  end
  xlabel('x');ylabel('y');zlabel('z');
  
end