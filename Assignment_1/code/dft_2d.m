function img_result = dft_2d(img_input, flag)

% You should include the center shifting in this function

if flag == "DFT"
    img_input = double(img_input);
     [Img_M, Img_N] = size(img_input);
     img_result=zeros(Img_M,Img_N);
     SumOutner = 0;

     [nx,ny]=ndgrid([0:Img_M-1]-(Img_M-1)/2,[0:Img_N-1]-(Img_N-1)/2 );
     du=1;
     for u = [0:Img_M-1]-(Img_M-1)/2
         dv=1;
        for v = [0:Img_N-1]-(Img_N-1)/2  
            SumOutner=sum(sum(img_input.*exp(-1i*2*3.1416*(u*nx/Img_M+v*ny/Img_N))));
            img_result(du,dv) = SumOutner;
            dv=dv+1;
        end
        du=du+1;
     end
elseif flag == "IDFT"
    img_input = double(img_input);
     [Img_M, Img_N] = size(img_input);
     img_result=zeros(Img_M,Img_N);
     SumOutner = 0;

     [nx,ny]=ndgrid([0:Img_M-1]-(Img_M-1)/2,[0:Img_N-1]-(Img_N-1)/2 );
     dx=1;
     for u = [0:Img_M-1]-(Img_M-1)/2
         dy=1;
        for v = [0:Img_N-1]-(Img_N-1)/2  
            SumOutner=sum(sum(img_input.*exp(1i*2*3.1416*(u*nx/Img_M+v*ny/Img_N))));
            img_result(dx,dy) = SumOutner/ (Img_M * Img_N);
            dy=dy+1;
        end
        dx=dx+1;
     end
end
 
end