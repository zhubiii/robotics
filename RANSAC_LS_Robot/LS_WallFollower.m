function LS_WallFollower(kP,kD,y_wall)
x_LS = linspace(0,50,100);
dt = .5;
[x,y] = ginput(1);
theta = (pi/2)*rand()+(-pi/4);
hold on;
yline(y_wall,'b','LineWidth',3);
yline(y_wall-2.5,'y','LineWidth',2);
robot = make_robot(x,y,theta,'make_trail',true,'size',2);
r = DetectWall(robot,0,y_wall);
rHat = FireSonar(r);
[a_r,b_r] = LS_Line(rHat,robot.sonar);
[a_w,b_w] = Transform_Line(robot,a_r,b_r);
prev_e = sqrt((b_w-robot.y)^2) - 2.5;

for i=1:100
    r = DetectWall(robot,0,y_wall);
    rHat = FireSonar(r);
    [a_r,b_r] = LS_Line(rHat,robot.sonar);
    [a_w,b_w] = Transform_Line(robot,a_r,b_r);
    
    y_LS = b_w - a_w*x_LS;
    h = plot(x_LS,y_LS);
    
    e = sqrt((b_w-robot.y)^2) - 2.5;

    e_deriv = (e-prev_e)/dt;
    
    prev_e = e;

    omega = kP*e + kD*e_deriv;
    if(omega>.5)
        omega=.5;
    end

    new_x =robot.x +( -(.5/omega)*sin(robot.theta)+(.5/omega)*sin(robot.theta+omega*dt));
    new_y =robot.y + ((.5/omega)*cos(robot.theta)-(.5/omega)*cos(robot.theta+omega*dt));
    new_theta =robot.theta + omega*dt;

    robot = move_robot(robot,new_x,new_y,new_theta);
    pause(.0001);
    delete(h);
end
hold off;