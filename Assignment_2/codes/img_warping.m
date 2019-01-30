function img_warp = img_warping(img, corners, n)

% Implement the image warping to transform the target A4 paper into the
% standard A4-size paper
% Input parameter:
% .    img - original input image
% .    corners - the 4 corners of the target A4 paper detected by the Hough transform
% .    (You can add other input parameters if you need. If you have added
% .    other input parameters, please state for what reasons in the PDF file)
% Output parameter:
% .    img_warp - the standard A4-size target paper obtained by image warping
% .    n - determine the size of the result image
    
    % 279n * 210n
    n = 5;
    nW = 279*n;
    nH = 210*n;
    img_warp = zeros(nW, nH);
    
    % Control points
    S1 = corners(1,:);
    S2 = corners(2,:);
    S3 = corners(3,:);
    S4 = corners(4,:);
    
    % Transformed control points
    T1 = S1;
    T2 = [T1(1)+nW T1(2)];
    T3 = [T1(1) T1(2)+nH];
    T4 = [T3(1)+nW T3(2)];
    
    W = sqrt(sum((S1-S2).^2));
    H = sqrt(sum((S3-S2).^2));
    
    % C = XM^-1 from lecture notes
    % Using inverse mapping
    X = [S1(1) S2(1) S3(1) S4(1);
         S1(2) S2(2) S3(2) S4(2)];
    M = [T1(1) T2(1) T3(1) T4(1);
         T1(2) T2(2) T3(2) T4(2);
         T1(1)*T1(2) T2(1)*T2(2) T3(1)*T3(2) T4(1)*T4(2);
         1 1 1 1];
    C = X * inv(M);
    
    for i = 1:size(img_warp, 1)
        for j = 1:size(img_warp, 2)
            c_x = T1(1)+i-1;
            c_y = T1(2)+j-1;
            dist = C*[c_x; c_y; c_x*c_y; 1];
            img_warp(i, j) = bi_interpolate(img, dist);
        end
    end
    img_warp = uint8(img_warp);
        
end

% Implementation of billinear interpolation
function intensity = bi_interpolate(img, pt)
    % Output parameter: 
    % .    intensity - Interpolated intensity
    x = pt(1);
    y = pt(2);
    x1 = ceil(x);
    y1 = ceil(y);
    x2 = floor(x);
    y2 = y1;
    x3 = x1;
    y3 = floor(y);
    x4 = floor(x);
    y4 = floor(y);
    p1 = double(img(y1, x1));
    p2 = double(img(y2, x2));
    p3 = double(img(y3, x3));
    p4 = double(img(y4, x4));
    intensity = (p1+p2+p3+p4)/4 ;
end
    

    
    
    
    
    