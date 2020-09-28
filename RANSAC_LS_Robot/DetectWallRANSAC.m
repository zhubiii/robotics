function [X,Y] = DetectWallRANSAC(robot,a_w,b_w)
%y1 = a_w*x + b_w; %equation of wall
counter = 1;


for i=1:length(robot.sonar)
    unit_y = sin(robot.sonar(i));
    unit_x = cos(robot.sonar(i));
    m = unit_y/unit_x; %slope of the laser
    
    %y2 = m*x + (-(m*robot.x) + robot.y); %equation of laser
    
    x_wall = (b_w - ((-m*robot.x) + robot.y))/(m-a_w); %coordinates of point of intersection between wall and laser
    y_wall = m*x_wall+((-m*robot.x) + robot.y);

    %check to see if the laser is the "correct one"
    real_dx = robot.x + unit_x; %taking a small step in the direction of the laser
    real_dy = robot.y + unit_y;
    real_dist = sqrt((x_wall-real_dx)^2+(y_wall-real_dy)^2); %finding the distance of the new point to the point on wall
    
    %potential alternate opposite laser
    alt_dx = robot.x + (-unit_x); %taking small step in opposite direction but still along the same LINE of the laser
    alt_dy = robot.y + (-unit_y);
    alt_dist = sqrt((x_wall-alt_dx)^2+(y_wall-alt_dy)^2);
    
    %if the distance of the step in the "real" direction" is greater than
    %the step of the "alternate" direction, then we know the laser is not
    %the right one
    correct_laser = true;
    if(real_dist>alt_dist)
        correct_laser = false;
    end
    
    
    
    %distance = sqrt((y_wall-robot.y)^2+(x_wall-robot.x)^2);
    distance =sqrt((y_wall-robot.y)^2 + (x_wall-robot.x)^2);
    %display(distance);
    if(correct_laser && distance<=10)
        X(counter) = x_wall;
        Y(counter) = y_wall;
        counter = counter + 1;
    end

end