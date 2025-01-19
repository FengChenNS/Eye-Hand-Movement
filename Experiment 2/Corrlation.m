clc
clear
 close all

%% Load Data
Data(1) = load('DataExtraction_7_21.mat');
Data(2) = load('DataExtraction_7_28.mat');
Data(3) = load('DataExtraction_8_04.mat');
Trajectory(1) = load('Trajectory_7_21_1.mat');
Trajectory(2) = load('Trajectory_7_28_1.mat');
Trajectory(3) = load('Trajectory_8_04_1.mat');
Data_Neuron = load('neuron_select_E2_1Hz.mat');
number_session = 4;

%%
ok_trial(1:8) = 0;
begin_xxx = 0;
num_e = date;
record(1:8,1:96) = 0;
record2(1:8,1:96,1:100) = 0;
for num_e = 1 : 3
    for num_session = 1:number_session
        for num_trial = 1 : 40
            if Trajectory(num_e).record(num_session).success(num_trial) == 1  
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,1,3]
                    labell = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,1] 
                    labell = 2; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,4,5]
                    labell = 3; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,5,4] 
                    labell = 4; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,3] 
                    labell = 5; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,1]
                    labell = 6; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,4,5]
                    labell = 7; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,5,4]
                    labell = 8; 
                end
                ok_trial(labell) = ok_trial(labell)  + 1;
                for num_neuron = 1 : Data(num_e).record(num_session).number_neuro
                    xx = floor((Data(num_e).record(num_session).neuron_id(num_neuron)  - 1) / 6) +1;
                        tt = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                                   Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199) );
                        tt_2 = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                                   Data(num_e).record(num_session).time(num_trial,4)-25 : Data(num_e).record(num_session).time(num_trial,4)) );
    
                        record(labell,xx) = record(labell,xx) + tt;
                        record2(labell,xx,ok_trial(labell)) =  record2(labell,xx,ok_trial(labell)) + tt;
                end
            end
        end
    end
end
okneuron_number = 96;
for i = 1 : 8
    for j = 1 : okneuron_number
        record(i,j) = record(i,j) / ok_trial(i);
    end
end

for  i = 1 : okneuron_number
    mean_fr_H = mean(record(1:4,i));
    mean_fr_E = mean(record(5:8,i));
    for j = 1 : 4
        record(j,i) = record(j,i) - mean_fr_H;
        record(j+4,i) = record(j+4,i) - mean_fr_E;
    end
end

%%
for i = 1 : 8
    for j = 1 : 8
        data_1(1:okneuron_number) = record(i,1:okneuron_number);
        data_2(1:okneuron_number) = record(j,1:okneuron_number);
        
        if i == j
            

            num_x = floor(ok_trial(i) / 2);
            list_1 = randperm(ok_trial(i),num_x);
            list_2 = [];
            for jjj = 1 : ok_trial
                if isempty(find(jjj == list_1(:), 1))
                    list_2 = [list_2,jjj];
                end
            end

            for jjj = 1 : 96
                mean_fr_H = mean(record(1:4,jjj));
                mean_fr_E = mean(record(5:8,jjj));
                
                
                aa(jjj) = mean(record2(i,jjj,list_1(1:num_x)));
                bb(jjj) = mean(record2(i,jjj,list_2(1:(ok_trial - num_x))));


                if i > 4
                    aa = aa - mean_fr_H;
                    bb = bb - mean_fr_H;
                else
                    aa = aa - mean_fr_E;
                    bb = bb - mean_fr_E;
                end
            end
            [R,P] = corrcoef(aa,bb);
        
            R2 = dot(aa,bb)/(norm(aa) .* norm(bb));
            corr_rate(i,j) = R(1,2);
            corr_rate_xl(i,j) = R2;
            corr_rate_P(i,j) = P(1,2);
        else

            [R,P] = corrcoef(data_1,data_2);
            R2 = dot(data_1,data_2)/(norm(data_1) .* norm(data_2));
            corr_rate(i,j) = R(1,2);
            corr_rate_xl(i,j) = R2;
            corr_rate_P(i,j) = P(1,2);
        end
    end
end

t_1 = 0;
t_2 = 0;

for i = 5 : 8
    for j = 1 : 4
        if i == j + 4
            t_1 = t_1 + 1;
            record_mean(t_1) = corr_rate_xl(i,j);
        else
            
            t_2 = t_2 + 1;
            record_mean_2(t_2) = corr_rate_xl(i,j);
            
        end
    end
end
mean(record_mean)
mean(record_mean_2)
[h,p] = ttest2(record_mean,record_mean_2)

for i = 1 : 8
    corr_rate_2(i,1:8) = corr_rate_xl(9-i,1:8);
    corr_rate_P_2(i,1:8) = corr_rate_P(9-i,1:8);
end

h = heatmap(corr_rate_2(:,:));





