% read a file with hand data
% return labels as a cell array of the class labels
% return data as a matrix of samples
function [labels, data] = read_dna(dna_file)

    data_file = fopen(dna_file, 'r');
    C = textscan(data_file, '%s %s');
    fclose(data_file);

    labels = C{1};
    data = C{2};
