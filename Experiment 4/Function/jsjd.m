function [aa] = jsjd(f1,f2)

f1(1:3) = f1(1:3) / abs(f1(3));
f2(1:3) = f2(1:3) / abs(f2(3));
angle = acos(sum(f1.*f2) / (norm(f1) * norm(f2)))/pi*180;

x(1) = f1(1) / sqrt(f1(1)^2 + f1(2)^2);
y(1) = f1(2) / sqrt(f1(1)^2 + f1(2)^2);
x(2) = f2(1) / sqrt(f2(1)^2 + f2(2)^2);
y(2) = f2(2) / sqrt(f2(1)^2 + f2(2)^2);

if x(1) < 0
   x(1:2) = - x(1:2);
end
if y(1) < 0
    y(1:2) = -y(1:2);
end

angle_h = acosd(x(1));

if y(2) > 0
    angle_e = acosd(x(2));
else
    angle_e = 360 - acosd(x(2));
end

aa = angle_h - angle_e;
if aa< 0
    aa = aa + 360;
end

if aa > 180
    aa = -angle;
else
    aa = angle;
end
