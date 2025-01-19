clc; clear; close all
Data(1) = load('DataExtraction_9_23.mat');
Data(2) = load('DataExtraction_9_24.mat');
Trajectory_fd(1) = load('Trajectory_9_23_fenduan.mat');
Trajectory_fd(2) = load('Trajectory_9_24_fenduan.mat');
Trajectory(1) = load('Trajectory_9_23.mat');
Trajectory(2) = load('Trajectory_9_24.mat');
Tra(1) = load('Trajectory_9_23_fenduan_4.mat');
Tra(2) = load('Trajectory_9_24_fenduan_4.mat');
neuron_Anova_eye = load('Eye_Anova_neuron_1_122_4duan.mat');
neuron_select = load('neuron_select_E4.mat');
st = 10; 
fenduan = 4; 
f = 0; 
csn = floor(st/5); 
tte(1:2) = [3,3];
date = 1;
ok_neuron = 0;
for no_neuron = 1 : 600
    ff = 1;
    for num_session = 1 : 4
        if Data(date).record(num_session).neuron_id_logical(no_neuron) == 0 || ...
            neuron_select.neuron_select(date,num_session,no_neuron) == 0
            ff = 0;
        end
    end
    if ff == 1 
        ok_neuron = ok_neuron + 1;
        neuron_id(ok_neuron) = no_neuron;
    end
end 

