%% Reading the image file
image = imread('scenery.jpg');

%% Projecting the image onto a cylinderical surface
projection = cylinder_projection(image, 252, 0, 0);

%% Isolating the projection alone

length = size(projection, 1);
breadth = size(projection, 2);

%% TODO Hack Setting the first and last column to null
projection(:,1,:) = 0;
projection(:,1024,:) = 0;

mid = length/2;
left_cood=1;
while projection(mid, left_cood, 1)==0 
    left_cood=left_cood+1;
end
right_cood=breadth;
while projection(mid, right_cood, 1)==0 
    right_cood=right_cood-1;
end

projection = projection(:,left_cood:right_cood,:);

%% Adding the left and right part of the flip to the final image
breadth = size(projection, 2);

leftprojection = projection(:,1:breadth/2,:);
rightprojection = projection(:,breadth/2:breadth,:);

%Flipping the rightprojection
breadth = size(rightprojection, 2);
for i=1:(breadth/2)
    temp = rightprojection(:,i,:);
    rightprojection(:,i,:) = rightprojection(:,breadth-i,:);
    rightprojection(:,breadth-i,:) = temp;
end

%TODO Get rid of the extra column pixel vector

%Flipping the leftprojection
breadth = size(leftprojection, 2);
for i=1:(breadth/2)
    temp = leftprojection(:,i,:);
    leftprojection(:,i,:) = leftprojection(:,breadth-i,:);
    leftprojection(:,breadth-i,:) = temp;
end

%% Adding left and right
%Adding the left and right projection to the image to get the final 360
% projection

projection = [leftprojection projection rightprojection];

%Getting rid of un necessary stuff from memory
clear image leftprojection rightprojection left_cood right_cood mid ...
    length breadth temp i;

%% Stretching the image to fill in the black spaces

projection = im2double(projection);
stretch_factor = 20;
length = size(projection, 1);
breadth = size(projection, 2);
%%
%Calculating the average pixels for the top half

for j=1:breadth
    for i=1:length/2
        if(projection(i,j,1)~=0)
            average = projection(i,j,:);
            for k=1:stretch_factor
                average = average+projection(i+k,j,:);
            end
            average = average/21;
            break;
        end
    end
    for i=1:length/2
        if(projection(i,j,1)== 0)
            projection(i,j,:) = average;               
        end
    end
end

%%
%Calculating the average pixels for the bottom half and averaging

for j=1:breadth
    for i=length:-1:(length/2)
        if(projection(i,j,1)~=0)
            average = projection(i,j,:);
            for k=1:stretch_factor
                average = average+projection(i-k,j,:);
            end
            average = average/21;
            break;
        end
    end
    for i=(length/2):(length)
        if(projection(i,j,1)== 0)
            projection(i,j,:) = average;               
        end
    end
end

stretch = projection;
clear projection;
%% blurring the image

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

