% A nearest neighbor classifier class
classdef nn_classifier

    properties
        examples = {}; % training data
    end

    methods
        % train on a given set of samples and their labels
        % this overrides old training data
        function self = train(self, sample_labels, samples)
            self.examples = {};
            for i = 1:size(samples, 1)
                self.examples{end+1} = {sample_labels{i}, samples{i}};
            end
        end

        % predict the class of a sample
        function prediction = predict(self, x)
            best = {inf, ''};
            dna = 'GATC';
            for i = 1:size(self.examples, 2)
                y = self.examples{i}{2};
                l = - sum(x == y & ismember(x, dna) & ismember(y, dna));
                if l < best{1}
                    best = {l, self.examples{i}{1}};
                end
            end
            prediction = best{2};
        end
    end
end
