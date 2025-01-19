function plot_2D_figure(data_raw, type, Plane)
    color2(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
    label(1:2) = ['o','^'];
    Linewith_size(1:2) = [1.5,0.25];
    plane_pre(1:4) = Plane(1,1:4);
    a_a = plane_pre(1);
    b_a = plane_pre(2);
    c_a = plane_pre(3);
    d_a = plane_pre(4);
    n = [a_a,b_a,c_a];
    n_unit = n / norm(n);
    
    data_all(1:40,1:3) = data_raw(1,1:40,1:3);
    data_all(41:80,1:3) = data_raw(2,1:40,1:3);
    P0 = [0,0,0];
    pointt = 6;
    location_plane_point(1:3) = mean(data_all(1+(pointt-1)*10 : pointt*10,1:3),1);
    v1 = location_plane_point(1:3) - P0;
    v2 = cross([a_a, b_a, c_a], v1);
    v1 = v1 / norm(v1);
    v2 = -v2 / norm(v2);
    for i = 1 : 80
        P_new(i,1:3) = data_all(i,1:3) - P0;
        Score_Shared_plane_2D(i,1) = dot(P_new(i,1:3), v1);
        Score_Shared_plane_2D(i,2) = dot(P_new(i,1:3), v2);
    end

    for i = 1 : 8
        x = mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,1));
        y = mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,2));
        for j = 1 : 10
            diss(i,j) = sqrt((Score_Shared_plane_2D((i-1)*10+j,1)-x)^2 +...
                            (Score_Shared_plane_2D((i-1)*10+j,2)-y)^2);
        end
    end

    figure;
    for i = 1 : 3
        plot([mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,1)),mean(Score_Shared_plane_2D(1+(i)*10:i*10+10,1))],...
             [mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,2)),mean(Score_Shared_plane_2D(1+(i)*10:i*10+10,2))],...
             '-','Color',[114,113,113]/256);
        hold on
    end
    for i = 1 : 4
        dis_range(i) = std(diss(i,1:10));
        
        filledCircle([mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,1)),...
                      mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,2))],dis_range(i),100,color2(i,1:3)); hold on
    end
    for i = 1 : 4
        scatter(Score_Shared_plane_2D(1+(i-1)*10:i*10,1),...
                Score_Shared_plane_2D(1+(i-1)*10:i*10,2),75,color2(i,1:3),label(type),'LineWidth',Linewith_size(type));
        hold on
        scatter(mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,1)),...
                mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,2)),100,color2(i,1:3),'filled',label(type));
        hold on
    end
    axis equal
    xlim([-2.5,2.5]);
    ylim([-2.5,2.5]);
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    

    figure;
    for i = 1 : 3
        plot([mean(Score_Shared_plane_2D(41+(i-1)*10:40+i*10,1)),mean(Score_Shared_plane_2D(41+(i)*10:40+i*10+10,1))],...
             [mean(Score_Shared_plane_2D(41+(i-1)*10:40+i*10,2)),mean(Score_Shared_plane_2D(41+(i)*10:40+i*10+10,2))],...
             '-','Color',[114,113,113]/256);
        hold on
    end
    for i = 5:8
        dis_range(i) = std(diss(i,1:10));
        % dis_range(i) = mean(diss(i,1:10)); 
        filledCircle([mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,1)),...
                      mean(Score_Shared_plane_2D(1+(i-1)*10:i*10,2))],dis_range(i),100,color2(i-4,1:3)); hold on
    end
    for i = 1 : 4
        scatter(Score_Shared_plane_2D(41+(i-1)*10:40+i*10,1),...
                Score_Shared_plane_2D(41+(i-1)*10:40+i*10,2),75,color2(i,1:3),label(type),'LineWidth',Linewith_size(type));
        hold on
        scatter(mean(Score_Shared_plane_2D(41+(i-1)*10:i*10+40,1)),...
                mean(Score_Shared_plane_2D(41+(i-1)*10:i*10+40,2)),100,color2(i,1:3),'filled',label(type));
        hold on
    end
    axis equal
    xlim([-2.5,2.5]);
    ylim([-2.5,2.5]);
    set(gca,'xtick',[])
    set(gca,'ytick',[])
end