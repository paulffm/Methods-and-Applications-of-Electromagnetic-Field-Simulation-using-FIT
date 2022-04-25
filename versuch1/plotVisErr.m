%Skript zur Darstellung der Diskretisierungsfehler eines Zylinders.
%
%   Eingabe
%   nmax        Maximale Stützstellenanzahl
%
%   Rückgabe
%   figure(1)   Plot Fehler doppelt-logarithmisch (wird abgespeichert 
%               in plotVisErrloglog.pdf)

% Parameter setzen

clc;clear;close all;

nmax=1000;
r = 1;
h = 1;

% Vektor mit verschiedener Anzahl von Dreiecken
nd=3:nmax;
phi=zeros(1,length(nd));
for i=1:length(nd)
  phi(i) = 2*pi/nd(i);
end
Ad = 1/2*r^2*sin(phi);
ad = r*sin(phi./2);

% Berechnung von diskreter Oberfläche und Volumen 
% oberflaecheDiskrete =
% volumenDiskrete =

oberflaecheDiskrete = 2*nd.*(Ad+ad.*h);
volumenDiskrete = Ad.*nd.*h;

% Berechnung von analytischer Oberfläche und Volumen 
% oberflaecheAnalytisch =
% volumenAnalytisch =

oberflaecheAnalytisch = 2*pi*r*(h+r);
volumenAnalytisch = pi*r^2*h;

% Berechnung von Oberflächen- und Volumenfehler
% oberflaechenFehler =
% volumenFehler =

oberflaechenFehler = (oberflaecheAnalytisch - oberflaecheDiskrete)/oberflaecheAnalytisch;
volumenFehler = (volumenAnalytisch - volumenDiskrete)/volumenAnalytisch;


% Plotten der beiden Fehler über nd
figure(1)

    %loglog(nd,oberflaechenFehler,nd,volumenFehler)
  loglog(nd,oberflaechenFehler,"linewidth",3)
  hold on
  loglog(nd,volumenFehler,"linewidth",3)
 
   
    %loglog(nd,volumenFehler,"linewidth",3);
    xlabel('Anzahl Dreiecke Deckelfläche')
    ylabel('relativer Fehler')
    legend({'Oberflaechenfehler',...
            'Volumenfehler'},...
            'Location','Northeast')
    set(1,'papersize',[12,9])
    set(1,'paperposition',[0,0,12,9])
    set(gca,"fontsize",20);
    
    
% nd für Fehler kleiner als 10^(-5) finden
