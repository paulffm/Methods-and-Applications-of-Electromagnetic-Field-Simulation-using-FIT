% Aufgabe 8

% Skript zur Darstellung der relativen Anzahl der Fehlerkanten als
% doppel-logarithmischer Graph
nxyMax = 10;
relOccurence = zeros(1,nxyMax);
for nxy=1:nxyMax
    % Gittererzeugung: kartesisches Gitter mit nxy Punkten in x- und y-
    % Richtung. Es handelt sich um ein ebenes Gitter (x-y-Ebene) mit z = 1
   xmesh=1:nxy;
   ymesh=1:nxy;
   zmesh=1;
    msh=cartMesh(xmesh,ymesh,zmesh);
    % Geisterkanten finden
    [edg]=boundEdg(msh); % 3*np,1
    % Geisterkanten zaehlen
  index=0;
    for n=1:size(edg,1);
        if edg(n)==0;
            index=index+1;
            
        end
       
    end
    relOccurence(nxy)=index;
    % Berechnen der relativen Anzahl fuer dieses nxy
    relOccurence(nxy)=relOccurence(nxy)./(3*nxy^2);
    
end

% Darstellen der relativen Anzahl als doppel-logarithmischer Graph
figure;
plot(1:nxyMax,relOccurence, 'LineWidth', 2);
legend('Relativer Anteil von Geisterkanten');
xlabel('N_{xy}');
ylabel('Rel. Anteil');
title(['Relative Anzahl der Geisterkanten bei N_x bzw. N_y von 1 bis ',...
       num2str(nxyMax)]);
ylim([min(relOccurence),max(relOccurence)])
set(gca,"fontsize",12);
