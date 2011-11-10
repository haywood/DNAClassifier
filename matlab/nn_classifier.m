% A nearest neighbor classifier class
classdef nn_classifier

    properties
        examples = {}; % training data
        mean_ = [];
        cov_ = [];
        Aw = [];
    end

    methods
        % train on a given set of samples and their labels
        % this overrides old training data
        function self = train(self, sample_labels, samples)
            self.examples = {};
            X = [];
            for i = 1:size(samples, 2)
                x = double(samples{i});
                self.examples{end+1} = {sample_labels{i}, x'/norm(x)};
                X = [X; double(samples{i})'];
            end

            self.mean_ = mean(X);
            self.cov_ = cov(X);
            [D, V] = eig(self.cov_);
            self.Aw = V*D^-0.5;
        end

        % predict the class of a sample
        function prediction = predict(self, x)
            best = {inf, ''};
            x = double(x);
            x = x'/norm(x);
            for i = 1:size(self.examples, 2)
                y = self.examples{i}{2};
                l = norm(x - y, 4) - x'*y;
                if l < best{1}
                    best = {l, self.examples{i}{1}};
                end
            end
            prediction = best{2};
        end
    end
end
