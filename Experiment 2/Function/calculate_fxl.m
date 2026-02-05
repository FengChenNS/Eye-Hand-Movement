function f = calculate_fxl(a,b,c,d,x,y,z)
    fd = length(x);
    ys_point(1:fd,1:3) =0;
    for point = 1 : fd
        ys_point(point,1:3) = yinshe(a,b,c,d,x(point),y(point),z(point));
    end
    
    minn = 0;
    maxx(1:3) = 0;
    for i = 1 : fd
        for j = i+1 : fd
            for k = j+1 : fd
                A(1:3) = ys_point(i,1:3);
                B(1:3) = ys_point(j,1:3);
                C(1:3) = ys_point(k,1:3);
                AB = B-A;
                BC = C-B;
                Z=cross(AB,BC);  
                s=1/2*norm(Z);
                if s > minn
                    minn = s;
                    maxx(1) = i;
                    maxx(2) = j;
                    maxx(3) = k;
                    f = Z;
                end
            end
        end
    end

end
