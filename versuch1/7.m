for i = 1:nd
    
    %Ermitteln der Koordinaten des ersten beliebig gewaehlten Dreiecks
    %auf der Deckflaeche
    if i = 1
        ZDeckPunkt1 = h;
        ZDeckPunkt2 = h;
        ZDeckPunkt3 = h;
    
        YDeckPunkt1 = 0;
        YDeckPunkt2 = r*sin(i*deltaphi);
        YDeckPunkt3 = 0;
    
        XDeckPunkt1 = 0;
        XDeckPunkt2 = r*cos(i*deltaphi);
        XDeckPunkt3 = r;
    
    %Ermitteln der Koordinaten der verbleibenden Dreiecke
    elseif
        ZDeckPunkt1 = h;
        ZDeckPunkt2 = h;
        ZDeckPunkt3 = h;
    
        YDeckPunkt1 = 0;
        YDeckPunkt2 = r*sin(i*deltaphi);
        YDeckPunkt3 = YDeckelPunkt2(i-1); 
    
        XDeckPunkt1 = 0;
        XDeckPunkt2 = r*cos(i*deltaphi);
        XDeckPunkt3 = XDeckelPunkt2(i-1);
    end

end
