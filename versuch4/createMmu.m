%   Identisch zu Methode createMeps nur für die Permeabilität bei M-Statik Problemen
%
%   Erzeugt die geometrischen Matrizen für ein kanonisches 
%   kartesisches Gitter.
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   ds          Primäre Kanten-Matrix
%   da          Primäre Flächen-Matrix
%   dat         Duale Flächen-Matrix        
%
%   Rückgabe
%   Mmu        Materialmatrix der Permittivitäten

function Mmu = createMmu(msh, ds, da, dat, mu)
    
    if nargin < 5
        warning('Zu wenig Eingabeparameter.')
    end
    
    mu0 = 4*pi*10^(-7);
   
    nx = msh.nx;
    ny = msh.ny;
    nz = msh.nz;
    np = msh.np;
    
    if numel(mu)==np
    
        % Inhomogener Fall: Mittelung Permittivität
        zeromat = sparse(np,np);

        cells = repmat([repmat([ones(nx-1,1); 0], ny-1, 1); zeros(nx,1)], nz, 4);
        avex = spdiags(cells, [0 -nx -nx*ny -(nx+nx*ny)], np, np);
        avey = spdiags(cells, [0 -nx*ny -1 -(nx*ny+1)], np, np);
        avez = spdiags(cells, [0 -1 -nx -(1+nx)], np, np);

        ave = [avex zeromat zeromat;
                zeromat avey zeromat;
                zeromat zeromat avez];

        dmu = spdiags(mu0*nullInv(dat)/4*(ave*da*[mu; mu; mu]), 0, 3*np, 3*np);
        
    elseif numel(mu)==3
        
        % Homogener anisotroper Fall
        dmu = mu0*spdiags([mu(1)*ones(1,np), mu(2)*ones(1,np), mu(3)*ones(1,np)], 0, 3*np, 3*np);
        
    elseif numel(mu)==1
        
        % Homogener isotroper Fall
        dmu = mu0*mu*speye(3*np);
        
    else
        
        warning('Nicht implementiert; falscher Übergabeparameter mu')
        
    end
    
    Mmu = dat*dmu*nullInv(ds);
    
end