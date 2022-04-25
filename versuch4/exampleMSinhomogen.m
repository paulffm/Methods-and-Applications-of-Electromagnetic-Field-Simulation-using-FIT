% Aufgabe 10

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);

msh = cartMesh(xmesh, ymesh, zmesh);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

% Erstellen des Strom-Vektors ( Index berechnen und benutzen)
% jbow = 
% ...

jbow = zeros(3*np,1);
#% Strom ist nur auf mittlerer z-Kante allokiert => xy-Komponenten (erste 2*np Einträge) = 0
for i=1:msh.nx
  for j=1:msh.ny
    for k=1:msh.nz
      
      n = 1 + ( i-1 )*Mx + ( j-1 )*My + ( k-1 )*Mz;         #% kanonischer Index
      if  ( n==ceil( (msh.nx*msh.ny)/2 ) +  Mz*(k-1) )      #% wenn betrachteter Punkt Mittelpunkt ist => weise Strom zu!
        jbow(n+2*np) = 1000/(1/100); 
      end

    end
  end
end

% Erstellen der Permeabilitätsmatrix mit boxMesher
% mu = 
# In y-Richtung in der Hälfte geteilte Permeabilität
defaultvalue = 1;
boxesMu(1).box = [1, msh.nx, 1, floor(msh.ny/2), 1, msh.nz];
boxesMu(1).value = 100;
boxesMu(2).box = [1, msh.nx, ceil(msh.ny/2), msh.ny, 1, msh.nz];
boxesMu(2).value = 20;

mu = boxMesher(msh, boxesMu, defaultvalue);

% Lösen des Systems
[hbow, bbow, relRes] = solveMS(msh, mu, jbow);

figure(1); clf;
plotEdgeVoltage (msh, hbow, ceil(msh.nz/2), [0, 0, 0, 0, 0, 0]);
xlabel('x')
ylabel('y');
set(gca,"fontsize",20);
#%print -depsc V4D10.eps