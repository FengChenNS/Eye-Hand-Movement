function [a,b,c,d] = threedplane(x,y,z)
%UNTITLED3 Summary of this function goes here
% 协方差矩阵的SVD变换中，最小奇异值对应的奇异向量就是平面的方向
planeData = [x,y,z];
xyz0=mean(planeData,1);
centeredPlane=bsxfun(@minus,planeData,xyz0);
[U,S,V]=svd(centeredPlane);
a=V(1,3);
b=V(2,3);
c=V(3,3);
d=-dot([a b c],xyz0);

%图形绘制

scatter3(x,y,z,'filled')
hold on;

xfit = min(x):0.1:max(x);
yfit = min(y):0.1:max(y);
[XFIT,YFIT]= meshgrid (xfit,yfit);
ZFIT = -(d + a * XFIT + b * YFIT)/c;
mesh(XFIT,YFIT,ZFIT);

hold on;

end