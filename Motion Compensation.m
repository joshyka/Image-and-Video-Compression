%% Computing motion vectors
[x,y] = size(Blocks_Idif);
MV = zeros(x,y,2);
for i=1:x
    for j = 1:y
        if(ismember(1,Blocks_Idif{i,j}))
           [Mx,My] = size(Blocks_Idif{i,j})
           min_er= 100000;
           dx(:)=-241:1:241;
           dy(:)=-321:1:321;
           for t=1:length(dx)
               if((i)*Mx-241<=dx(t))
                  if(dx(t)<(i-1)*Mx)
                  else
                    dx(t)=0;
                  end
               else
                  dx(t)=0;
               end
           end

           for t=1:length(dy)
               if(j*My-321<=dy(t))
                  if(dy(t)<(j-1)*My)
                  else
                     dy(t)=0;
                  end
               else
                  dy(t)=0;
               end
           end

          for dx_i = 1:length(dx)
              for dy_j=1:length(dy)
                  temp = 0;
                  for xi =(i-1)*Mx+1:i*Mx
                      for yj =(j-1)*My+1:j*My
                          temp = temp + (I_new(xi,yj)-I_old(xi-dx(dx_i),yj-dy(dy_j)))^2;
                      end
                  end
                  temp = temp/(Mx*My);
                  if(temp <= min_er)
                      min_er = temp;
                      MV(i,j,1)=dx(dx_i);
                      MV(i,j,2)=dy(dy_j);
                   end
              end
           end
            
        end
    end
end

%% Motion compensation for motion blocks
I4 = zeros(m,n);
for i =1:x
    for j = 1:y
        if(ismember(1,Blocks_Idif{i,j}))
            [Mx,My] = size(Blocks_Idif{i,j})
            for xi=(i-1)*Mx+1:i*Mx
                for yj=(j-1)*My+1:j*My
                    I4(xi,yj) = I_old(xi-MV(i,j,1),yj-MV(i,j,2));
                end
            end
        end
    end
end
figure
imshow(I4);
title('Image with motion compensation')
imwrite(I4,'I4.bmp');

%% INTRA processing of non-motion blocks by copying previous blocks:
I5 = I4;
for i =1:x
    for j = 1:y
        if(~ismember(1,Blocks_Idif{i,j}))
            [Mx,My] = size(Blocks_Idif{i,j})
            for xi=(i-1)*Mx+1:i*Mx
                for yj=(j-1)*My+1:j*My
                    I5(xi,yj) = I_old(xi,yj);
                end
            end
        end
    end
end
figure
imshow(I5);

%% Computing error Image
er5=30*abs(I5-I_new);
figure
subplot(2,2,1)

imshow(I_new)
title('New/Original Image')
subplot(2,2,2)
imshow(I4);
title('Motion compensated image from INTER mode')
subplot(2,2,3)
imshow(I5);
title('INTER and INTRA modes')
subplot(2,2,4)
imshow(er5);
title('Error image enlarged 30 times')
%colormap(gca,jet(64))
colorbar

%% Computing PSNR
x = I_new;
y = I5;
difference = (x-y).^2;
sum_dif = sum(difference(:));       
B = 1;
MAXx = 2^B-1;
MSE = double(sum_dif)/(m*n);
PSNR5 = 10*log10(1/MSE);
%% MSSIM

[ssimval,ssimmap] = ssim(I5,I_new);
ssim_sum = sum(ssimmap(:));
MSSIM5 = ssim_sum/(m*n);