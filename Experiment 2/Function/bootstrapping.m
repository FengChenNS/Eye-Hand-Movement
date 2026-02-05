function [p] = bootstrapping(N_1,N_2,all_1,all_2)

    DL_1(1:N_1) = 1;
    DL_1(N_1+1:all_1) = 0;
    DL_2(1:N_2) = 1;
    DL_2(N_2+1:all_2) = 0;
    [bootstat_1,bootsam] = bootstrp(10000, @(x) sum(x), DL_1);
    [bootstat_2,bootsam] = bootstrp(10000, @(x) sum(x), DL_2);
    
    p = bootstrp_p(bootstat_1,bootstat_2);
    
end
