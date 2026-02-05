clc
clear
close all

%% Load Data
addpath(genpath(pwd));
Data(1) = load('DataExtraction_E2_demo.mat');
Trajectory(1) = load('Trajectory_E2_demo.mat');
Data_Neuron = load('neuron_select_E2_demo.mat');
number_session = 4;
%%
ok_trial(1:8) = 0;
record_move(1:8,1:100,1:100) = 0;
record_rest(1:8,1:100,1:100) = 0;
jg = 5;
num_E_E = 0;
num_H_H = 0;
num_EH_EH = 0;
for num_e = 1
    for num_session = 1 : number_session
        for num_trial = 1 : 40
            if Trajectory(num_e).record(num_session).success(num_trial) == 1  
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,1,3] % 眼左向右    
                    labell = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,1] % 眼右向左
                    labell = 2; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,4,5] % 眼上向下
                    labell = 3; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,5,4] % 眼下向上
                    labell = 4; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,3] % 手左向右
                    labell = 5; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,1] % 手右向左
                    labell = 6; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,4,5] % 手上向下
                    labell = 7; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,5,4] % 手下向上
                    labell = 8; 
                end
                ok_trial(labell) = ok_trial(labell)  + 1;

                for num_neuron = 1 : Data(num_e).record(num_session).number_neuro
                    No_neuron = Data(num_e).record(num_session).neuron_id(num_neuron);
                    No_Channel = floor((No_neuron-1) / 6) + 1;
                    time_move = Data(num_e).record(num_session).time(num_trial,4);
                    
                    tt_move = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, time_move : time_move+199) );
                    tt_rest = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, time_move-25 : time_move) );
                    
                    record_move(labell,No_Channel,ok_trial(labell)) = record_move(labell,No_Channel,ok_trial(labell)) + tt_move;
                    record_rest(labell,No_Channel,ok_trial(labell)) = record_rest(labell,No_Channel,ok_trial(labell)) + tt_rest;
                   
                end
            end
        end
    end
%
    number(1:8) = 0;
    position(1:8,1:10,1:10) = 0;
    for labell = 1 : 8
        for ele = 1 : 96
            clear aa bb
            trial_number = ok_trial(labell);
            
            aa(1 : trial_number) = record_move(labell,ele,1:trial_number);
            bb(1 : trial_number) = record_rest(labell,ele,1:trial_number);
            [h,p] = ttest(aa,bb,"Tail","both");
    
            
            if p < 0.05
                record_ans(labell,ele) = (mean(aa) - mean(bb));
            else 
                record_ans(labell,ele) = -1;
                if mean(aa) == 0 || mean(bb) ==0
                    record_ans(labell,ele) = nan;
                end
            end
            
            if mean(aa) <= 1/50
                record_ans(labell,ele) = nan;
            end
        end
    
        % plot
        clear plot_matrix;
        ele = 0;
        for i =1 : 10
            for j = 1 : 10
                f = true;
                if ((i == 1) || (i == 10)) && ((j == 1) || (j==10)) 
                    f = false;
                end
                if f
                    ele = ele + 1;
                   % if record_ans(labell,ele) ~= 0
                        plot_matrix(i,j) = record_ans(labell,ele);
                   % end
                end
            end
        end
        for i =1 : 10
            for j = 1 : 10
                if plot_matrix(i,j) == 0
                    plot_matrix(i,j) = nan;
                else
                   plot_matrix(i,j) = plot_matrix(i,j) * 50;
                end
            end
        end

        plot_matrix(1,1) = -30;
        plot_matrix(10,10) = 60;   
      
        startColor = [0 0.4470 0.7410];
        endColor = [256 256 256]/256;
        steps = 500;
        gradientColors = zeros(1500,3);
        for i = 1:500
            gradientColors(i, :) = startColor + (endColor - startColor) * (i - 1) / (steps - 1);
        end
    
        startColor = [256 256 256]/256;
      
        endColor = [0.6350 0.0780 0.1840];
        steps = 1000;
      
        for i = 501 : 1500
            gradientColors(i, :) = startColor + (endColor - startColor) * (i - 501) / (steps - 1);
        end
      
        num_dis = 0;
        for i = 1 : 10
            for j = 1 : 10
                if plot_matrix(i,j)~=-30 && plot_matrix(i,j)~=60 && ...
                   plot_matrix(i,j)~=-50 && ~isnan(plot_matrix(i,j)) %% && plot_matrix(i,j) > 0
                    number(labell) = number(labell) + 1;
                    position(labell,i,j) = 1; 
                end
            end
        end
    end
    
    for labell = 1 : 4
        pos_E(1:100,1:2) = 0;
        pos_H(1:100,1:2) = 0;
        pos_EH(1:100,1:2) = 0;
        num_E(labell) = 0;
        num_H(labell) = 0;
        num_EH(labell) = 0;
        ppp_EH(1:10,1:10) = 0;
        ppp_E(1:10,1:10) = 0;
        ppp_H(1:10,1:10) = 0;
        for i = 1 : 10
            for j = 1 : 10
                if position(labell,i,j) == 1 && position(labell+4,i,j) == 0
                    num_E(labell) = num_E(labell) + 1;
                    pos_E(num_E(labell),1:2) = [i,j]; 
                    ppp_E(i,j) = 1;
                end
    
                if position(labell,i,j) == 0 && position(labell+4,i,j) == 1
                    num_H(labell) = num_H(labell) + 1;
                    pos_H(num_H(labell),1:2) = [i,j];
                    ppp_H(i,j) = 1;
                end
                
                if position(labell,i,j) == 1 && position(labell+4,i,j) == 1
                    num_EH(labell) = num_EH(labell) + 1;
                    pos_EH(num_EH(labell),1:2) = [i,j]; 
                    ppp_EH(i,j) = 1;
                end
            end
        end

        all_dis_si = 0;
        num_dis_si = 0;
        all_dis = 0;
        num_dis = 0;
        for sis_ele = 1 : num_E(labell)
            x1 = pos_E(sis_ele,1);
            y1 = pos_E(sis_ele,2);
            for i = 1 : 10
                for j = 1 : 10
                    dis = 0;
                    if ~(i==x1 && j==y1)
                        if i~=1 && i~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 1 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 10 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                    end
                    if dis ~= 0 && dis<=jg
                       all_dis = all_dis + dis;
                       num_dis = num_dis + 1;
                    end

                end
            end
            num_E_E = num_E_E + 1;
            record_E_E(num_E_E,1) = all_dis / num_dis;

            for i = 1 : num_E(labell)
                if i~= sis_ele
                    dis = sqrt((x1 - pos_E(i,1))^2 + (y1 - pos_E(i,2))^2);
                    if dis <=jg
                        all_dis_si = all_dis_si + dis;
                        num_dis_si = num_dis_si + 1;
                    end
                end
            end
            record_E_E(num_E_E,2) = all_dis_si / num_dis_si;

        end
    
        all_dis_si = 0;
        num_dis_si = 0;
        all_dis = 0;
        num_dis = 0;
        for sis_ele = 1 : num_H(labell)
            x1 = pos_H(sis_ele,1);
            y1 = pos_H(sis_ele,2);
            for i = 1 : 10
                for j = 1 : 10
                    dis = 0;
                    if ~(i==x1 && j==y1)
                        if i~=1 && i~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 1 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 10 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                    end
                    if dis ~= 0 && dis<=jg
                       all_dis = all_dis + dis;
                       num_dis = num_dis + 1;
                    end

                end
            end
            num_H_H = num_H_H + 1;
            record_H_H(num_H_H,1) = all_dis / num_dis;

            for i = 1 : num_H(labell)
                if i~= sis_ele
                    dis = sqrt((x1 - pos_H(i,1))^2 + (y1 - pos_H(i,2))^2);
                    if dis <=jg
                        all_dis_si = all_dis_si + dis;
                        num_dis_si = num_dis_si + 1;
                    end
                end
            end
            record_H_H(num_H_H,2) = all_dis_si / num_dis_si;

        end
    
        all_dis_si = 0;
        num_dis_si = 0;
        all_dis = 0;
        num_dis = 0;
        for sis_ele = 1 : num_EH(labell)
            x1 = pos_EH(sis_ele,1);
            y1 = pos_EH(sis_ele,2);
            for i = 1 : 10
                for j = 1 : 10
                    dis = 0;
                    if ~(i==x1 && j==y1)
                        if i~=1 && i~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 1 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                        if i == 10 && j~=1 && j~=10
                            dis = sqrt((x1-i)^2 + (y1-j)^2);
                        end
                    end
                    if dis ~= 0 && dis<=jg
                       all_dis = all_dis + dis;
                       num_dis = num_dis + 1;
                    end

                end
            end
            num_EH_EH = num_EH_EH + 1;
            record_EH_EH(num_EH_EH,1) = all_dis / num_dis;

            for i = 1 : num_EH(labell)
                if i~= sis_ele
                    dis = sqrt((x1 - pos_E(i,1))^2 + (y1 - pos_E(i,2))^2);
                    if dis <=jg
                        all_dis_si = all_dis_si + dis;
                        num_dis_si = num_dis_si + 1;
                    end
                end
            end
            record_EH_EH(num_EH_EH,2) = all_dis_si / num_dis_si;

        end
    
    end
