clc; clear; close all
addpath(genpath(pwd));
Data(1) = load('DataExtraction_E4_demo.mat');
Trajectory_fd(1) = load('Trajectory_E4_demo_1.mat');
Trajectory(1) = load('Trajectory_E4_demo_2.mat');
Tra(1) = load('Trajectory_E4_demo_3.mat');
neuron_Anova_eye = load('Neuron_Anova_demo.mat');
neuron_select = load('neuron_select_E4_demo.mat');
st = 10; 
fenduan = 4; 
f = 0; 
csn = floor(st/5); 
tts = [3,3];
%%
for date = 1
    num_anova1_Q =0;
    num_anova1_H =0;
    ok_neuron = 0;
    neuron_id(1:200) = 0;
    record_SVM_HC(1:96,1:st,1:fenduan) =0;
    record_SVM_QC(1:96,1:st,1:fenduan) =0;
    for no_neuron = 1 : 600
        ff = 1;
        for sss = 1 : 4
            if Data(date).record(sss).neuron_id_logical(no_neuron) == 0 || ...
              neuron_select.neuron_select(date,sss,no_neuron) == 0
                 ff =0;
            end
        end
         
        if ff == 1
            ok_neuron = ok_neuron + 1;
            neuron_id(ok_neuron) = no_neuron;
            ele = floor((no_neuron-1) / 6) +1;
            neuron_ele(ok_neuron) = ele;
            linshi_ele(ele) = 1;
        end
    end
    for neuron = 1 : ok_neuron 
        record_QC(1:40,1:fenduan) = 0;
        record_HC(1:40,1:fenduan) = 0;
        num_session = 2;
        num_neuron_1 = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:));    
        number_trial = 0;
       for trial = 1 : 10  
                num_trial = trial;
            
                number_trial = number_trial + 1;
                time_f_begin = Data(date).record(num_session).time(num_trial,3)-25;
                time_f_end = Data(date).record(num_session).time(num_trial,3);
                firing_focus = mean(Data(date).record(num_session).Spike_Count(num_neuron_1,num_trial,time_f_begin:time_f_end));
                
                time_m_begin = Data(date).record(num_session).time(num_trial,4);
                time_m_end = Data(date).record(num_session).time(num_trial,4) + 199;
                time_length = 200;
                time_fenduan = floor(time_length / fenduan);
                firing_move(1:fenduan) = 0;
                for i = 1 : fenduan
                    t_1 = time_m_begin + (i-1) * time_fenduan;
                    t_2 = t_1 + time_fenduan-1;
                    firing_move(i) = mean(Data(date).record(num_session).Spike_Count(num_neuron_1,num_trial,t_1:t_2));
                end
                
                if f == 1
                    record_QC(number_trial,1:fenduan) = (firing_move(1:fenduan)-firing_focus) / 0.02;
                else
                    record_QC(number_trial,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end

           
        end

        num_session = 3;
        number_trial = 0;
        num_neuron_2 = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:));    
        for trial = 1 : 10
            num_trial = trial;
           if Trajectory(date).record(3).record_dis_RNSE(num_trial)<=tts(date) && number_trial < st
               
                time_f_begin = Data(date).record(num_session).time(num_trial,3)-25;
                time_f_end = Data(date).record(num_session).time(num_trial,3);
                firing_focus = mean(Data(date).record(num_session).Spike_Count(num_neuron_2,num_trial,time_f_begin:time_f_end));
                number_trial = number_trial + 1;
                time_m_begin = Data(date).record(num_session).time(num_trial,4);
                time_m_end = Data(date).record(num_session).time(num_trial,4) + 199;
                time_length = 200;
                time_fenduan = floor(time_length / fenduan);
                firing_move(1:fenduan) = 0;
                for i = 1 : fenduan
                    t_1 = time_m_begin + (i-1) * time_fenduan;
                    t_2 = t_1 + time_fenduan-1;
                    firing_move(i) = mean(Data(date).record(num_session).Spike_Count(num_neuron_2,num_trial,t_1:t_2));
                end
                if f == 1
                    record_HC(number_trial,1:fenduan) = (firing_move(1:fenduan)-firing_focus) / 0.02;
                else
                    record_HC(number_trial,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end
           end
        end


        for i = 1 : fenduan
            data_anova_Q(1+(i-1)*st:i*st) = record_QC(1:st,i);
            label_anova_Q(1+(i-1)*st:i*st) = i; 
            data_anova_H(1+(i-1)*st:i*st) = record_HC(1:st,i);
            label_anova_H(1+(i-1)*st:i*st) = i;
        end
        [Anova_p(neuron,1),~,state1] = anova1(data_anova_Q,label_anova_Q,'off');
        [Anova_p(neuron,2),~,state2] = anova1(data_anova_H,label_anova_H,'off');


        if Anova_p(neuron,1)<0.05
            ans =  multcompare(state1,"Display","off");
            ff = false;
            for iii = 1 : 6
                if ans(iii,6)<0.05
                    ff = true;
                end
            end
            if ff
                num_anova1_Q = num_anova1_Q +1;
                record_same(1,num_anova1_Q) = neuron_id(neuron);
            end
        end
        if Anova_p(neuron,2)<0.05
            ans =  multcompare(state2,"Display","off");
            ff = false;
            for iii = 1 : 6
                if ans(iii,6)<0.05
                    ff = true;
                end
            end
            if ff
                num_anova1_H = num_anova1_H +1;
                record_same(2,num_anova1_H) = neuron_id(neuron);
            end
        end
        for ii = 1 : st
            for n_fd = 1 :fenduan
                record_SVM_HC(neuron_ele(neuron),ii,n_fd) = record_SVM_HC(neuron_ele(neuron),ii,n_fd) + ...
                    record_HC(ii,n_fd);
                record_SVM_QC(neuron_ele(neuron),ii,n_fd) = record_SVM_QC(neuron_ele(neuron),ii,n_fd) + ...
                    record_QC(ii,n_fd);
            end
        end
        
    end
    xx = [num_anova1_Q,ok_neuron-num_anova1_Q;
          num_anova1_H,ok_neuron-num_anova1_H]


    ok_ele = 96;   
    AC_8all_Q(1:8,1:8) = 0;
    for times = 1 : 100
        dl_1 = randperm(st); 
        for num_trial = 1 : st-csn
            number_trial_2 = dl_1(num_trial);
            for num_fenduan = 1 : fenduan 
                t = (num_trial-1) * fenduan + num_fenduan;
                train_data(t,1:ok_ele) = record_SVM_QC(1:ok_ele,number_trial_2,num_fenduan);
                train_label(t,1) = num_fenduan;
            end
        end
        for num_trial = 1 : csn
            number_trial_2 = dl_1(st-csn+num_trial);
            for num_fenduan = 1 : fenduan
                t = (num_trial-1) * fenduan + num_fenduan;
                test_data(t,1:ok_ele) = record_SVM_QC(1:ok_ele,number_trial_2,num_fenduan);
                test_label(t,1) = num_fenduan;
            end
        end
        
        [predict_label,bate] = SVM_one_to_all(train_data,train_label,test_data);
       ac = 0;
        true_class(1:8) = 0;
        for i = 1 : csn*fenduan
            if predict_label(i) == test_label(i)
                ac = ac + 1;
            end
            true_class(test_label(i)) = true_class(test_label(i)) + 1;
        end


        ac = ac / (csn*fenduan);
        AC_1(times) = ac;

        AC_8(1:8,1:8) = 0;
        for i = 1 : csn*fenduan 
            AC_8(9-test_label(i),predict_label(i)) = AC_8(9-test_label(i),predict_label(i)) + 1;
        end
        for i = 1 : 8
            AC_8(9-i,1:8) = AC_8(9-i,1:8) / true_class(i);
        end
        AC_8all_Q(1:8,1:8) =  AC_8all_Q(1:8,1:8) + AC_8(1:8,1:8);
    end
        AC_mean_Q = mean(AC_1(1:times));
        AC_8all_Q = AC_8all_Q / times;
        figure
        h = heatmap(AC_8all_Q);
    


    AC = 0;
    AC_8all_H(1:8,1:8) = 0;
    for times = 1 : 100
        dl_1 = randperm(st); 
        for num_trial = 1 : st-csn
            number_trial_2 = dl_1(num_trial);
            for num_fenduan = 1 : fenduan 
                t = (num_trial-1) * fenduan + num_fenduan;
                train_data(t,1:ok_ele) = record_SVM_HC(1:ok_ele,number_trial_2,num_fenduan);
                train_label(t,1) = num_fenduan;
            end
        end
        for num_trial = 1 : csn
            number_trial_2 = dl_1(st-csn+num_trial);
            for num_fenduan = 1 : fenduan
                t = (num_trial-1) * fenduan + num_fenduan;
                test_data(t,1:ok_ele) = record_SVM_HC(1:ok_ele,number_trial_2,num_fenduan);
                test_label(t,1) = num_fenduan;
            end
        end
        

        [predict_label,bate] = SVM_one_to_all(train_data,train_label,test_data);
        ac = 0;
        true_class(1:8) = 0;
        for i = 1 : csn*fenduan
            if predict_label(i) == test_label(i)
                ac = ac + 1;
            end
            true_class(test_label(i)) = true_class(test_label(i)) + 1;
        end

        ac = ac / (csn*fenduan);
        AC_2(times) = ac;

        AC_8(1:8,1:8) = 0;
        for i = 1 : csn*fenduan 
            AC_8(9-test_label(i),predict_label(i)) = AC_8(9-test_label(i),predict_label(i)) + 1;
        end

        for i = 1 : 8
            AC_8(9-i,1:8) = AC_8(9-i,1:8) / true_class(i);
        end
        AC_8all_H(1:8,1:8) =  AC_8all_H(1:8,1:8) + AC_8(1:8,1:8);
    end
        AC_mean_H = mean(AC_2(1:times));
        AC_8all_H = AC_8all_H / times;
        figure
        h = heatmap(AC_8all_H);


    mean(AC_1)
    mean(AC_2)
    mean(AC_2) - mean(AC_1)
    [h,p] = ttest2(AC_1,AC_2)

    for i = 1 : 8
        aaa(i,1) = AC_8all_Q(9-i,i);
        aaa(i,2) = AC_8all_H(9-i,i);
    end




end


x = [mean(AC_1),mean(AC_2)];
bar(x);
ylim([0.25,1]);
