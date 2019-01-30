clc
clear

% Assignment 2
% img - original input image
% img_marked - image with marked sides and corners detected by Hough transform
% corners - the 4 corners of the target A4 paper
% img_warp - the standard A4-size target paper obtained by image warping
% n - determine the size of the result image

% define the n by yourself
n = 5;
inputs = [1,2,3,4,5,6];

for i = 1:length(inputs)
    img_name = [num2str(inputs(i)), '.JPG'];
%     img_name = ['Assignment 2\Sample\input_imgs\' , num2str(inputs(i)) , '.JPG'];
    img = imread(img_name);
    img_gray = rgb2gray(img);
    T = adaptthresh(img_gray, 0.42);
    BW = imbinarize(img_gray,T);
%     imshowpair(img_gray, BW, 'montage');
%     level = graythresh(img_gray);
%     BW = imbinarize(img_gray,level);
%     imshowpair(img,BW,'montage');
    
%     img_edge = edge(BW, "log");
     img_edge = edge(BW, "canny");
    [img_marked, corners] = hough_transform(img, img_edge, i);
    
    img_warp = img_warping(img, corners, n);
%     imwrite(img_warp, ['Assignment 2\Sample\result_imgs\image_warping\', num2str(i), '.jpg']);
 
    figure, 
    subplot(131),imshow(img);
    subplot(132),imshow(img_marked);
    subplot(133),imshow(img_warp);
end
