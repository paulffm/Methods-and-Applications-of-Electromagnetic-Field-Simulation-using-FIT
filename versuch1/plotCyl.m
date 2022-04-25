%Skript fuer die Visualisierung eines diskretisierten Zylinders.
%
%   Eingabe
%   nd          Anzahl Dreiecksflaechen je Deckel
%   h           Hoehe des Zylinders
%   r           Radius des Zylinders
%
%   Rueckgabe
%   figure(1)   Plot Zylinder (wird abgespeichert in cyl.pdf)

clc;close;clear all;

% Parameter setzen
nd=20;
h=1;
r=1;

% Berechnung von delta phi
delta_phi=360/nd;

% Bestimmung der Arrays fuer die X, Y, Z Koordinate, 
% jeweils 3 Zeilen (Punkt 1, 2, 3 des Dreiecks) 
% und nd Spalten (Anzahl der Dreiecke)
% und das fuer die vier Dreiecke Deckel, Boden, Mantel 1, Mantel 2
XDeckel = zeros(3, nd);
YDeckel = zeros(3, nd);
ZDeckel = zeros(3, nd);
XBoden = zeros(3, nd);
YBoden = zeros(3, nd);
ZBoden = zeros(3, nd);
XMantel1 = zeros(3, nd);
YMantel1 = zeros(3, nd);
ZMantel1 = zeros(3, nd);
XMantel2 = zeros(3, nd);
YMantel2 = zeros(3, nd);
ZMantel2 = zeros(3, nd);

for i=1:nd
  
    if i==1
      %Deckel 1. Dreieck
      ZDeckel(1,i)=h;
      ZDeckel(2,i)=h;
      ZDeckel(3,i)=h;
      
      YDeckel(1,i)=0;
      YDeckel(2,i)=r*sin(i*delta_phi*(pi/180));
      YDeckel(3,i)=0;
      
      XDeckel(1,i)=0;
      XDeckel(2,i)=r*cos(i*delta_phi*(pi/180));
      XDeckel(3,i)=r;  
      %Boden 1. Dreieck
      ZBoden(1,i)=0;
      ZBoden(2,i)=0;
      ZBoden(3,i)=0;
      
      YBoden(1,i)=0;
      YBoden(2,i)=r*sin(i*delta_phi*(pi/180));
      YBoden(3,i)=0;
      
      XBoden(1,i)=0;
      XBoden(2,i)=r*cos(i*delta_phi*(pi/180));
      XBoden(3,i)=r;
      
      
   elseif
    %Deckel restliche Dreiecke
    ZDeckel(1,i)=h;
    ZDeckel(2,i)=h;
    ZDeckel(3,i)=h;
    
    YDeckel(1,i)=0;
    YDeckel(2,i)=r*sin(i*delta_phi*(pi/180));
    YDeckel(3,i)=YDeckel(2,i-1);
    
    XDeckel(1,i)=0;
    XDeckel(2,i)=r*cos(i*delta_phi*(pi/180));
    XDeckel(3,i)=XDeckel(2,i-1);
    %Boden restliche Dreiecke
    ZBoden(1,i)=0;
    ZBoden(2,i)=0;
    ZBoden(3,i)=0;
      
    YBoden(1,i)=0;
    YBoden(2,i)=r*sin(i*delta_phi*(pi/180));
    YBoden(3,i)=YBoden(2,i-1);
      
    XBoden(1,i)=0;
    XBoden(2,i)=r*cos(i*delta_phi*(pi/180));
    XBoden(3,i)=XBoden(2,i-1);
    
  end
  
    %Mantel1 (1 Punkt mit Boden gemeinsam)
    ZMantel1(1,i)=ZBoden(3,i);
    ZMantel1(2,i)=ZDeckel(2,i);
    ZMantel1(3,i)=ZDeckel(3,i);
        
    YMantel1(1,i)=YBoden(3,i);
    YMantel1(2,i)=YDeckel(2,i);
    YMantel1(3,i)=YDeckel(3,i);
      
    XMantel1(1,i)=XBoden(3,i);
    XMantel1(2,i)=XDeckel(2,i);
    XMantel1(3,i)=XDeckel(3,i);
    
    %Mantel2 (1 Punkt mit Deckel gemeinsam)
    ZMantel2(1,i)=ZDeckel(2,i);
    ZMantel2(2,i)=ZBoden(2,i);
    ZMantel2(3,i)=ZBoden(3,i);
        
    YMantel2(1,i)=YDeckel(2,i);
    YMantel2(2,i)=YBoden(2,i);
    YMantel2(3,i)=YBoden(3,i);
      
    XMantel2(1,i)=XDeckel(2,i);
    XMantel2(2,i)=XBoden(2,i);
    XMantel2(3,i)=XBoden(3,i);
  
end

% Plotten und Speichern der Dreiecke mithilfe von Patch
figure(1)

patch(XBoden,YBoden,ZBoden,zeros(3,nd))
patch(XDeckel,YDeckel,ZDeckel,zeros(3,nd))
patch(XMantel1,YMantel1,ZMantel1,zeros(3,nd))
patch(XMantel2,YMantel2,ZMantel2,zeros(3,nd))

view([1,-1,0.5])    
xlabel('x')
ylabel('y')
zlabel('z')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
set(gca,'DataAspectRatio',[1 1 1])
set(gca, "fontsize",20);
print -depsc cyl.eps
