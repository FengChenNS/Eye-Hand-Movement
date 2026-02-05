function [a,b,c,d] = threedplane(x,y,z)

planeData = [x,y,z];
xyz0=mean(planeData,1);
centeredPlane=bsxfun(@minus,planeData,xyz0);
[U,S,V]=svd(centeredPlane);
a=V(1,3);
b=V(2,3);
c=V(3,3);
d=-dot([a b c],xyz0);


scatter3(x,y,z,'filled')
hold on;

xfit = min(x):0.1:max(x);
yfit = min(y):0.1:max(y);
[XFIT,YFIT]= meshgrid (xfit,yfit);
ZFIT = -(d + a * XFIT + b * YFIT)/c;
mesh(XFIT,YFIT,ZFIT);

hold on;

end
