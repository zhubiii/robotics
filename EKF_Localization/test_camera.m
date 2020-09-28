function [camera, bearing] = test_camera(camera,robot)
global SIGMA_BEARING;
distance = sqrt((robot.x - camera.x)^2 + (robot.y - camera.y)^2);
delete(camera.line);
if(distance<=camera.range)
    camera.line = plot([robot.x camera.x],[robot.y camera.y],'b');
    display(camera.line);
    camera.color = 'b';
    bearing = atan2(robot.y-camera.y, robot.x-camera.x);
    bearing = bearing + SIGMA_BEARING*randn();
else
    camera.color = [0.5 0.5 0.5];
    bearing = [];
end