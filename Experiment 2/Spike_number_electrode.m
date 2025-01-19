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
record_move(1:8,1:100,1:100) = 0;
record_rest(1:8,1:100,1:100) = 0;
num_jy_E = 0;
num_jy_H = 0;
num_jy_E_H = 0;
num_jy_EH = 0;
num_jy_E_H_true = 0;
num_jy_E_EH_true = 0;
num_jy_E_EH = 0;
num_jy_H_EH_true = 0;
num_jy_H_EH = 0;
ans_true(1:100) = 0;
ans_all(1:100) = 0;
ans_true_E(1:100) = 0;
ans_all_E(1:100) = 0;
ans_true_H(1:100) = 0;
ans_all_H(1:100) = 0;
ans_X(1:100) = 0;
ans_true_EH(1:100) = 0;
ans_all_EH(1:100) = 0;
ans_X_H_EH(1:100) = 0;
ans_X_E_EH(1:100) = 0; 
ans_all_E_EH(1:100) = 0;
ans_all_H_EH(1:100) = 0;
jg = 1;
num_EH_all = 0;
num_E_all = 0;
num_H_all = 0;

for num_e = 1 : 3 
    for num_session = 1 : number_session
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
                    No_neuron = Data(num_e).record(num_session).neuron_id(num_neuron);
                    No_Channel = floor((No_neuron-1) / 6) + 1;
                    time_move = Data(num_e).record(num_session).time(num_trial,4);
                    
                    tt_move = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, time_move : time_move+199) );
                    tt_rest = mean( Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, time_rest : time_move) );
                    
                    record_move(labell,No_Channel,ok_trial(labell)) = record_move(labell,No_Channel,ok_trial(labell)) + tt_move;
                    record_rest(labell,No_Channel,ok_trial(labell)) = record_rest(labell,No_Channel,ok_trial(labell)) + tt_rest;
                   
                end
            end
        end
    end
end
%
number(1:8) = 0;
position(1:8,1:10,1:10) = 0;
aax_E(1:100) = 0;
aax_H(1:100) = 0;
for ele = 1 : 96
    
    for labell = 1 : 4
        clear aa bb
        trial_number = ok_trial(labell);
        aa(1 : trial_number) = record_move(labell,ele,1:trial_number);
        bb(1 : trial_number) = record_rest(labell,ele,1:trial_number);
        [h,p] = ttest(aa,bb,"Tail","both");
        if p < 0.05
            record_ans(labell,ele) = (mean(aa) - mean(bb));
        else 
            record_ans(labell,ele) = -1;
            if mean(aa) == 0 || mean(bb) ==0
                record_ans(labell,ele) = nan;
            end
        end
        if mean(aa) <= 1/50
            record_ans(labell,ele) = nan;
        end
    end

    max = 0; ll = 0;
    for labell = 1 : 4
          if ~isnan(record_ans(labell,ele))
              if record_ans(labell,ele) > max
                    max = record_ans(labell,ele);
                    ll = labell;
              end
          end
    end
    
    if max  ~= 0
        aax_E(ele) = ll;
    end


    for labell = 5:8
        clear aa bb
        trial_number = ok_trial(labell);
        aa(1 : trial_number) = record_move(labell,ele,1:trial_number);
        bb(1 : trial_number) = record_rest(labell,ele,1:trial_number);
        [h,p] = ttest(aa,bb,"Tail","both");
        if p < 0.05
            record_ans(labell,ele) = (mean(aa) - mean(bb));
        else 
            record_ans(labell,ele) = -1;
            if mean(aa) == 0 || mean(bb) ==0
                record_ans(labell,ele) = nan;
            end
        end
        if mean(aa) <= 1/50
            record_ans(labell,ele) = nan;
        end
    end

    max = 0; ll = 0;
    for labell = 5:8
          if ~isnan(record_ans(labell,ele))
              if record_ans(labell,ele) > max
                    max = record_ans(labell,ele);
                    ll = labell;
              end
          end
    end
    
    if max  ~= 0
        aax_H(ele) = ll;
    end
end

ele = 0;
    for i =1 : 10
        for j = 1 : 10
            f = true;
            if ((i == 1) || (i == 10)) && ((j == 1) || (j==10)) 
                f = false;
            end
            if f
                ele = ele + 1;
               if aax_E(ele) ~= 0
                    position(aax_E(ele),i,j) = 1; 
               end
               if aax_H(ele) ~= 0
                    position(aax_H(ele),i,j) = 1; 
               end
            end
        end
    end
