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
%   meps        Materialmatrix der Permittivitäten

function meps = createMeps(msh, ds, da, dat, eps)
    
    if nargin < 5
        warning('Zu wenig Eingabeparameter.')
    end
    
    eps0 = 8.854*10^(-12);
    
    nx = msh.nx;
    ny = msh.ny;
    nz = msh.nz;
    np = msh.np;
    
    if numel(eps)==np
    
        % Inhomogener Fall: Mittelung Permittivität
        zeromat = sparse(np,np);

        cells = repmat([repmat([ones(nx-1,1); 0], ny-1, 1); zeros(nx,1)], nz, 4);
        avex = spdiags(cells, [0 -nx -nx*ny -(nx+nx*ny)], np, np);
        avey = spdiags(cells, [0 -nx*ny -1 -(nx*ny+1)], np, np);
        avez = spdiags(cells, [0 -1 -nx -(1+nx)], np, np);

        ave = [avex zeromat zeromat;
                zeromat avey zeromat;
                zeromat zeromat avez];

        deps = spdiags(eps0*nullInv(dat)/4*(ave*da*[eps; eps; eps]), 0, 3*np, 3*np);
        
    elseif numel(eps)==3
        
        % Homogener anisotroper Fall
        deps = eps0*spdiags([eps(1)*ones(1,np), eps(2)*ones(1,np), eps(3)*ones(1,np)], 0, 3*np, 3*np);
        
    elseif numel(eps)==1
        
        % Homogener isotroper Fall
        deps = eps0*eps*speye(3*np);

    else
        
        warning('Nicht implementiert; falscher Übergabeparameter eps')
        
    end
    
    meps = dat*deps*nullInv(ds);
    
end