for neuron = 1 : ok_neuron 
    for num_session = 1 : 4
        num_neuron = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:)); 
            if num_session == 1 || num_session == 4
                number_trial_T = 0;
                number_trial_UT = 0;
                for num_triall = 1 : 20
                    num_trial = selected(date,num_session,num_triall);
                    
                        time_f_begin = Data(date).record(num_session).time(num_trial,3)-25;
                        time_f_end = Data(date).record(num_session).time(num_trial,3);
                        firing_focus = mean(Data(date).record(num_session).Spike_Count(num_neuron,num_trial,time_f_begin:time_f_end));
                        time_m_begin = Data(date).record(num_session).time(num_trial,4);
                        time_m_end = Data(date).record(num_session).time(num_trial,4) + 199;
                        time_length = 200;
                        time_fenduan = floor(time_length / fenduan);
                        firing_move(1:fenduan) = 0;
                        for i = 1 : fenduan
                            t_1 = time_m_begin + (i-1) * time_fenduan;
                            t_2 = t_1 + time_fenduan-1;
                            firing_move(i) = mean(Data(date).record(num_session).Spike_Count(num_neuron,num_trial,t_1:t_2));
                        end
                        if num_triall <= 10
                            number_trial_T = number_trial_T + 1;
                            record(num_session,neuron,number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                        end
                        if num_triall > 10
                            number_trial_UT = number_trial_UT + 1;
                            record(num_session,neuron,number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                        end
                   
                end
            end        
    end
end

%% 
record_Tra(1:4,1:2*st,1:fenduan) = 0;
for num_session = 1 :4 
    if (num_session == 1) || (num_session == 4)
        number_trial_T = 0;
        number_trial_UT = 0;
        for num_triall = 1 : 20  
            num_trial = selected(date,num_session,num_triall);
            if (number_trial_T + number_trial_UT) < 2*st 
                movetype = Data(date).record(num_session).move_type(num_trial, 1:3);
                if (movetype(2) == 1) && (number_trial_T < st)
                    number_trial_T = number_trial_T + 1;
                    record_Tra(num_session,number_trial_T,1:fenduan) = ...
                        Tra(date).record_fenduan_4(num_session,num_triall,1:fenduan);
                end
                if (movetype(2) == 3) && (number_trial_UT < st)
                    number_trial_UT = number_trial_UT + 1;
                    record_Tra(num_session,number_trial_UT+st,1:fenduan) = ...
                        Tra(date).record_fenduan_4(num_session,num_triall,1:fenduan);
                end
            end
        end
    end
end

%%
total(1:fenduan,1:4) = 0;
for num_fd = 1 :fenduan 
    for num_neuron = 1 : ok_neuron
        mean_Spike_T_Q = mean(record(1,num_neuron,1:st,num_fd));
        mean_Spike_UT_Q = mean(record(1,num_neuron,1+st:st*2,num_fd));
        mean_Spike_T_H = mean(record(4,num_neuron,1:st,num_fd));
        mean_Spike_UT_H = mean(record(4,num_neuron,1+st:st*2,num_fd));
        mean_Tra_T_Q = mean(record_Tra(1,1:st,num_fd));
        mean_Tra_UT_Q = mean(record_Tra(1,1+st:st*2,num_fd));
        mean_Tra_T_H = mean(record_Tra(4,1:st,num_fd));
        mean_Tra_UT_H = mean(record_Tra(4,1+st:st*2,num_fd));
        for num_trial = 1 : st
            bianyi_sj(num_trial,1) = abs(record(1,num_neuron,num_trial,num_fd)-mean_Spike_T_Q);
            bianyi_sj(num_trial,2) = abs(record(1,num_neuron,num_trial+st,num_fd)-mean_Spike_UT_Q);
            bianyi_sj(num_trial,3) = abs(record(4,num_neuron,num_trial,num_fd)-mean_Spike_T_H);
            bianyi_sj(num_trial,4) = abs(record(4,num_neuron,num_trial+st,num_fd)-mean_Spike_UT_H);
        
            bianyi_sj_tra(num_trial,1) = abs(record_Tra(1,num_trial,num_fd)-mean_Tra_T_Q);
            bianyi_sj_tra(num_trial,2) = abs(record_Tra(1,num_trial+st,num_fd)-mean_Tra_UT_Q);
            bianyi_sj_tra(num_trial,3) = abs(record_Tra(4,num_trial,num_fd)-mean_Tra_T_H);
            bianyi_sj_tra(num_trial,4) = abs(record_Tra(4,num_trial+st,num_fd)-mean_Tra_UT_H);
        end
        for i = 1 : 4
            [R(num_fd,num_neuron,i),P(num_fd,num_neuron,i)] = corr(bianyi_sj(1:st,i),bianyi_sj_tra(1:st,i));
            if (P(num_fd,num_neuron,i) < 0.05) && (isnan(R(num_fd,num_neuron,i)) == 0)
                total(num_fd,i) = total(num_fd,i) + 1;
            end
        end
        
    end
end

%%
num(1:4) = 0;
for i = 1 : 4
    for fd = 1 : 4
        cc = 0; Mean_R(i,fd) = 0;
        for num_neuron = 1 : ok_neuron
           
            if ~isempty(find(neuron_id(num_neuron) == neuron_Anova_eye.record_sum_eye(fd,:)))
                cc = cc + 1;
                Mean_R(i,fd) = Mean_R(i,fd) + nanmean(R(fd,1:ok_neuron,i));
        
            end
        end
        Mean_R(i,fd) = Mean_R(i,fd) / cc;
    end

    for num_neuron = 1 : ok_neuron
        f = false;
        for fd = 1 : 4
            if P(fd,num_neuron,i)<0.05
                f = true;
            end
            
        end
        if f 
            num(i) = num(i) + 1;
            no_neruon_ans(i,num(i)) = Data(2).record(1).neuron_id(num_neuron);
        end
    end      
end



%%
no_veen = load('VEEN_No_neuron.mat');
num_veen = load('VEEN_No_neuron_num.mat');
date = 1;
record_num_ans(1:4,1:7) = 0;
for session = 1 : 2
    for j = 1 : 7
        numm = num_veen.record_num(date,session,j);
        xx(1:numm) = no_veen.record(date,session,j,1:numm);
        for jj = 1 : numm
            if session == 1
                if ~isempty(find(xx(jj) == no_neruon_ans(1,:))) 
                   record_num_ans(1,j) = record_num_ans(1,j) + 1; 
                end
                if ~isempty(find(xx(jj) == no_neruon_ans(2,:)))
                    record_num_ans(2,j) = record_num_ans(2,j) + 1;
                end
            end
            if session == 2
                if ~isempty(find(xx(jj) == no_neruon_ans(3,:)))
                    record_num_ans(3,j) = record_num_ans(3,j) + 1;
                end
                if ~isempty(find(xx(jj) == no_neruon_ans(4,:)))
                    record_num_ans(4,j) = record_num_ans(4,j) + 1;
                end
            end
        end
    end
end


%%
data_hand = load('Hand_Anova_neuron_1_122_4duan.mat');
data_eye = load('Eye_Anova_neuron_1_122_4duan.mat');
date = 1;
record_num_ans(1:4,1:7) = 0;
% no_neruon_ans(1) 前测 
session = 1;
num_hh = 0;
num_ee = 0;
num_he = 0;
f_h = 0;
f_e = 0;
for i = 1 : num(1)
    no_neuron = no_neruon_ans(session,i);
    f_h =0; f_e = 0;
    if ~isempty(find(data_hand(date).record_same(1,:) == no_neuron,1))
        f_h = 1;
    end
    if ~isempty(find(data_eye(date).record_sum_eye(1,:) == no_neuron,1))
        f_e = 1;
    end
    if f_h == 1 && f_e == 1 
        num_he = num_he + 1;
    end
    if f_h == 0 && f_e == 1 
        num_ee = num_ee + 1;
    end
    if f_h == 1 && f_e == 0
        num_hh = num_hh + 1;
    end
end

session = 3;
num_hh = 0;
num_ee = 0;
num_he = 0;
f_h = 0;
f_e = 0;
for i = 1 : num(1)
    no_neuron = no_neruon_ans(session,i);
    f_h =0; f_e = 0;
    if ~isempty(find(data_hand(date).record_same(2,:) == no_neuron,1))
        f_h = 1;
    end
    if ~isempty(find(data_eye(date).record_sum_eye(3,:) == no_neuron,1))
        f_e = 1;
    end
    if f_h == 1 && f_e == 1 
        num_he = num_he + 1;
    end
    if f_h == 0 && f_e == 1 
        num_ee = num_ee + 1;
    end
    if f_h == 1 && f_e == 0
        num_hh = num_hh + 1;
    end
end


