function img_result = filter2d_fre(img_input,filter)
%FILTER2D_FRE Summary of this function goes here
%   Detailed explanation goes here
    h1 = img_input.*filter;
    idft_img = dft_2d(h1, 'IDFT');
    real_img = uint8(abs(idft_img));
    real_spectrum = mat2gray(real_img);
    img_result = real_spectrum;
end

