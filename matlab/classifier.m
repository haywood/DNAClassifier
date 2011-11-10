% train a nearest neighbor classifier on the data in trainin
% test it on testin
% output training results to trainout
% output test results to testout

function classifier(trainin, testin, trainout, testout)
    
    [sample_labels, originals] = read_dna(trainin); % read training data
    samples = originals;
    n_samples = size(samples, 1);
    classes = {};

    judge = nn_classifier(); % make the training sample
    correct = 0;

    judge = judge.train(sample_labels, samples);

    % classify every training sample
    out_file = fopen(trainout, 'w');
    for i = 1:n_samples
        prediction = judge.predict(samples{i});
        if strcmp(prediction, sample_labels{i})
            correct = correct + 1;
        end
        fprintf(out_file, '%s', prediction);
        fprintf(out_file, ' %s', originals{i});
        fprintf(out_file, '\n');
    end
    fclose(out_file);
    correct/n_samples

    [test_labels, originals] = read_dna(testin); % read test data
    test_samples = originals;
    out_file = fopen(testout, 'w');

    % classify test samples
    for i = 1:size(test_samples, 1)
        prediction = judge.predict(test_samples{i});
        fprintf(out_file, '%s', prediction);
        fprintf(out_file, ' %s', originals{i});
        fprintf(out_file, '\n');
    end
    fclose(out_file);
