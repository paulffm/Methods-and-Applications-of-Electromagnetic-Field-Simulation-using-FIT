function [ jvalue ] = trapez_pulse(time, trise, thold, tfall)

% number of time points
 nt = length(time);

t1 = trise;
t2 = trise + thold;
t3 = trise + thold + tfall;

jvalue = zeros(1,nt);

% trapez value
for k = 1:nt
    t = time(k);
    if (0 <= t && t < t1)
         jvalue(k) =t/t1;
    elseif (t1 <= t && t < t2)
         jvalue(k) =1;
    elseif ( t2 <= t && t < t3)
         jvalue(k) = (t3-t)/(t3-t2);
    else
         jvalue(k) = 0;
end
end
end

