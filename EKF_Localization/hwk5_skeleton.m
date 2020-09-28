%===============================================================
function hwk5_skeleton
%===============================================================
% Note that it is considered bad practice to use global variables when
% programming.  Don't do this at home!!!
global V_ROBOT OMEGA_MAX DT_ODOM WHEELBASE SIGMA_WHEEL SIGMA_BEARING;

% Initialize the robot parameters
V_ROBOT=5;          % Robot velocity in m/s
DT_ODOM = 0.1;      % Update rate for odometry (10 Hz)    
OMEGA_MAX=pi/4;     % Angular velocity bound in radians/s 
WHEELBASE = 1.0;    % Wheelbase of the robot in meters
SIGMA_WHEEL = 0.1;  % This is the std dev of the wheel velocity in m/s

% Camera measurement parameters
SIGMA_BEARING = 3*pi/180;   % Std dev for bearing estimates in radians

% Set up the figure 
close all; figure; axis equal; axis([0 120 0 80]); hold on;

% Initial robot pose
x0 = 15;  y0 = 15;  theta0 = 0;

% This is the actual robot position.  The robot is green.
robot = make_robot( x0, y0, theta0, 'size', 1.5, 'color', 'g', 'make_trail', 1 );
% This is the position of the robot as estimated by your EKF.  It is redd
robot_hat = make_robot( x0+10*randn, y0+10*randn, theta0+pi/8*randn, 'size', 1.5, 'color', 'r', 'make_trail', 1 );
% Make the path for the robot to follow
rectangle( 'position', [15 15 90 50],'linestyle',':', 'edgecolor', 'k' );

% This is our initial Covariance estimate.  Note is is NOT correct.  You
% can play with this as you see fit based upon other parameters given. 
%P = [20 0;0 (pi/18)^2];
%P = [100 0; 0 100; 0 (pi/18)^2];
P = [100 0 0; 0 100 0; 0 0 (pi/18)^2];
num_cameras = 0;
button = 1;
while 1    
    % Gets a single mouse input from the user.  The corresponding x-y
    % position will be the location of the camera
    [ x, y, button ] = ginput(1);
    % If you hit the right mouse button, the loop will terminate
    if button==3, break; end
    num_cameras = num_cameras+1;
    % This is the position of the camera, the range it is capable of 
    % transmitting and the color it is initially set to.  
    camera(num_cameras) = make_camera( x, y, 20, [0.5 0.5 0.5] );
end

% This is just here for demonstration purposes showing how the robots will
% move.  You will need to comment out this loop, and comment in the while
% loop below where you will add the EKF code.  
% for i=1:50
%     robot = move_robot( robot, robot.x+cos(robot.theta), robot.y+sin(robot.theta), robot.theta+0.05*randn );
%     robot_hat = move_robot( robot_hat, robot_hat.x+cos(robot_hat.theta), robot_hat.y+sin(robot_hat.theta), robot_hat.theta+0.05*randn );
%     pause(0.5);
% end


%******************************************
% initial
%******************************************
newPosX = robot.x+cos(robot.theta);
newPosY = robot.y+sin(robot.theta);
newPosXhat = robot_hat.x+cos(robot_hat.theta);
newPosYhat = robot_hat.y+sin(robot_hat.theta);
initTheta = robot.theta;
initThetaHat = robot_hat.theta;
robot = move_robot( robot, newPosX, newPosY, robot.theta+0.01*randn );
robot_hat = move_robot( robot_hat, newPosXhat, newPosYhat, robot_hat.theta );
postTheta = robot.theta;
postThetaHat = robot_hat.theta;
robot.omega = postTheta-initTheta;
robot_hat.omega = postThetaHat-initThetaHat;
current_leg=1;
counter = 0;
while current_leg~=9
    % Measurement Update Phase

    for i=1:num_cameras
        % Each camera is tested to see if it can be seen by the robot.  
        % Visible cameras are set to green, and a line reflecting its
        % measured position as estimated by the robot is also plotted.  
        [ camera(i), bearing ] = test_camera( camera(i), robot );   
        if ~isempty( bearing )
            [ robot_hat, P ] = MeasurementUpdate( robot_hat, P, camera(i), bearing );
            delete(camera(i).h);
            camera(i).h = patch(camera(i).X,camera(i).Y,camera(i).color);
            
        else
            delete(camera(i).h);
            camera(i).h = patch(camera(i).X,camera(i).Y,camera(i).color);
        end
    end

    % Time Update Phase.  Note we do multiple time updates for each
    % measurement update because the update rate of the odometry is higher
    legV = 5;
    legOmega = pi/4;
    for j=1:1/DT_ODOM
        [ robot, robot_hat, P, new_leg, new_counter ] = TimeUpdate( robot, robot_hat, P, legV, legOmega, current_leg,counter );  
        current_leg = new_leg;
        counter = new_counter;
    end
    pause(0.1);

