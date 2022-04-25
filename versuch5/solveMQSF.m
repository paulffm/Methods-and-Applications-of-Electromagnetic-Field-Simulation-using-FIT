% Aufgabe 4
%
% Einfacher Solver fuer magnetoquasistatische Probleme im Frequenzbereich
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   mui         Inverse Permeabilitaet entsprechend Methode createMmui
%   kap         Diskrete gemittelte Leitfähigkeit
%   jsbow       Stromgitterfluss (Erregung), als Funktion der Zeit
%   f           Frequenz der Anregung
%
%   Rückgabe
%   abow        Integriertes magnetisches Vektorpotential
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetische Gitterfluss
%   jbow        Stromgitterfluss
%   relRes      Relatives Residuum fuer jeden Iterationsschritt
%   bc          Randbedingungen (0=magnetisch, 1=elektrisch)

function [abow, hbow, bbow, jbow, relRes] = solveMQSF(msh, mui, kap, jsbow, f, bc)

    % Anzahl der Rechenpunkte des Gitters
    np = msh.np;

    % Erzeugung topologische Matrizen
    [c, ~, ~] = createTopMats(msh);
        
    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);       
    
    % Erzeugung der Materialmatrix
    mmui = createMmui(msh, ds, dst, da, mui, bc);
    mkap = createMeps(msh, ds, da, dat, kap, bc);

    % Berechnung der Kreisfrequenz
    % omega =   
    omega = 2*pi*f;
    
    % Berechnung Systemmatrix A und rechte Seite rhs
    % A =
    % rhs =
    j = sqrt(-1);
    A = c.'*mmui*c+j*omega*mkap;
    rhs = jsbow;
    % Einträge der Geisterkanten aus Systemmatrix und rechter Seite
    % streichen (da pcg sonst nicht konvergieren würde, ausprobieren!)
    idxGhostEdges = getGhostEdges(msh);
    % idxAllEdges = 
    for n=1:3*np
      idxAllEdges(n,1)=n;
    end
    % idxExistingEdges = setdiff();
    idxExistingEdges = setdiff(idxAllEdges,idxGhostEdges);
    % rhs_reduced =  
    rhs_reduced = rhs(idxExistingEdges);
    
    
    A_reduced = A(idxExistingEdges,idxExistingEdges);
    % Initialisieren der Lösung
    % abow = 
    abow = zeros(3*np,1);
    
    % Vorkonditionierer wählen (hier Jacobi)
    % M = 

    % Gleichungssystem loesen
    #[abow_reduced, flag, relRes, iter, resVec] = pcg(A_reduced, rhs_reduced, 1e-6, 1000, M);
    [abow_reduced, flag, relRes, iter, resVec] = gmres(A_reduced, rhs_reduced, [], 1e-6, size(A_reduced,2)); #% aufgrund von Warnung von gmres nicht auf 1000, sonder size(A,2) gesetzt
  
    if flag == 0
      fprintf('gmres: converged at iteration %2d to a solution with relative residual %d.\n',iter,relRes);
    else
      error('gmres: some error ocurred, please check flag output.')
    end
    relRes = resVec./norm(rhs_reduced);
    
    % A und rhs zurück auf ursprüngliche Größe bringen
    % ... 
    for k=1:length(idxExistingEdges);
      p=idxExistingEdges(k);
      abow(p)=abow_reduced(k);
    end
    % Magnetische Gitterspannung, magnetischen Fluss und Stromgitterfluss
    % berechnen
    % bbow = 
    % hbow = 
    % jbow = 
    bbow = c*abow;
    hbow = mmui*bbow;
    jbow = -j*omega*mkap*abow;
end
