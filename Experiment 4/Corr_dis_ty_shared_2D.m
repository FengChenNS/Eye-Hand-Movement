clc
clear
data = load("Shared_plane_positon_ty.mat");
data_t = xlsread('data.xlsx');
data_corr = data_t(1:40,10:17);

color2(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
for session = 1 : 2
    for i = 1 : 4
        for j = 1 : 3
            ZX_E(session,i,j) = mean(data.record_scotter(session).data_E(i*10-9:i*10,j));
            ZX_H(session,i,j) = mean(data.record_scotter(session).data_H(i*10-9:i*10,j));
        end
    end
end


for session = 1 : 2
    data_tt(1:40,1:3) = data.record_scotter(session).data_E(1:40,1:3);
    data_tt(41:80,1:3) = data.record_scotter(session).data_H(1:40,1:3);
    record_ac(1:100,session*2-1:session*2) = SVM_PCA_Shared(data_tt);
    ac_mean(session,1) = mean(record_ac(1:100,session*2-1));
    ac_mean(session,2) = mean(record_ac(1:100,session*2));
end


for session = 1 : 2
    data_tt(1:40,1:3) = data.record_scotter(session).raw_score_E(1:40,1:3);
    data_tt(41:80,1:3) = data.record_scotter(session).raw_score_H(1:40,1:3);
    record_ac(1:100,session*2-1:session*2) = SVM_PCA_Shared(data_tt);
    ac_mean_3d(session,1) = mean(record_ac(1:100,session*2-1));
    ac_mean_3d(session,2) = mean(record_ac(1:100,session*2));
end

angle_big_0 = 0;
for i = 1 : 10000
    for session = 1: 2
        data_E(1:40,1:3) = data.record_scotter(session).raw_score_E(1:40,1:3);
        data_H(41:80,1:3) = data.record_scotter(session).raw_score_H(1:40,1:3);
        ZXX_E(1:4,1:3) = 0;

        ss = randi(10,1,10);
        for j =1 : 4 
            jj = (j-1) * 10;
            ZXX_E(j,1) = mean(data_E(jj+ss(1:10),1));
            ZXX_E(j,2) = mean(data_E(jj+ss(1:10),2));
            ZXX_E(j,3) = mean(data_E(jj+ss(1:10),3));
        end
        ZXX_H(1:4,1:3) = 0;
        for j =1 : 4 
            jj = (j-1) * 10;
            ZXX_H(j,1) = mean(data_H(jj+ss(1:10),1));
            ZXX_H(j,2) = mean(data_H(jj+ss(1:10),2));
            ZXX_H(j,3) = mean(data_H(jj+ss(1:10),3));
        end
        ZX_E(1:3) = mean(ZXX_E,1);
        ZX_H(1:3) = mean(ZXX_H,1);
        line(session,1:3) = ZX_E(1:3) - ZX_H(1:3);
    end
    line_1(1:3) = line(1,1:3);
    line_2(1:3) = line(2,1:3);
    angle(i) = jsjd2(line_1,line_2);
 
    if angle(i) > 0
        angle_big_0 = angle_big_0 + 1;
    end
    i
end

t = angle_big_0 / 10000;
p = min(t, 1-t)
mean(angle)

for i = 1 : 4
    ss(1:40,1:3) = data.record_scotter(i).raw_score_H(1:40,1:3);
    ss(41:80,1:3) = data.record_scotter(i).raw_score_E(1:40,1:3);
    record_Score(i).Score_all = ss;
end
[angel_ans_p,record_angle_own] = boot_plane_own_angle(record_Score);
record_angle_own_cos = cosd(record_angle_own);
%%
for session = 1 : 2
    pE = data.record_scotter(session).panel_data_E;
    pH = data.record_scotter(session).panel_data_H;
    data_E = data.record_scotter(session).data_E;
    data_H = data.record_scotter(session).data_H;
    Plane_E(session,1:4) = pE;
    Plane_H(session,1:4) = pH;
    for i = 1 : 40
        dataE(i,1:3) = yinshe_v(pE(1),pE(2),pE(3),pE(4),data_E(i,1),data_E(i,2),data_E(i,3));
        dataH(i,1:3) = yinshe_v(pH(1),pH(2),pH(3),pH(4),data_H(i,1),data_H(i,2),data_H(i,3));
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

[h,p] = ttest(dis_mean_E(1,1:4),dis_mean_E(2,1:4))
[h,p] = ttest(dis_mean_H(1,1:4),dis_mean_H(2,1:4))

plot_2D_figure(dataE_all,1,Plane_E);
plot_2D_figure(dataH_all,2,Plane_H);

for session = 1 : 2
    xxx = disE(1:40,session);
    xx= data_corr(1:40,session*2);
    x_1 = xxx;
    x_2 = xx;
    x_1 = zscore(xxx);
    x_2 = zscore(xx);
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
    x_22 = polyval(pn,[-3,4]);
    plot([-3,4],x_22(:));
    hold on
   
    xlim([-3,4])
    ylim([-3,4])
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'position',[0.1,0.1,0.5,0.5])
    set(gcf,'position',[200,200,600,600]);
end