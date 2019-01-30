function accuracy = ada_classification(digits_set)

% Classify the digits by adaboost
% digits_set: a matrix that stores the segmented digits. The number of rows
%            equal to the number of digits in the iuput image. Each digit 
%            is stored in each row.
% accuracy: the classified accuracy of the adaboost algorithm.

% Remember to train the adaboost classifier firstly.