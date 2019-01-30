function img_result = filter_spa(img_input, filter)
    I = img_input;
    [x,y] = size(I);
    [f,g] = size(filter);
    if f~=g 
        disp("This filter is not a square.");
        return;
    end
    if mod(f,2)==0
        disp("Size of the filter is even.");
        return;
    end
    dim = (f-1)/2;
    for i = 1+dim:x-dim
        for j = 1+dim:y-dim
            subI = I(i-dim:i+dim,j-dim:j+dim);
            subI = double(subI);
            img_result(i,j) = sum(dot(subI,filter));
        end
    end
    img_result = uint8(img_result);
end