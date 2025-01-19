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
number_e = 1 : 3;
number_ok(1:8) = 0;
record_ave_spike(1:8,1:300,1:300) = 0;
%
for num_e = 1 : number_e
    for num_session = 1 : number_session
        for num_trial = 1 : Data(num_e).record(num_session).number_trial
            
          if Trajectory(num_e).record(num_session).success(num_trial) == 1 
                time_begin = Data(num_e).record(num_session).time(num_trial,4)+150;  
                time_end = time_begin+79;
                
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3 1 2]
                    move_type = 1; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3 2 1]
                    move_type = 2; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3 2 3]
                    move_type = 2; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3 3 2]
                    move_type = 1; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4 1 2]
                    move_type = 5; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4 2 1]
                    move_type = 6; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4 2 3]
                    move_type = 6; end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4 3 2]
                    move_type = 5; end
                
                number_ok(move_type) = number_ok(move_type) + 1;
                for num_neuron = 1 : Data(num_e).record(num_session).number_neuro
                     num_ele = floor((Data(num_e).record(num_session).neuron_id(num_neuron) - 1) / 6) + 1;
                     record_ave_spike(move_type,number_ok(move_type),num_ele) = record_ave_spike(move_type,number_ok(move_type),num_ele) + ...
                         mean(Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial,time_begin:time_end));
                end
           end
        end 
    end
end

%% SVM
% 
global record_beta;
clear AC
AC_4all(1:4,1:4)=0;
% train_move_type = [1,2,3,4];
%   train_move_type = [5,6,7,8];
%   test_move_type = [1,2,3,4];
 % test_move_type = [5,6,7,8];

% train_move_type = [1,2];
 train_move_type = [5,6];
 test_move_type = [1,2];
% test_move_type = [5,6];

test_number = [10,10];
% test_number = number_ok(test_move_type);

% test_number = [5,5,5,5];
% test_number = number_ok(test_move_type);

for test_times = 1 : 100
    % train data
    num_test = 0; 
    num_train = 0;
    data_train = []; label_train = []; 
    data_test = []; label_test = [];
    label_predict = [];
    % for move_type = 1 : 4
    for move_type = 1 : 2
        id = randperm(number_ok(train_move_type(move_type)));
        for num_trial = 1 : test_number(move_type)
            num_test = num_test + 1;
            label_test(num_test) = move_type;
            data_test(num_test,1:96) = record_ave_spike(test_move_type(move_type),id(num_trial),1:96);
            % data_test(num_test,1:96) = record_ave_spike(test_move_type(move_type),num_trial,1:96);
        end
        
        for num_trial = test_number(move_type)+1 : number_ok(train_move_type(move_type))
       %  for num_trial = 1 : number_ok(train_move_type(move_type))
            num_train = num_train+ 1;
            label_train(num_train) = move_type;
            data_train(num_train,1:96) = record_ave_spike(train_move_type(move_type),id(num_trial),1:96);
           % data_train(num_train,1:96) = record_ave_spike(train_move_type(move_type),num_trial,1:96);
        end

    end
    
    label_train = label_train';
  %  label_predict = SVM_one_to_all(data_train, label_train, data_test)';
    
    model = fitcsvm(data_train, label_train);
    label_predict = predict(model, data_test)';
    
   
    tt = 0; 
    true_class(1:4) = 0;
    for i = 1 : sum(test_number)   
        if label_predict(i) == label_test(i)
            tt = tt + 1;
           
        end
        true_class(label_test(i)) = true_class(label_test(i)) + 1;
    end
    AC(test_times) = tt/sum(test_number);
    test_times 
    
    AC_4(1:4,1:4) = 0;
    for i = 1 : sum(test_number)   
        AC_4(5-label_test(i),label_predict(i)) = AC_4(5-label_test(i),label_predict(i)) + 1;
    end
    for i = 1 : 4
        AC_4(5-i,1:4) = AC_4(5-i,1:4) / true_class(i);
    end
    AC_4all(1:4,1:4) =  AC_4all(1:4,1:4) + AC_4(1:4,1:4);
    

end
AC_mean = mean(AC)
AC_4all = AC_4all / test_times;
% h = heatmap(AC_4all);
AC = AC';
std(AC)


