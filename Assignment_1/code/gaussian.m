function [ f ] = gaussian( size,cutoff )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [v,u] = freqspace(size,'meshgrid');
    dist = sqrt(v.^2+u.^2);
    f = 1-exp(-dist.^2./(2*cutoff.^2));
end
