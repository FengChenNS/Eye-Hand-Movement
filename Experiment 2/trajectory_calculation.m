clc; clear;  close all

Trajectory(1) = load('Trajectory_7_21_1.mat');
Trajectory(2) = load('Trajectory_7_28_1.mat');
Trajectory(3) = load('Trajectory_8_04_1.mat');
type_information(1,1:7) = [3,1,3,0.325,0.675,0.5,0.5]; type_information(2,1:7) = [3,3,1,0.675,0.325,0.5,0.5]; 
type_information(3,1:7) = [3,4,5,0.5,0.5,0.19,0.81]; type_information(4,1:7) = [3,5,4,0.5,0.5,0.81,0.19]; 
type_information(5,1:7) = [4,1,3,0.5,0.5,0.5,0.5]; type_information(6,1:7) = [4,3,1,0.5,0.5,0.5,0.5]; 
type_information(7,1:7) = [4,4,5,0.5,0.5,0.5,0.5]; type_information(8,1:7) = [4,5,4,0.5,0.5,0.5,0.5]; 

type_information(9,1:7) = [3,1,2,0.13603,0.5,0.5,0.5]; type_information(10,1:7) = [3,2,1,0.5,0.13603,0.5,0.5]; 
type_information(11,1:7) = [3,2,3,0.5,0.86397,0.5,0.5]; type_information(12,1:7) = [3,3,2,0.86397,0.5,0.5,0.5]; 
type_information(13,1:7) = [4,1,2,0.318015,0.318015,0.5,0.5]; type_information(14,1:7) = [4,2,1,0.318015,0.318015,0.5,0.5]; 
type_information(15,1:7) = [4,2,3,0.681985,0.681985,0.5,0.5]; type_information(16,1:7) = [4,3,2,0.681985,0.681985,0.5,0.5]; 

number_type = 16; 
distances = 70;
angle_control = 3; 
all_good_trial(1:4) = 0;
record_x(1:4,1:200,1:200) = 0;
record_y(1:4,1:200,1:200) = 0;
mo =0;
for num_e = 1 : 3
for num_sessionn = 1 : 2
    num_session = num_sessionn * 2-1;
    for num_trial = 1 : Data(num_e).record(num_session).number_trial
        move_type = Data(num_e).record(num_session).move_type(num_trial,1:3);
        time_begin = Data(num_e).record(num_session).time(num_trial,4); 
        time_end = Data(num_e).record(num_session).time(num_trial,4)+199; 
        time_length = time_end - time_begin + 1;
        
        time_begin_2 = Data(num_e).record(num_session).time(num_trial,3) - 25;
        time_end_2 = Data(num_e).record(num_session).time(num_trial,3);
        x_move = mean(Data(num_e).record(num_session).position_x(num_trial,time_begin_2:time_end_2));
        y_move = mean(Data(num_e).record(num_session).position_y(num_trial,time_begin_2:time_end_2));


        x = Data(num_e).record(num_session).position_x(num_trial,time_begin:time_end); 
        y = Data(num_e).record(num_session).position_y(num_trial,time_begin:time_end);

       
        for num_type = 1 : number_type
            if move_type == type_information(num_type,1:3)
                x_begin = type_information(num_type,4);
                x_end = type_information(num_type,5);
                y_begin = type_information(num_type,6);
                y_end = type_information(num_type,7);
            end
        end
        
         x(1:time_length) = x(1:time_length) + (x_begin - x_move);
         y(1:time_length) = y(1:time_length) + (y_begin - y_move);
      %  
        x_ave = (x_end - x_begin) / (time_length - 1);
        y_ave = (y_end - y_begin) / (time_length - 1); 
        
      
        dis = 0; angle_2 = 0;
        for pos = 1:time_length
            x_t(pos) = x_begin + (pos-1) * x_ave; 
            y_t(pos) = y_begin + (pos-1) * y_ave;
            x_dis = abs(x(pos) - x_t(pos)); 
            y_dis = abs(y(pos) - y_t(pos)); 
            ddd = sqrt((x_dis*70)^2 + (y_dis*40)^2);
            dis = dis + ddd;

            a_1 = sqrt(((x_t(pos) - 0.5) * 70)^2 + ((y_t(pos) - 0.5)*40)^2 + distances^2);
            a_2 = sqrt(((x(pos) - 0.5) * 70)^2 + ((y(pos) - 0.5)*40)^2 + distances^2);
            angle_2 = angle_2 + acos((a_1^2 + a_2^2 - ddd^2) / (2 * a_1 * a_2));
        end

        dis_mse = dis / time_length;
        angle_2 = angle_2 / time_length / pi * 180;
        dis_angle_mse = atan(dis_mse/distances)*180/pi;
        
        if move_type(1:3) == [3,1,3] 
            mo = 1;
        end
        if move_type(1:3) == [3,3,1] 
            mo = 2;
        end
        if move_type(1:3) == [3,4,5] 
            mo = 3;
        end
        if move_type(1:3) == [3,5,4] 
            mo = 4;
        end

        if dis_angle_mse <= angle_control         
            all_good_trial(mo) = all_good_trial(mo) + 1;
            for lengthth = 1 : time_length
             
                record_x(mo,all_good_trial(mo),lengthth) = x(lengthth);
                record_y(mo,all_good_trial(mo),lengthth) = y(lengthth);
            end

        end

    end
    
