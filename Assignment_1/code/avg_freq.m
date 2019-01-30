function f = avg_freq(p, q, cutoff)
    [v,u] = freqspace([p q],'meshgrid');
    dist = sqrt(v.^2+u.^2);
    func = 1-exp(-dist.^2./(2*cutoff.^2));
    H = zeros(p,q);
    for i = 1:p
        for j = 1:q
            if func(i,j) <= cutoff
                H(i,j) = 1;
            else
                H(i,j) = 0;
            end
        end
    end
    f = H;
end
