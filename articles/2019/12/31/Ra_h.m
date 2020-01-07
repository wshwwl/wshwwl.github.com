dr=[0.02;0.2;1]; %\zeta
r=0.01:0.01:5;  %w/wn
nr=1./r;
Ha=(2i*dr*r+1)./(-r.^2+2i*dr*r+1);
Hr=1./(-1+2i*dr*nr+nr.^2);

plot(r,abs(Hr),'black','linewidth',2);
grid on
xlabel('\omega/\omega_n');
ylabel('R_r(\omega)');











