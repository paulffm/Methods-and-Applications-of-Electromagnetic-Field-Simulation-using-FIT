function [l] = boundPoints(msh)

    nx=msh.nx;
    ny=msh.ny;
    nz=msh.nz;
    np=nx*ny*nz;

    bp=[]; 
    %Randpunkte an YZ-Flaeche
    for i=[1,nx];
        for j=1:ny;
            for k=1:nz;
                n=1+(i-1)+(j-1)*nx+(k-1)*nx*ny;
                bp(n)=n;
            end
        end
    end

    %Randpunkte an XZ-Flaeche

    for i=1:nx;
        for j=[1,ny];
            for k=1:nz;
                n=i+(j-1)*nx+(k-1)*nx*ny;
                bp(n)=n;
            end
        end
    end

    %Randpunkte an XY-Flaeche
    for i=1:nx;
        for j=1:ny;
            for k=[1,nz];
                n=i+(j-1)*nx+(k-1)*nx*ny;
                bp(n)=n;
            end 
        end
    end

    index=1;
    l=[];
    for n=1:np;
        if bp(n)>0;
            l(index)=n;
            index=index+1;
        end
    end
    
end

