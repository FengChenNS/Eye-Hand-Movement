function AC = SVM_PCA_Shared(data)
    st = 10;
    for times = 1 : 100
        times
        clear train_data train_label test_label test_data
        for fd = 1 : 8
            list = randperm(st); 
            begin = (fd - 1) * 10;
            for trial = 1 : 8
                train_data((fd-1) * 8 + trial,1:3) = data(begin + list(trial),1:3);
                if fd>4
                    train_label((fd-1) * 8 + trial,1) = fd-4;
                else
                    train_label((fd-1) * 8 + trial,1) = fd;
                end
            end
            for trial = 1 : 2
                test_data((fd-1) * 2 + trial,1:3) = data(begin + list(trial + 8),1:3);
                if fd>4
                    test_label((fd-1) * 2 + trial,1) = fd-4;
                else
                    test_label((fd-1) * 2 + trial,1) = fd;
                end
            end
        end

        [label_predict,bate] = SVM_one_to_all(train_data, train_label, test_data);
        ac = 0;
        for i = 1 : 8
            if label_predict(i) == test_label(i)
                ac = ac + 1;
            end
        end
        ac = ac / 8;
        AC(times,1) = ac;
        
        ac = 0;
        for i = 9:16
            if label_predict(i) == test_label(i)
                ac = ac + 1;
            end
        end
        ac = ac / 8;
        AC(times,2) = ac;
    end

end