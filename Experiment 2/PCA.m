clc
clear
close all
%% Load Data
addpath(genpath(pwd));
Data(1) = load('DataExtraction_E2_demo.mat');
Trajectory(1) = load('Trajectory_E2_demo.mat');
Data_Neuron = load('neuron_select_E2_demo.mat');
number_session = 4;
%%
oktrial = 0;
ff = 0;
labell(1:1000) = 0;
for num_e = 1 
    for num_session = 1:number_session
        for num_trial = 1 : 40
            
           if Trajectory(num_e).record(num_session).success(num_trial) == 1  
                oktrial = oktrial + 1;
                ff = 0;
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,1,3] 
                    labell(oktrial) = 1; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,3,1]
                    labell(oktrial) = 3; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,4,5] 
                    labell(oktrial) = 4; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [3,5,4] 
                    labell(oktrial) = 2; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,1,3] 
                    labell(oktrial) = 5; ff = 1;
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,3,1] 
                    labell(oktrial) = 7; ff = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,4,5] 
                    labell(oktrial) = 8; ff = 1; 
                end
                if Data(num_e).record(num_session).move_type(num_trial,1:3) == [4,5,4] 
                    labell(oktrial) = 6; ff = 1; 
                end
                

                if ff == 1 
                    linshi(1:100) = 0;
                    for num_neuron = 1:Data(num_e).record(num_session).number_neuro
                        no_neuron = Data(num_e).record(num_session).neuron_id(num_neuron); 
                       
                            num_ele = floor(Data(num_e).record(num_session).neuron_id(num_neuron) / 6) +1; 
                            tt = sum(Data(num_e).record(num_session).Spike_Count(num_neuron,num_trial, ...
                                        Data(num_e).record(num_session).time(num_trial,4) : Data(num_e).record(num_session).time(num_trial,4)+199));
                            linshi(num_ele) = linshi(num_ele) + tt;
                        
                    end
                    linshi(1:100) = linshi(1:100) / 200;  
                    PCA_trial(oktrial,1:100) = linshi(1:100) * 50;
                else 
                    oktrial = oktrial - 1; 
                end


            end
        end
    end
end
linshi(1:8,1:100) = 0;
jishu(1:8) = 0;
for num_trial = 1 : oktrial
    linshi(labell(num_trial),1:100) = linshi(labell(num_trial),1:100) + PCA_trial(num_trial,1:100);
    jishu(labell(num_trial)) = jishu(labell(num_trial)) + 1;
end
for tt = 1 : 8 
    if jishu(tt) ~= 0 
        linshi(tt,1:100) = linshi(tt,1:100) / jishu(tt); 
    end
end

