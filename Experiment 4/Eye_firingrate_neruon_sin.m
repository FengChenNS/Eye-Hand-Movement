clc; clear;
Data(1) = load('DataExtraction_9_23.mat');
Data(2) = load('DataExtraction_9_24.mat');
Trajectory(1) = load('Trajectory_9_23.mat');
Trajectory(2) = load('Trajectory_9_24.mat');
neuron_select = load('neuron_select_E4.mat');
st = 10; 
fenduan = 4; 
f = 0; 
csn = floor(st/5);

%%
for date = 1
    ok_neuron = 0;
    neuron_id(1:200) = 0;
    record_ans_num(1:2,1:fenduan) = 0;
    record_ans_all_num(1:2,1:fenduan) = 0;
    record_anova_num(1:fenduan) = 0;

    for no_neuron = 1 : 600
        ff = 1;
        for sss = 1 :4
            if Data(date).record(sss).neuron_id_logical(no_neuron) == 0 || ...
               neuron_select.neuron_select(date,sss,no_neuron) == 0
                 ff =0;
            end
        end
       
        if ff == 1
            ok_neuron = ok_neuron + 1;
            neuron_id(ok_neuron) = no_neuron;
            ele = floor((no_neuron-1) / 6) +1;
        end
    end

   
    for neuron = 1 : ok_neuron 
        record_QC(1:40,1:fenduan) = 0;
        record_HC(1:40,1:fenduan) = 0;
        
      
        num_session = 1;
        num_neuron_1 = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:));    
        number_trial_T = 0;
        number_trial_UT = 0;
        for num_trial_l = 1 : 20  
            num_trial = selected(date,num_session,num_trial_l);
            if (number_trial_T + number_trial_UT) < 2*st 
                
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
                    firing_move(1:fenduan) = firing_move(1:fenduan) - firing_focus;
                end
                movetype = Data(date).record(num_session).move_type(num_trial, 1:3);
                if (movetype(2) == 1) && (number_trial_T < st)
                    number_trial_T = number_trial_T + 1;
                    record_QC(number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                    record_SVM_QC(neuron,number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end
                if (movetype(2) == 3) && (number_trial_UT < st)
                    number_trial_UT = number_trial_UT + 1;
                    record_QC(number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                    record_SVM_QC(neuron,number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end

                
                
            end
        end

        num_session = 4;
        number_trial_T = 0;
        number_trial_UT = 0;
        num_neuron_2 = find(neuron_id(neuron) == Data(date).record(num_session).neuron_id(:));    
        for num_trial_l = 1 : 20  
            num_trial = selected(date,num_session,num_trial_l);
            if (number_trial_T + number_trial_UT) < 2 * st 

                time_f_begin = Data(date).record(num_session).time(num_trial,3)-25;
                time_f_end = Data(date).record(num_session).time(num_trial,3);
                firing_focus = mean(Data(date).record(num_session).Spike_Count(num_neuron_2,num_trial,time_f_begin:time_f_end));
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
                    firing_move(1:fenduan) = firing_move(1:fenduan) - firing_focus;
                end
                movetype = Data(date).record(num_session).move_type(num_trial, 1:3);
                if (movetype(2) == 1) && (number_trial_T < st)
                    number_trial_T = number_trial_T + 1;
                    record_HC(number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                    record_SVM_HC(neuron,number_trial_T,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end
                if (movetype(2) == 3) && (number_trial_UT < st)
                    number_trial_UT = number_trial_UT + 1;
                    record_HC(number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                    record_SVM_HC(neuron,number_trial_UT+st,1:fenduan) = (firing_move(1:fenduan)) / 0.02;
                end

            end
        end

        for i =1 : fenduan
            [record_ans(neuron,i),p] = ttest2(record_QC(1:st,i),record_HC(1:st,i));
            if isnan(record_ans(neuron,i))
                record_ans(neuron,i) = 0;
            end
            if mean(record_QC(1:st,i)) < mean(record_HC(1:st,i))
                record_ans_num(1,i) = record_ans_num(1,i) + record_ans(neuron,i);
            end
            record_ans_all_num(1,i) = record_ans_all_num(1,i) + record_ans(neuron,i);
            [record_ans(neuron,i+fenduan),p] = ttest2(record_QC(1+st:st*2,i),record_HC(1+st:st*2,i));
            if isnan(record_ans(neuron,i+fenduan))
                record_ans(neuron,i+fenduan) = 0;
            end
            if mean(record_QC(1+st:st*2,i)) < mean(record_HC(1+st:st*2,i))
                record_ans_num(2,i) = record_ans_num(2,i) + record_ans(neuron,i+fenduan);
            end
            record_ans_all_num(2,i) = record_ans_all_num(2,i) + record_ans(neuron,i+fenduan);
        end
     
        for i = 1 : fenduan
            y_Q_T(1+(i-1)*st:i*st) = record_QC(1:st,i); 
            y_Q_UT(1+(i-1)*st:i*st) = record_QC(1+st:st*2,i);
            y_H_T(1+(i-1)*st:i*st) = record_HC(1:st,i);
            y_H_UT(1+(i-1)*st:i*st) = record_HC(1+st:st*2,i);
            label_ANOVA(1+(i-1)*st:i*st) = i; 
        end
        [Anova_p(neuron,1),~,state(1)] = anova1(y_Q_T,label_ANOVA,'off');
        [Anova_p(neuron,2),~,state(2)] = anova1(y_Q_UT,label_ANOVA,'off');
        [Anova_p(neuron,3),~,state(3)] = anova1(y_H_T,label_ANOVA,'off');
        [Anova_p(neuron,4),~,state(4)] = anova1(y_H_UT,label_ANOVA,'off');

        for i = 1 : 4
            if Anova_p(neuron,i) < 0.05
                ans = multcompare(state(i),"Display","off");
                ff =  false;
                for iii = 1 : 6
                    if ans(iii,6)<0.05
                        ff = true;
                    end
                end
                if ff
                    record_anova_num(i) = record_anova_num(i) + 1;
                    record_sum_eye(i,record_anova_num(i)) = neuron_id(neuron);
                end
            end
        end
        
    end
        xx(1,1:2) = [record_anova_num(1),ok_neuron-record_anova_num(1)];
        xx(2,1:2) = [record_anova_num(3),ok_neuron-record_anova_num(3)];
        xx(3,1:2) = [record_anova_num(2),ok_neuron-record_anova_num(2)];
        xx(4,1:2) = [record_anova_num(4),ok_neuron-record_anova_num(4)];
        figure
        bar(xx/ok_neuron,"stacked");
        p_1 = bootstrapping(record_anova_num(1),record_anova_num(3),ok_neuron,ok_neuron)
        p_2 = bootstrapping(record_anova_num(2),record_anova_num(4),ok_neuron,ok_neuron)
   

end
