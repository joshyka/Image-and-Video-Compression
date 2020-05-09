%% task 4
clc;
clear;
video_obj = VideoReader('Trees1.avi');
videoWidth = video_obj.Width;
videoHeight = video_obj.Height;

mov = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);
k = 1;
while hasFrame(video_obj)
    mov(k).cdata = readFrame(video_obj);
    I=frame2im(mov(k));
    k = k+1;
    if ismember(k, [50 51])
        I = rgb2gray(I);
        imwrite(I, sprintf('frame%d.bmp', k));
    end
end

%% tas5 Compute motion blocks by thresholding the difference image

I_new = mat2gray(imread("frame51.bmp"));
I_old = mat2gray(imread("frame50.bmp"));
I_difference = I_new - I_old;
th = 32/255;
I_difference(abs(I_difference)<th)=0;
I_diff = I_difference;
I_difference(abs(I_difference)>=th)=1;

%%Results
figure
subplot(1,2,1)
imshow(I_new);
title("New image");
subplot(1,2,2)
imshow(I_old);
title("Old image");
figure
imshow(I_diff);
title("difference image");

%% task6 Estimate motion vectors for motion blocks using MSE criterion and global search

[m, n] = size(I_difference); 
totalRows = floor(m / 8);% Finding the size of each block in row.
row_vector = [8 * ones(1, totalRows), rem(m, 8)];% Finding size of each block in columns. 
totalColumns = floor(n / 8);
col_vector = [8 * ones(1, totalColumns), rem(n, 8)];
Blocks_Idif = mat2cell(I_difference, row_vector, col_vector);%convertion to 8x8x blocks
Blocks_Iold = mat2cell(I_old, row_vector, col_vector);
Blocks_Inew = mat2cell(I_new, row_vector, col_vector);

%finding I_motion
[bm, bn] = size(Blocks_Idif);
 I_motion = cell(bm,bn);
 for i=1:bm
    for j=1:bn
        [temp_m,temp_n] = size(Blocks_Idif{i,j});
        temp_motionblock = ones([temp_m,temp_n]);
        temp_nonmotionblock = zeros([temp_m,temp_n]);
        if ismember(1,Blocks_Idif{i,j})
           I_motion{i,j} = temp_motionblock
        else
           I_motion{i,j} = temp_nonmotionblock; 
        end
    end
end
I_motion = cell2mat(I_motion);
figure
imshow(I_motion)
title("Motion map");