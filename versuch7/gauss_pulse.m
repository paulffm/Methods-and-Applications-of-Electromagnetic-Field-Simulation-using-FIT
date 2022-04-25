function [j] = gauss_pulse(t,fmax,np,distributed)

% value
omega = 2*pi*fmax;
sigma = sqrt(2*log(100)/omega^2);
t0 = sqrt(2*sigma^2 * log(1000));
tm = t - t0;
jvalue = exp(-tm.^2 / (2*sigma^2));

j = sparse(3*np,length(t));
if distributed
	% set j in a way that the current is distributed over the entire port face
    XfacesMinus = [5,9];
    YfacesMinus = [2,3]+np;
    XfacesPlus = [7,11];
    YfacesPlus = [10,11]+np;
    j(XfacesPlus,:) = [jvalue/8; jvalue/8];
    j(XfacesMinus,:) = -[jvalue/8; jvalue/8];
    j(YfacesPlus,:) = [jvalue/8; jvalue/8];
    j(YfacesMinus,:) = -[jvalue/8; jvalue/8];
else
	% set j in a way that one edge in the port face is excited by the entire current
    j(2 + np) = jvalue;
end