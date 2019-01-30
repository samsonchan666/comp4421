clc
clear

img_name_arr = ["1.jpg", "2.bmp", "3.bmp"];
for imgNo = 1:length(img_name_arr)
    img_name = ['Sample\input images\', convertStringsToChars(img_name_arr(imgNo))];
    img = imread(img_name);
    img_gray = rgb2gray(img);
    if imgNo == 3 || imgNo == 2
        T = adaptthresh(img_gray, 0.9);
    else
        T = adaptthresh(img_gray, 0.68);
    end
    BW = ~(imbinarize(img_gray,T));
%     imshow(BW);
    [digits_set] = digit_segment(BW, imgNo);
end

images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
I = images;
I = reshape(I, [28, 28, 60000]);
training_set = zeros(256, 60000);
for i = 1:size(I, 3)
%     disp(i);
    features = LBP(I(:,:,i), 1);  
    features = features(:);
    for j = 1:length(features)
        training_set(features(j)+1, i) = training_set(features(j)+1, i) + 1;
    end
end

% rng(10);
% Mdl = fitcknn(transpose(training_set),labels,'NumNeighbors',5,'Standardize',1);
% rloss = resubLoss(Mdl);
Mdl = fitctree(transpose(training_set),labels);
rloss = resubLoss(Mdl);
for resultNo = 1:3
    if resultNo == 1
        num = 14;
        true = transpose([1 2 4 7 6 7 3 8 9 5 2 4 8 1]);
    elseif resultNo == 2
        num = 12;
        true = transpose([1 2 3 4 1 9 8 6 2 0 1 9]);
    else
        num = 16;
        true = transpose([2 0 1 9 1 0 2 5 2 0 1 9 1 1 0 1]);    
    end
    correct = 0;
    test_set = zeros(256, num);
    for i = 1:num
        test_img_path = ['Sample\result images\digits of image ', num2str(resultNo),'\r', num2str(i), '.jpg'];
        test_img = imread(test_img_path);
        if size(test_img, 1) ~= size(test_img, 2)
            if size(test_img, 1) > size(test_img, 2)
                tmp_img = uint8(zeros(size(test_img, 1), size(test_img, 1)));
                tmp_img(1:size(test_img, 1), 1:size(test_img, 2)) = test_img;
                test_img = tmp_img;
            else
                tmp_img = uint8(zeros(size(test_img, 2), size(test_img, 2)));
                tmp_img(1:size(test_img, 1), 1:size(test_img, 2)) = test_img;
                test_img = tmp_img;
            end
        end
        test_img = imresize(test_img, [28, 28]);
        features = LBP(double(test_img)/255, 1);
        features = features(:);
        for j = 1:length(features)
            test_set(features(j)+1, i) = test_set(features(j)+1, i) + 1;
        end
    end
    label = predict(Mdl,transpose(test_set));
    disp(double(sum(label == true))/num);
end


% accuracy = ada_classification(digits_set);