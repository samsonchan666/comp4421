function img_result = medfilt2d(img_input, size)
    I = img_input;
    x = numel(img_input(:,1));
    y = numel(img_input(1,:));
    f = size;
    %disp("f is "+f);
    if f<=0
        disp("The size must be greater than 0");
        return;
    end
    if mod(f,2)==0
        disp("Size of the filter is even.");
        return;
    end
    dim = (f-1)/2;
    %disp("dim is: "+dim)
    for i = 1+dim:x-dim
        for j = 1+dim:y-dim
            %disp("i: "+i+" j: "+j)
            subI = I(i-dim:i+dim,j-dim:j+dim);
            subI = double(subI);
            img_result(i,j) = median(reshape(subI,[1,f*f]));
        end
    end
    img_result = uint8(img_result);
end