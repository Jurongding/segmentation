function calc_time()
%Time spent calculating the program
%Convert time units
global t0 t1 rstr
t1=etime(clock, t0);
if t1>3600
    t1=roundn(t1/3600,-1);
    rstr='hours';
elseif t1>60
    t1=roundn((t1/60),-1);
    rstr='minutes';
else
    t1=roundn(t1,-2);
    rstr='seconds';
end