%Loest das Eigenwertproblem einer Matrix und gibt Wellenzahlen,
%berechnet aus Eigenwerten und Gitterschrittweite, und 
%Eigenvektoren geordnet aus. Bereinigt _nicht_ von unphysikalischen Moden.
%
%   Eingabe
%   cc          Curl-Curl-Matrix
%   dx          Gitterschrittwete
%
%   Rueckgabe
%   kx          Wellenzahlen (aufsteigend)
%   modes       Eigenmoden (geordnet entsprechend kx)

function [kx ,modes]=solveCC(cc, dx)

    % Bestimmen der Eigenwerte und -vektoren mit eig
    [eigVec,eigVal] = eig(cc);
    % Bestimmen der Wellenzahlen aus den Eigenwerten
    
    temp = diag(eigVal);
    
    kx = sqrt(temp./(-dx^2));
    
    % Sortieren der Wellenzahlen. Sortierindex mit zurueckgeben lassen !
    
    [kx,sortIndex] = sort(kx);
    
    % Sortieren der Eigenvektoren mithilfe des Sortierindexes und damit
    % Bestimmung der Moden.
   
  
    modes = sparse(size(eigVec,1),size(eigVec,2));
    
    for col=1:size(eigVec)(2)
      modes(:,col) = eigVec(:,sortIndex(col));
    end
   
    modes=full(modes);
  
    
end
