%%     main.m文件
clc;
clear;
% BW :二值图像；
% stepR：检测的圆半径步长 
% stepAngle：角度步长，单位为弧度
% minR：最小圆半径  
% maxR：最大圆半径 p：阈值 0,1之间的数，通过调节此值可以得到图中圆的圆心和半径
% 读取视频的第一帧进行如下操作：
%1）剪裁图片的四个角 
%2）利用霍夫变换检测圆，检测圆的之后得到圆的圆心并同时输出四个圆的坐标和半径。
%3）输出的有圆心的相对坐标和圆心的绝对坐标。
I = imread('1.jpg');
for i = 1:4 % 连续剪裁图片的四个角
   switch (i)
       case {1}
           tlc= imcrop(I,[117 50 100 100]);% 左上角
           processpic(tlc,1);
           figure,imshow(tlc); 
       case {2}
           dlc= imcrop(I,[115 520 100 100]);% 左下角
           processpic(dlc,2);
           figure,imshow(dlc);
       case {3}
           trc = imcrop(I,[810 45 100 100]); % 右上角
           processpic(trc,3);
           figure,imshow(trc);
       case {4}
           drc = imcrop(I,[745 510 100 100]); % 右下角
           processpic(drc,4);
           figure,imshow(drc);
   end
end

