clc;
clear all
close all
imtool close all

rmax=20;
rmin=5;
T = 10;
findradiusdir = [-1,-1;-1,0;-1,1;0,1;1,1;1,0;1,-1];
[filename, pathname] = uigetfile('*','选择文件');
filepath=fullfile(pathname,filename);
img0=imread(filepath);
[row, col, channel] = size(img0);

if channel==3             %判断图像是否是彩色图像
    gray = rgb2gray(img0); % 图像灰度变换
else
    gray = img0;
end
cannyedge = double(edge(gray,'canny'));

filt = fspecial('sobel');
sobely = imfilter(cannyedge,filt);
sobelx = imfilter(cannyedge,filt');

%投票过程
immask = zeros(row, col);
for y=1:row
    for x=1:col
 
        if sobely(y,x) == 0 && sobelx(y,x)~=0
            dirx = sobelx(y,x)/abs(sobelx(y,x));
            diry = 0;
        elseif sobely(y,x) ~= 0 && sobelx(y,x)==0
            dirx = 0;
            diry = sobely(y,x)/abs(sobely(y,x));
        elseif sobely(y,x) == 0 && sobelx(y,x)==0
            continue
        else 
            dirx = sobelx(y,x)/abs(sobelx(y,x));
            diry = sobely(y,x)/abs(sobely(y,x));
            ratio = abs(sobely(y,x)/sobelx(y,x));
        end
        
        for i=rmin:rmax
            
            addx = i / sqrt(1+ratio*ratio);
            
            addy = diry * floor(addx * ratio);
            if y+addy<=0 || y+addy>row
                break
            end
            
            addx = dirx * floor(addx);
            if x+addx<=0 || x+addx>col
                break
            end
            
            immask(y+addy,x+addx) = immask(y+addy,x+addx) + 1;
        end
        
    end
end
filt = fspecial('average',3);
immask = imfilter(immask,filt);

imtool(immask,[])

%找出极值
centers = [];
rs=[];
for y=2:row-1
    for x=2:col-1
        if immask(y,x)>T
            neighbor = immask(y-1:y+1,x-1:x+1);
            if max(neighbor(:)) == immask(y,x)
                centers = [centers;y,x];
            end
        end
    end
end
rarray = zeros(rmax-rmin + 1,1);
thetastep = 0:0.2:2*pi;
pointnum = length(thetastep);
getradius = zeros(length(centers(:,1)),1);
%得到半径
for i=1:length(centers(:,1))
   
    maxpoint=0;
    for r=rmin:rmax
        getcircle=0;
        
        for theta=thetastep
            y = floor(centers(i,1)+r * sin(theta));
            if y<=0 || y>row
                break
            end
            
            x = floor(centers(i,2)+r * cos(theta));
            if x<=0 || x>col
                break
            end
            if floor(cannyedge(y,x))~=0
                getcircle = getcircle + 1;
            end
        end
        if getcircle > maxpoint
            getradius(i) = r;
            maxpoint = getcircle;
        end
    end
    
    
    
    
end
%画圆
thetastep = 0:0.01:2*pi;
for i=1:length(centers(:,1))
    img0(centers(i,1),centers(i,2),1)=255;
    img0(centers(i,1),centers(i,2),2)=0;
    img0(centers(i,1),centers(i,2),3)=0;
     for theta=thetastep
        y = floor(centers(i,1) + getradius(i) * sin(theta));
        if y<=0 || y>row
            break
        end

        x = floor(centers(i,2) + getradius(i) * cos(theta));
        if x<=0 || x>col
            break
        end
        img0(y,x,1)=255;
        img0(y,x,2)=0;
        img0(y,x,3)=0;

    end
end
imtool(img0,[])

