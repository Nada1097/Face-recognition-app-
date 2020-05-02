
 
%function to load data of 40 folder of 40 person ...each person has 10
%images in all postion 
%argument : None
%return : img  matrix of type unit8 has places of all pixel for image 
 
function img = load_database()
persistent img_now; 
persistent permnant_img;
if(isempty(img_now)) %to check to upload ong image only at the time if it's empty  
    Images = zeros(10304,40); %create matrix of zeros by 112*92 the size of image for 40 folder
    %to loop in folders and in each folder and detect the image
    cd('Database');
    for i=1:40
        cd(strcat('s',num2str(i)));
        for j=1:10
            image_read = imread(strcat(num2str(j),'.pgm'));
            Images(:,(i-1)*10+j)=reshape(image_read,size(image_read,1)*size(image_read,2),1);
        end
        disp('Database');
        cd ..
    end
    cd ..
    permnant_img = uint8(Images); %convert images to unit8 type 
end
img_now = 1; 
img = permnant_img; %return img  