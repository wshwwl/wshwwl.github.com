function [pm,pb] = linearize( loc,stress )
%LINEARIZE Summary of this function goes here
S=stress;
loc=reshape(loc,size(S));
loc=loc-loc(1);
loc=abs(loc);
t=diff(loc);
T=sum(t);
pm=sum(0.5*(S(1:end-1)+S(2:end)).*t)/T;

nt=1000;
Ts=0:T/nt:T;
Ss=interp1(loc,S,Ts);
pb=sum((Ss(1:end-1)+Ss(2:end))/2*T/nt.*(0.5*Ts(1:end-1)+0.5*Ts(2:end)-T/2))*6/T^2;

end

