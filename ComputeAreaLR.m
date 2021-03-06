function similiarityLeftRight = ComputeAreaLR(P)
% This function computes the left and right area changes of the LV, and
% return their similiarity.

% SimiliarityLR = ComputeAreaLR(P)

% Input 
% P: the contour points with coordinates

% Output
% similiarityLeftRight: the ratio between the left area and the right

% By GUO Qiang 08/06/2016 at ENS

% Find the geometrical center of the heart
%center_x = mean(mean(P(:,1,:)));
%center_y = mean(mean(P(:,2,:)));

num = size(P);
n = num(3);
area_left = zeros(1,n);
area_right = zeros(1,n);

Coord = zeros(2, size(P,3));

for i=1:size(P,3)
    temp = sum(P(1:end-1,1,i).*P(2:end,2,i) - P(2:end,1,i).*P(1:end-1,2,i))/2;
    Coord(1,i) = sum((P(1:end-1,1,i)+P(2:end,1,i)).*(P(1:end-1,1,i).*P(2:end,2,i) - P(2:end,1,i).*P(1:end-1,2,i)))/6;
    Coord(1,i) = Coord(1,i)/temp;
    Coord(2,i) = sum((P(1:end-1,2,i)+P(2:end,2,i)).*(P(1:end-1,1,i).*P(2:end,2,i) - P(2:end,1,i).*P(1:end-1,2,i)))/6;
    Coord(2,i) = Coord(2,i)/temp;
    
    % Compute the area
    for j=1:num(1)-1
        temp1 = sqrt((P(j,1,i)-Coord(1,i))^2 + (P(j,2,i)-Coord(2,i))^2)*sqrt((P(j,1,i)-P(j+1,1,i))^2 + (P(j,2,i)-P(j+1,2,i))^2);
        temp2 = (P(j,1,i)-Coord(1,i))*(P(j,1,i)-P(j+1,1,i)) + (P(j,2,i)-Coord(2,i))*(P(j,2,i)-P(j+1,2,i));
        Sine = sqrt(1-(temp2/temp1)^2);
        if(P(j,1,i) < Coord(1,i))
            area_left(i) = area_left(i) + temp1*Sine/2;
        else
            area_right(i) = area_right(i) + temp1*Sine/2;
        end
    end

end

% Normalization of the volume
area_left = area_left/max(area_left);  
area_right = area_right/max(area_right); 

similiarityLeftRight = sum((area_left-area_right).^2)/size(area_left,2);
%SimiliarityLR = var(area_left)/var(area_right);

% area = area_right/2 + area_left/2;
% Show the results
% figure;
% plot(area_left, 'b'); 
% ylim([0, 1.1]);
% title('The change of area of the LV');
% xlabel('The timeline');
% ylabel('The normalized area');
% 
% hold on
% plot(area_right, 'r');
% legend('The left area change', 'The right area change');
% %plot(area, 'k');
% hold off




