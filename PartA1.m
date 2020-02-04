retina1 = imread('retina1.png');



gr1 = rgb2gray(retina1);

gr1s = imsharpen(gr1);

gr1_imadjust = imadjust(gr1);
gr1_histeq = histeq(gr1);
gr1_adapthisteq = adapthisteq(gr1);
gr1_localcontrast = localcontrast(gr1);
gr1_imsharpen = imsharpen(gr1);


sgr1_imadjust = imadjust(gr1s);
sgr1_histeq = histeq(gr1s);
sgr1_adapthisteq = adapthisteq(gr1s);
sgr1_localcontrast = localcontrast(gr1s);

subplot(2,3,1)
imshow(gr1)

subplot(2,3,2)
imshow(gr1_imadjust)

subplot(2,3,3)
imshow(gr1_histeq)

subplot(2,3,4)
imshow(gr1_adapthisteq)

subplot(2,3,5)
imshow(gr1_localcontrast)

subplot(2,3,6)
imshow(gr1_imsharpen)

figure('Name','sharpen')

subplot(2,3,1)
imshow(gr1)

subplot(2,3,2)
imshow(sgr1_imadjust)

subplot(2,3,3)
imshow(sgr1_histeq)

subplot(2,3,4)
imshow(sgr1_adapthisteq)

subplot(2,3,5)
imshow(sgr1_localcontrast)

subplot(2,3,6)
imshow(gr1_imsharpen)

