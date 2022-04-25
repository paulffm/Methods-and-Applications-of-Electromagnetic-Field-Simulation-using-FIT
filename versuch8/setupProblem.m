% setupProblem(mur,epsr) definiert das Problem für gegebene relative
% Permittivität epsr und Permeabilität mur
function [Meps,Mmui,c] = setupProblem(epsr,mur)

if ~exist('epsr','var'), epsr = 0.9; end
if ~exist('mur','var'), mur = 1; end

% Geometrie definieren
deltax = 1e-2;
deltay = 1e-2;
deltaz = 1e-2;
xmesh = 0:deltax:3e-2;
ymesh = 0:deltay:3e-2;
zmesh = 0:deltaz:150e-2;
msh = cartMesh(xmesh,ymesh,zmesh);
np = msh.np;
nz = msh.nz;
Mz = msh.Mz;
[ds,dst,da,dat] = createGeoMats(msh);

% Konstanten für Vakuum
mu0 = 4e-7*pi;
eps0 = 8.854e-12;

% Material-Vektoren aufbauen
epsilon = epsr*eps0*ones(np,1);
mu = mur*mu0*ones(np,1);
mui = 1./mu;

% Materialmatrizen mit entsprechenden Randbedingungen erstellen
Mmui = createMmui(msh,ds,dst,da,mui,[1,1,1,1,0,0]);
Meps = createMeps(msh,ds,da,dat,epsilon,[1,1,1,1,0,0]);

% Indizes in erster z-Ebene, um PEC für Innenleiter in Meps zu setzen
idxXedgePECfront = [6,10];
idxYedgePECfront = np+[6,7];
idxZedgePECfront = 2*np+[6,7,10,11];
idxEdgePECfront = [idxXedgePECfront,idxYedgePECfront,idxZedgePECfront];

% Indizes für alle PEC-Kanten des Innenleiters
idxEdgePEC = repmat(idxEdgePECfront,nz,1) + repmat((0:(nz-1))'*Mz,1,length(idxEdgePECfront));
idxEdgePEC = sort(idxEdgePEC(:));

% PEC Innenleiter in Meps einarbeiten
Meps(idxEdgePEC,idxEdgePEC) = 0;

% Indizes in erster z-Ebene, um PEC für Innenleiter in Mmui zu setzen
idxXdualEdgePECfront = [6,7];
idxYdualEdgePECfront = np+[6,10];
idxZdualEdgePECfront = 2*np+6;
idxDualEdgePECfront = [idxXdualEdgePECfront,idxYdualEdgePECfront,idxZdualEdgePECfront];

% Indizes für alle PEC-Kanten des Innenleiters
idxDualEdgePEC = repmat(idxDualEdgePECfront,nz,1) + repmat((0:(nz-1))'*Mz,1,length(idxDualEdgePECfront));
idxDualEdgePEC = sort(idxDualEdgePEC(:));

% PEC Innenleiter in Mmui einarbeiten
Mmui(idxDualEdgePEC,idxDualEdgePEC) = 0;

% curl-Matrix zurückgeben
[c,~,~] = createTopMats(msh);

end