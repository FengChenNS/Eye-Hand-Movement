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
xxx(1:4) = 0;
%% 
date = 2;
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


%
ok_trial(1:8) = 0;
begin_xxx = 0;
num_e = date;
record(1:8,1:okneuron_number) = 0;
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
                labell = 2; 
            end
            if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,2] 
                labell = 1; 
            end
            if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,2]
                labell = 3; 
            end
            if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,1] 
                labell = 4; 
            end
            if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,3] 
                labell = 4; 
            end
            if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,2] 
                labell = 3; 
            end
            ok_trial(labell) = ok_trial(labell)  + 1;
            for num_neuron = 1 : okneuron_number
                xx = find(Data(num_e).record(num_session).neuron_id(:)  == neuron_id(num_neuron));
                if xx ~= 0
                    tt = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199) );
                    tt_2 = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4)-25 : Data(num_e).record(num_session).time(num_trial,4)) );

                    record1(labell,num_neuron,ok_trial(labell)) = tt;
                    record2(labell,num_neuron,ok_trial(labell)) = tt_2  ;%- tt_2;
                    
                end
            end
        end
    end
end


%
p_neuron(1:8,1:okneuron_number) = 0;
for i = 1 : 4
    for j = 1 : okneuron_number
         [h,p] = ttest(record1(i,j,1:ok_trial(i)),record2(i,j,1:ok_trial(i)),"Tail","both");
         distance(i,j) = abs(mean(record1(i,j,1:ok_trial(i))) - mean( record2(i,j,1:ok_trial(i)) ));

         if p<0.05
            p_neuron(i,j) = 1;
         end
    end
end
a_1 = 0; a_2 = 0; a_3 = 0;
okkk_neuron = [];
same_d = 0;
for i = 1 : okneuron_number
    f_1 = 0; f_2 = 0;
    for j = 1 : 2
        if p_neuron(j,i) == 1
            f_1 = 1;
        end
    end
    if f_1 == 1
        a_1 = a_1 + 1;
    end
    for j = 3 : 4
        if p_neuron(j,i) == 1
            f_2 = 1;
        end
    end
    if f_2 == 1
        a_2 = a_2 + 1;
    end
    if f_1 ==1 && f_2 ==1
        a_3 = a_3 +1;
        okkk_neuron = [okkk_neuron,i];
        
        if distance(1,i)>distance(2,i) && distance(3,i)>distance(4,i)
            same_d = same_d + 1;
        end

        if distance(1,i)<=distance(2,i) && distance(3,i)<=distance(4,i)
            same_d = same_d + 1;
        end

    end
end
a_1 = a_1 - a_3;
a_2 = a_2 - a_3;
xx(1:4) = [num_neuron-a_1-a_2-a_3,a_2,a_3,a_1];
xxx(date,1:4) = xx / num_neuron;