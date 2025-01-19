function [pos] = yinshe(a,b,c,d,x,y,z)
    t = (a*x + b*y + c*z + d) / (a^2 + b^2 + c^2);
    pos(1) = x - a*t;
    pos(2) = y - b*t;
    pos(3) = z - c*t;
end