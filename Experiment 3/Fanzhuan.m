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
date = 1;
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
            for num_neuron = 1 : okneuron_number
                xx = find(Data(num_e).record(num_session).neuron_id(:)  == neuron_id(num_neuron));
                if xx ~= 0
                    tt = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199) );
                    tt_2 = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                               Data(num_e).record(num_session).time(num_trial,4)-25 : Data(num_e).record(num_session).time(num_trial,4)) );

                    record1(labell,num_neuron,ok_trial(labell)) = tt;
                    record2(labell,num_neuron,ok_trial(labell)) = tt_2;
                    
                end
            end
        end
    end
end

%%
p_neuron(1:8,1:okneuron_number) = 0;
for i = 1 : 4
    for j = 1 : okneuron_number
        
         [h,p] = ttest(record1(i*2-1,j,1:ok_trial(i)),record1(i*2,j,1:ok_trial(i)),"Tail","both");
         dis(i,j) = mean(record1(i*2-1,j,1:ok_trial(i))) - mean(record1(i*2,j,1:ok_trial(i)));
         if p<0.05
            p_neuron(i,j) = 1;
         end
    end
end

%%
num_hand = 0;
num_eye = 0;
num_ok_eye = 0;
num_ok_hand = 0;
num_nok_eye = 0;
num_nok_hand = 0;
for j = 1 : okneuron_number
    if p_neuron(1,j) == 1 || p_neuron(2,j) == 1
        num_eye = num_eye + 1;
    end
    if p_neuron(3,j) == 1 || p_neuron(4,j) == 1
        num_hand = num_hand + 1;
    end
    
   
    if p_neuron(1,j) == 1 && p_neuron(2,j) == 1
        if dis(1,j) * dis(2,j) < 0
            num_ok_eye = num_ok_eye + 1;
            jdfz_eye(num_ok_eye) = j;
        end
    end
    if p_neuron(3,j) == 1 && p_neuron(4,j) == 1
        if dis(4,j) * dis(3,j) < 0
            num_ok_hand = num_ok_hand + 1;
            jdfz_hand(num_ok_hand) = j;
        end
    end

   
    if p_neuron(1,j) == 1 && p_neuron(2,j) == 1
        if dis(1,j) * dis(2,j) > 0
            num_nok_eye = num_nok_eye + 1;
        end
    end
    if p_neuron(3,j) == 1 && p_neuron(4,j) == 1
        if dis(4,j) * dis(3,j) > 0
            num_nok_hand = num_nok_hand + 1;
        end
    end
end

num_xd_eye = num_eye - num_nok_eye - num_ok_eye;
num_xd_hand = num_hand - num_nok_hand - num_ok_hand;

[num_eye, num_hand, num_ok_eye, num_ok_hand, num_xd_eye, num_xd_hand]

%%
q(1:3,1:4) = [11/67, 2/111, 49/67, 102/111;...
              14/75, 11/135, 54/75, 108/135;...
              7/78, 1/95, 65/78, 75/95];

for i = 1 : 4
    mean_q(i) = mean(q(1:3,i));
end