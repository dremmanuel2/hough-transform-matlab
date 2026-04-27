% 霍夫检测圆的主要代码
function [para] = findcircle(BW,stepR,stepAngle,minR,maxR,p)
%circleParaXYR = [];
[m,n] = size(BW);% BW:二值图像；
cntR = round((maxR-minR)/stepR)+1;% stepR:检测的圆半径步长， minR:最小圆半径， maxR:最大圆半径
cntAngle = round(2*pi/stepAngle);% stepAngle:角度步长，单位为弧度
hough_space = zeros(m,n,cntR);
% hough_space:参数空间，h(a,b,r)表示圆心在(a,b)半径为r的圆上的点数
[rows,cols] = find(BW);
cntPoints = size(rows,1); 
% Hough变换将图像空间(x,y)对应到参数空间(a,b,r)
% a = x-r*cos(angle), b = y-r*sin(angle)
for i=1:cntPoints
    for r=1:cntR
        for k=1:cntAngle
            a = round(rows(i)-(minR+(r-1)*stepR)*cos(k*stepAngle));
            b = round(cols(i)-(minR+(r-1)*stepR)*sin(k*stepAngle));
            if(a>0 && a<=m && b>0 && b<=n)
                hough_space(a,b,r) = hough_space(a,b,r)+1;
            end
        end
    end
end
 
% 寻找满足阈值的圆的参数
max_para = max(max(max(hough_space)));
index = find(hough_space>=max_para*p); % p:以p*hough_space的最大值为阈值，p取0，1之间的数
length = size(index,1);
hough_circle=zeros(m,n);
for i=1:cntPoints
    for k=1:length
        par3 = floor(index(k)/(m*n))+1;
        par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;
        par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;
        if((rows(i)-par1)^2+(cols(i)-par2)^2<(minR+(par3-1)*stepR)^2+5 && (rows(i)-par1)^2+(cols(i)-par2)^2>(minR+(par3-1)*stepR)^2-5)
            hough_circle(rows(i),cols(i)) = 1;% hough_circl:二值图像，检测到的圆
        end
    end
end
 
for k=1:length
    par3 = floor(index(k)/(m*n))+1;     
    par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;    % 圆心y坐标
    par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;      % 圆心x坐标
    par3 = minR+(par3-1)*stepR;                    % 圆的半径
    fprintf(1,'Center %d %d radius %d\n',par1,par2,par3);
    para(k,:) = [par1,par2,par3];% para:检测到的圆的圆心、半径
    plot(par2,par1,'x','LineWidth',5,'Color','red');%用红的的X对圆心位置进行标记
        
end


