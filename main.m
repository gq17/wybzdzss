
%% This is the main process of the project. Our alorithm runs on the video 
% of heart movement, and tracks its movement, looks for the features that
% reflect the condition of the heart.
clear all; close all;

%% Read the vidio, extract the frames/images
%heartVideo = VideoReader('../FETT4C.avi');
%heartVideo = VideoReader('../NOBECOURT3cvg.avi');
%heartVideo = VideoReader('../benis4c.avi');
heartVideo = VideoReader('../examples/abnormal/004.avi');
heartImg = heartVideo.read();
frames = heartVideo.NumberOfFrames;

%% Set the options of the algorithm
Options=struct;
Options.Verbose=true;
Options.Iterations=80;
Options.nPoints = 200;
Options.Wedge=2;
Options.Wline=0;
Options.Wterm=2;
Options.Kappa=4;
Options.Sigma1=8;
Options.Sigma2=8;
Options.Alpha=0.1;
Options.Beta=0.3;
Options.Mu=0.5;
Options.Delta=-0.1;
Options.GIterations=200;

%% Run the snakes algorithm
img = heartImg(:,:,:,1);
I=im2double(img);
figure, imshow(I);[y,x] = getpts; 
P=[x(:) y(:)];

% The contour must always be clockwise (because of the balloon force)
P=MakeContourClockwise2D(P);

% Make an uniform sampled contour description
P=InterpolateContourPoints2D(P,Options.nPoints);
Pcopy = P;

% Preallocate for acceleration
O = zeros(Options.nPoints, 2, frames);

% Run snakes
[O(:,:,1),J]=Snake2D(I,P,Options);
for x = 2:frames
    img = heartImg(:,:,:,x);
    I=im2double(img);
    %ImgDiff(:,:,x-1) = rgb2gray(I) - rgb2gray(im2double(heartImg(:,:,:,x-1)));
    [O(:,:,x),J]=Snake2D(I,P,Options);
    %P = O(:,:,x);
    %P = clockwiseSnake(P);
    P = ContourIte(Pcopy, O(:,:,x));
    % Linear resampling of the contour to avoid twist
    dis=[0;cumsum(sqrt(sum((P(2:end,:)-P(1:end-1,:)).^2,2)))];
    P(:,1) = interp1(dis,P(:,1),linspace(0,dis(end),floor(size(P,1))));
    P(:,2) = interp1(dis,P(:,2),linspace(0,dis(end),floor(size(P,1))));
end

%% Linear resampling of the contour
% n = 1;
% for i=1:size(O,3)
%     % Linear resampling to get more accurate result
%     dis=[0;cumsum(sqrt(sum((O(2:end,:,i)-O(1:end-1,:,i)).^2,2)))];
%     O(:,1,i) = interp1(dis,O(:,1,i),linspace(0,dis(end),floor(size(O,1)*n)));
%     O(:,2,i) = interp1(dis,O(:,2,i),linspace(0,dis(end),floor(size(O,1)*n)));
% end

%% Show the contour change of the LV
% w = waitforbuttonpress;
% figure;
% imshow(I,[]), hold on; 
% title('Contour movement ')
% drawnow;
% for i = 1:frames
%     c = i/frames;
%     plot([O(:,2,i);O(1,2,i)],[O(:,1,i);O(1,1,i)],'-','Color',[c 1-c 0]);  drawnow
%     pause(1);
% end

%% features extraction
% Potential choice: the area, curvature, distance, barycenter

% Compute the area of the left ventricle, record the change
w = waitforbuttonpress;
[Rat, Vol] = ComputeArea(O);

% FFT of area change
fftvol = fft(Vol);
figure;plot(abs(fftvol));
title('Frequence of the area change');

% Compute and show the curvature
w = waitforbuttonpress;
Curv = computeCurvature(O);
figure;
surf(Curv);

% % Compute the distance between points in LV.
% w = waitforbuttonpress;
% ffDistArray = ComputeDist(O);
% 
% % Compute the distance between points and the center in LV.
% w = waitforbuttonpress;
% [cDistArray, DistSum] = ComputeDistCentral(O);
% figure;
% plot(DistSum);
% title('The sum of distance change');
% 
% % Compute the distance between the left and right surface of the LV
% w = waitforbuttonpress;
% [DistList, EccenList] = ComputeDistLR(O);
% 
% % The motion of the barycenter
% w = waitforbuttonpress;
% MotionB = ComputeMotionBarycenter(O);

%% feature extraction 2
% % Compute the distance between points in one contour
% w = waitforbuttonpress;
% DistArrayP = ComputeDistPoints(O);
% 
% % Compute the perimeter of the contour
% w = waitforbuttonpress;
% Peri = sum(DistArrayP);
% figure;
% plot(Peri);
% title('The perimeter change');
% 
% % Compute the correlation of the distance between points and the center
% w = waitforbuttonpress;
% CorrArray = ComputeCorrelation(O);




% Analyses

% 
% % Curvature analyse
% CorrCurv = AnalsCurv(Curv);

% Distance analyse








