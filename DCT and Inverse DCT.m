clc;
clear;
%% step 1.2 Applying 2D DCT to the entire image
imgInfo=imfinfo('lena.bmp');
I = imread('lena.bmp');
[m,n] = size(I);
I = mat2gray(I);
F = dct2(I);
F1 = F;

%% step 1.3 Removing small value DCT coeffients
F_sort = sort(abs(F1(:)),'ascend');
th = F_sort(floor(0.98*m*n))
F1(abs(F1) <th) = 0;

%% step 1.4 Applying inverse DCT to obtain compressed image and computing error,PSNR and MMSIM
I1 = idct2(F1);
imwrite(I1,"compressed_img.bmp");
%computing error
for n1=1:m
    for n2=1:n
      e1(n1,n2) = abs(I(n1,n2) - I1(n1,n2));
    end
end

%computing PSNR
x = I;
y = I1;
difference = (x-y).^2;
sum_dif = sum(difference(:)); 
B=1;
MAXx = 2^B-1;%B=1
MSE = sum_dif/(m*n);
PSNR1 = 10*log10(1/MSE);

%computing MMSIM
[ssimval,ssimmap] = ssim(y,x);
ssim_sum = sum(ssimmap(:));
MSSIM = ssim_sum/(m*n);

%% Results
figure
subplot(2,2,1)
imshow(I);
title("Original image");
subplot(2,2,2)
imshow(F);
%colormap(gca,jet(64))
%colorbar
title("Image in the DCT domain");
subplot(2,2,3)
imshow(I1);
title("Compressed image after inverse DCT");
subplot(2,2,4)
imshow(e1);
%colormap(gca,jet(64))
%colorbar
title("30*enlarged error image");

