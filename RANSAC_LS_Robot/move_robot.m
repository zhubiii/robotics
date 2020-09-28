function robot = move_robot( robot, x, y, theta, varargin )
%MOVE_ROBOT moves a robot that has already been created.  
%   robot = MOVE_ROBOT( robot, x, y, theta, ['position'] ) moves robot to
%   the given pose.  This is the default move type. 
%
%   robot = MOVE_ROBOT( robot, dx, dy, dtheta, 'displacement' ) applies a
%   displacement to the current robot pose
%   

% This deletes the graphics handles to the different patches
for i=1:6
    delete(robot.h(i));
end

% Checks if we're giving a displacement (deltas) vs. absolute position
if nargin==5 && strcmpi( varargin{1}, 'displacement' )
    robot = make_robot( robot.x+x, robot.y+y, robot.theta+theta, ...
        'size', robot.size, 'color', robot.color, 'make_trail', robot.trail);
else
    robot = make_robot( x, y, theta, 'size', robot.size, 'color', ...
        robot.color,'make_trail', robot.trail);
end