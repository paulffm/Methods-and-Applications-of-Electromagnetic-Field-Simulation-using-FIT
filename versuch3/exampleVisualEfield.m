%% Aufgabe Visualisierung E-Feld 
clc;clear;close all;
% Erstellen des Meshs und benötigter Geometrie-Matrizen
xmesh = linspace(-3,3,16);
ymesh = linspace(-3,3,16);
zmesh = linspace(1,3,3);

msh = cartMesh(xmesh, ymesh, zmesh);

%% Erzeugen benötigter Geometriematrizen
[DS, DSt] = createDS(msh);
[DA] = createDA(DS);
[DAt] = createDA(DSt);
DAtDiag = diag(DAt);

%% Spezifikation des kartesischen Gitters 
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;

%% Berechnung von dBow
% ...
#field = @(x,y,z) ( 1/(sqrt(x^2+y^2)^3)*[x,y] );

dBow=zeros(3*np,1);
%x-Komponente
for i=1:(nx-1)
  for j=1:ny
    for k=1:nz
      nX = 1+ (i-1)*Mx+(j-1)*My+(k-1)*Mz;
      x = (xmesh(i) + xmesh(i+1))/2;
      y = ymesh(j);
      dBow(nX) = DAt(nX, nX) * x/((x^2+y^2)^(3/2));
    end
  end
end
%y-Komponente
for i=1:nx
  for j=1:(ny-1)
    for k=1:nz
      nY = 1+(i-1)*Mx+(j-1)*My+(k-1)*Mz+np;
      x = xmesh(i);
      y = (ymesh(j)+ymesh(j+1))/2;
      dBow(nY) = DAt(nY, nY) * y/((x^2+y^2)^(3/2));
    end
  end
end

%% Isotrope Permittivität
eps_r = ones(3*np,1);

%bc = ; % PEC
bc = 1;
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(1);
plotEBow(msh,eBow,2);
title('Isotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');


figure(2);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Isotropes E-Feld');
xlabel('x in m');
ylabel('y in m');


% Folge-Aufgabe: Anisotrope Permittivität
%eps_r(1:np) =
eps_r_x=ones(np,1);
eps_r_y=eps_r_x/4;
eps_r = [eps_r_x;eps_r_y;eps_r_y];

%bc = ; % PEC
bc=1;
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(3);
plotEBow(msh,eBow,2);
title('Anisotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');


figure(4);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Anisotropes E-Feld');


