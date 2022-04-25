% Methode zur Erstellung der Materialmatrix Deps.
%
% Eingabe 
%	msh         kartesisches Gitter, erzeugt von cartMesh
% 	DA          Die DA Matrix, erzeugt von createDA (DS) 
% 	DAt         Die DAt Matrix, erzeugt von createDA (DSt) 
%	eps_r       Ein Vektor der Länge np, in dem die relativen
%               Epsilon-Werte für alle Elemente in kanonischer
%               Indizierung eingetragen sind.
%   bc          bc=0 für keine Randbedingungen
%				bc=1 für elektrische Randbedingungen
%
% Rückgabe 
%	Deps        Die Matrix Deps der gemittelten Permittivitäten


function [ Deps ] = createDeps( msh, DA, DAt, eps_r, bc ) 

if size(eps_r,1) == msh.np
    eps_r = [eps_r;eps_r;eps_r]; %3*np x 1
end

% für diese Funktion brauchen wir die folgenden Größen des Meshes
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np = msh.np;
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np=nx*ny*nz;
% Berechnen der Permittivität aus der relativen Permittivität
eps0 = 8.854187817*10^-12;
eps = eps_r*eps0;

% Nur die Diagonale der DA und DAt Matrix ist besetzt, also brauchen wir nur die Diagonale
At = diag(DAt);
A  = diag(DA);

% Berechnen der Flächen für die Flächen in x-, y- und z-Richtung
Atx = At(1:np);
Aty = At(np+1:2*np);
Atz = At(2*np+1:3*np);

Ax = A(1:np);
Ay = A(np+1:2*np);
Az = A(2*np+1:3*np);

% Erstellen der Vektoren für die gemittelten epsilon Werte für x-, y- und z-Flächen
meanEpsX = zeros(np, 1);
meanEpsY = zeros(np, 1);
meanEpsZ = zeros(np, 1);

% Gehe durch alle Punkte und setze die gemittelten epsilon Werte für x-, y- und z-Flächen
% Beachten Sie, dass manche Indizes in der Formel im Skript kleiner als 1 werden können und
% damit speziell behandelt werden müssen (if anweisung)

for i = 1:nx
    for j = 1:ny
        for k = 1:nz
            n=i+(j-1)*nx +(k-1)*nx*ny;
            
          if (j==1) && (k==1)
              meanEpsX(n) = 1/4 * eps(n)*Ax(n) * 1/Atx(n);
          elseif (k==1) && (j>1)
              meanEpsX(n) = 1/4 * ( eps(n)*Ax(n) + eps(n-My)*Ax(n-My) ) * 1/Atx(n);
          elseif (j==1) && (k>1)
               meanEpsX(n) = 1/4 * ( eps(n)*Ax(n) + eps(n-Mz)*Ax(n-Mz) ) * 1/Atx(n);
          else
               meanEpsX(n) = 1/4 * ( eps(n)*Ax(n) + eps(n-Mz)*Ax(n-Mz) + eps(n-My)*Ax(n-My) + eps(n-My-Mz)*Ax(n-My-Mz) ) * 1/Atx(n);
          end
          
          if(i==1) && (k==1) 
            meanEpsY(n) = 1/4 * eps(n+np)*Ay(n) * 1/Aty(n);
          elseif (i>1) && (k==1)
            meanEpsY(n) = 1/4 * ( eps(n+np)*Ay(n) + eps(n+np-Mx)*Ay(n-Mx) ) * 1/Aty(n);
          elseif (i==1) && (k>1)
            meanEpsY(n) = 1/4 * ( eps(n+np)*Ay(n) + eps(n+np-Mz)*Ay(n-Mz) ) * 1/Aty(n);
          else 
            meanEpsY(n) = 1/4 * ( eps(n+np)*Ay(n) + eps(n+np-Mx)*Ay(n-Mx) + eps(n+np-Mz)*Ay(n-Mz) + eps(n+np-Mz-Mx)*Ay(n-Mz-Mx) ) * 1/Aty(n);
          end
          
          if (i==1) && (j==1)
            meanEpsZ(n) = 1/4 * eps(n+2*np)*Az(n) * 1/Atz(n);
          elseif (i>1) && (j==1)
            meanEpsZ(n) = 1/4 * ( eps(n+2*np)*Az(n) + eps(n+2*np-Mx)*Az(n-Mx) ) * 1/Atz(n);
          elseif (j>1) && (i==1)
            meanEpsZ(n) = 1/4 * ( eps(n+2*np)*Az(n) + eps(n+2*np-My)*Az(n-My) ) * 1/Atz(n);
          else
            meanEpsZ(n) = 1/4 * ( eps(n+2*np)*Az(n) + eps(n+2*np-Mx)*Az(n-Mx) + eps(n+2*np-My)*Az(n-My) + eps(n+2*np-My-Mx)*Az(n-My-Mx) ) * 1/Atz(n);
          end
          
        end
    end
end
%% Randbedingungen

% Spezialfall nur bei PEC Rand (bc=1)
if bc==1
    for i=1:nx
        for j=1:ny
            for k=1:nz
              n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
              if or(i==1,i==nx)
                meanEpsY(n) = 0; meanEpsZ(n) = 0;
                
              elseif or(j==1,j==ny)
                meanEpsX(n) = 0; meanEpsZ(n) = 0;
              
              elseif or(k==1,k==nz)
                meanEpsX(n) = 0; meanEpsY(n) = 0;
              end
              
            end
        end
    end
end
    
% Matrix Deps mithilfe des Diagonalenvektors (spdiags) erzeugen
Deps = spdiags([meanEpsX; meanEpsY; meanEpsZ], 0, 3*np, 3*np);
    
end