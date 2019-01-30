function [ f ] = butterworth( size,cutoff,n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [v,u] = freqspace(size,'meshgrid');
    dist = sqrt(v.^2+u.^2);
    f = 1./((1+cutoff./dist).^(2*n));
end