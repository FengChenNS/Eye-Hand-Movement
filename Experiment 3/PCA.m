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
%%
oktrial = 0;
ff = 0;
labell(1:400) = 0;
js(1:8) =0;
for num_e = 1
    for num_session = 1 : number_session
        for num_trial = 1 : 40
            if  Trajectory(num_e).record(num_session).success(num_trial) == 1  
                oktrial = oktrial + 1;
                ff = 0;
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,1,2]     
                    labell(oktrial) = 1; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,2,1] 
                    labell(oktrial) = 2; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,2,3] 
                    labell(oktrial) = 3; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,2] 
                    labell(oktrial) = 4; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,2] 
                    labell(oktrial) = 5; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,1] 
                    labell(oktrial) = 6; ff = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,2,3] 
                    labell(oktrial) = 7; ff = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,2] 
                    labell(oktrial) = 8; ff = 1; 
                end
                js(labell(oktrial)) = js(labell(oktrial))  + 1;
                if ff == 1 
                    linshi(1:100*200) = 0;
                    for num_neuron = 1: Data(num_e).record(num_session).number_neuro
                        if okneuron(num_e,num_neuron) == 1
                            ele = floor(Data(num_e).record(num_session).neuron_id(num_neuron) / 6) +1; 
                            tt(1:200) = Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                                        Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199);
                            x_begin = (ele - 1) *200 +1;
                            x_end = x_begin + 199;
                            linshi(x_begin:x_end) = linshi(x_begin:x_end)  + tt(1:200);
                        end
                    end
                    linshi = linshi / 50; 
                    PCA_trial(oktrial,1:100*200) = linshi(1:100*200);
                else 
                    oktrial = oktrial -1; 
                end

           end

        end
    end
end

csc(1:8,1:20000) = 0;
for i = 1 : oktrial
    for k =1 : 20000
        csc(labell(i),k) = csc(labell(i),k) + PCA_trial(i,k);
    end
end
for i = 1 : 8
    csc(i,1:20000) = csc(i,1:20000) / js(i);
end

%%
culm(1:3,1:8) = [1,2,3,4,5,6,7,8;
                 1,3,2,4,5,7,6,8;
                 1,4,2,3,5,8,6,7];
%%%%%%%%%%%%%%%%%%%%%%
type = 1;
%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : 4
    k1 = culm(type,i*2-1);
    k2 = culm(type,i*2);
    for j =1 : 20000
        mmean = (csc(k1,j) + csc(k2,j)) / 2;
        dcsc(k1,j) = csc(k1,j) - mmean;
        dcsc(k2,j) = csc(k2,j) - mmean;
    end
end

for i = 1 : oktrial
    for k =1 : 20000
        PCA_trial_2(i,k) = PCA_trial(i,k) - dcsc(labell(i),k);
    end
end

number_class = 50;
label_numbers = 2;
[coeff3, score3, latent3, tsquared3, explained3, mu3] = pca(PCA_trial_2,'NumComponents',number_class);
score = normalize(score3);

% 画图
figure;
x_1 = 2; x_2 =3; 
size_o = 120;
size_s = 120;
xx(1:8) = 0;
yy(1:8) = 0;
for i = 1 : oktrial
    xx(labell(i)) = xx(labell(i)) + score(i,x_1);
    yy(labell(i)) = yy(labell(i)) + score(i,x_2);
    if labell(i) == 1
        color = [197 100 98]/256;
        scatter(score(i,x_1),score(i,x_2),size_o,color,'filled','o');
    end
    if labell(i) == 2
        color = [116 165 50]/256;
        scatter(score(i,x_1),score(i,x_2),size_o,color,'filled','o');
    end
    if labell(i) == 3
        color = [80 180 225]/256;
        scatter(score(i,x_1),score(i,x_2),size_o,color,'filled','o');
    end
    if labell(i) == 4
        color = [228 172 41]/256;
        scatter(score(i,x_1),score(i,x_2),size_o,color,'filled','o');
    end
    if labell(i) == 5
        color = [197 100 98]/256;
        scatter(score(i,x_1),score(i,x_2),size_s,color,'filled','^');
    end
    if labell(i) == 6
        color = [116 165 50]/256;
        scatter(score(i,x_1),score(i,x_2),size_s,color,'filled','^');
    end
    if labell(i) == 7
        color = [80 180 225]/256;
        scatter(score(i,x_1),score(i,x_2),size_s,color,'filled','^');
    end
    if labell(i) == 8
        color = [228 172 41]/256;
        scatter(score(i,x_1),score(i,x_2),size_s,color,'filled','^');
    end
    hold on;
end

axis equal
xlim([-0.8, 0.8])
ylim([-0.8,0.8])

%% 计算4个重心
culm(1:3,1:8) = [1,2,3,4,5,6,7,8;
                 1,3,2,4,5,7,6,8;
                 1,4,2,3,5,8,6,7];
