function RANSAC_WallFollower(kP,kD,y_wall)
x_RANSAC = linspace(0,50,100);
dt = .5;
[x,y] = ginput(1);
theta = (pi/2)*rand()+(-pi/4);
hold on;
yline(y_wall,'b','LineWidth',3);
yline(y_wall-2.5,'y','LineWidth',2);
robot = make_robot(x,y,theta,'make_trail',true,'size',2);
[X,Y] = DetectWallRANSAC(robot,0,y_wall);
data = FireSonarRANSAC(X,Y);
[a_r,b_r] = Wikipedia_RANSAC(data,2,190,10,.1);
%[a_w,b_w] = Transform_Line(robot,a_r,b_r);
prev_e = sqrt((b_r-robot.y)^2) - 2.5;

%%%%%%%%%FOR CALCULATING LINE OF LEAST SQUARED
x_LS = linspace(0,50,100);
for i=1:100
    [X,Y] = DetectWallRANSAC(robot,0,y_wall);
    data = FireSonarRANSAC(X,Y);
%     newdatax = [newdata(1,:),data(1,:)];  was trying to compound data
%     history but realized for ransac might not be good because iterations
%     increase with sample size for 99.9 percent
%     newdatay = [newdata(2,:),data(2,:)];
%     data = [newdatax; newdatay];


    %%%for plotting LS LINE
    r = DetectWall(robot,0,y_wall);
    rHat = FireSonar(r);
    [a_rLS,b_rLS] = LS_Line(rHat,robot.sonar);
    [a_wLS,b_wLS] = Transform_Line(robot,a_rLS,b_rLS);
    
    y_LS = b_wLS - a_wLS*x_LS;
    hLS = plot(x_LS,y_LS,'r-','LineWidth',3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    [a_r,b_r] = Wikipedia_RANSAC(data,2,190,10,.1);
    %[a_w,b_w] = Transform_Line(robot,a_r,b_r);
    
    y_RANSAC = b_r-a_r*x_RANSAC;
    h = plot(x_RANSAC,y_RANSAC,'g','LineWidth',3);
    
    e = sqrt((b_r-robot.y)^2) - 2.5;

    e_deriv = (e-prev_e)/dt;
    
    prev_e = e;

    omega = kP*e + kD*e_deriv;
    if(omega>.25)
        omega=.25;
    end

    new_x =robot.x +( -(.5/omega)*sin(robot.theta)+(.5/omega)*sin(robot.theta+omega*dt));
    new_y =robot.y + ((.5/omega)*cos(robot.theta)-(.5/omega)*cos(robot.theta+omega*dt));
    new_theta =robot.theta + omega*dt;

    robot = move_robot(robot,new_x,new_y,new_theta);
    pause(.1);
    if(i<=99)
        delete(h);
        delete(hLS);
    end
end
hold off;