function img_result = high_freq_emphasis(img_input, a, b, type)
if type == "butterworth"
    f = a+b*butterworth(size(img_input),0.1,1);
elseif type == "gaussian"
    f = a+b*gaussian(size(img_input),0.1);
else
    return
end
ft = dft_2d(img_input, "DFT");
img_result = uint8(abs(dft_2d(ft.*f, "IDFT")));
end