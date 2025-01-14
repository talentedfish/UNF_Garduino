% open this file in MATLAB with the image processing toolbox
% reads in images A and B uncropped
BeforeA = imread('1.jpeg');
BeforeB = imread('2.jpeg');

% rotates cropped and uncropped images 90 degrees
% RBeforeA and RBeforeB are rotated cropped images
% BA and BB are rotated uncropped images
RBeforeB = imrotate(BobRoss,-90,'bilinear');
RBeforeA = imrotate(BobRoss2,-90,'bilinear');
BA = imrotate(BeforeA,-90,'bilinear');
BB = imrotate(BeforeB,-90,'bilinear');

% converts RGB cropped and uncropped images A and B to HSV
% hsvA and hsvB are HSV rotated cropped images
% hsvBA and hsvBB are HSV rotated uncropped images
hsvA = rgb2hsv(RBeforeA);
hsvB = rgb2hsv(RBeforeB);
hsvBA = rgb2hsv(BA);
hsvBB = rgb2hsv(BB);

% uses setup function
% GreenPixelsA and GreenPixelsB are number of pixels in uncropped images
% GreenPixelsBA and GreenPixelsBB are number of pixels in cropped images
GreenPixelsA = setup(BeforeA);
GreenPixelsB = setup(BeforeB);
GreenPixelsBA = setup(BobRoss2);
GreenPixelsBB = setup(BobRoss);

% makes the output images
subplot(3,3,1); imshow(RBeforeA); title('Cropped Image A')
subplot(3,3,2); imshow(RBeforeB); title('Cropped Image B')
subplot(3,3,3); imshow(GreenPixelsA); title('A Green pixels')
subplot(3,3,4); imshow(GreenPixelsB); title('B Green pixels')
subplot(3,3,5); imshow(BA); title('Image A')
subplot(3,3,6); imshow(BB); title('Image B')
subplot(3,3,7); imshow(GreenPixelsBA); title('Cropped A Green Pixels')
subplot(3,3,8); imshow(GreenPixelsBB); title('Cropped B Green Pixels')

% output percentage change
fprintf("Uncropped from A to B: \n")
fprintf("%.f%% percent change\n",percentChange(GreenPixelsA, GreenPixelsB))
fprintf("Cropped from A to B: \n")
fprintf("%.f%% percent change\n",percentChange(GreenPixelsBA, GreenPixelsBB))
fprintf("Compare Error A between cropped and uncropped: \n");
fprintf("%.f%% percent change\n",percentChange(GreenPixelsA, GreenPixelsBA))
fprintf("Compare Error B between cropped and uncropped: \n");
fprintf("%.f%% percent change\n",percentChange(GreenPixelsB, GreenPixelsBB))

% divides the HSV image into its components: hue, saturation, and value
function [hueImage, saturation, valueImage] = divideImage(hsv)
    hueImage = hsv(:,:,1);
    saturation = hsv(:,:,2);
    valueImage = hsv(:,:,3);
end

% calculates number of green pixels in image
function GreenPixels = calculatePixels(hueImage, valueImage)
Subtract = hueImage > .177 & hueImage < .306 & valueImage < 0.177;
Total = hueImage > .177 & hueImage < .306 & valueImage < 0.806;
GreenPixels = Total - Subtract;
end

% calculates the percentage change of green pixels between image A and B
function Percentage = percentChange(GreenPixelsA, GreenPixelsB)
    plantArea1 = sum(GreenPixelsA(:));
    plantArea2 = sum(GreenPixelsB(:));
    fprintf("plantArea A: %.f\n", plantArea1);
    fprintf("plantArea B: %.f\n", plantArea2);
    Difference = plantArea2 - plantArea1;
    Percentage = (100 * (Difference / plantArea1));
end

% rotates, converts to HSV, divides components into variables, 
% uses function calculatePixels to calculate the pixels
function defineHSV = setup(image)
    Before = imrotate(image,-90,'bilinear');
    hsv = rgb2hsv(Before);
    [hueImage,saturation,valueImage] = divideImage(hsv);
    defineHSV = calculatePixels(hueImage, valueImage);
end