end

%% bootstrapping
num = length(record_E_E(:,1));
[bootstat,bootsam] = bootstrp(1000,@mean,1:num);
xx = 0;
for i =1 : 1000
    for i_num = 1 : num
        record_boot_E_E(i,1) = nanmean(record_E_E((bootsam(1:num,i)),1));
        record_boot_E_E(i,2) = nanmean(record_E_E((bootsam(1:num,i)),2));
    end
    if record_boot_E_E(i,1) > record_boot_E_E(i,2)
        xx= xx + 1;
    end
end
mean(record_boot_E_E(1 : 1000,2)) / mean(record_boot_E_E(1 : 1000,1))
p = min(xx/1000,1-xx/1000)


num = length(record_H_H(:,1));
[bootstat,bootsam] = bootstrp(1000,@mean,1:num);
xx = 0;
for i =1 : 1000
    for i_num = 1 : num
        record_boot_H_H(i,1) = nanmean(record_H_H((bootsam(1:num,i)),1));
        record_boot_H_H(i,2) = nanmean(record_H_H((bootsam(1:num,i)),2));
    end
    if record_boot_H_H(i,1) > record_boot_H_H(i,2)
        xx = xx + 1;
    end
end
mean(record_boot_H_H(1 : 1000,2)) / mean(record_boot_H_H(1 : 1000,1))
p_H_H = min(xx/1000,1-xx/1000)


num = length(record_EH_EH(:,1));
[bootstat,bootsam] = bootstrp(1000,@mean,1:num);
xx = 0;
for i =1 : 1000
    for i_num = 1 : num
        record_boot_EH_EH(i,1) = nanmean(record_EH_EH((bootsam(1:num,i)),1));
        record_boot_EH_EH(i,2) = nanmean(record_EH_EH((bootsam(1:num,i)),2));
    end
    if record_boot_EH_EH(i,1) > record_boot_EH_EH(i,2)
    end
end
mean(record_boot_EH_EH(1 : 1000,2)) / mean(record_boot_EH_EH(1 : 1000,1))
p_EH_EH = min(xx/1000,1-xx/1000)







