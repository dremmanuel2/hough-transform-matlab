clc;
clear all
close all
imtool close all


[filename, pathname] = uigetfile('*','选择文件');
filepath=fullfile(pathname,filename);
img0=imread(filepath);

[row, col, channel] = size(img0);

if channel==3             %判断图像是否是彩色图像
    gray = rgb2gray(img0); % 图像灰度变换
else
    gray = img0;
end
cannyedge = edge(gray,'canny');

imshow(img0);
%imshow(cannyedge);
hold on;

%设置圆的参数范围
stepR = 3;
stepAngle = 0.07;
minR = 200;%16;%
maxR = 250;%18;%
p = 0.95;

parm = findcircle(cannyedge,stepR,stepAngle,minR,maxR,p);
paraAvg = mean(parm);%对矩阵的每一列进行求均值

fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+50),round(parm(1,2)+117),parm(1,3));
   
%parm = paraAvg;%只有一个圆时，用均值  
% 绘制所有的圆 
for i = 1:size(parm,1)
    x0 = parm(i,1); y0 = parm(i,2);  r0 = parm(i,3);
    xi=[-r0:0 0:r0];
    yi=round((r0^2-xi.^2).^0.5);
    plot(yi+y0,xi+x0,'Color','g','LineWidth',3); % 下半圆
    plot(-yi+y0,xi+x0,'Color','g','LineWidth',3); % 上半圆
    plot(y0,x0,'x','LineWidth',2,'Color','red');
end

