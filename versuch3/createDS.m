% Methode zum Erstellen der Geometriematrizen DS und DSt
%
% Eingabe
% msh           Struktur, die von cartMesh erzeugt wird. Benutzen Sie
%               hierfür die bereitgestellte Methode.
%
% Rueckgabe
% DS            DS-Matrix
% DSt           DSt-Matrix
% Erzeugen des Gitters

function [ DS, DSt ] = createDS( msh )
  
  %% nx, ny, nz und np aus msh struct holen
  nx = msh.nx;
  ny = msh.ny;
  nz = msh.nz;
  np = msh.np;
  xmesh=msh.xmesh;
  ymesh=msh.ymesh;
  zmesh=msh.zmesh;

  %% Erstellen der Matrix DS
  % Überlegen Sie sich, wie Sie die von Matlab bereitgestellte Methode diff
  % geschickt verwenden können. Achten Sie auch auf die Geisterkanten

  %Gitterabstände/Schrittweiten entlang der x-Achse
  %dx = [   ,   ];
  dx = [diff(xmesh),0];

  % Gitterabstände/Schrittweiten entlang der y-Achse
  %dy = [   ,   ];
  dy = [diff(ymesh),0];

  % Gitterabstände/Schrittweiten entlang der z-Achse
  %dz = [   ,   ];
  dz = [diff(zmesh),0];

  % Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
  % Ist aufgrund der schwierigen Implementation schon gegeben. 
  % Versuchen sie sich aber klar zu machen,
  % was die 3 komplizierten reshape und repmat Konstrukte eigentlich tun.
  DSdiag = [repmat(dx, 1, ny*nz), ...
          repmat(reshape(repmat(dy, nx, 1), 1, nx*ny), 1, nz),...
          reshape(repmat(dz, nx*ny, 1), 1, np)];

  % aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
  DS = spdiags(DSdiag', 0, 3*np, 3*np);

  %% Das Gleiche nochmal für die Matrix DSt

  % Gitterabstände/Schrittweiten entlang der x-Achse
  xmesht=zeros(1,nx-1);
  ymesht=zeros(1,ny-1);
  zmesht=zeros(1,nz-1);
  
  for i=1:nx-1
   xmesht(i)=0.5*(xmesh(i)+xmesh(i+1));
  end
  
  for j=1:ny-1
      ymesht(j)=0.5*(ymesh(j)+ymesh(j+1));
  end
  
  for k=1:nz-1
      zmesht(k)=0.5*(zmesh(k)+zmesh(k+1));
  end
  
  % Gitterabstände/Schrittweiten entlang der x-Achse
  % Siehe Abbildung 3.2
  %dxt = 
  dxt = [ dx(1)/2 , diff(xmesht) , dx(nx-1)/2 ];

  % Gitterabstände/Schrittweiten entlang der y-Achse
  %dyt =
  dyt = [ dy(1)/2 , diff(ymesht) , dy(ny-1)/2 ];

  % Gitterabstände/Schrittweiten entlang der z-Achse
  %dzt = 
  dzt = [ dz(1)/2, diff(zmesht) , dz(nz-1)/2 ];

  %repmat kopiert Matrix dxt 1mal in Zeile und in Spalten Richtung ny*nz
  %mal=b
  %reshape arbeitet c spaltenweise ab: schreibt n (hier 1) elemente in 
  %die erste spalte von d:, dann wechselt es in die zweite spalte von d
  %bis nx*nz Spalten mit einem Element gefüllt sind
  %d wird dann wieder einmal in die zeile kopiert und in nz Spalten
  %
  % Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
  DStdiag = [repmat(dxt, 1, ny*nz), ...
      repmat(reshape(repmat(dyt, nx, 1), 1, nx*ny), 1, nz),...
      reshape(repmat(dzt, nx*ny, 1), 1, np)];

  % aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
  %DSt = 
  DSt=spdiags(DStdiag.',0,3*np,3*np);
end