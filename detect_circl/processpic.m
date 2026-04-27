function processpic(t,h)   

[row, col, channel] = size(t);

if channel==3             %判断图像是否是彩色图像
    grayI = rgb2gray(t); % 图像灰度变换
else
    grayI = t;%图片灰度处理，对图片进行预处理
end

BW = edge(grayI,'sobel');%边缘检测

imshow(t);
hold on;

stepR = 3;
stepAngle = 0.07;
minR = 16;
maxR = 18;
p = 0.95;

switch (h)
    case {1}% 这是检测到的第一个圆
        parm = findcircle(BW,stepR,stepAngle,minR,maxR,p);
        % 对于supple因为调参之后就出现了一组数据，所以不用再求均值。
        %disp(parm);
        %paraAvg = mean(parm);%对矩阵的每一列进行求均值
        % 输出的坐标是绝对坐标坐标形式是（y,x）;
        %fprintf('CenterAvg %d %d  radiusAvg %d\n',round(paraAvg(1,1)+50),round(paraAvg(1,2)+117),paraAvg(1,3));
        fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+50),round(parm(1,2)+117),parm(1,3));
    case {2}%这是检测到的第二个圆
        parm = findcircle(BW,3,0.07,16,18,0.95);
       % paraAvg = mean(parm);%对矩阵的每一列进行求均值
        fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+520),round(parm(1,2)+115),parm(1,3));
    case {3}%这是检测的第三个圆
       parm = findcircle(BW,3,0.07,16,18,0.95);
       % paraAvg = mean(parm);%对矩阵的每一列进行求均值
       fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+45),round(parm(1,2)+810),parm(1,3));
    case {4}%这是检测的第四个圆
       parm = findcircle(BW,3,0.07,16,18,0.95);
       % paraAvg = mean(parm);%对矩阵的每一列进行求均值
       fprintf('CenterAvg %d %d  radiusAvg %d\n',round(parm(1,1)+510),round(parm(1,2)+745),parm(1,3));
end
   
% 绘制所有的圆 
for i = 1:size(parm,1)
    x0 = parm(i,1); y0 = parm(i,2);  r0 = parm(i,3);
    xi=[-r0:0 0:r0];
    yi=round((r0^2-xi.^2).^0.5);
    plot(yi+y0,xi+x0,'Color','g','LineWidth',3); % 下半圆
    plot(-yi+y0,xi+x0,'Color','g','LineWidth',3); % 上半圆
    % plot(y0,x0,'x','LineWidth',2,'Color','red');
end
end
