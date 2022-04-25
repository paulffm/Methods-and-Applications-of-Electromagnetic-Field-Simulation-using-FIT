% Berechnung der Materialmatrix Meps für elektrische Randbedingungen
% für die vorgegebenen Werte
%% Erzeugen des kartesischen Gitters
clc;clear;
xmesh=[-2,0,2];
ymesh=[-1,0,1];
zmesh=[0,1];
%msh = cartMesh(        );
msh = cartMesh(xmesh,ymesh,zmesh);

%% Erzeugen benötigter Geometriematrizen
% [DS, DSt] = createDS();
% DA = createDA();
% DAt = 
[DS,DSt] = createDS(msh);
DA = createDA(DS);
DAt = createDA(DSt);

%% Permittivitäten für jedes Element festlegen
% eps_r =
eps_r = ones(msh.np,1);

%% Berechnen der Meps-Matrix
% bc =
% Deps = createDeps( msh, DA, DAt, eps_r, bc );
% Meps = createMeps( DAt, Deps, DS );
bc = 1;
Deps = createDeps(msh,DA,DAt,eps_r,bc);
Meps = createMeps(DAt, Deps, DS);
