function AC = SVM_PCA_2(data)
    st = 10;
    for times = 1 : 100
        times
        clear train_data train_label test_label test_data
        for fd = 1 : 4
            list = randperm(st); 
            begin = (fd - 1) * 10;
            for trial = 1 : 8
                train_data((fd-1) * 8 + trial,1:3) = data(begin + list(trial),1:3);
                train_label((fd-1) * 8 + trial,1) = fd;
            end
            for trial = 1 : 2
                test_data((fd-1) * 2 + trial,1:3) = data(begin + list(trial + 8),1:3);
                test_label((fd-1) * 2 + trial,1) = fd;
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
        AC(times) = ac;

    end

end