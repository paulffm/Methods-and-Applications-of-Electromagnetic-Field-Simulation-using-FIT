clc; clear;
%Skript für die Darstellung des Konvergenzverhaltens der Lösung der
%eindimensionalen Wellengleichung. Verwendet createCC (Erstellung der
%Systemmatrix) und solveCC (Lösen des Eigenwertproblems).
%
%   Eingabe
%   L           Abmessung/Länge des eindimensionalen Gebietes
%   nmax        Maximale Stützstelleanzahl
%   kxind       Betrachtete Mode (Grundmode=1)
%
%   Rückgabe
%   figure(1)   Plot Konvergenzverhalten kx, linear (wird abgespeichert in
%               plotConv.pdf)
%   figure(2)   Plot Konvergenzverhalten fehler, doppelt-logarithmisch (wird
%               abgespeichert in plotConvloglog.pdf)

% Setzen der Parameter
nmax = 100;
L = 1;
kxind = 1;
nOrd2 = 3:nmax;
nOrd4 = 5:nmax;


% Konvergenzstudie für Ordnung 2 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 2 und keine Randbedingung')
kxOrd2bc0 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
 dx=L/(n-1);
[cc]=createCC(n, 2, 0);
[kx02 ,modes]=solveCC(cc, dx);
kxOrd2bc0(i) =kx02(kxind);
end

% Konvergenzstudie für Ordnung 4 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 4 und keine Randbedingung')
kxOrd4bc0 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
  dx=L/(n-1);
[cc]=createCC(n, 4, 0);
[kx04 ,modes]=solveCC(cc, dx);
kxOrd4bc0(i)=kx04(kxind);
end

% Konvergenzstudie für Ordnung 2 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 2 und elektrische Randbedingung')
kxOrd2bc1 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
dx=L/(n-1);
[cc]=createCC(n, 2, 1);
[kx12 ,modes]=solveCC(cc, dx);
kxOrd2bc1(i)=kx12(kxind);
end

% Konvergenzstudie für Ordnung 4 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 4 und elektrische Randbedingung')
kxOrd4bc1 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
dx=L/(n-1);
[cc]=createCC(n, 4, 1);
[kx14 ,modes]=solveCC(cc, dx);
kxOrd4bc1(i)=kx14(kxind);
end


% Formel für analytische Lösung
 kxAna = pi/L;
kxAna=kxAna*ones(1,length(nOrd4));
% Plot für die Wellenzahl über Stützstellenanza

figure(1)
hold on

plot(nOrd4,kxAna)
plot(nOrd2,kxOrd2bc1)
plot(nOrd4,kxOrd4bc1)
legend({'analytische Wellenzahl',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       },...
        'Location','Southeast')
xlabel('Stützstellenanzahl')
ylabel('Wellenzahl in 1/m')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
#print -dpdf plotConv.pdf


% Plot für den relativen Wellenzahlfehler über Gitterschrittweite (loglog)
relError2bc0=(kxAna-kxOrd2bc0)./kxAna;
relError4bc0=(kxAna-kxOrd4bc0)./kxAna;
relError2bc1=(kxAna-kxOrd2bc1)./kxAna;
relError4bc1=(kxAna-kxOrd4bc1)./kxAna;

figure(2)
loglog(L./(nOrd2-1),relError2bc1(:,end),...
 L./(nOrd4-1),relError4bc1(:,end),...
 L./(nOrd2-1),relError2bc0(:,end),...
 L./(nOrd4-1),relError4bc0(:,end));
 
legend({'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.',...
        'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.'},...
        'Location','Southeast');
        
xlabel('Gitterschrittweite')
ylabel('rel. Fehler der Wellenzahl')
print -depsc V1D5_b.eps
set(2,'papersize',[12,9])
set(2,'paperposition',[0,0,12,9])
