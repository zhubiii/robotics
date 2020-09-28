# CSE298 - Homework 4

See attached writeup and starter code, as well as the example videos hosted here: 

1. https://youtu.be/VR6ZEHF3ovc
2. https://youtu.be/_PFS5SvlG2k

# writeup
1. See sampleTrial.jpg  
  
3a. I would say that the robot is neither performing better or worse than open loop odometry. By definition
open loop control takes no feedback into how it determines its control. Therefore it cannot be correcting its position or anything like that. The only thing this robot model is doing 
differently is that it is better able to know its actual position than if it were purely guessing, no EKF, with dead reckoning.  
  
3b. I was not able to get this part working but after observing the video it does seem like it converges but only when observing a certain amount of landmarks. 
This is actually expected beacause the more landmarks the robot observes, the better it can estimate its position therefore the covariance converges down. But as soon as 
it stops observing landmarks the covariance grows again. So I suppose in a graph vs time, in the end it won't converge unless it has ample landmakrs throughout the robot's path.  
  
3c. These occur when landmarks come into view. This is expected beacuse due to dead reckoning, the robots expected position is likely to be way off due to a variety of factors. But when landmarks come in then it better knows its position so it jumps to where the robot actually is.  
  
3d. I think the order that it checks does actually matter because if it checks all the cameras that are not detecting the robot first than it could slightly offput the measurement that the robot detects because the robot will keep moving but the measurement is the same. 
So if there are a lot of cameras to process, by the time it checks the "right" camera, the robot will be in a slightly different position which can throw off performance.
