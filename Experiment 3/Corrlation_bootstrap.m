clc; clear; close all
%% load data
Data_Spike(1) = load('DataExtraction_8_25.mat');
Data_Spike(2) = load('DataExtraction_8_26.mat');
Data_Spike(3) = load('DataExtraction_9_02.mat');
Data_Traj(1) = load('Trajectory_8_25.mat');
Data_Traj(2) = load('Trajectory_8_26.mat');
Data_Traj(3) = load('Trajectory_9_02.mat');
Data_neuron_select = load('neuron_select_E2_1Hz.mat');
number_session = 4;
%%
ok_trial(1:8) = 0;
begin_xxx = 0;
num_e = date;
record_ori(1:8,1:96) = 0;
record_all(1:8,1:100,1:96) = 0;
for num_e = 2
    for num_session = 1:number_session

        for num_trial = 1 : 40
            if Trajectory(num_e).record(num_session).success(num_trial) == 1  
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,1,2] 
                    labell = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,2,1] 
                    labell = 2; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,2,3] 
                    labell = 3; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,2] 
                    labell = 4; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,2] 
                    labell = 5; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,1] 
                    labell = 6; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,3] 
                    labell = 7; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,2]
                    labell = 8; 
                end
                ok_trial(labell) = ok_trial(labell)  + 1;
                
                for num_neuron = 1 : Data(num_e).record(num_session).number_neuro
                    xx = floor((Data(num_e).record(num_session).neuron_id(num_neuron)  - 1) / 6) +1;
                    tt = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199) );
                         
                    record_ori(labell,xx) = record_ori(labell,xx) + tt;
                    record_all(labell,ok_trial(labell),xx) = record_all(labell,ok_trial(labell),xx) + tt;
                end
            end
        end
    end
end


%%
trial_number = max(ok_trial(1:8));
okneuron_number = 96;
% ss(1:4,1:2) = [1,2; 3,4; 5,6; 7,8];
% ss(1:4,1:2) = [1,3; 2,4; 5,7; 6,8];
ss(1:4,1:2) = [1,4; 2,3; 5,8; 6,7];
all_time = 1000;
for time = 1 : all_time
    for label = 1 : 8
        clear xx
        xx = round(rand(trial_number,1) * (ok_trial(label) -1)) + 1;
        for j = 1 : okneuron_number
            record(label,j) = mean(record_all(labell,xx(1:trial_number),j));
        end
    end
    
    for  i = 1 : okneuron_number
        mean_fr_eye = mean(record(1:4,i));
        mean_fr_hand = mean(record(5:8,i)); 
        record(1:4,i) = record(1:4,i) - mean_fr_eye;
        record(5:8,i) = record(5:8,i) -  mean_fr_hand;
    end
    
    for i = 1 : 4
        record_h(i,1:okneuron_number) = (record(ss(i,1), 1:okneuron_number) + ...
                                         record(ss(i,2), 1:okneuron_number) ) /2;
    end


    for i = 1 : 4
        for j = 1 : 4
            data_1(1:okneuron_number) = record_h(i,1:okneuron_number);
            data_2(1:okneuron_number) = record_h(j,1:okneuron_number);
            corr_rate(i,5-j) = corr2(data_1,data_2);
            [r,p] = corrcoef(data_1,data_2);
            corr_rate_p(i,5-j) = p(1,2);
        end
    end

    record_ans(time,1) = corr_rate(1,1);
    record_ans(time,2) = corr_rate(1,2);

end

%%
xx = 0;
for i = 1 : all_time
    
    if record_ans(i,1)<0 
        xx = xx + 1;

    end

end

p = min(xx/all_time, (all_time-xx)/all_time)




