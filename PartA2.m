retina1 = imread('retina1.png');
gr1 = rgb2gray(retina1);

gr1_adapthisteq = adapthisteq(gr1);
gr1_adapthisteq2 = adapthisteq(gr1,'ClipLimit',0.05);
gr1_adapthisteq3 = adapthisteq(gr1,'ClipLimit',0.01);
gr1_adapthisteq4 = adapthisteq(gr1,'ClipLimit',0.02);
gr1_adapthisteq5 = adapthisteq(gr1,'ClipLimit',0.03);
gr1_adapthisteq6 = adapthisteq(gr1,'ClipLimit',0.04);



subplot(2,3,1)
imshow(gr1_adapthisteq)

subplot(2,3,2)
imshow(gr1_adapthisteq2)

subplot(2,3,3)
imshow(gr1_adapthisteq3)

subplot(2,3,4)
imshow(gr1_adapthisteq4)

subplot(2,3,5)
imshow(gr1_adapthisteq5)

subplot(2,3,6)
imshow(gr1_adapthisteq6)

