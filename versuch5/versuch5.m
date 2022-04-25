% Aufgabe 1,3,4,7,8,9
clc;clear;close all;
%% Aufgabe 1
% -------------------------------------------------------------------------
% ------------ Problem modellieren ----------------------------------------
% -------------------------------------------------------------------------
% Konsolenausgabe
disp('Gitter erstellen')
% Erstellen des Gitters mit cartMesh
 xmesh = linspace(0,1,6);
 ymesh = linspace(0,1,6);
 zmesh = linspace(0,1,5);
 msh = cartMesh(xmesh, ymesh, zmesh);

 np = msh.np;
 Mx = msh.Mx;
 My = msh.My;
 Mz = msh.Mz;

% Randbedingung für alle Raumrichtungen definieren [xmin, xmax, ymin, ymax, zmin, zmax] (0 = magnetisch, 1 = elektrisch)
% bc = [ , , , , , ] 
bc = [0,0,0,0,1,1];
% Erstellen von jsbow
jsbow = zeros(3*np,1);
jsbow(87) = 1000;
jsbow(93) = -1000;
jsbow(267)= -1000;
jsbow(268)= 1000;

% Erstellen der Materialverteilung mui und kappa mithilfe von boxmesher
disp('Materialmatrizen erstellen')
 boxeskappa(1).box = [ 1, msh.nx , 1 , msh.ny ,1  ,2 ];
 boxeskappa(1).value = 5.8*10^7;
 kappa = boxMesher(msh, boxeskappa, 0);

 boxesmu(1).box = [ 1, msh.nx , 1 , msh.ny ,1  ,2 ];
 boxesmu(1).value = 1000*4*pi*10^(-7);
 mu = boxMesher(msh, boxesmu, 1.2566*10^-6);

% Inverse Permeabilität berechnen (siehe Hinweis Aufgabe 1)
 mui = mu.^(-1);


%% Aufgabe 3
% -------------------------------------------------------------------------
% ----------- Lösen des magnetostatischen Problems ------------------------
% -------------------------------------------------------------------------
solve_statik = true;
if solve_statik
	disp('Loesung des statischen Problems')
    
	% Solver benutzen, um A-Feld zu bestimmen
	[abow_ms, hbow_ms, bbow_ms, relRes] = solveMSVec(msh, mui, jsbow);
	
	% Grafisches Darstellen des magnetischen Vektorpotentials, am besten 
    % unter der Verwendung verschiedener Ebenen


  figure(1)
	plotEdgeVoltage(msh, abow_ms, 3,  bc);
	title('Statische Loesung des Vektorpotentials')
  set(gca,"fontsize",20);
  #print -depsc V5D3_1.eps
  
  figure(2)
    % Grafisches Darstellen der z-Komponente des B-Feldes
    X=zeros(msh.nx,msh.ny); Y=zeros(msh.nx,msh.ny); Z=zeros(msh.nx,msh.ny);
    for i=1:msh.nx
      for j=1:msh.ny
        for k=1:msh.nz
          n = 1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
          if ( k==3 )
            X(i,j) = xmesh(i);
            Y(i,j) = ymesh(j);
            Z(i,j) = bbow_ms(2*np+n);
          end
        end
      end
    end
    surf(X,Y,Z);
    set(gca,"fontsize",20);
    #print -depsc V5D3_2.eps
    
end


% Verschiebt diese Zeile zur nächsten Aufgabe, wenn Aufgabe 3 abgeschlossen ist


%% Aufgabe 5
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Frequenzbereich -----------
% -------------------------------------------------------------------------
disp('Lösung des quasistatischen Problems im Frequenzbereich')

% Frequenz festlegen
 f = 50;
 omega =2*pi*f;

% Löser ausführen
[abow_mqs_f, hbow_mqs_f, bbow_mqs_f, jbow_mqs_f, relRes] = solveMQSF(msh, mui,...
                                                         kappa, jsbow, f, bc);

% Grafisches Darstellen der Stromdichte auf der Oberfläche der leitfähigen
% Platte (Real- und Imaginärteil)

