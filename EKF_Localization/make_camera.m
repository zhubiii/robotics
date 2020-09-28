function camera = make_camera(x,y,max_range,color)

camera.x = x;
camera.y = y;
camera.range = max_range;
camera.color = color;
camera.line = gobjects(0);

camera.X = [camera.x-1.5;camera.x;camera.x+1.5];
camera.Y = [camera.y;camera.y+3.5;camera.y];

camera.h = patch(camera.X,camera.Y,camera.color);