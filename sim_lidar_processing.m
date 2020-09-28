function [x y] = sim_lidar_processing( ranges )
%=========================================================================
% function [x y] = sim_lidar_processing( ranges )
% - The purpose of this function is to simulate LIDAR (laser range finder)
% processing.
% - Ranges is an m x n array where each of the n columns corresponds to a
% set of ranges measured by the LIDAR at angle theta.  Thus, since theta is
% defined below as -90:1:90, we know that num_rows = m = 181.  Each column
% is then a separate LIDAR scan. 
% - If the LIDAR scan does not receive a valid range, it will have a value
% of -1.  These values need to be caught, and the x-y coordinates set to
% (0,0).  Otherwise, the correct cartesian point needs to be generated
%=========================================================================

% Tells us the dimensions of ranges
[num_rows, num_cols] = size( ranges );

% Creates a vector of angles from -90 to 90 every 1 degree
theta = [1:num_rows]';

% Sets the initial x and y coordinates to 0.  This handles the case for
% when range == -1, but none of the other cases
x = zeros( size( ranges ) );
y = zeros( size( ranges ) );

%turn all -1s into 0 so when operated on still has x-y = (0,0)
ranges = max(ranges,0);

x = ranges.*(cos(theta.*pi/180));
y = ranges.*(sin(theta.*pi/180));
