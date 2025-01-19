clc; clear;
Data(1) = load('DataExtraction_9_23.mat');
Data(2) = load('DataExtraction_9_24.mat');
Trajectory_fd(1) = load('Trajectory_9_23_fenduan.mat');
Trajectory_fd(2) = load('Trajectory_9_24_fenduan.mat');
Trajectory(1) = load('Trajectory_9_23.mat');
Trajectory(2) = load('Trajectory_9_24.mat');
Tra(1) = load('Trajectory_9_23_fenduan_4.mat');
Tra(2) = load('Trajectory_9_24_fenduan_4.mat');
neuron_select = load('neuron_select_E4.mat');
st = 10;
fenduan = 4; 
f = 0;
csn = floor(st/5);
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
record(1:4,1:96,1:40,1:fenduan) = 0;
for neuron = 1 : ok_neuron 
    for num_session = 1 : 4
        num_neuron = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:)); 
        ele = floor((neuron_id(neuron)-1) / 6) +1;
            if num_session == 1 || num_session == 4
                number_trial_T = 0;
                number_trial_UT = 0;
                for num_triall = 1 : 20
                    num_trial = selected(date,num_session,num_triall);
                    if (number_trial_T + number_trial_UT) < 2*st 
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
                        if f == 1
                            firing_move(1:fenduan) = firing_move(1:fenduan) - firing_focus;
                        end
                        movetype = Data(date).record(num_session).move_type(num_trial, 1:3);
                        if num_triall <=10
                            number_trial_T = number_trial_T + 1;
                            for ll = 1 : fenduan
                                record(num_session,ele,number_trial_T,ll) = ...
                                        record(num_session,ele,number_trial_T,ll) + ...
                                        (firing_move(ll)) / 0.02;
                            end
                        end
                        if num_triall >10
                            number_trial_UT = number_trial_UT + 1;
                            for ll = 1 : fenduan
                                record(num_session,ele,number_trial_UT+st,ll) = ...
                                    record(num_session,ele,number_trial_UT+st,ll) + ...
                                    (firing_move(ll)) / 0.02;
                            end
                        end
                    end
                end
            end        
    end
end

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

total(1:fenduan,1:4) = 0;
ok_neuron = 96;
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
            bianyi_sj(num_neuron,num_trial,num_fd,1) = abs(record(1,num_neuron,num_trial,num_fd)-mean_Spike_T_Q);
            bianyi_sj(num_neuron,num_trial,num_fd,2) = abs(record(1,num_neuron,num_trial+st,num_fd)-mean_Spike_UT_Q);
            bianyi_sj(num_neuron,num_trial,num_fd,3) = abs(record(4,num_neuron,num_trial,num_fd)-mean_Spike_T_H);
            bianyi_sj(num_neuron,num_trial,num_fd,4) = abs(record(4,num_neuron,num_trial+st,num_fd)-mean_Spike_UT_H);
        
            bianyi_sj_tra(num_trial,num_fd,1) = abs(record_Tra(1,num_trial,num_fd)-mean_Tra_T_Q);
            bianyi_sj_tra(num_trial,num_fd,2) = abs(record_Tra(1,num_trial+st,num_fd)-mean_Tra_UT_Q);
            bianyi_sj_tra(num_trial,num_fd,3) = abs(record_Tra(4,num_trial,num_fd)-mean_Tra_T_H);
            bianyi_sj_tra(num_trial,num_fd,4) = abs(record_Tra(4,num_trial+st,num_fd)-mean_Tra_UT_H);
        end
    end
end

for fd = 1
    for ii = 1 : 4
        for ele = 1 : 96
            nn_data(1:st*fenduan) = 0;
            tr_data(1:st*fenduan) = 0;
            ss = 0;
            for trial = 1 : st
               
                    ss = ss + 1;
                    nn_data(ss) = bianyi_sj(ele,trial,fd,ii);
                    tr_data(ss) = bianyi_sj_tra(trial,fd,ii);
                
            end
            [rr,pp] = corrcoef(nn_data(1:ss),tr_data(1:ss));
            R(fd,ii,ele) = rr(1,2);
            P(fd,ii,ele) = pp(1,2);
        end
    end
end

x1 = 1;
x2 = 3;
ss = 0;
for fd = 1 : fd
    for ele = 1 : 96
        if ~isnan(R(fd,x1,ele)) && ~isnan(R(fd,x2,ele))
            ss = ss + 1;
            t_1(ss) = R(fd,x1,ele);
            t_2(ss) = R(fd,x2,ele);
        end

    end

end

[h,p] = ttest2(t_1,t_2)

x1 = 1;
x2 = 3;
for fd = 1 : fd
    ss = 0;
    t_1 = 0;
    t_2 = 0;
    for ele = 1 : 96
        if ~isnan(R(fd,x1,ele)) && ~isnan(R(fd,x2,ele))
            ss = ss + 1;
            t_1 = t_1 + R(fd,x1,ele);
            t_2 = t_2 + R(fd,x2,ele);
        end
    end

    tt_1(fd) = t_1 / ss;
    tt_2(fd) = t_2 / ss;

end

[h,p] = ttest(tt_1,tt_2)
s
startColor = [0 0.4470 0.7410];
    endColor = [256 256 256]/256;
    steps = 500;
    gradientColors = zeros(1000,3);
    for i = 1:500
        gradientColors(i, :) = startColor + (endColor - startColor) * (i - 1) / (steps - 1);
    end

    startColor = [256 256 256]/256;

    endColor = [0.6350 0.0780 0.1840];
    steps = 500;
    for i = 501 : 1000
        gradientColors(i, :) = startColor + (endColor - startColor) * (i - 501) / (steps - 1);
    end

for lx = 1 : 3
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
                plot_matrix(i,j) = R(fd,lx,ele);
                if P(fd, lx,ele) > 0.05
                    plot_matrix(i,j) = 0;
                end
            end
        end
    end
    for i =1 : 10
        for j = 1 : 10
            if isnan (plot_matrix(i,j))
                plot_matrix(i,j) = 0;
            end
        end
    end
   
    plot_matrix(1,1) = 1;
    plot_matrix(10,10) = -1;
    
   figure
   h = heatmap(plot_matrix);
   colormap(h, gradientColors);
    sss(lx,1:10,1:10) = plot_matrix;
end
