function [p] = bootstrp_p(data_1,data_2)
    
    t =0;
    for i = 1 : length(data_1)
        if data_1(i) > data_2(i) 
            t =t + 1;
        end
    end
    
    t = t/ length(data_1);
    t = min(t, 1-t);
    p = t;

end
