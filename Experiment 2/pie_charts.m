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
date = 3;
ok_neuron(1:600)  = 0;
okneuron_number = 0;
for num_neuron = 1 : 600
    f = 1;
    for num_e = date 
        for num_session = 1 : number_session
           if Data(num_e).record(num_session).neuron_id_logical(num_neuron) == 0 || Data_Neuron.neuron_select(num_e,num_session,num_neuron) == 0
                f = 0;
           end
        end
    end
    if f == 1
        okneuron_number = okneuron_number + 1;
        ok_neuron(num_neuron) = 1;
        neuron_id(okneuron_number) = num_neuron;
    end
end

ok_trial(1:8) = 0;
begin_xxx = 0;
num_e = date;
record(1:8,1:okneuron_number) = 0;
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
            for num_neuron = 1 : okneuron_number
                xx = find(Data(num_e).record(num_session).neuron_id(:)  == neuron_id(num_neuron));
                if xx ~= 0
                    tt = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199) );
                    tt_2 = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4)-25 : Data(num_e).record(num_session).time(num_trial,4) - 0) );

                    record1(labell,num_neuron,ok_trial(labell)) = tt;
                    record2(labell,num_neuron,ok_trial(labell)) = tt_2  ;%- tt_2;
                end
            end
        end
    end
end
p_neuron(1:8,1:okneuron_number) = 0;
for i = 1 : 8
    for j = 1 : okneuron_number
        
         [h,p] = ttest(record1(i,j,1:ok_trial(i)),record2(i,j,1:ok_trial(i)),"Tail","both");
         distance(i,j) = mean(record1(i,j,1:ok_trial(i))) - mean( record2(i,j,1:ok_trial(i)) );
         if p<0.05
            p_neuron(i,j) = 1;
         end
    end
end
a_1 = 0; a_2 = 0; a_3 = 0;
for i = 1 : okneuron_number
    f_1 = 0; f_2 = 0;
    for j = 1 : 4
        if p_neuron(j,i) == 1
            f_1 = 1;
        end
    end
    if f_1 == 1
        a_1 = a_1 + 1;
    end
    for j = 5 : 8
        if p_neuron(j,i) == 1
            f_2 = 1;
        end
    end
    if f_2 == 1
        a_2 = a_2 + 1;
    end
    if f_1 ==1 && f_2 ==1
        a_3 = a_3 +1;
    end
end
a_1 = a_1 - a_3;
a_2 = a_2 - a_3;
xx(1:4) = [num_neuron-a_1-a_2-a_3,a_2,a_3,a_1];

cm = [[256 256 256]; [234 139 173]; [176 141 186]; [118 143 198]] / 256;

%
same_neron_num =0;
same_d = 0;
for i = 1 : okneuron_number
    f_1 = 0; f_2 = 0;
    for j = 1 : 4
        if p_neuron(j,i) == 1
            f_1 = 1;
        end
    end
    for j = 5 : 8
        if p_neuron(j,i) == 1
            f_2 = 1;
        end
    end
    if f_1 ==1 && f_2 ==1
        same_neron_num = same_neron_num + 1;
        [v, a_1] = max(distance(1:4,i));
        [v, a_2] = max(distance(5:8,i));
        if a_1 == a_2 
            same_d = same_d + 1;
        end
    end
        
end