end

%==================================================================================
function [ robot, robot_hat, P, current_leg, counter ] = TimeUpdate( robot, robot_hat, P, v, omega, current_leg,counter )
%==================================================================================
global DT_ODOM WHEELBASE SIGMA_WHEEL;
%display(current_leg);
    
if((robot.x>=104.5&&robot.x<=105.5)&&(current_leg==1))
    current_leg = 2;
elseif((robot.y>=64.5&&robot.y<=65.5)&&(current_leg==3))
    current_leg = 4;
elseif((robot.x>=14.5&&robot.x<=15.5)&&(current_leg==5))
    current_leg = 6;
elseif((robot.y>=14.5&&robot.y<=15.5)&&(current_leg==7))
    current_leg = 8;
end
    
if(mod(current_leg,2)~=0)
     newPosX = robot.x+cos(robot.theta);
     newPosY = robot.y+sin(robot.theta);
%     if(((newPosX-robot.x)/DT_ODOM)>5)
%         newPosX = .5+robot.x;
%     elseif(((newPosY-robot.y)/DT_ODOM)>5)
%         newPosY = .5+robot.y;
%     end
%     
     newPosXhat = robot_hat.x+cos(robot_hat.theta);
     newPosYhat = robot_hat.y+sin(robot_hat.theta);
%     if(((newPosXhat-robot_hat.x)/DT_ODOM)>5)
%         newPosXhat = .5+robot_hat.x;
%     elseif(((newPosYhat-robot_hat.y)/DT_ODOM)>5)
%         newPosYhat = .5+robot_hat.y;
%     end
    robot = move_robot( robot, newPosX, newPosY, robot.theta+0.01*randn );
    robot_hat = move_robot( robot_hat, newPosXhat, newPosYhat, robot_hat.theta );
    %fprintf('FIRST CASE');
else
    %fprintf('SECOND CASE');

    robot = move_robot( robot, robot.x, robot.y, robot.theta+pi/4 );
    robot_hat = move_robot( robot_hat, robot_hat.x, robot_hat.y, robot_hat.theta+pi/4 );
    counter = counter + 1;
    if(counter==2) 
        switch current_leg
            case 2
                current_leg = 3;
            case 4
                current_leg = 5;
            case 6
                current_leg = 7;
            case 8
                current_leg = 9;
        end
        counter = 0;
    end
    
end


%==================================================================================
function [ robot_hat, P ] = MeasurementUpdate( robot_hat, P, camera, range )
%==================================================================================
global SIGMA_BEARING;
% bearing = range;%i dont understand the namespacing here because bearing is being passed into where range is
% range = sqrt((camera.x-robot_hat.x)^2+(camera.y-robot_hat.y)^2);
% 
% 
% 
% 
% 
% 
% omega = robot_hat.omega; 
% xUP = -(5/omega)*cos(robot_hat.theta)+(5/omega)*cos(robot_hat.theta+omega); %Doesn't robot_hat always have angular velocity of zero since it isnt affected by noise?
% yUP = -(5/omega)*sin(robot_hat.theta)+(5/omega)*sin(robot_hat.theta+omega);% I dont understand how these equations work given this
% G_t = [1 0 xUP; 0 1 yUP; 0 0 1];
% 
% V_t = [(-sin(robot_hat.theta)+sin(robot_hat.theta+omega))/omega ((5*(sin(robot_hat.theta)-sin(robot_hat.theta+omega))/omega^2) + ((5*cos(robot_hat.theta+omega))/omega));
%         (cos(robot_hat.theta)-cos(robot_hat.theta+omega))/omega -((5*(cos(robot_hat.theta)-cos(robot_hat.theta+omega))/omega^2) + ((5*sin(robot_hat.theta+omega))/omega));
%         0 1];
% 
% alpha = [.1 .1 .1 .1];   
% Q_t = [(alpha(1)*5^2 + alpha(2)*omega^2) 0;
%        0 (alpha(3)*5^2 + alpha(4)*omega^2)];
%    
% P = (G_t*P)*G_t' + (V_t*Q_t)*V_t';
% 
% h = plot_cov([robot_hat.x robot_hat.y],P);