end
end




for i = 1 : 4
    figure;
    for lengthth = 1 : time_length
        xx(lengthth) = mean(record_x(i,1:all_good_trial(i),lengthth));
        ax(lengthth) = std(record_x(i,1:all_good_trial(i),lengthth)) ;
       
        yy(lengthth) = mean(record_y(i,1:all_good_trial(i),lengthth));
        ay(lengthth) = std(record_y(i,1:all_good_trial(i),lengthth)) ;
        
    end
    
    % 判断是否在三个标准差之内
    for lengthth = 1 : time_length
        ok_trial_x = 0;
        ok_trial_y = 0;
        xxx(1:40) = 0;
        yyy(1:40) = 0;
        for num_trial = 1 : all_good_trial(i)
            
            if abs(record_x(i,num_trial,lengthth) - xx(lengthth)) <= 3 * ax(lengthth)
                ok_trial_x = ok_trial_x + 1;
                xxx(ok_trial_x) = record_x(i,num_trial,lengthth);
            end

            if abs(record_y(i,num_trial,lengthth) - yy(lengthth)) <= 3 * ay(lengthth)
                ok_trial_y = ok_trial_y + 1;
                yyy(ok_trial_y) = record_y(i,num_trial,lengthth);
            end

        end
        
        xx(lengthth) = mean(xxx(1:ok_trial_x));
        a_x(lengthth) = std(xxx(1:ok_trial_x));
        

        yy(lengthth) = mean(yyy(1:ok_trial_y));
        a_y(lengthth) = std(yyy(1:ok_trial_y));
        
        
        dele_x(lengthth) = all_good_trial(i) - ok_trial_x;
        dele_y(lengthth) = all_good_trial(i) - ok_trial_y;

    end
    

    window = 1;
    a_x = smoothdata(a_x,"gaussian",window);
    a_y = smoothdata(a_y,"gaussian",window);

    xx_up(1:lengthth) = xx(1:lengthth) + a_x(1:lengthth);
    xx_down(1:lengthth) = xx(1:lengthth) - a_x(1:lengthth);
    yy_up(1:lengthth) = yy(1:lengthth) + a_y(1:lengthth);
    yy_down(1:lengthth) = yy(1:lengthth) - a_y(1:lengthth);
    xzb = 1 :200;
    plot(1:200,xx(1:200),'color',[0 0.4470 0.7410],'LineWidth',0.5);
    hold on
    plot(1:200,yy(1:200),'color',[0.8500 0.3250 0.0980],'LineWidth',0.5);
    hold on
    fill([xzb, fliplr(xzb)],[xx_up, fliplr(xx_down)], [0 0.4470 0.7410],...
         'LineStyle','none','FaceAlpha','0.2');
    hold on
    fill([xzb, fliplr(xzb)],[yy_up, fliplr(yy_down)], [0.8500 0.3250 0.0980],...
         'LineStyle','none','FaceAlpha','0.2');
    xlim([1,200])
    ylim([0,1])
    hold on
    x_begin = type_information(i,4); x_end = type_information(i,5);
    y_begin = type_information(i,6); y_end = type_information(i,7);
    line([0,200],[x_begin,x_end],'color',[0 0.4470 0.7410],'LineWidth',0.5,'LineStyle','--')
    line([0,200],[y_begin,y_end],'color',[0.8500 0.3250 0.0980],'LineWidth',0.5,'LineStyle','--')
    xlabel('Time(s)');
    ylabel('Position (SD)');

end

clc; clear; close
close all
Trajectory(1) = load('Trajectory_7_21_1.mat');
Trajectory(2) = load('Trajectory_7_28_1.mat');
Trajectory(3) = load('Trajectory_8_04_1.mat');
type_information(1,1:7) = [3,1,3,0.325,0.675,0.5,0.5]; type_information(2,1:7) = [3,3,1,0.675,0.325,0.5,0.5]; 
type_information(3,1:7) = [3,4,5,0.5,0.5,0.19,0.81]; type_information(4,1:7) = [3,5,4,0.5,0.5,0.81,0.19]; 
type_information(5,1:7) = [4,1,3,0.5,0.5,0.5,0.5]; type_information(6,1:7) = [4,3,1,0.5,0.5,0.5,0.5]; 
type_information(7,1:7) = [4,4,5,0.5,0.5,0.5,0.5]; type_information(8,1:7) = [4,5,4,0.5,0.5,0.5,0.5]; 

