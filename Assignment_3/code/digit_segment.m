function [digits_set] = digit_segment(BW, imgNo)

% Implement the digit segmentation
% img: input image
% digits_set: a matrix that stores the segmented digits. The number of rows
%            equal to the number of digits in the iuput image. Each digit 
%            is stored in each row.
    [n, m] = size(BW);
    hist = zeros(1, m);
    for i = 1:m
        no_white = 0;
       for j = 1:n
           if BW(j, i) == 1
               no_white = no_white + 1;
           end
       end
       hist(i) = no_white;
    end
    if imgNo == 3
        noiseThresh = 5;
        t1 = findThresh(hist, 0);
        t2 = findThresh(hist(1:t1), 0);
        t3 = findThresh(hist(t1+1:length(hist)), t1);
        t4 = findThresh(hist(1:t2), 0);
        t5 = findThresh(hist(t2+1:t1), t2);
        t6 = findThresh(hist(t1+1:t3), t1);
        t7 = findThresh(hist(t3+1:length(hist)), t3);
        thresh_h = [0 t1 t2 t3 t4 t5 t6 t7 0];
    elseif imgNo == 1
        noiseThresh = 0;
        t1 = findThresh(hist, 0);
        t2 = findThresh(hist(1:t1), 0);
        t3 = findThresh(hist(t1+1:length(hist)), t1);
        t4 = findThresh(hist(1:t2), 0);
        t5 = findThresh(hist(t1+1:t3), t1);
        t6 = findThresh(hist(t3+1:length(hist)), t3);
        thresh_h = [0 t1 t2 t3 t4 t5 t6 0];
    else
        noiseThresh = 0;
        t1 = findThresh(hist, 0);
        t2 = findThresh(hist(1:t1), 0);
        t3 = findThresh(hist(t1+1:length(hist)), t1);
        thresh_h = [0 t1 t2 t3 0];
    end
    for i = 1:m
      if hist(i) > noiseThresh
          thresh_h(1) = i;
          break
      end
    end
    for i = 0:m-1
      if hist(m-i) > noiseThresh
          thresh_h(length(thresh_h)) = m-i;
          break
      end
    end
    thresh_h = sort(thresh_h);
    % =================================================== %
    hist_v = zeros(1, n);
    v_thresh = 500;
    for i = 1:n
        no_white = 0;
       for j = 1:m
           if BW(i, j) == 1
               no_white = no_white + 1;
           end
       end
       hist_v(i) = no_white;
    end
    if imgNo == 2
        t1_v = findThresh(hist_v, 0);
        t2_v = findThresh(hist_v(1:t1_v), 0);
        thresh_v = [0 t1_v t2_v 0];
        v_thresh = 400;
    else
        t1_v = findThresh(hist_v, 0);
        thresh_v = [0 t1_v 0];
    end
    
    for i = 1:n
      if hist_v(i) > noiseThresh
          thresh_v(1) = i;
          break
      end
    end
    for i = 0:n-1
      if hist_v(n-i) > noiseThresh
          if abs(t1_v - (n-i)) > v_thresh
              continue
          end
          thresh_v(length(thresh_v)) = n-i;
          break
      end
    end
    thresh_v = sort(thresh_v);
    % =================================================== %
%     tmp = 1;
    digits_set = [];
    for i = 1:length(thresh_v)-1
        for j = 1:length(thresh_h)-1
           row = thresh_v(i):thresh_v(i+1);
           col =  thresh_h(j):thresh_h(j+1);
%            imwrite(BW(row,col), ['Assignment 3\Sample\result images\digits of image 3\r', num2str(tmp), '.jpg']);
%            tmp = tmp + 1;
           imshow(BW(row,col));
        end
    end
end

function thresh = findThresh(hist, offset)
    classB_variance = inf;
    sump = sum(hist);
    m = length(hist);
    for i = 1:m
        if sum(hist(1:i)) == 0 || sum(hist(i:m)) == 0
            continue;
        end
        Wb = sum(hist(1:i)) / sump;
        Mub = sum(([1:i] .*  hist(1:i))) /  sum(hist(1:i));
        Varb = sum(([1:i] - Mub).^2 .* hist(1:i)) / sum(hist(1:i));

        Wf = sum(hist(i:m)) / sump;
        Muf = sum(([i:m] .*  hist(i:m))) / sum(hist(i:m));
        Varf = sum(([i:m] - Muf).^2 .* hist(i:m)) /  sum(hist(i:m));

        if Wb*Varb + Wf*Varf < classB_variance
            classB_variance = Wb*Varb + Wf*Varf;
            thresh = i;
        end 
    end
    thresh = thresh + offset;
end