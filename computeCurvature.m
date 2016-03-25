function Q = computeCurvature(P, n)
% This function compute the curvature of the contour for each point of the
% contour. This may needs to be improved to get a better precision.

% Q = computeCurvature(P, n)
% Input&Output
% P: all the contours with their coordinate set
% n: the resample coefficient

% Q: curvature of all the contours

% By GUO Qiang 25/03/2016 at ENS


Q = zeros(size(P,1)*n, size(P,3));
% Compute the curvature
for i=1:size(P,3)
    dis=[0;cumsum(sqrt(sum((P(2:end,:,i)-P(1:end-1,:,i)).^2,2)))];
    K(:,1) = interp1(dis,P(:,1,i),linspace(0,dis(end),floor(size(P,1)*n)));
    K(:,2) = interp1(dis,P(:,2,i),linspace(0,dis(end),floor(size(P,1)*n)));
    dx = gradient(K(:,1));
    dy = gradient(K(:,2));
%      dx = gradient(P(:,1));
%      dy = gradient(P(:,2));
    Q(:,i) = gradient(atan2(dy,dx))./hypot(dx,dy);
end

% Show the results
figure;
for i=1:size(Q,2)
    plot(Q(:,i));
    ylim([min(min(Q))*1.2 max(max(Q))*1.2]);
    title(['Curvature of contour of time: ', num2str(i)]);
    pause(1);
end