meanpoint(1:4,1:2) = 0;
ttt(1:4) = 0;
for i = 1 : oktrial
    for j = 1 : 4
        if labell(i) == culm(type,j*2) || labell(i) == culm(type,j*2-1)
            ttt(j) = ttt(j) + 1;
            meanpoint(j,1) = meanpoint(j,1) + score(i,x_1);
            meanpoint(j,2) = meanpoint(j,2) + score(i,x_2);
        end
    end
end
for i = 1 : 4
    meanpoint(i,1) = meanpoint(i,1) / ttt(i);
    meanpoint(i,2) = meanpoint(i,2) / ttt(i);
end


ZZX(1,1) = (meanpoint(1,1) + meanpoint(2,1))/2;
ZZX(1,2) = (meanpoint(1,2) + meanpoint(2,2))/2;
ZZX(2,1) = (meanpoint(3,1) + meanpoint(4,1))/2;
ZZX(2,2) = (meanpoint(3,2) + meanpoint(4,2))/2;

ZeroPoint(1) =  (ZZX(1,1) + ZZX(2,1)) / 2;
ZeroPoint(2) =  (ZZX(1,2) + ZZX(2,2)) / 2;

vZX = [ZZX(1,1) - ZZX(2,1), ZZX(1,2) - ZZX(2,2)];
v_bisector = [ZZX(1,2) - ZZX(2,2), ZZX(2,1) - ZZX(1,1)];
C = -(vZX(1)*ZeroPoint(1) + vZX(2)*ZeroPoint(2));
line2 = [vZX,C];
intersection = ZeroPoint;

clear A B
A = v_bisector(1);
B = v_bisector(2);
ttt(1:4) = 0;
tt(1:4,1:100) = 0;
x_1 = 2; x_2 =3;
for i= 1 : oktrial
    x0 = score(i,x_1);
    y0 = score(i,x_2);
    C = -(A*x0 + B*y0);
    line1 = [A,B,C];
    
    AA = [line1(1), line1(2); line2(1), line2(2)];
    BB = [-line1(3); -line2(3)];
    Point(i,1:2) = AA \ BB;
    dis = sqrt((Point(i,1) - intersection(1))^2 + (Point(i,2) - intersection(2))^2);
    if Point(i,1)<intersection(1)
       dis = -dis;
    end
    for j = 1 : 4
        if labell(i) == culm(type,j*2) || labell(i) == culm(type,j*2-1)
            ttt(j) = ttt(j) + 1;
            tt(j,ttt(j)) = dis;
        end
    end
end

cc(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
figure
for j = 1:2
    [f,xi] = ksdensity(tt(j,1 : ttt(j)));
    fill([xi,xi(1)],[f,0],cc(j,1:3),'FaceAlpha',...
            0.3,'EdgeColor',cc(j,1:3),'LineWidth',1.2)
    hold on
    ylim([0,5]);
    xlim([-1,1]);
end

figure
for j = 3:4
    [f,xi] = ksdensity(tt(j,1 : ttt(j)));
    fill([xi,xi(1)],[f,0],cc(j,1:3),'FaceAlpha',...
            0.3,'EdgeColor',cc(j,1:3),'LineWidth',1.2)
    hold on
    ylim([0,5]);
    xlim([-1,1]);
end


%% svm
close all
test_bl = 0.2;
for times = 1 : 100
    train_data = [];
    test_data = [];
    train_label = [];
    test_label = [];
    number_test = 0;
    number_train = 0;
    for j = 1 : 4
        id = randperm(ttt(j));
        num = floor(test_bl*ttt(j));
        test_data(number_test+1:number_test+num) = tt(j,id(1:num));
        test_label(number_test+1:number_test+num) = j;
        train_data(number_train+1:number_train+ttt(j)-num) = tt(j,id(num+1:ttt(j)));
        if j >2
            train_label(number_train+1:number_train+ttt(j)-num) = j-2;
        else
            train_label(number_train+1:number_train+ttt(j)-num) = j;
        end
        number_train = number_train+ttt(j)-num;
        number_test = number_test+num;
    end

    model = fitcsvm(train_data', train_label');
    p_label = predict(model, test_data')';

    AC_E = 0; all_E = 0;
    AC_H = 0; all_H = 0;
    for i = 1 : length(p_label)
        if test_label(i)>2
            all_H = all_H +1;
            if test_label(i) == p_label(i)+2
                AC_H = AC_H + 1;
            end
        else
            all_E = all_E +1;
            if test_label(i) == p_label(i)
                AC_E = AC_E + 1;
            end
        end
    end
    AC_final(times,1) = AC_E/all_E;
    AC_final(times,2) = AC_H/all_H;
    AC_final(times,3) = (AC_E+AC_H)/(all_E+all_H);
end
mean(AC_final(:,1))
mean(AC_final(:,2))
mean(AC_final(:,3))