mid_X_mean(1:1000) = 0;
mid_E_H_mean(1:1000) = 0;


for labell = 1 : 4 
    pos_E(1:100,1:2) = 0;
    pos_H(1:100,1:2) = 0;
    pos_EH(1:100,1:2) = 0;
    num_E(labell) = 0;
    num_H(labell) = 0;
    num_EH(labell) = 0;
    ppp_EH(1:10,1:10) = 0;
    ppp_E(1:10,1:10) = 0;
    ppp_H(1:10,1:10) = 0;
    for i =1 : 10
        for j = 1 : 10
            if position(labell,i,j) == 1 && position(labell+4,i,j) == 0
                num_E(labell) = num_E(labell) + 1;
                pos_E(num_E(labell),1:2) = [i,j]; 
                ppp_E(i,j) = 1;
            end

            if position(labell,i,j) == 0 && position(labell+4,i,j) == 1
                num_H(labell) = num_H(labell) + 1;
                pos_H(num_H(labell),1:2) = [i,j];
                ppp_H(i,j) = 1;
            end

            if position(labell,i,j) == 1 && position(labell+4,i,j) == 1
                num_EH(labell) = num_EH(labell) + 1;
                pos_EH(num_EH(labell),1:2) = [i,j]; 
                ppp_EH(i,j) = 1;
            end
        end
    end
   

    all_line(1:100,1:100) = 0;
    true_line(1:100,1:100) = 0;
    for sis_ele = 1 : num_E(labell)
        x1 = pos_E(sis_ele,1);
        y1 = pos_E(sis_ele,2);
        for i = 1 : 10
            for j = 1 : 10
                dis = 0;
                if ~(i==pos_E(sis_ele,1) && j==pos_E(sis_ele,2))
                    if i~=1 && i~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 1 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 10 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                end
                if dis ~= 0
                    dis = ceil(dis / jg);
                    all_line(sis_ele,dis) = all_line(sis_ele,dis)+1;
                end
            end
        end
        
        for i = 1 : num_E(labell)
            if i~= sis_ele
                dis = sqrt((x1 - pos_E(i,1))^2 + (y1 - pos_E(i,2))^2);
                dis = ceil(dis / jg);
                true_line(sis_ele,dis) = true_line(sis_ele,dis)+1;
            end
        end
                
    end
    
    all_line = all_line / 95;
    if num_E(labell)~=1
        true_line = true_line / (num_E(labell)-1);
    else
        clear true_line
        true_line(1,1:100) = 0;
        true_line(1,1) = 1; 
    end
    
    ans_true_E(1:100) = ans_true_E(1:100) + sum(true_line,1);
    ans_all_E(1:100) = ans_all_E(1:100) + sum(all_line,1);
    ans_all(1:100) = ans_all(1:100) + sum(all_line,1);
    ans_all_E_EH(1:100) = ans_all_E_EH(1:100) + sum(all_line,1);

    jianyan_E(num_jy_E+1:num_jy_E+num_E(labell),1) = true_line(1:num_E(labell),1);
    jianyan_E(num_jy_E+1:num_jy_E+num_E(labell),2) = all_line(1:num_E(labell),1);
    num_jy_E = num_jy_E + num_E(labell);

    jianyan_E_H(num_jy_E_H+1:num_jy_E_H+num_E(labell)) = all_line(1:num_E(labell),1);
    num_jy_E_H = num_jy_E_H + num_E(labell);

    jianyan_E_EH(num_jy_E_EH+1:num_jy_E_EH+num_E(labell)) = all_line(1:num_E(labell),1);
    num_jy_E_EH = num_jy_E_EH + num_E(labell);

    % Hand
    all_line(1:100,1:100) = 0;
    true_line(1:100,1:100) = 0;
    for sis_ele = 1 : num_H(labell)
        x1 = pos_H(sis_ele,1);
        y1 = pos_H(sis_ele,2);
        for i = 1 : 10
            for j = 1 : 10
                dis = 0;
                if ~(i==pos_H(sis_ele,1) && j==pos_H(sis_ele,2))
                    if i~=1 && i~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 1 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 10 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                end
                if dis ~= 0
                    dis = ceil(dis / jg);
                    all_line(sis_ele,dis) = all_line(sis_ele,dis)+1;
                end
            end
        end

        for i = 1 : num_H(labell)
            if i~= sis_ele
                dis = sqrt((x1 - pos_H(i,1))^2 + (y1 - pos_H(i,2))^2);
                dis = ceil(dis / jg);
                true_line(sis_ele,dis) = true_line(sis_ele,dis)+1;
            end
        end
                
    end
    all_line = all_line / 95;
    true_line = true_line / (num_H(labell)-1);
    
    ans_true_H(1:100) = ans_true_H(1:100) + sum(true_line,1);
    ans_all_H(1:100) = ans_all_H(1:100) + sum(all_line,1);
    ans_all(1:100) = ans_all(1:100) + sum(all_line,1);
    ans_all_H_EH(1:100) = ans_all_H_EH(1:100) + sum(all_line,1);

    jianyan_H(num_jy_H+1:num_jy_H+num_H(labell),1) = true_line(1:num_H(labell),1);
    jianyan_H(num_jy_H+1:num_jy_H+num_H(labell),2) = all_line(1:num_H(labell),1);
    num_jy_H = num_jy_H + num_H(labell);
    
    jianyan_E_H(num_jy_E_H+1:num_jy_E_H+num_H(labell)) = all_line(1:num_H(labell),1);
    num_jy_E_H = num_jy_E_H + num_H(labell);
    
    jianyan_H_EH(num_jy_H_EH+1:num_jy_H_EH+num_H(labell)) = all_line(1:num_H(labell),1);
    num_jy_H_EH = num_jy_H_EH + num_H(labell);

    % E and H
    all_line(1:100,1:100) = 0;
    true_line(1:100,1:100) = 0;
    for sis_ele = 1 : num_EH(labell)
        x1 = pos_EH(sis_ele,1);
        y1 = pos_EH(sis_ele,2);
        for i = 1 : 10
            for j = 1 : 10
                dis = 0;
                if ~(i==pos_EH(sis_ele,1) && j==pos_EH(sis_ele,2))
                    if i~=1 && i~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 1 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                    if i == 10 && j~=1 && j~=10
                        dis = sqrt((x1-i)^2 + (y1-j)^2);
                    end
                end
                if dis ~= 0
                    dis = ceil(dis / jg);
                    all_line(sis_ele,dis) = all_line(sis_ele,dis)+1;
                end
                
            end
        end
        
        
        for i = 1 : num_EH(labell)
            if i~= sis_ele
                dis = sqrt((x1 - pos_EH(i,1))^2 + (y1 - pos_EH(i,2))^2);
                dis = ceil(dis / jg);
                true_line(sis_ele,dis) = true_line(sis_ele,dis)+1;
            end
        end
                
    end 
    all_line = all_line / 95;
    true_line = true_line / (num_EH(labell)-1);
    
    ans_true_EH(1:100) = ans_true_EH(1:100) + sum(true_line,1);
    ans_all_EH(1:100) = ans_all_EH(1:100) + sum(all_line,1);
    ans_all_E_EH(1:100) = ans_all_E_EH(1:100) + sum(all_line,1);
    ans_all_H_EH(1:100) = ans_all_H_EH(1:100) + sum(all_line,1);

    jianyan_EH(num_jy_EH+1:num_jy_EH+num_EH(labell),1) = true_line(1:num_EH(labell),1);
    jianyan_EH(num_jy_EH+1:num_jy_EH+num_EH(labell),2) = all_line(1:num_EH(labell),1);
    num_jy_EH = num_jy_EH + num_EH(labell);

    jianyan_E_EH(num_jy_E_EH+1:num_jy_E_EH+num_EH(labell)) = all_line(1:num_EH(labell),1);
    num_jy_E_EH = num_jy_E_EH + num_EH(labell);

    jianyan_H_EH(num_jy_H_EH+1:num_jy_H_EH+num_EH(labell)) = all_line(1:num_EH(labell),1);
    num_jy_H_EH = num_jy_H_EH + num_EH(labell);

    % H E 
    all_line(1:1000,1:100) = 0;
    for i = 1 : num_E(labell)
        for j = 1 : num_H(labell)
            dis = sqrt((pos_E(i,1) - pos_H(j,1))^2 + (pos_E(i,2) - pos_H(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i,dis) = all_line(i,dis)+1;
        end
    end
    
    all_line = all_line / (num_H(labell));
    jianyan_E_H_true(num_jy_E_H_true+1 : num_jy_E_H_true + num_E(labell)) = ...
        all_line(1 : num_E(labell),1);
    num_jy_E_H_true = num_jy_E_H_true + num_E(labell);

    for i = 1 : num_H(labell)
        for j = 1 : num_E(labell)
            dis = sqrt((pos_H(i,1) - pos_E(j,1))^2 + (pos_H(i,2) - pos_E(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i+num_E(labell),dis) = all_line(i+num_E(labell),dis)+1;
        end
    end
    all_line(num_E(labell)+1:num_E(labell)+num_H(labell),:) = ...
        all_line(num_E(labell)+1:num_E(labell)+num_H(labell),:) / (num_E(labell));

    jianyan_E_H_true(num_jy_E_H_true+1 : num_jy_E_H_true + num_H(labell)) = ...
        all_line(num_E(labell)+1 : num_E(labell)+num_H(labell),1);
    num_jy_E_H_true = num_jy_E_H_true + num_H(labell);

    ans_X(1:100) = ans_X(1:100) + sum(all_line,1);


    % E H&E
    all_line(1:1000,1:100) = 0;
    for i = 1 : num_E(labell)
        for j = 1 : num_EH(labell)
            dis = sqrt((pos_E(i,1) - pos_EH(j,1))^2 + (pos_E(i,2) - pos_EH(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i,dis) = all_line(i,dis)+1;
        end
    end
    all_line = all_line / (num_EH(labell));
    jianyan_E_EH_true(num_jy_E_EH_true+1 : num_jy_E_EH_true + num_E(labell)) = ...
        all_line(1 : num_E(labell),1);
    num_jy_E_EH_true = num_jy_E_EH_true + num_E(labell);

    for i = 1 : num_EH(labell)
        for j = 1 : num_E(labell)
            dis = sqrt((pos_EH(i,1) - pos_E(j,1))^2 + (pos_EH(i,2) - pos_E(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i+num_E(labell),dis) = all_line(i+num_E(labell),dis)+1;
        end
    end
    all_line(num_E(labell)+1:num_E(labell)+num_EH(labell),:) = ...
        all_line(num_E(labell)+1:num_E(labell)+num_EH(labell),:) / (num_E(labell));

    jianyan_E_EH_true(num_jy_E_EH_true+1 : num_jy_E_EH_true + num_EH(labell)) = ...
        all_line(num_E(labell)+1:num_E(labell)+num_EH(labell),1);
    num_jy_E_EH_true = num_jy_E_EH_true + num_EH(labell);

    ans_X_E_EH(1:100) = ans_X_E_EH(1:100) + sum(all_line,1);
    
    % H  E&H
    all_line(1:1000,1:100) = 0;
    for i = 1 : num_H(labell)
        for j = 1 : num_EH(labell)
            dis = sqrt((pos_H(i,1) - pos_EH(j,1))^2 + (pos_H(i,2) - pos_EH(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i,dis) = all_line(i,dis)+1;
        end
    end
    all_line = all_line / (num_EH(labell));
    jianyan_H_EH_true(num_jy_H_EH_true+1 : num_jy_H_EH_true + num_H(labell)) = ...
        all_line(1 : num_H(labell),1);
    num_jy_H_EH_true = num_jy_H_EH_true + num_H(labell);

    for i = 1 : num_EH(labell)
        for j = 1 : num_H(labell)
            dis = sqrt((pos_EH(i,1) - pos_H(j,1))^2 + (pos_EH(i,2) - pos_H(j,2))^2);
            dis = ceil(dis / jg);
            all_line(i+num_H(labell),dis) = all_line(i+num_H(labell),dis)+1;
        end
    end
    all_line(num_H(labell)+1:num_H(labell)+num_EH(labell),:) = ...
        all_line(num_H(labell)+1:num_H(labell)+num_EH(labell),:) / (num_H(labell));

    jianyan_H_EH_true(num_jy_H_EH_true+1 : num_jy_H_EH_true + num_EH(labell)) = ...
        all_line(num_H(labell)+1:num_H(labell)+num_EH(labell),1);
    num_jy_H_EH_true = num_jy_H_EH_true + num_EH(labell);

    ans_X_H_EH(1:100) = ans_X_H_EH(1:100) + sum(all_line,1);
end
num_EH_all = num_EH_all + sum(num_EH);
num_E_all = num_E_all + sum(num_E);
num_H_all = num_H_all + sum(num_H);


%%
[h,p] = ttest(jianyan_E(1:num_jy_E,1),jianyan_E(1:num_jy_E,2),'Tail','both')
clear ansss
for ii = 1 : num_jy_E
    ansss(ii) = jianyan_E(ii,1) / jianyan_E(ii,2);
end
aaaaa(1,1) = mean(ansss(1:num_jy_E));
aaaaa(1,2) = std(ansss(1:num_jy_E))/sqrt(num_jy_E);

[h,p] = ttest(jianyan_H(1:num_jy_H,1),jianyan_H(1:num_jy_H,2))
clear ansss
for ii = 1 : num_jy_H
    ansss(ii) = jianyan_H(ii,1) / jianyan_H(ii,2);
end
aaaaa(2,1) = mean(ansss(1:num_jy_H));
aaaaa(2,2) = std(ansss(1:num_jy_H))/sqrt(num_jy_H);

[h,p] = ttest(jianyan_EH(1:num_jy_EH,1),jianyan_EH(1:num_jy_EH,2))
clear ansss
for ii = 1 : num_jy_EH
    ansss(ii) = jianyan_EH(ii,1) / jianyan_EH(ii,2);
end
aaaaa(3,1) = mean(ansss(1:num_jy_EH));
aaaaa(3,2) = std(ansss(1:num_jy_EH))/sqrt(num_jy_EH);

[h,p] = ttest(jianyan_E_H_true(1:num_jy_E_H),jianyan_E_H(1:num_jy_E_H))
clear ansss
for ii = 1 : num_jy_E_H
    ansss(ii) = jianyan_E_H_true(ii) / jianyan_E_H(ii);
end
aaaaa(4,1) = mean(ansss(1:num_jy_E_H));
aaaaa(4,2) = std(ansss(1:num_jy_E_H))/sqrt(num_jy_E_H);

[h,p] = ttest(jianyan_E_EH_true(1:num_jy_E_EH),jianyan_E_EH(1:num_jy_E_EH))
clear ansss
for ii = 1 : num_jy_E_EH
    ansss(ii) = jianyan_E_EH_true(ii) / jianyan_E_EH(ii);
end
aaaaa(5,1) = mean(ansss(1:num_jy_E_EH));
aaaaa(5,2) = std(ansss(1:num_jy_E_EH))/sqrt(num_jy_E_EH);

[h,p] = ttest(jianyan_H_EH_true(1:num_jy_H_EH),jianyan_H_EH(1:num_jy_H_EH))
clear ansss
for ii = 1 : num_jy_H_EH
    ansss(ii) = jianyan_H_EH_true(ii) / jianyan_H_EH(ii);
end
aaaaa(6,1) = mean(ansss(1:num_jy_H_EH));
aaaaa(6,2) = std(ansss(1:num_jy_H_EH))/sqrt(num_jy_H_EH);

%%
ans_all(1:100) = ans_all(1:100) / (sum(num_E_all)+sum(num_H_all));
ans_true_H(1:100) = ans_true_H(1:100) / sum(num_H_all);
ans_all_H(1:100) = ans_all_H(1:100) / sum(num_H);
ans_true_E(1:100) = ans_true_E(1:100) / sum(num_E_all);
ans_all_E(1:100) = ans_all_E(1:100) / sum(num_E_all);
ans_X(1:100) = ans_X(1:100) / (sum(num_E_all)+sum(num_H_all));

ans_X_H_EH(1:100) = ans_X_H_EH(1:100) / (sum(num_H_all)+sum(num_EH_all));
ans_X_E_EH(1:100) = ans_X_E_EH(1:100) / (sum(num_E_all)+sum(num_EH_all));
ans_all_H_EH(1:100) = ans_all_H_EH(1:100) / (sum(num_H_all)+sum(num_EH_all));
ans_all_E_EH(1:100) = ans_all_E_EH(1:100) / (sum(num_E_all)+sum(num_EH_all));

for i = 1 : 20
    line_X_E_H(i) = ans_X(i) / ans_all(i);
    line_X_E_EH(i) = ans_X_E_EH(i) / ans_all_E_EH(i);
    line_X_H_EH(i) = ans_X_H_EH(i) / ans_all_H_EH(i);
end
