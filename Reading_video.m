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
    if ismember(k, [10 20])
        I = rgb2gray(I);
        imwrite(I, sprintf('frame%d.bmp', k));
    end
end

%plt = figure;
%set(plt,'position',[300 300 videoWidth videoHeight]);
%movie(plt,mov,1,video_obj.FrameRate);


subplot(1,2,1)
imshow('frame10.bmp');
title("frame10.bmp");

subplot(1,2,2)
imshow('frame20.bmp');
title("frame20.bmp");