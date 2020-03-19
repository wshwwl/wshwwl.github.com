r_ansys=1800;
r_source=1800;
scale=r_ansys/r_source;
Xmm=scale*Xm;
Ymm=scale*Ym;
f=scatteredInterpolant(Xmm,Ymm,TemperatureK);
temp=f(nx,ny);
figure(1)
scatter(Xm,Ym,5,TemperatureK,'filled');
axis equal
figure(2)
scatter(nx,ny,5,temp,'filled');
axis equal

temp=temp-273.15;
fid=fopen('node_temp.csv','wt');
fprintf(fid,'%f\n',temp);
fclose(fid);

