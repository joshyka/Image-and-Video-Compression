%% step 2.1
clc;
clear;
imgInfo=imfinfo('lena.bmp');
%Reading the image
I = imread('lena.bmp');
I = mat2gray(I);
imshow(I);

%% step 2.2
[m, n] = size(I);
RowSize = floor(m / 8);% Calculate the size of each block in row. 
RowVector = [8 * ones(1, RowSize)];% Calculate the size of each block in columns. 
ColumnSize = floor(n / 8);
ColumnVector = [8 * ones(1, ColumnSize)];
Blocks = mat2cell(I, RowVector, ColumnVector);

%Applying 2D dct to each block and placing the blocks in corresponding posn
[r,c] = size(Blocks);
block_dct = cell(r,c);
for row=1:r
    for column=1:c
       block_dct{row,column} = dct2(Blocks{row,column});
    end
end
dct_image = cell2mat(block_dct);

%Compression in the DCT domain
dct_sort = sort(abs(dct_image(:)),'ascend');%choosing dct transformed image
th = dct_sort(floor(0.98*m*n));

for row=1:r
    for column=1:c
       temp = block_dct{row,column};
       temp(abs(temp)<th) = 0;
       block_dct{row,column} = temp;
    end
end
F2 = cell2mat(block_dct);

%% task 2.4 Inverse block DCT transform to produce the compressed image
for row=1:r
    for column=1:c
        block_idct{row,column} = idct2(block_dct{row,column});
    end
end
I2 = cell2mat(block_idct);

imwrite(I2,"bdct.bmp");
%% step 2.5 Computing error,PSNR2 and MMSIM2

%computing error
for n1=1:m
    for n2=1:n
      e2(n1,n2) = abs(I(n1,n2) - I2(n1,n2));
    end
end

%computing PSNR
x = I;
y = I2;
difference = (x-y).^2;
sum_dif = sum(difference(:));       
B = 1;
MAXx = 2^B-1;
MSE = double(sum_dif)/(m*n);
PSNR2 = 10*log10(1/MSE);

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
imshow(F2);
colorbar;
title("Image in the DCT domain");
subplot(2,2,3)
imshow(I2);
title("Compressed image after inverse DCT");
subplot(2,2,4)
imshow(e2);
colorbar;
title("30*enlarged error image");
%colormap(gca,jet(64))
colorbar
