load('stretch.mat');
length = size(stretch, 1);
breadth = size(stretch, 2);
%Blur the top third and bottom third of the image
blur_fraction = 3;
%Experiment with any of the filters, whatever gives the best results
myfilter = fspecial('disk', 10);%fspecial('gaussian', [8, 8], 0.5);

%% Dividing the image into three portions
upperimage = stretch(1:(length/blur_fraction),:,:);
centralimage = stretch((length/blur_fraction):(2*(length/blur_fraction)),:,:);
lowerimage = stretch((2*(length/blur_fraction)):length,:,:);
%% Smoothening each dimension and joining to create the final

utempr = upperimage(:,:,1);
utempg = upperimage(:,:,2);
utempb = upperimage(:,:,3);

ltempr = lowerimage(:,:,1);
ltempg = lowerimage(:,:,2);
ltempb = lowerimage(:,:,3);

ltempr = imfilter(ltempr,myfilter,'replicate');
ltempg = imfilter(ltempg,myfilter,'replicate');
ltempb = imfilter(ltempb,myfilter,'replicate');

utempr = imfilter(utempr,myfilter,'replicate');
utempg = imfilter(utempg,myfilter,'replicate');
utempb = imfilter(utempb,myfilter,'replicate');

upperimage(:,:,1) = utempr;
upperimage(:,:,2) = utempg;
upperimage(:,:,3) = utempb;

lowerimage(:,:,1) = ltempr;
lowerimage(:,:,2) = ltempg;
lowerimage(:,:,3) = ltempb;

blurredimage = [upperimage;centralimage;lowerimage];
imshow(blurredimage);

%% Cleaning up 

clear lowerimage upperimage utempr utempg utempb ltempr ltempg ltempb ...
    centralimage stretch blur_fraction myfilter