figure(3)
plotEdgeVoltage(msh,real(jbow_mqs_f),2,bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y')
#print -depsc V5D5_1.eps

figure(4)
plotEdgeVoltage(msh,imag(jbow_mqs_f),2,bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y') 
#print -depsc V5D5_2.eps


%% Aufgabe 7
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Zeitbereich --------------
% -------------------------------------------------------------------------
disp('Loesung des quasistatischen Problems im Zeitbereich')

% Zeitparameter so setzen, dass drei Perioden durchlaufen werden
periods = 3;                % Anzahl an Perioden
nperperiod = 21;            % Anzahl an Zeitpunkten pro Periode
time = linspace(0,3/50,periods*nperperiod); % Zeit-Vektor
tend = time(end);           % Endzeit
nt = length(time);          % Gesamtzahl an Zeitpunkten

% Anfangswert für die Lösung der DGL wählen
% abow_init = ...
abow_init = ones(3*np,1);

% Anregung jsbow als Funktion der Zeit
% jsbow_t = @(t)(....);
jsbow_t = @(t)(150*t);

% Lösen des MQS-Problems
[abow_mqs_t, hbow_mqs_t, bbow_mqs_t, jbow_mqs_t, ebow_mqs_t] = solveMQST(msh, mui, kappa, abow_init, jsbow_t, time, bc);

% Index für Plot wählen
i = 3; j = 2; k = 2;
idx2plot = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;



% Vektorpotential (Lösung der DGL) für gewählte primäre Kante (idx2plot) über die Zeit plotten
figure(5)
plot(time,abow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Vektorpotential abow_{mqs,t}');
#print -depsc V5D7_1.eps

% Stromdichteverteilung für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(6)
plot(time,jbow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Strom jbow_{mqs,t}');
#print -depsc V5D7_2.eps




%% Aufgabe 8
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Frequenzbereich in Zeitbereich ---------
% ----------          Vergleich Real- und Imaginärteil            ---------
% -------------------------------------------------------------------------
disp('Vergleich Frequenzbereich <=> Zeitbereich')

% Transformation der Frequenzbereichslösung in den Zeitbereich
% abow_mqs_f_t = ;
% jbow_mqs_f_t = ;
abow_mqs_f_t = real( abow_mqs_f*exp(sqrt(-1)*omega*time) );
jbow_mqs_f_t = real( jbow_mqs_f*exp(sqrt(-1)*omega*time) );



% Vektorpotential (Lösung der DGL) Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(7)
plot(time,abow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,abow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Vektorpotential abow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')

% Stromdichte-Lösung Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(8)
plot(time,jbow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,jbow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Strom jbow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')
#print -depsc V5D8.eps

% Vergleich von Zeitlösung zur Frequenzlösung im Zeitbereich
% -> Implementierung der Fehlernorm aus der Aufgabenstellung
% ...
% ...
% ...
% errorTimeVSfrequency = 
% fprintf('Relativer Fehler im Zeitbereich: %e\n',errorTimeVSfrequency);
errorTimeVSfrequency = max( norm( jbow_mqs_t - jbow_mqs_f_t ) )/max( norm( jbow_mqs_f_t ) );
fprintf('Relativer Fehler im Zeitbereich: %e\n',errorTimeVSfrequency);




%% Aufgabe 9
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Zeitbereich in Frequenzbereich ---------
% ----------               Vergleich der Phasoren                 ---------
% -------------------------------------------------------------------------

% (Vergleich der Phasoren)

% Transformation der Zeitbereichslösung in den Frequenzbereich
% Bestimmung von Real- und Imaginärteil des komplexen Phasors,
% der aus dem Zeitsignal gewonnen werden kann
    % t_real =
    % t_imag = 
      t_real = 1/f;
      t_imag = 1/f * (1-1/4);
    
    %    jbow_re_t(i) = interp1(...);
    %    jbow_im_t(i) = ...
      jbow_re_t = zeros(3*msh.np,1);
      jbow_im_t = zeros(3*msh.np,1);
      for i=1:3*msh.np
          jbow_re_t(i) = interp1(time, jbow_mqs_t(i,:), t_real);
          jbow_im_t(i) = interp1(time, jbow_mqs_t(i,:), t_imag);
      end


% Vergleich von Real- und Imaginärteil des Phasors aus dem Zeitbereich
% mit dem Phasor aus der Frequenzbereichslösung (Implementierung der Formel aus Aufgabenstellung)
% errorPhasorReal = ...
% errorPhasorImag = ...
% fprintf('Relativer Fehler Realteil: %e\n',errorPhasorReal);
% fprintf('Relativer Fehler Imaginärteil: %e\n',errorPhasorImag);
  
  errorPhasorReal = norm(jbow_re_t-jbow_mqs_f)/norm(jbow_mqs_f);
  errorPhasorImag = norm(jbow_im_t-jbow_mqs_f)/norm(jbow_mqs_f);
  fprintf('Relativer Fehler Realteil: %e\n',errorPhasorReal);
  fprintf('Relativer Fehler Imaginärteil: %e\n',errorPhasorImag);
  
  
% Plot: gleiches Feldbild für Phasoren des Zeitintegration zum optischen 
% Vergleich mit den Plots, die man für die Phasoren des Frequenzbereiches
% erhalten hat
figure(9)
plotEdgeVoltage(msh,jbow_re_t, 2, bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')
#print -depsc V5D9_1.eps

figure(10)
plotEdgeVoltage(msh,jbow_im_t, 2, bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')
#print -depsc V5D9_2.eps


%% Aufgabe 10
% -------------------------------------------------------------------------
% -------------- Konvergenz des Fehlers der Zeitintegration ---------------
% -------------------------------------------------------------------------

% Konvergenz des Fehlers der Zeitintegration
% nperperiodMax = 100
% plotConvSolveMQST(msh,mui,kappa,jsbow_t,jbow_mqs_f,periods,tend,f,nperperiodMax,bc);
  nperperiodMax = 100;
  plotConvSolveMQST(msh,mui,kappa,jsbow_t,jbow_mqs_f,periods,tend,f,nperperiodMax,bc);
  
return
