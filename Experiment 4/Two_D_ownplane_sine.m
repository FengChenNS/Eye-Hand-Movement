clc
clear
close all
data = load("Scotter_data_ownplane_sine.mat");
data_t = xlsread('data.xlsx');
data_corr = data_t(1:40,2:9);
color2(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
for session = 1 : 4
    for i = 1 : 4
        for j = 1 : 3
            ZX_E(session,i,j) = mean(data.record_scotter(session).data_E(i*10-9:i*10,j));
            ZX_H(session,i,j) = mean(data.record_scotter(session).data_H(i*10-9:i*10,j));
        end
    end
end


for i = 1 : 1000
    for session = 4
        record_ac(1:100,session*2-1) = SVM_PCA_2(data.record_scotter(session).data_E(1:40,1:3));
        record_ac(1:100,session*2) = SVM_PCA_2(data.record_scotter(session).data_H(1:40,1:3)); 
        ac_mean(session,1) = mean(record_ac(1:100,session*2-1));
        ac_mean(session,2) = mean(record_ac(1:100,session*2));
    end
end
for time = 1 : 10000
    for session = 1 : 4
        for i = 1 : 4
            xxx = randsample(10,10,'true');
           
            for j = 1 : 3
                ZX_E(session,i,j) = mean(data.record_scotter(session).data_E(i*10-10+xxx(1:10),j));
                ZX_H(session,i,j) = mean(data.record_scotter(session).data_H(i*10-10+xxx(1:10),j));
            end
        end
        EE(1:4,1:3) = ZX_E(session,1:4,1:3);
        HH(1:4,1:3) = ZX_H(session,1:4,1:3);
        for jj =1 : 3
            Zhou(session,jj) = mean(ZX_E(session,1:4,jj)) - mean(ZX_H(session,1:4,jj));
        end
        [a(session,1),b(session,1),c(session,1),d(session,1)] = ...
            threedplane(EE(1:4,1), EE(1:4,2), EE(1:4,3));
        [a(session,2),b(session,2),c(session,2),d(session,2)] = ...
            threedplane(HH(1:4,1), HH(1:4,2), HH(1:4,3));
        f_E(session,1:3) = calculate_fxl(a(session,1),b(session,1),c(session,1),d(session,1),...
                                     EE(1:4,1), EE(1:4,2), EE(1:4,3));
        f_H(session,1:3) = calculate_fxl(a(session,2),b(session,2),c(session,2),d(session,2),...
                                     HH(1:4,1), HH(1:4,2), HH(1:4,3));
        angle_Hand_Eye(time,session) = jsjd(f_H(session,1:3),f_E(session,1:3));

        
    end
    angle_Zhou(time,1) = jsjd2(Zhou(1,1:3),Zhou(2,1:3));
    angle_Zhou(time,2) = jsjd2(Zhou(3,1:3),Zhou(4,1:3));

    angle_Change(time,1) = jsjd2(f_E(1,1:3),f_E(2,1:3));
    angle_Change(time,2) = jsjd2(f_E(3,1:3),f_E(4,1:3));
    angle_Change(time,3) = jsjd2(f_H(1,1:3),f_H(2,1:3));
    angle_Change(time,4) = jsjd2(f_H(3,1:3),f_H(4,1:3));
      
end
p_z_1 = 0;
for time = 1 : 10000
    if angle_Zhou(time,1)>0
        p_z_1 = p_z_1 + 1;
    end
end
p_z_1 = min(1-p_z_1/10000, p_z_1/10000)

for i = 1 : 4
    p1(i) = 0;
    p2(i) = 0;
    for time = 1 : 10000

        if angle_Hand_Eye(time,i) > 0 && i<3
            p1(i) = p1(i) + 1;
        end
        if angle_Hand_Eye(time,i) > 90 && i>2
            p1(i) = p1(i) + 1;
        end

        if angle_Change(time,i) > 0 
            p2(i) = p2(i) + 1;
        end
        
    end
    p2(i) = min(1-p2(i)/10000, p2(i)/10000)
    mean2(i) = mean(angle_Change(:,i))
    std2(i) = std(angle_Change(:,i)) 

    
    p1(i) = min(1-p1(i)/10000, p1(i)/10000)
    mean1(i) = mean(angle_Hand_Eye(:,i))
    std1(i) = std(angle_Hand_Eye(:,i))
end

for session = 1 : 4
    pE = data.record_scotter(session).panel_data_E;
    pH = data.record_scotter(session).panel_data_H;
    data_E = data.record_scotter(session).data_E;
    data_H = data.record_scotter(session).data_H;
    Plane_E(session,1:4) = pE;
    Plane_H(session,1:4) = pH;
    for i = 1 : 40
        dataE(i,1:3) = yinshe(pE(1),pE(2),pE(3),pE(4),data_E(i,1),data_E(i,2),data_E(i,3));
        dataH(i,1:3) = yinshe(pH(1),pH(2),pH(3),pH(4),data_H(i,1),data_H(i,2),data_H(i,3));
    end

    
    dataE_all(session,1:40,1:3) = dataE(1:40,1:3);
    dataH_all(session,1:40,1:3) = dataH(1:40,1:3);

    record_ac(1:200,session*2-1) = SVM_PCA_2(dataE);
    record_ac(1:200,session*2) = SVM_PCA_2(dataH); 
    ac_mean(session,1) = mean(record_ac(1:200,session*2-1));
    ac_mean(session,2) = mean(record_ac(1:200,session*2));

    for i = 1 : 4
        x_meanE = mean(dataE((i-1) * 10 +1:i*10,1));
        y_meanE = mean(dataE((i-1) * 10 +1:i*10,2));
        z_meanE = mean(dataE((i-1) * 10 +1:i*10,3));

        x_meanH = mean(dataH((i-1) * 10 +1:i*10,1));
        y_meanH = mean(dataH((i-1) * 10 +1:i*10,2));
        z_meanH = mean(dataH((i-1) * 10 +1:i*10,3));
        
        for j = 1 : 10
            t = (i-1) * 10 + j;
            disE(t,session) = sqrt((dataE(t,1) - x_meanE)^2 + (dataE(t,2) - y_meanE)^2 + (dataE(t,3) - z_meanE)^2);
            disH(t,session) = sqrt((dataH(t,1) - x_meanH)^2 + (dataH(t,2) - y_meanH)^2 + (dataH(t,3) - z_meanH)^2);
        end
        dis_mean_E(session,i) = mean(disE(t-9:t,session));
        dis_mean_H(session,i) = mean(disH(t-9:t,session));
    end
end

%%
plot_2D_figure(dataE_all,1,Plane_E);
plot_2D_figure(dataH_all,2,Plane_H);

for session =  3:4
    x = disE(1:40,session);
    x_1 = zscore(x);
    x = data_corr(1:40,session*2);
    x_2 = zscore(x);
    [c,p] = corrcoef(x_1,x_2);
    corr(session) = c(1,2);
    corr_p(session) = p(1,2);

    figure;
    for i = 1 : 4
        b = (i-1)*10;
        plot(x_1(b+1:b+10),x_2(b+1:b+10),'.','Color',color2(i,1:3),'MarkerSize',25);
        hold on
    end
    [pn,s,mu] = polyfit(x_1(:),x_2(:),1);
    x = LinearModel.fit(x_1,x_2);
    x_22 = polyval(pn,[-2,4]);
    plot([-2,4],x_22(:));
    hold on

end

