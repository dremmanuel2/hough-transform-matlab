function img_ruihua = laplacian_trans(img)
    i = 1;
    w = fspecial('log', [i i], 0.5);%生成高斯-拉普拉斯滤波器
    img_ruihua = filter1(img, w, i);