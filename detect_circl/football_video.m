clc;
clear all
close all
imtool close all
% 创建一个 VideoReader 对象来读取视频文件
videoFile = '202410151735.mp4';
vdr = VideoReader(videoFile);

% 获取视频的一些属性
frameRate = vdr.FrameRate; % 帧率

% 初始化一个 VideoWriter 对象来保存输出视频
outputVideo = 'output_a.mp4';
vwr = VideoWriter(outputVideo, 'MPEG-4');
vwr.FrameRate = frameRate;
open(vwr);


% 读取并处理每一帧
while hasFrame(vdr)
    % 读取一帧
    frame = readFrame(vdr);
    % 设定缩放比例
    scaleFactor = 0.25; % 缩小
    
    % 调整图像尺寸
    frame = imresize(frame, scaleFactor);

    [row, col, channel] = size(frame);
    
    if channel==3             %判断图像是否是彩色图像
        gray = rgb2gray(frame); % 图像灰度变换
    else
        gray = frame;
    end

    gray = laplacian_trans(gray);
    % imshow(gray);
    cannyedge = edge(gray,'canny');
    %imshow(frame);
    % imshow(cannyedge);
    
    %hold on;
    
    %设置圆的参数范围
    stepR = 3;
    stepAngle = 0.07;
    minR = 30;%16;%
    maxR = 40;%18;%
    p = 0.99;
    
    parm = findcircle(cannyedge,stepR,stepAngle,minR,maxR,p);
    paraAvg = mean(parm);%对矩阵的每一列进行求均值
    
    fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+50),round(parm(1,2)+117),parm(1,3));
       
    %parm = paraAvg;%只有一个圆时，用均值  
    % 绘制所有的圆 
    for i = 1:size(parm,1)
        if(size(parm,1)>=2)
            break;
        end
        x0 = parm(i,1); y0 = parm(i,2);  r0 = parm(i,3);
        xi=[-r0:0 0:r0];
        yi=round((r0^2-xi.^2).^0.5);
        % 使用 insertShape 函数来绘制圆
        frame = insertShape(frame,'circle', [y0, x0, r0], ...
            'Color', 'green', 'LineWidth', 3);

        %标记圆心
        frame = insertShape(frame, 'circle', [y0, x0,5], ...
            'Color', 'red', 'LineWidth', 2);
        % plot(yi+y0,xi+x0,'Color','g','LineWidth',3); % 下半圆
        % plot(-yi+y0,xi+x0,'Color','g','LineWidth',3); % 上半圆
        % plot(y0,x0,'x','LineWidth',2,'Color','red');
    end
    
    % 显示处理后的帧
    imshow(frame);
    
    % 添加显示帧之间的延迟
    %pause(1/frameRate); % 按照原视频帧率暂停
    
    % 写入到输出视频
    writeVideo(vwr, frame);
end

% 关闭 VideoWriter
close(vwr);