% Aufgabe 6
%
% Einfacher Solver fuer magnetoquasistatische Probleme im Zeitbereich
%
%   Eingabe
%   msh        Kanonisches kartesisches Gitter
%   mui         Inverse Permeabilitaet entsprechend Methode createMmui
%   kap         Leitfaehigkeit kappa, die entsprechend Methode createMeps
%               berechnet werden kann.
%   abow_init   Anfangswert für die DGL (3*np-by-1)
%   jsbow_t     Stromgitterfluss (Erregung), als Funktion der Zeit
%   time        Zeit-Vektor
%
%   Rückgabe
%   abow        Integriertes magnetisches Vektorpotential
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetischer Gitterfluss
%   jbow        Elektrischer Stromfluss 
%   ebow        Elektrische Gitterspannung
%   bc          Randbedingungen (0=magnetisch, 1=elektrisch)

function [abow, hbow, bbow, jbow, ebow] = solveMQST(msh, mui, kap, abow_init, jsbow_t, time, bc)

    % Erzeugung topologische Matrizen
    [c, ~, ~] = createTopMats(msh);
        
    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);
        
    % Erzeugung Materialmatrix inverse Permeabilitaet
    mmui = createMmui(msh, ds, dst, da, mui, bc);
    mkap = createMeps(msh, ds, da, dat, kap, bc);
    % Anzahl der Zeitpunkte auslesen
    % nt = 
    nt = length(time);
    % Speichermatrizen fuer die Felder zu bestimmten Zeiten
    np = msh.np;
    ebow = zeros(3*np, nt);
    bbow = zeros(3*np, nt);
    hbow = zeros(3*np, nt);
    jbow = zeros(3*np, nt);    
    
    % Initialisierung
    abow_t = abow_init;
    omega = 2*pi*50;
    

    % Zeitintegrationsschleife
    for i=1:nt
      if i==1
        tau(i) = time(i+1)-time(i);
      else
        tau(i) = time(i)-time(i-1);
      end
    end
    
    for i=1:nt
      % Alten Feldwert des Vektorpotentials speichern
      % abow_t_old = ;
      abow_t_old = abow_t;
      
      
      % Systemmatrix erstellen
      % A =
      
        
        A = c'*mmui*c+tau(i)^(-1)*mkap;
        
        % Rechte Seite rhs fuer diesen Zeitschritt bestimmen
        % je = 
        % rhs = 
        je = jsbow_t(i);
        rhs = je + tau(i)^(-1)*mkap*abow_t_old;
        % Gleichungssystem loesen
        abow_t = pcg(A,rhs,1e-6,500);

      % Update der elektrischen Gitterspannung ebow_t 
	  % Rückwärtsdifferenzenquotienten verwenden, nicht Formel aus Vorbereitung!
      % ebow_t = 

        ebow_t = (abow_t - abow_t_old)/tau(i);
     
      
        % Magnetische Gitterspannung, magnetischen Fluss und
        % Stromgitterfluss für diesen Zeitschritt speichern
        %abow(:,i) =
        %ebow(:,i) =
        %bbow(:,i) =
        %hbow(:,i) =
        %jbow(:,i) =
        abow(:,i) = abow_t;
        ebow(:,i) = ebow_t;
        bbow(:,i) = c*abow(:,i);
        hbow(:,i) = mmui*bbow(:,i);
        jbow(:,i) = mkap*ebow(:,i);
      end
   
end