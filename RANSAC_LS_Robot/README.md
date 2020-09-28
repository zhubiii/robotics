# CSE 298 - Foundations of Robotics

See included assignment and starter code.

best parameters for LS_WF: kP=.1; kD=.4 (shown in the LS_WallFollower_result figure)
best parameters for RANSAC_WF: kP=.1; kD=.8 (shown in the RANSAC_WallFOllower_figure)

Additional Questions:

5. a To find n_max we use the equation .01>=(1-.75^s)^k  
Lets assume that the sample size stays around 13, Solving for this gives us k=190 minimum iterations to have a 99.9 percent chance of having the right line

1. ab. I found that gains where kP was significantly proportionally smaller than kD worked the best. And when kD was proportionally small to kP, it was the worst.
The numbers didnt so much matter as to the ratio. A great result I got was when kP=.1; and kD=1; This is likely due to the fact that kD, when small to kP, can not dominate the controller
function and is unable to tell the controller to change "slope" or direction. Often times the robot will just go in a circle continuously.refer to bad_gains.png  
  
c. When I set kP to zero I get a runtime error saying that the index exceeds the array alpha. I am not sure why this happens but I know that it
only happens after a few iterations and then alpha becomes null. So perhaps the angular velocity is being controlled by the derivative term so much that it has nothing to balance out with and it turns into values 
that can't be interpreted(or buggy code)? When kD is set to zero the robot will only spin in a circle. This is because there is no derivative term to correct for slope/new direction of the robot and it cant break out of the cycle.    

d. When I increased the initial error the controllers will sometimes not be able to find the correct course in time before the robot goes out of range of 10 meters. 
When kD is set too high proportionally to kP, it may not go in the direction of the wall fast enough and will go out of range. But also if the orientation is unlucky then it also may run into issues.  

e. I had drastically increase the controller kD to kP ratio because with the higher angular velocity it would sometimes overshoot how far it really should have turned and made the robot a little unwieldy. Although with the correct
gain it did seem to get to the settle point a little faster.


2. LS, when dialed in seemed to have a longer settle time and longer rise time. It didn't have bad overshoot, however, and the steady state error was also not bad. 
In contrast, using RANSAC I found that it had a much faster rise time, and settle time. However, i could not dial in the gains to where it would not overshoot(wheras on LS i had a few runs that had a nice shape) and it consistently
 had a noticeable steady state error. 

3. If the robot is staying further away from the wall than desired it means you need to correct for steady state error. You can do this by implementing a PID controller that will add an integral term to the function and reduce steady state error.