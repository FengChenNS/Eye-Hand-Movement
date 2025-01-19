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
for neuron = 1 : ok_neuron 
    for num_session = 1 : 4
        num_neuron = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:)); 
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
                        if (movetype(2) == 1) && (number_trial_T < st)
                            number_trial_T = number_trial_T + 1;
                            record(num_session,neuron,number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                        end
                        if (movetype(2) == 3) && (number_trial_UT < st)
                            number_trial_UT = number_trial_UT + 1;
                            record(num_session,neuron,number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                        end
                    end
                end
            else
                number_trial = 0;
                if num_session == 2
                    xl = 1 : 40;
                else
                    xl = 40 : -1 : 1;
                end
                for num_trial = xl 
                    if Trajectory(date).record(num_session).record_dis_RNSE(num_trial)<=tte(date)  && ...
                       number_trial < st 
                        number_trial = number_trial + 1;
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
                            record(num_session,neuron,number_trial,1:fenduan) = (firing_move(1:fenduan)-firing_focus) / 0.02;
                        else
                            record(num_session,neuron,number_trial,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                        end
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
