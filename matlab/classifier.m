% train a nearest neighbor classifier on the data in trainin
% test it on testin
% output training results to trainout
% output test results to testout

function classifier(trainin, testin, trainout, testout)
    
    [sample_labels, originals] = read_dna(trainin); % read training data
    samples = transform_dna(originals); % transform it to have useful features
    n_samples = size(samples, 1);
    classes = {};

    judge = nn_classifier(); % make the training sample
    correct = 0;

    % partition data into training and validation
    [train_samples, train_labels, validation_samples, test_labels] = split_samples(samples, sample_labels);

    judge = judge.train(train_labels, train_samples);
    for i = 1:size(validation_samples, 2)
        prediction = judge.predict(validation_samples{i});
        if strcmp(prediction, test_labels{i})
            correct = correct + 1;
        end
    end

    correct = correct/size(validation_samples, 2);

    % sort by distance from the mean
    display 'cross validation results'
    correct
    fprintf(1, 'using %d training and %d testing\n', size(train_samples, 2), size(validation_samples, 2));

    % classify every training sample
    out_file = fopen(trainout, 'w');
    for i = 1:size(samples, 2)
        prediction = judge.predict(samples{i});
        fprintf(out_file, '%s', prediction);
        fprintf(out_file, ' %s', originals{i});
        fprintf(out_file, '\n');
    end
    fclose(out_file);

    [test_labels, originals] = read_dna(testin); % read test data
    test_samples = transform_dna(originals); % transform test data to have useful features
    out_file = fopen(testout, 'w');

    % classify test samples
    for i = 1:size(test_samples, 2)
        prediction = judge.predict(test_samples{i});
        fprintf(out_file, '%s', prediction);
        fprintf(out_file, ' %s', originals{i});
        fprintf(out_file, '\n');
    end
    fclose(out_file);

% split samples for cross validation

function [train_samples, train_labels, validation_samples, test_labels] = split_samples(samples, labels)

    train_samples = {};
    train_labels = {};
    validation_samples = {};
    test_labels = {};

    for i = 1:size(samples, 2)
        if ~ismember(labels{i}, train_labels)
            train_samples{end+1} = samples{i};
            train_labels{end+1} = labels{i};
        else
            k = find(ismember(labels{i}, train_labels) == 1);
            s = sum(samples{i} == 'N') + sum(samples{i} == '-');
            c = sum(train_samples{k} == 'N') + sum(train_samples{k} == '-');
            if s < c % always favor the sample with less missing data
                validation_samples{end+1} = train_samples{k};
                test_labels{end+1} = train_labels{k};
                train_samples{k} = samples{i};
                train_labels{k} = labels{i};
            else
                validation_samples{end+1} = samples{i};
                test_labels{end+1} = labels{i};
            end
        end
    end
