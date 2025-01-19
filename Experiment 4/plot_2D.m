function fig = plot_2D(data,type)
    color2(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
    label(1:2) = ['o','^'];
    Linewith_size(1:2) = [1.5,0.25];
    for i = 1 : 4
        for j = 1 : 3
            ZX(i,j) = mean(data(i*10-9:i*10,j));
        end
    end
    Centt(1:3) = mean(ZX,1);
    for i = 1 : 4
        dis(i) = sqrt((ZX(i,1) - Centt(1,1))^2 + (ZX(i,2) - Centt(1,2))^2 + (ZX(i,3) - Centt(1,3))^2);
        if i ~= 2
            zx_a(1:3) =   ZX(i,1:3) - Centt(1:3);
            zx_b(1:3) =   ZX(2,1:3) - Centt(1:3);
            record_cos(i) = (zx_a * zx_b') / (norm(zx_a) * norm(zx_b));
            record_sin(i) = norm(cross(zx_a,zx_b)) / (norm(zx_a) * norm(zx_b));
        end
    end

    zb_zx(2,1) = dis(2);
    zb_zx(2,2) = 0;
    zb_zx(1,1) = dis(1) * record_cos(1);
    zb_zx(1,2) = dis(1) * record_sin(1)* -1;
    for i = 3 : 4
        dis_1 = sqrt((ZX(i,1)- ZX(1,1))^2 + (ZX(i,2)- ZX(1,2))^2 + (ZX(i,3)- ZX(1,3))^2);
        zb_zx(i,1) = dis(i) * record_cos(i);
        t = dis(i) * record_sin(i);
        d_1 = sqrt((zb_zx(1,1) - zb_zx(i,1))^2 + (zb_zx(1,2) - t)^2);
        d_2 = sqrt((zb_zx(1,1) - zb_zx(i,1))^2 + (zb_zx(1,2) + t)^2);

        if abs(d_1 - dis_1) < abs(d_2 - dis_1)
            zb_zx(i,2) = t;
        else
            zb_zx(i,2) = -t;
        end
    end

    for i = 1 : 40
        dis_0 = sqrt((data(i,1)- Centt(1))^2 + (data(i,2)- Centt(2))^2 + (data(i,3)- Centt(3))^2);  %与中心的距离
        dis_1 = sqrt((data(i,1)- ZX(1,1))^2 + (data(i,2)- ZX(1,2))^2 + (data(i,3)- ZX(1,3))^2);  %与第一个点的距离

        zx_a(1:3) =   data(i,1:3) - Centt(1:3);
        zx_b(1:3) =   ZX(2,1:3) - Centt(1:3);
        cos_v = (zx_a * zx_b') / (norm(zx_a) * norm(zx_b));
        sin_v = norm(cross(zx_a,zx_b)) / (norm(zx_a) * norm(zx_b));
        
        zb_data(i,1) = dis_0 * cos_v;
        t = dis_0 * sin_v;
        

        d_1 = sqrt((zb_zx(1,1) - zb_data(i,1))^2 + (zb_zx(1,2) - t)^2);
        d_2 = sqrt((zb_zx(1,1) - zb_data(i,1))^2 + (zb_zx(1,2) + t)^2);
        
        if abs(d_1 - dis_1) < abs(d_2 - dis_1)
            zb_data(i,2) = t;
        else
            zb_data(i,2) = -t;
        end
    end
    
    for i = 1 : 4
        for j = 1 : 10
            t = i*10-10+j;
            diss(i,j) = sqrt( (zb_data(t,1) - zb_zx(i,1))^2 + (zb_data(t,2) - zb_zx(i,2))^2);
        end
    end

    fig = figure;
    for i = 1 : 4
        dis_range(i) = std(diss(i,1:10)); 
        filledCircle([zb_zx(i,1),zb_zx(i,2)],dis_range(i),100,color2(i,1:3)); hold on
    end
    
    for i = 1 : 4
        scatter(zb_data(i*10-9:i*10,1),zb_data(i*10-9:i*10,2),75,color2(i,1:3),label(type),'LineWidth',Linewith_size(type)); hold on
    end
    axis equal
  
    
    scatter(zb_zx(1:4,1),zb_zx(1:4,2),100,color2,'filled',label(type)); hold on

end