function [p,record] = boot_plane_own_angle(Score_all)
    
    num_biger_0(1:4) = 0;
    for i = 1 : 10000
        id = randi(10,1,10);
        for session = 1 : 4
            for j = 1 : 4  
                for kk = 1 : 3
                    tt = id + (j-1) * 10;
                    ZX(session,2,j,kk) = mean(Score_all(session).Score_all(tt,kk));
                    tt = id + (j-1) * 10 + 40;
                    ZX(session,1,j,kk) = mean(Score_all(session).Score_all(tt,kk));
                end
            end
            
            Score(1:4,1:3) = ZX(session,1,1:4,1:3);
            Score(5:8,1:3) = ZX(session,2,1:4,1:3);
            [a_H,b_H,c_H,d_H] = threedplane2(Score(1:4,1),Score(1:4,2),Score(1:4,3));
            [a_E,b_E,c_E,d_E] = threedplane2(Score(5:8,1),Score(5:8,2),Score(5:8,3));
            f_H(session,1:3) = calculate_fxl(a_H,b_H,c_H,d_H,Score(1:4,1),Score(1:4,2),Score(1:4,3));
            f_E(session,1:3) = calculate_fxl(a_E,b_E,c_E,d_E,Score(5:8,1),Score(5:8,2),Score(5:8,3));
        end
        % session 1,2; Eye
        record(i,1) = jsjd(f_E(1,1:3), f_E(2,1:3));
        % session 1,2; Hand
        record(i,2) = jsjd(f_H(1,1:3), f_H(2,1:3));
        % session 3,4; Eye
        record(i,3) = jsjd(f_E(3,1:3), f_E(4,1:3));
        % session 3,4; Hand
        record(i,4) = jsjd(f_H(3,1:3), f_H(4,1:3));
        for ii = 1 : 4
            if record(i,ii) > 0
                num_biger_0(ii) = num_biger_0(ii) + 1;
            end
        end
        i
    end
    
    p(1:4) = min(1-(num_biger_0(1:4) / 10000) , num_biger_0(1:4) / 10000);
    

end