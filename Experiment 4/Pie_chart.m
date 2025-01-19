clc
clear;
data_hand(1) = load('raw_VEEN_Hand_Sine.mat');
data_hand(2) = load('raw_VEEN_Hand_ty.mat');
data_eye(1) = load('raw_VEEN_Eye_Sine.mat');
data_eye(2) = load('raw_VEEN_Eye_ty.mat');

for date = 1:2
    for session = 1:2
        num_3 = 0;
        num_h_te = 0; num_h_ute = 0; num_te_ute = 0;
        num_h = 0; num_te = 0; num_ute = 0; num_0 = 0;

        for no_neuron = 1 : 600
            f_h = 0;
            f_te = 0;
            f_ute = 0;
    
            if ~isempty(find(data_hand(date).record_same(session,:) == no_neuron,1))
                f_h = 1;
            end
            if ~isempty(find(data_eye(date).record_sum_eye((session-1)*2 +1,:) == no_neuron,1))
                f_te = 1;
            end
            if ~isempty(find(data_eye(date).record_sum_eye(session*2,:) == no_neuron,1))
                f_ute = 1;
            end


            if f_h ==1 && f_te ==1 && f_ute ==1
                num_3 = num_3 +1;
                record(date,session,1, num_3) = no_neuron;
            end
            if f_h ==1 && f_te ==1 && f_ute ==0
                num_h_te = num_h_te +1;
                record(date,session,2, num_h_te) = no_neuron;
            end
            if f_h ==1 && f_te ==0 && f_ute ==1
                num_h_ute = num_h_ute +1;
                record(date,session,3, num_h_ute) = no_neuron;
            end
            if f_h ==1 && f_te ==0 && f_ute ==0
                num_h = num_h +1;
                record(date,session,4, num_h) = no_neuron;
            end
            if f_h ==0 && f_te ==1 && f_ute ==1
                num_te_ute = num_te_ute +1;
                record(date,session,5, num_te_ute) = no_neuron;
            end
            if f_h ==0 && f_te ==1 && f_ute ==0
                num_te = num_te +1;
                record(date,session,6, num_te) = no_neuron;
            end
            if f_h ==0 && f_te ==0 && f_ute ==1
                num_ute = num_ute +1;
                record(date,session,7, num_ute) = no_neuron;
            end
    
        end
        record_num(date,session,1) = num_3;
        record_num(date,session,2) = num_h_te;
        record_num(date,session,3) = num_h_ute;
        record_num(date,session,4) = num_h;
        record_num(date,session,5) = num_te_ute;
        record_num(date,session,6) = num_te;
        record_num(date,session,7) = num_ute;
        record_num(date,session,8) = 185-num_3-num_h-num_te-num_ute-num_te_ute-num_h_ute-num_h_te;
    end
    

end


