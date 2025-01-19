function [all_angle,angle] = pinmianjj(data,fenduan,st)

    for i =1 : fenduan
        for j = 1 : 3
            mean_P(i,j) = mean(data(1+(i-1)*st:i*st,j));
            mean_P(i+fenduan,j) = mean(data(1+(i-1)*st+st*fenduan:i*st+st*fenduan,j));
        end
    end


    all_angle = 0;
    num_time = 1000;
    for num_fd = 1 : fenduan
        data_fd_H(1:st,1:3) = data((num_fd-1)*st+1 : num_fd *st, 1:3);
        data_fd_E(1:st,1:3) = data((num_fd-1)*st+1 + fenduan*st : num_fd *st+ fenduan*st, 1:3);
        [bootstat,bootsam_H] = bootstrp(num_time, @(x) sum(x), data_fd_H(:,1)); bootsam_H = bootsam_H';
        [bootstat,bootsam_E] = bootstrp(num_time, @(x) sum(x), data_fd_E(:,1)); bootsam_E = bootsam_E';
        for i = 1 : num_time
            t_H(1:3) = 0; t_E(1:3) = 0;
            for trial = 1 : st
                t_H(1:3) = t_H(1:3) + data_fd_H(bootsam_H(i,trial),1:3);
                t_E(1:3) = t_E(1:3) + data_fd_E(bootsam_E(i,trial),1:3);
            end
            pos_H(i,num_fd,1:3) = t_H(1:3) / st;
            pos_E(i,num_fd,1:3) = t_E(1:3) / st;
        end
    end

    for times = 1 : num_time
        dataa(1:fenduan,1:3) = pos_H(times,1:fenduan,1:3);
        [a_QH,b_QH,c_QH,d_QH] = threedplane(dataa(1:fenduan,1),dataa(1:fenduan,2),dataa(1:fenduan,3));
        dataa(1:fenduan,1:3) = pos_E(times,1:fenduan,1:3);
        [a_QE,b_QE,c_QE,d_QE] = threedplane(dataa(1:fenduan,1),dataa(1:fenduan,2),dataa(1:fenduan,3));
        
        f_H = calculate_fxl(a_QH,b_QH,c_QH,d_QH,mean_P(1:fenduan,1),mean_P(1:fenduan,2),mean_P(1:fenduan,3));
        f_E = calculate_fxl(a_QE,b_QE,c_QE,d_QE,mean_P(1+fenduan:fenduan*2,1),mean_P(1+fenduan:fenduan*2,2),mean_P(1+fenduan:fenduan*2,3));
        angle(times) = jsjd(f_H,f_E);

        all_angle = all_angle + angle(times);
    end
    all_angle = all_angle / num_time;
end