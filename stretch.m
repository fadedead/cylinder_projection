%% Stretching the image to fill in the black spaces
%TODO remove this
load('projection.mat');
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