type_information(9,1:7) = [3,1,2,0.13603,0.5,0.5,0.5]; type_information(10,1:7) = [3,2,1,0.5,0.13603,0.5,0.5]; 
type_information(11,1:7) = [3,2,3,0.5,0.86397,0.5,0.5]; type_information(12,1:7) = [3,3,2,0.86397,0.5,0.5,0.5]; 
type_information(13,1:7) = [4,1,2,0.318015,0.318015,0.5,0.5]; type_information(14,1:7) = [4,2,1,0.318015,0.318015,0.5,0.5]; 
type_information(15,1:7) = [4,2,3,0.681985,0.681985,0.5,0.5]; type_information(16,1:7) = [4,3,2,0.681985,0.681985,0.5,0.5]; 

number_type = 16; 
distances = 70;
angle_control = 3;
all_good_trial(1:4) = 0;
record_x(1:4,1:2000,1:200) = 0;
record_y(1:4,1:2000,1:200) = 0;
mo =0;

for num_e = 1 : 3
for num_sessionn = 1 : 2
    num_session = num_sessionn * 2;
    for num_trial = 1 : Data(num_e).record(num_session).number_trial
        move_type = Data(num_e).record(num_session).move_type(num_trial,1:3);
        time_begin = Data(num_e).record(num_session).time(num_trial,4); 
        time_end = Data(num_e).record(num_session).time(num_trial,4)+199; 
        time_length = time_end - time_begin + 1; 
        
        time_begin_2 = Data(num_e).record(num_session).time(num_trial,3) - 25;
        time_end_2 = Data(num_e).record(num_session).time(num_trial,3);
        x_move = mean(Data(num_e).record(num_session).position_x(num_trial,time_begin_2:time_end_2));
        y_move = mean(Data(num_e).record(num_session).position_y(num_trial,time_begin_2:time_end_2));

        x = Data(num_e).record(num_session).position_x(num_trial,time_begin:time_end); 
        y = Data(num_e).record(num_session).position_y(num_trial,time_begin:time_end); 

    
        for num_type = 1 : number_type
            if move_type == type_information(num_type,1:3)
                x_begin = type_information(num_type,4);
                x_end = type_information(num_type,5);
                y_begin = type_information(num_type,6);
                y_end = type_information(num_type,7);
            end
        end
        x(1:time_length) = x(1:time_length) + (x_begin - x_move);
        y(1:time_length) = y(1:time_length) + (y_begin - y_move);
        x_ave = (x_end - x_begin) / (time_length - 1); 
        y_ave = (y_end - y_begin) / (time_length - 1); 
        
      
        dis = 0; angle_2 = 0;
        for pos = 1:time_length
            x_t(pos) = x_begin + (pos-1) * x_ave;
            y_t(pos) = y_begin + (pos-1) * y_ave; 
            x_dis = abs(x(pos) - x_t(pos)); 
            y_dis = abs(y(pos) - y_t(pos)); 
            ddd = sqrt((x_dis*70)^2 + (y_dis*40)^2);
            dis = dis + ddd;
            a_1 = sqrt(((x_t(pos) - 0.5) * 70)^2 + ((y_t(pos) - 0.5)*40)^2 + distances^2);
            a_2 = sqrt(((x(pos) - 0.5) * 70)^2 + ((y(pos) - 0.5)*40)^2 + distances^2);
            angle_2 = angle_2 + acos((a_1^2 + a_2^2 - ddd^2) / (2 * a_1 * a_2));
        end
        dis_mse = dis / time_length;
        angle_2 = angle_2 / time_length / pi * 180;
        dis_angle_mse = atan(dis_mse/distances)*180/pi;
        if dis_angle_mse <= angle_control
            if move_type(1:3) == [4,1,3] 
                mo = 1;
            end
            if move_type(1:3) == [4,3,1] 
                mo = 2;
            end
            if move_type(1:3) == [4,4,5] 
                mo = 3;
            end
            if move_type(1:3) == [4,5,4] 
                mo = 4;
            end
            all_good_trial(mo) = all_good_trial(mo) + 1; 
            for lengthth = 1 : time_length
                record_x(mo,all_good_trial(mo),lengthth) = x(lengthth);
                record_y(mo,all_good_trial(mo),lengthth) = y(lengthth);
            end
        end

    end
end
end

color(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
for i = 1 : 4
    clear xx yy
    cc(1:3) = color(i,1:3);
    for num_trial = 1 : all_good_trial(i)
       
            xx = atand(((mean(record_x(i,num_trial,1:lengthth))-0.5)  * 70) / 90);
            yy = atand(((mean(record_y(i,num_trial,1:lengthth))-0.5)  * 40) / 90);
            scatter(xx,yy,20,cc,'filled','o','LineWidth',0.5);
            hold on
        
    end
    hold on;     
end