number_class = 50;
label_numbers = 2;
[coeff2, score2, latent2, tsquared2, explained2, mu2] = pca(linshi,'NumComponents',number_class);
score = normalize((coeff2'*PCA_trial')');

ZX(1:8,1:50) = 0;
for num_trial = 1 : oktrial
    for i = 1 : 4
        ZX(labell(num_trial),i) =  ZX(labell(num_trial),i) + score(num_trial,i);
    end
end
for i = 1 : 8
    ZX(i,:) = ZX(i,:) / jishu(i);
end
[a_QE,b_QE,c_QE,d_QE] = threedplane(ZX(1:4,1),ZX(1:4,2),ZX(1:4,3));
[a_QH,b_QH,c_QH,d_QH] = threedplane(ZX(5:8,1),ZX(5:8,2),ZX(5:8,3));

f_H = calculate_fxl(a_QH,b_QH,c_QH,d_QH,ZX(1:4,1),ZX(1:4,2),ZX(1:4,3));
f_E = calculate_fxl(a_QE,b_QE,c_QE,d_QE,ZX(5:8,1),ZX(5:8,2),ZX(5:8,3));
    
angle(1) = jsjd(f_H,f_E)
[x, y] = meshgrid(-0.1:0.01:0.1, -0.1:0.01:0.1);
z_QH = (-d_QH - a_QH*x - b_QH*y) / c_QH;
z_QE = (-d_QE - a_QE*x - b_QE*y) / c_QE;

for i = 1 : 4
    P0 = [ZX(i,1),ZX(i,2),ZX(i,3)];
    n = [a_QE,b_QE,c_QE];
    n_unit = n / norm(n);
    distance = (a_QE*P0(1) + b_QE*P0(2) + c_QE*P0(3) + d_QE) / norm(n);
    ZX_plane(i,1:3) = P0 - distance * n_unit;
end
for i = 5:8
    P0 = [ZX(i,1),ZX(i,2),ZX(i,3)];
    n = [a_QH,b_QH,c_QH];
    n_unit = n / norm(n);
    distance = (a_QH*P0(1) + b_QH*P0(2) + c_QH*P0(3) + d_QH) / norm(n);
    ZX_plane(i,1:3) = P0 - distance * n_unit;
end
color(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
figure
scatter3(ZX_plane(1:4,1),ZX_plane(1:4,2),ZX_plane(1:4,3),200,color,'filled','o');
hold on
scatter3(ZX_plane(5:8,1),ZX_plane(5:8,2),ZX_plane(5:8,3),200,color,'filled','^');
hold on
axis equal
zlim([-2,2]);
xlim([-4,4]);
ylim([-2,2]);

ZX  = ZX_plane;
x_1 = 1; 
x_2 = 2;
x_3 = 3;

line([ZX(1,x_1),ZX(3,x_1)],[ZX(1,x_2),ZX(3,x_2)],[ZX(1,x_3),ZX(3,x_3)],'Color','b');
line([ZX(2,x_1),ZX(3,x_1)],[ZX(2,x_2),ZX(3,x_2)],[ZX(2,x_3),ZX(3,x_3)],'Color','b');
line([ZX(1,x_1),ZX(4,x_1)],[ZX(1,x_2),ZX(4,x_2)],[ZX(1,x_3),ZX(4,x_3)],'Color','b');
line([ZX(4,x_1),ZX(2,x_1)],[ZX(4,x_2),ZX(2,x_2)],[ZX(4,x_3),ZX(2,x_3)],'Color','b');

line([ZX(5,x_1),ZX(7,x_1)],[ZX(5,x_2),ZX(7,x_2)],[ZX(5,x_3),ZX(7,x_3)],'Color','r');
line([ZX(6,x_1),ZX(7,x_1)],[ZX(6,x_2),ZX(7,x_2)],[ZX(6,x_3),ZX(7,x_3)],'Color','r');
line([ZX(5,x_1),ZX(8,x_1)],[ZX(5,x_2),ZX(8,x_2)],[ZX(5,x_3),ZX(8,x_3)],'Color','r');
line([ZX(8,x_1),ZX(6,x_1)],[ZX(8,x_2),ZX(6,x_2)],[ZX(8,x_3),ZX(6,x_3)],'Color','r');

bigZX(1,1) = mean(ZX(1:4,1));
bigZX(1,2) = mean(ZX(1:4,2));
bigZX(1,3) = mean(ZX(1:4,3));
bigZX(2,1) = mean(ZX(5:8,1));
bigZX(2,2) = mean(ZX(5:8,2));
bigZX(2,3) = mean(ZX(5:8,3));

scatter3(bigZX(1,1),bigZX(1,2),bigZX(1,3))
scatter3(bigZX(2,1),bigZX(2,2),bigZX(2,3))

zz = ZX(1,3);
xx = 3;
yy = -(a_QE*xx + c_QE*zz + d_QE) / b_QE;
scatter3(xx,yy,zz);
A = a_QE; B = b_QE; C = c_QE; D = d_QE;
x1 = xx; y1 = yy; z1 = zz;
x2 = ZX(1,1); y2 = ZX(1,2); z2 = ZX(1,3);
x_e = ZX(1,1); y_e = ZX(1,2); z_e = ZX(1,3);
v_B = [x2 - x1, y2 - y1, z2 - z1];
n_A = [A, B, C];
v_C = cross(v_B, n_A);
t = -0.5;
xx_2 = x_e + t*v_C(1);
yy_2 = y_e + t*v_C(2);
zz_2 = z_e + t*v_C(3);
scatter3(xx_2,yy_2,zz_2);

% Hand
zz = ZX(5,3);
xx = 0.5;
yy = -(a_QH*xx + c_QH*zz + d_QH) / b_QH;
scatter3(xx,yy,zz);
A = a_QH; B = b_QH; C = c_QH; D = d_QH;
x1 = xx; y1 = yy; z1 = zz;
x2 = ZX(5,1); y2 = ZX(5,2); z2 = ZX(5,3);
x_e = ZX(5,1); y_e = ZX(5,2); z_e = ZX(5,3);
v_B = [x2 - x1, y2 - y1, z2 - z1];
n_A = [A, B, C];
v_C = cross(v_B, n_A);
t = 1;
xx_2 = x_e + t*v_C(1);
yy_2 = y_e + t*v_C(2);
zz_2 = z_e + t*v_C(3);
scatter3(xx_2,yy_2,zz_2);


%%
n = [bigZX(2,1)-bigZX(1,1), bigZX(2,2)-bigZX(1,2), bigZX(2,3)-bigZX(1,3)];
a_a = n(1);
b_a = n(2);
c_a = n(3);
for i = 1 : 3
    ZeroPoint(i)  = (bigZX(1,i) + bigZX(2,i)) / 2;
end
d_a = -(ZeroPoint(1) * a_a + ZeroPoint(2) * b_a + ZeroPoint(3) * c_a);
n_unit = n / norm(n);
for i = 1 : 8
    P0(1:3) = ZX(i,1:3);
    distance = -(a_a*P0(1) + b_a*P0(2) + c_a*P0(3) + d_a) / dot([a_a b_a c_a], n_unit);
    P_final(i,1:3) = P0 + distance * n_unit;
end

for i = 1 : oktrial
    P0(1:3) = score(i,1:3);
    distance = -(a_a*P0(1) + b_a*P0(2) + c_a*P0(3) + d_a) / dot([a_a b_a c_a], n_unit);
    Score_final(i,1:3) = P0 + distance * n_unit;
end
figure
scatter3(P_final(1:4,1),P_final(1:4,2),P_final(1:4,3),200,color,'filled','o');
hold on
scatter3(P_final(5:8,1),P_final(5:8,2),P_final(5:8,3),200,color,'filled','^');


P0 = ZeroPoint;
v1 = ZX(7,1:3) - P0;
v2 = cross([a_a, b_a, c_a], v1);
v1 = v1 / norm(v1);
v2 = -v2 / norm(v2);

for i = 1 : 8
    P_new(i,1:3) = P_final(i,1:3) - P0;
    P2D(i,1) = dot(P_new(i,1:3), v1);
    P2D(i,2) = dot(P_new(i,1:3), v2);
end

for i = 1 : oktrial
    P_new(i,1:3) = Score_final(i,1:3) - P0;
    Score2D(i,1) = dot(P_new(i,1:3), v1);
    Score2D(i,2) = dot(P_new(i,1:3), v2);
end

figure
scatter(P2D(1:4,1),P2D(1:4,2),200,color,'filled','o');
hold on
scatter(P2D(5:8,1),P2D(5:8,2),200,color,'filled','^');
hold on
axis equal;
xlim([-2,2])
ylim([-2,2])

ZX  = P2D;
x_1 = 1; 
x_2 = 2;

line([ZX(1,x_1),ZX(3,x_1)],[ZX(1,x_2),ZX(3,x_2)],'Color','b');
line([ZX(2,x_1),ZX(3,x_1)],[ZX(2,x_2),ZX(3,x_2)],'Color','b');
line([ZX(1,x_1),ZX(4,x_1)],[ZX(1,x_2),ZX(4,x_2)],'Color','b');
line([ZX(4,x_1),ZX(2,x_1)],[ZX(4,x_2),ZX(2,x_2)],'Color','b');

line([ZX(5,x_1),ZX(7,x_1)],[ZX(5,x_2),ZX(7,x_2)],'Color','r');
line([ZX(6,x_1),ZX(7,x_1)],[ZX(6,x_2),ZX(7,x_2)],'Color','r');
line([ZX(5,x_1),ZX(8,x_1)],[ZX(5,x_2),ZX(8,x_2)],'Color','r');
line([ZX(8,x_1),ZX(6,x_1)],[ZX(8,x_2),ZX(6,x_2)],'Color','r');


%% SVM

ttt(1:8) = 0;
tt(1:8,1:30,1:2) = 0;
AC_LD_H_all(1:4,1:8) = 0;
AC_LD_E_all(1:4,1:8) = 0;
AC_LD_E_all_2(1:100,1:4,1:4) =0;
AC_LD_H_all_2(1:100,1:4,1:4) =0;

for i = 1 : oktrial
    ttt(labell(i)) = ttt(labell(i))+1;
    tt(labell(i), ttt(labell(i)), 1:2) = [Score2D(i,1), Score2D(i,2)];
end

for time = 1 : 100
    train_data= [];
    train_label = [];
    test_data = [];
    test_label = [];
    number_test = 0;
    number_train = 0;
    AC_LD_H(1:4,1:4) = 0;
    AC_LD_E(1:4,1:4) = 0;
    for i = 1 : 8
        id = randperm(ttt(i));
        num_test = floor(ttt(i) / 5);

        for j = 1 : num_test
            number_test = number_test + 1;
            test_label(number_test) = i;
            test_data(number_test,1:2) = tt(i,id(j),1:2);
        end

        for j = num_test+1 : ttt(i)
            number_train = number_train + 1;
            if i>4
                train_label(number_train) = i-4;
            else
                train_label(number_train) = i;
            end
            train_data(number_train,1:2) = tt(i,id(j),1:2);
        end
    end
    train_label = train_label';
    p_label = SVM_one_to_all(train_data, train_label, test_data);
    AC_H = 0;
    AC_E = 0;
    number_E = 0;
    number_H = 0;
    NUM_LD_E(1:4) = 0;
    NUM_LD_H(1:4) = 0;
    for ii =1 : length(p_label)
        if test_label(ii)<5
            number_E = number_E + 1;
            
            AC_LD_E(test_label(ii),p_label(ii)) = ...
                AC_LD_E(test_label(ii),p_label(ii)) + 1;
            NUM_LD_E(test_label(ii)) = NUM_LD_E(test_label(ii)) + 1;

            if test_label(ii) == p_label(ii)
                AC_E = AC_E + 1;
            end
        else
            number_H = number_H + 1;

            AC_LD_H(test_label(ii)-4,p_label(ii)) = ...
                AC_LD_H(test_label(ii)-4,p_label(ii)) + 1;
            NUM_LD_H(test_label(ii)-4) = NUM_LD_H(test_label(ii)-4) + 1;

            if test_label(ii)-4 == p_label(ii)
                AC_H = AC_H + 1;
            end
        end
    end
    
    for ii = 1 : 4
        AC_LD_E(ii,1:4) = AC_LD_E(ii,1:4) / NUM_LD_E(ii);
        AC_LD_H(ii,1:4) = AC_LD_H(ii,1:4) / NUM_LD_H(ii);
    end
    
    AC_LD_E_all_2(time,1:4,1:4) = AC_LD_E(1:4,1:4);
    AC_LD_H_all_2(time,1:4,1:4) = AC_LD_H(1:4,1:4);
    
    AC_H = AC_H/number_H;
    AC_E = AC_E/number_E;
    AC_final(time,1) =  AC_E;
    AC_final(time,2) =  AC_H;
end
mean(AC_final(1:time,1))
mean(AC_final(1:time,2))


for i = 1 : 4
    for j = 1 : 4
        AC_LD_E_all(i,j) = mean(AC_LD_E_all_2(1:100,i,j));
        AC_LD_H_all(i,j) = mean(AC_LD_H_all_2(1:100,i,j));
    end
end

AC_LD_E_all(1:4,5:8) = AC_LD_E_all(1:4,1:4);
AC_LD_H_all(1:4,5:8) = AC_LD_H_all(1:4,1:4);



for i = 1 : 4
    ACC_LD_E(i,1:4) = AC_LD_E_all(i,i:i+3);
    ACC_LD_H(i,1:4) = AC_LD_H_all(i,i:i+3);
end

mean(ACC_LD_E,1)
mean(ACC_LD_H,1)

%%
for time = 1 : 100
    for ii =1 : 4
        for jj = 1 : 4
            AC_LD_E_all(ii,jj) = mean(AC_LD_E_all_2(time,ii,jj));
            AC_LD_H_all(ii,jj) = mean(AC_LD_H_all_2(time,ii,jj));
        end
    end
    AC_LD_E_all(1:4,5:8) = AC_LD_E_all(1:4,1:4);
    AC_LD_H_all(1:4,5:8) = AC_LD_H_all(1:4,1:4);
    for i = 1 : 4
        ACC_LD_E(i,1:4) = AC_LD_E_all(i,i:i+3);
        ACC_LD_H(i,1:4) = AC_LD_H_all(i,i:i+3);
    end
    sd_ACC_LD_E(time,1:4) = mean(ACC_LD_E,1);
    sd_ACC_LD_H(time,1:4) = mean(ACC_LD_H,1);
end

for i =1 : 4
    std(sd_ACC_LD_E(1:100,i))
    std(sd_ACC_LD_H(1:100,i))
end
