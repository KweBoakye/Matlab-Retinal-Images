retina1 = imread('retina1.png'); %read in image
gr1 = rgb2gray(retina1); 
mono1= imread('monochrome1.png');
mono1= rgb2gray(mono1);
mono1 = imbinarize(mono1);
mono1 = imresize(mono1,[267 280]);

%Kirsch's operator, used to find maximu edge strength in each direction
g1=[5,5,5; -3,0,-3; -3,-3,-3];
g2=[5,5,-3; 5,0,-3; -3,-3,-3];
g3=[5,-3,-3; 5,0,-3; 5,-3,-3];
g4=[-3,-3,-3; 5,0,-3; 5,5,-3];
g5=[-3,-3,-3; -3,0,-3; 5,5,5];
g6=[-3,-3,-3; -3,0,5;-3,5,5];
g7=[-3,-3,5; -3,0,5;-3,-3,5];
g8=[-3,5,5; -3,0,5;-3,-3,-3];

fret1 = imfilter(retina1,g1,'replicate');% the image is filtered in each direction
fret2 = imfilter(retina1,g2,'replicate');
fret3 = imfilter(retina1,g3,'replicate');
fret4 = imfilter(retina1,g4,'replicate');
fret5 = imfilter(retina1,g5,'replicate');
fret6 = imfilter(retina1,g6,'replicate');
fret7 = imfilter(retina1,g7,'replicate');
fret8 = imfilter(retina1,g8,'replicate');

y1=max(fret1,fret2);
    y2=max(y1,fret3);
    y3=max(y2,fret4);
    y4=max(y3,fret5);
    y5=max(y4,fret6);
    y6=max(y5,fret7);
    y7=max(y6,fret8);

%y7 =fret1 +fret2 +fret3 +fret4 +fret5 +fret6 +fret7 +fret8 ;% the sum

lab_he = rgb2lab(y7); %convert from RGB  to CIE 1976 L*ab

nColors = 4; 
ab = lab_he(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',4);%k means clustering is used to create 4 colour clusters using the Eucilidean spaceMetric
pixel_labels = reshape(cluster_idx,nrows,ncols);% clusters added to array

segmented_images = cell(1,4);
rgb_label = repmat(pixel_labels,[1 1 3]);%repeat copies of rgb_label into 1-by-1-3 arrangement

for k = 1:nColors
    color = y7;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
% here  the  objects are seperated by colour

%next I attampt to extract the vessels 
mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value);
vessel_cluster_num = idx(1); % I have determined that the vessels have the smallest cluster_center value so I can programtically find it indes

L = lab_he(:,:,1);
vessel_idx = find(pixel_labels == vessel_cluster_num); %find the values that match the index
L_vessel = L(vessel_idx); %extract them from L
scaled = L_vessel - min(L_vessel);
scaled = scaled / max(scaled);
is_vessel = imbinarize(scaled);  % the brightness values are extrated scaled then truned into a binary image useing a global threshold



vessel_labels = repmat(uint8(0),[nrows ncols]); % declare an uint8 array
vessel_labels(vessel_idx(is_vessel==true)) = 1; % find where it matches the mask
vessel_labels = repmat(vessel_labels,[1 1 3]);

not_vessel_labels = repmat(uint8(0),[nrows ncols]);%finding wehre the vessels are not for later use as a filter
not_vessel_labels(vessel_idx(is_vessel==false)) = 1;
not_vessel_labels = repmat(not_vessel_labels,[1 1 3]);

vessel = y7; % the image that has been filtered using Kirsch Operator
vessel(vessel_labels ~= 1) = 0; %the values that do not match the find labels are made to equal 0

not_vessel = y7;
not_vessel((not_vessel_labels ~= 1)) = 0; 


vg = rgb2gray(vessel);% convert to grayscale
 not_vg = rgb2gray(not_vessel);


vf= imguidedfilter(vg,not_vg);% guided filter using where the vessels were found not to be using k-menas clustering
vgad = adapthisteq(vf);% use dapative histogram equalization



v = imbinarize(vgad,'adaptive'); % binarize the image using adaptive filtering

SE = strel('square',2);
vc = imerode(v ,SE); % using morphological operations to close gaps in the vessels

Z = imabsdiff(vc,mono1); % compare the images by subtracting the groundtruth from my result


figure

subplot(2,2,1)
imshow(vc)
title('vessels')

subplot(2,2,2)
imshow(mono1)
title('monochrome')

subplot(2,2,3)
imshow(Z)
title('comparison')

figure
subplot(2,2,1)
imshow(v), title('binary image from clustering');

subplot(2,2,2)
imshow(vg), title('vg');

subplot(2,2,3)
imshow(vgad), title('vgad');





figure
subplot(2,3,1)
imshow(pixel_labels,[]), title('image labeled by cluster index');

subplot(2,3,2)
imshow(segmented_images{1}), title('objects in cluster 1');

subplot(2,3,3)
imshow(segmented_images{2}), title('objects in cluster 2');

subplot(2,3,4)
imshow(segmented_images{3}), title('objects in cluster 3');

subplot(2,3,5)
imshow(segmented_images{4}), title('objects in cluster 4');



figure
subplot(3,3,1)
imshow(fret1)

subplot(3,3,2)
imshow(fret2)

subplot(3,3,3)
imshow(fret3)

subplot(3,3,4)
imshow(fret4)

subplot(3,3,5)
imshow(fret5)

subplot(3,3,6)
imshow(fret6)

subplot(3,3,7)
imshow(fret7)

subplot(3,3,8)
imshow(fret8)

subplot(3,3,9)
imshow(y7)
