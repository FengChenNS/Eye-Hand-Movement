function [AC] = dcoding_diraction_x(s,session_train,session_test,choose_neuron,should_be_train,should_be_test)
    AC = 0;
    neuron_id = []; number_use_neuron = 0;
    for n_neuron = 1 : length(choose_neuron)
        num_id = choose_neuron(n_neuron);
        num_neuron_1 = find(num_id == s.record(session_train).neuron_id(:));
        num_neuron_2 = find(num_id == s.record(session_test).neuron_id(:));
        if s.record(session_train).number_trial(num_neuron_1,1:4) == should_be_train 
            if s.record(session_test).number_trial(num_neuron_2,1:4) == should_be_test 
                number_use_neuron = number_use_neuron+1;
                neuron_id(number_use_neuron) = num_id;
            end
        
        end
    end
    num_test = 0; num_train = 0;
    data_train = []; lable_train = []; 
    data_test = []; label_test = [];
    label_predict = [];

    
    for move_type = 1 : 4
       
        for t = 1 : should_be_test(move_type)
            num_test = num_test +1;
            label_test(num_test) = move_type;
            for num_neuron = 1 : number_use_neuron
                xx = find(s.record(session_test).neuron_id(:) == neuron_id(num_neuron));
                data_test(num_test,num_neuron) = sum(s.record(session_test).SpikeCount_Move(xx,move_type,t,:));
            end
        end
       
        for t = 1 : should_be_train(move_type)
            num_train = num_train + 1;
            label_train(num_train) = move_type;
            for num_neuron = 1 : number_use_neuron 
                xx = find(s.record(session_train).neuron_id(:) == neuron_id(num_neuron));
                data_train(num_train,num_neuron) = sum(s.record(session_train).SpikeCount_Move(xx,move_type,t,:));
            end
        end
    end
        
   
    label_train = label_train';
    label_predict = SVM_one_to_all(data_train, label_train, data_test)';
        
    
    for move_type = 1 : 4
        tt = 0;
        if label_predict(move_type*2-1) == move_type
            tt = tt+1;
        end
        if label_predict(move_type*2) == move_type
            tt = tt+1;
        end
        AC(num_c,move_type) = tt/2;
    end
end

