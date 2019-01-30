function [img_marked, corners] = hough_transform(input_image, binary_image, ii)

% Implement the Hough transform to detect the target A4 paper
% Input parameter:
% .    img - original input image
% .    (You can add other input parameters if you need. If you have added
% .    other input parameters, please state for what reasons in the PDF file)
% Output parameter:
% .    img_marked - image with marked sides and corners detected by Hough transform
% .    corners - the 4 corners of the target A4 paper
   
    theta = ((-90:89)./180) .* pi;
    D = sqrt(size(binary_image,1).^2 + size(binary_image,2).^2);
    HS = zeros(ceil(2.*D),numel(theta));
    [y,x] = find(binary_image);
    y = y - 1;
    x = x - 1;
%     figure
    rho = cell(1,numel(x));
    
    %% Calculating the Hough Transform
    for i = 1: numel(x)
        rho{i} = x(i).*cos(theta) + y(i).*sin(theta); % [-sqrt(2),sqrt(2)]*D rho interval
%         plot(theta,-rho{i})
%         hold on
    end
    
    %% Creating the Hough Space as an Image
    for i = 1:numel(x)
        rho{i} = rho{i} + D; % mapping rho from 0 to 2*sqrt(2)
        rho{i} = floor(rho{i}) + 1;
        for j = 1:numel(rho{i})
            HS(rho{i}(j),j) = HS(rho{i}(j),j) + 1; 
        end
    end
%     figure
%     imshow(HS)
    [distance, angle] = find(HS > 380);
    distance = distance - D;
    angle = angle - 90;
    
%     straightA = 0;
%     straightD = 0;
    if abs(max(angle)-min(angle)-180) <= 5
        straightA = angle(find(angle <= 3 & angle >= -3));
        straightD = distance(find(angle <= 3 & angle >= -3));
    else
        straightA = angle(find(angle <= 0));
        straightD = distance(find(angle <= 0)); 
    end
 
    y1 = 1;
    p1x = (straightD - y1*sind(straightA)) ./ cosd(straightA);
    y2 = size(binary_image, 1);
    p2x = (straightD - y2*sind(straightA)) ./ cosd(straightA);
    
%     right_straight_mask = find(p1x > size(binary_image, 1)/2);
    threshold = (max(p1x) + min(p1x))/2;
    right_straight_mask = find(p1x >= threshold);
    right_p1x = p1x(right_straight_mask);
    right_p2x = p2x(right_straight_mask);
    
    s_right_p1x = mean(right_p1x);
    s_right_p2x = mean(right_p2x);
        
%     left_straight_mask = find(p1x <= size(binary_image, 1)/2);
    left_straight_mask = find(p1x < threshold);
    left_p1x = p1x(left_straight_mask);
    left_p2x = p2x(left_straight_mask);
    
    s_left_p1x = mean(left_p1x);
    s_left_p2x = mean(left_p2x);
           
%     horizontalA = 0;
%     horizontalD = 0;
    if abs(max(angle)-min(angle)-180) <= 5
        horizontalA = angle(find(angle <= -86 | angle >= 86));
        horizontalD = distance(find(angle <= -86 | angle >= 86)); 
    else
        horizontalA = angle(find(angle > 0));
        horizontalD = distance(find(angle > 0)); 
    end
    
    x1 = 1;
    p1y = (horizontalD - x1*cosd(horizontalA)) ./ sind(horizontalA);
    x2 = size(binary_image, 2);
    p2y = (horizontalD - x2*cosd(horizontalA)) ./ sind(horizontalA);
    
    threshold = (max(p1y) + min(p1y))/2;
    upp_horizontal_mask = find(p1y >= threshold);
    upp_p1y = p1y(upp_horizontal_mask);
    upp_p2y = p2y(upp_horizontal_mask);
    
    s_upp_p1y = mean(upp_p1y);
    s_upp_p2y = mean(upp_p2y);
       
    low_horizontal_mask = find(p1y < threshold);
    low_p1y = p1y(low_horizontal_mask);
    low_p2y = p2y(low_horizontal_mask);
    
    s_low_p1y = mean(low_p1y);
    s_low_p2y = mean(low_p2y);
    
    % Bottom left corner
    [c0x, c0y] = polyxpoly([x1 x2],[s_upp_p1y s_upp_p2y], [s_left_p1x, s_left_p2x], [y1 y2]);
    % Bottom right corner
    [c1x, c1y] = polyxpoly([x1 x2],[s_upp_p1y s_upp_p2y], [s_right_p1x, s_right_p2x], [y1 y2]);
    % Top left corner
    [c2x, c2y] = polyxpoly([x1 x2],[s_low_p1y s_low_p2y], [s_left_p1x, s_left_p2x], [y1 y2]);
    % Top right corner
    [c3x, c3y] = polyxpoly([x1 x2],[s_low_p1y s_low_p2y], [s_right_p1x, s_right_p2x], [y1 y2]);
  
    corners = [[c0x, c0y]; [c1x, c1y]; [c2x, c2y]; [c3x, c3y]];
    
    imshow(input_image);  
    hold on;
    x = linspace(s_right_p1x,s_right_p2x,512);
    y = linspace(y1,y2,512);
    plot(x,y,'Color', [1, 0, 0]);   % Red line
    x = linspace(s_left_p1x,s_left_p2x,512);
    y = linspace(y1,y2,512);
    plot(x,y,'Color', [1, 0, 0]);   % Red line
    x = linspace(x1,x2,512);
    y = linspace(s_upp_p1y,s_upp_p2y,512);
    plot(x,y,'Color', [1, 0, 0]);   % Red line
    x = linspace(x1,x2,512);
    y = linspace(s_low_p1y,s_low_p2y,512);
    plot(x,y,'Color', [1, 0, 0]);   % Red line
    plot(c0x, c0y, 'ko');
    plot(c1x, c1y, 'ko');
    plot(c2x, c2y, 'ko');
    plot(c3x, c3y, 'ko');
        
%     saveas(gcf,['Assignment 2\Sample\result_imgs\hough_transform\', num2str(ii), '.jpg']);
%     close
    try
        img_marked = imread(['Assignment 2\Sample\result_imgs\hough_transform\', num2str(ii), '.JPG']);
    catch
        try
            img_marked = imread(['result_imgs\hough_transform\', num2str(ii), '.JPG']);
        catch
            disp 'Path does not correct'
        end
    end
%     imshow(input_image);  
%     hold on;
%     for idx = 1:length(right_p1x)
%         x = linspace(right_p1x(idx),right_p2x(idx),512);
%         y = linspace(y1,y2,512);
%         plot(x,y,'Color', [1, 0, 0]);   % Red line
%     end
%     for idx = 1:length(left_p1x)
%         x = linspace(left_p1x(idx),left_p2x(idx),512);
%         y = linspace(y1,y2,512);
%         plot(x,y,'Color', [1, 0, 0]);   % Red line
%     end
%     for idx = 1:length(upp_p1y)
%         x = linspace(x1,x2,512);
%         y = linspace(upp_p1y(idx),upp_p2y(idx),512);
%         plot(x,y,'Color', [1, 0, 0]);   % Red line
%     end
%     for idx = 1:length(low_p1y)
%         x = linspace(x1,x2,512);
%         y = linspace(low_p1y(idx),low_p2y(idx),512);
%         plot(x,y,'Color', [1, 0, 0]);   % Red line
%     end
        
    end