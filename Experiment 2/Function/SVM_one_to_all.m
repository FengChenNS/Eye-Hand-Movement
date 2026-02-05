function y_predict = SVM_one_to_all(X_train, y_train, X_test)


    y_labels = unique(y_train);
    n_class = size(y_labels, 1);
    models = cell(n_class, 1);
    for i = 1:n_class
        class_i_place = find(y_train == y_labels(i));
        svm_train_x = X_train(class_i_place,:);
        sample_num = numel(class_i_place);
        class_others = find(y_train ~= y_labels(i));
        randp = randperm(numel(class_others));
        svm_train_minus = randp(1:sample_num)';
        svm_train_x = [svm_train_x; X_train(svm_train_minus,:)];
        svm_train_y = [ones(sample_num, 1); -1*ones(sample_num, 1)];
        
        models{i} = fitcsvm(svm_train_x, svm_train_y);
    end
    test_num = size(X_test, 1);
    y_predict = zeros(test_num, 1);
    
  
    for i = 1:test_num
        bagging = zeros(n_class, 1);
        for j = 1:n_class
            model = models{j};
            [label, rat] = predict(model, X_test(i,:));
            bagging(j) = bagging(j) + rat(2);
        end
        [maxn, maxp] = max(bagging);
        y_predict(i) = y_labels(maxp);
    end
end
