%Methode zur Erstellung der 1D Curl-Curl-Matrix eines einfachen
%Eigenwertproblems einer eindimensionalen Wellengleichung (TE-Mode).
%
%   Eingabe
%   n       Steutzstellenanzahl (n>=3 fuer ord=2, n>=5 fuer ord=4)
%   ord     Ordnung des Verfahrens (ord=2 zweite oder ord=4 vierte Ordnung)
%   bc      Randbedingungen (bc=0 keine, bc=1 elektrisch, bc=2 magnetisch)
%
%   Rueckgabe
%   cc      1D Curl-Curl-Matrix


function [cc]=createCC(n, ord, bc)

    % Aufstellen der Matrix
    cc = sparse(n,n);
    
    % Eintraege eintragen
    if ord==2
        % Bestimmen der Eintraege fuer Ordnung 2 ohne Randbedingungen
        
        e = ones(n,1);
        cc = spdiags([e -2*e e],-1:1,n,n);
        cc = full(cc);
        
        if bc==1          
            % Aenderung der Matrix bei elektrischem Rand
            
            b = ones(n,1);
            f = ones(n,1);
            f(n-1) = 0;
            b(2) = 0;
            cc = spdiags(f,-1,cc);
            cc = spdiags(b,1,cc);
            cc = full(cc);
            
        elseif bc == 2
            % Aenderung der Matrix bei magnetischem Rand
            
            b = ones(n,1);
            f = ones(n,1);
            f(n-1) = 2;
            b(2) = 2;
            cc = spdiags(f,-1,cc);
            cc = spdiags(b,1,cc);
            cc = full(cc);
            
        elseif bc ~= 0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end
	elseif ord==4
        % Bestimmen der cc Matrix fuer Ordnung 4 ohne Randbedingungen
        
        e = ones(n,1);
        cc = spdiags([-e 16*e -30*e 16*e -e],-2:2,n,n);
        cc = full(cc);
        
        if bc==1
            % Aenderung der Matrix bei elektrischem Rand
            
            b=-1*ones(n,1);
            b(n-2)=0;
            c=16*ones(n,1);
            c(n-1)=0;
            d=-30*ones(n,1);
            d(2)=-29;
            d(n-1)=-29;
            e=16*ones(n,1);
            e(2)=0;
            f=-1*ones(n,1);
            f(3)=0;
            cc=spdiags(b,-2,cc);
            cc=spdiags(c,-1,cc);
            cc=spdiags(d,0,cc);
            cc=spdiags(d,0,cc);
            cc=spdiags(e,1,cc);
            cc=spdiags(f,2,cc);
            cc=full(cc);
            
        elseif bc==2
            % Aenderung der Matrix bei magnetischem Rand
            
            b=-1*ones(n,1);
            b(n-2)=-2;
            c=16*ones(n,1);
            c(n-1)=32;
            d=-30*ones(n,1);
            d(2)=-31;
            d(n-1)=-31;
            e=16*ones(n,1);
            e(2)=32;
            f=-1*ones(n,1);
            f(3)=-2;
            cc=spdiags(b,-2,cc);
            cc=spdiags(c,-1,cc);
            cc=spdiags(d,0,cc);
            cc=spdiags(d,0,cc);
            cc=spdiags(e,1,cc);
            cc=spdiags(f,2,cc);
            cc=full(cc);
            
        elseif bc~=0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end

	else
		error('Ordnung %d ist noch nicht implementiert.', n)
  end
  cc=cc/12;
end
