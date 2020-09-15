# CSE 298 - Final Exam

Due by: 8/10 by end of day

## Ethics Contract

**FIRST**: Please read the following carefully:

-	I have not received, I have not given, nor will I give or receive, any assistance to another student taking this exam, including discussing the exam with students in another section of the course. Do not discuss the exam after you are finished until final grades are submitted.
- If I use any resource (including text books and online references and websites), I will cite them in my assignment.
- I will not ask question about how to debug my exam code on Piazza or any other platform.
-	I will not plagiarize someone else's work and turn it in as my own. If I use someone else's work in this exam, I will cite that work. Failure to cite work I used is plagiarism.
-	I understand that acts of academic dishonesty may be penalized to the full extent allowed by the Lehigh University Code of Conduct, including receiving a failing grade for the course. I recognize that I am responsible for understanding the provisions of the Lehigh University Code of Conduct as they relate to this academic exercise.

If you agree with the above, type your full name in the following space along with the date. Your exam **will not be graded** without this assent. When you are done, make your first commit with the commit message: "I, <your name>, agree to the ethics contract".

*** Write name and date below ***

Brian Zhu 8/8/20  

*** Write name and date above ***

-----------------------------------------------------------------------------------------------------

## Option 1: Implement FastSLAM

This option is an automatic A. All you have to do is implement the FastSLAM algorithm, a good summary of which is in the Probabilistic Robotics book on page 450. Homework 4 would be a good starting place for this. You can use the same bearing only cameras, or you can add the range in there if you want. It should work either way. You can also use the same robot model and the same noise model. Or you can just add Gaussian noise to everything. Either way, if you can get this algorithm working well, that's an A for you. Just submit the algorithm and a video or series of pictures showing it working. If you provide a series of still images, annotate them to show me what's going on in each one. If you provide a video, host it on youtube and give me a link. It's easy to [record your screen using zoom](https://support.zoom.us/hc/en-us/articles/201362473-Local-Recording). Either give me a voice annotation of what's going on, or write it out in this README with timestamps indicating what is happening.

## Option 2 (2 parts, equal weight)

For this option you'll have to do two problems.

### Part 1

First, Implement one of the following algorithms: 

- A* - Implement the A* algorithm in Matlab. The input to the algorithm can be an adjacency matrix, which is easy to implement in Matlab. The graph will represent a grid world, where each cell connects to its 8 neighbors, with `1` dist to the adjacent ones and `2^.5` distance to the diagonal ones. Represent obstacles by removing edges to neighboring cells. The input to the algorithm should be the start and goal cells. Make a figure that shows the start, goal, any obstacles, and the path found by the algorithm.

- Particle Filter - Implement a particle filter algorithm in Matlab. Homework 4 might be a good place to start with this one. You can keep the same cameras and the same bearing measurements, or you can also add in range. The robot model can be the same too. But instead of tracking a mean and covariance, you'll track a number of hypothetical robot particles. The spread of those robots will represent uncertainty, and you can take the mean of their positions as a guess for where they are. You can find a good particle filter algorithm on page 96 of the Probabilistic Robotics book. 

- Enhanced PID Wall Follower - Change the wall follower in Homework 3 as follows: 1) Handle a walls that are angled. 2) Make this a PID controller instead of just a PD controller. Demonstrate it working by having the robot follow a wall that changes direction. For example, the wall starts out horizontal, but then starts to become angled downward like this (X marks the robot, it wants to go to the right):

```
------------------\
                   \
    X->             \
                     \
                      \
```

- Trajectory Rollout - Implement the Trajectory Rollout algorithm described by [Gerkey and Konolige](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.330.2120&rep=rep1&type=pdf). Also described in [Lecture 8](https://www.youtube.com/watch?v=buEfiJftc0E&list=PL4A2v89SXU3SUUNrwKcE-yy2SX6YQOg_p&index=9&t=0s). Demonstrate this controller working in with the wall follower robot in Homework 3. You'll replace the PD controller with the Trajectory Rollout controller, and you can leave everything else the same.

**Once you are done implementing:**

Demonstrate the algorithm working with a video or a series of stills. If you provide a series of still images, annotate them to show me what's going on in each one. If you provide a video, host it on youtube and give me a link. It's easy to [record your screen using zoom](https://support.zoom.us/hc/en-us/articles/201362473-Local-Recording). Either give me a voice annotation of what's going on, or write it out in this README with timestamps indicating what is happening.

### Part 2

Choose one of the show-and-tell videos posted in our Slack channel. **You cannot choose the one you shared**. Based on what we learned in this course, form a hypothesis for how it works. Can you discern any sensors that are on the robot? What are they detecting? What sensors would this robot need theoretically to work? How does the robot use the info it collects from its sensors? How is the robot going from point A to point B? How does the robot know where it is? How is the robot avoiding obstacles? What do you observe about the robot's behavior leads you to your conclusions? What failure modes will the robot encounter (where won't the robot work?)

There are really no wrong or right answers here. I just want you to show me that you understand the architecture of robots we talked about in this class, and to see if you can apply that knowledge to a real-world example. You may be completely wrong, but that's not the point of this question.

Minimum: 200 words

# My work
## Video
https://youtu.be/VHNDjXfwkso  

## Part 2
I have decided to talk about the digit delivery humanoid robot by Ford, shared by Melody Su(Yuhan). Right off the bat you can see a very exposed lidar on top of the robots head. This gives a scan of the enviorment and likely allows the robot to see and map out its surroundings. The LIDAR probably scans everything from the car to the door (its destination). We saw with the lidar example used on campus sqaure, that the range is pretty good and atleast to a human eye, many objects could be detected such as trash cans, tables, and brick walls. Given the decent range of the LIDAR, and the fact that the delivery car in the video pulls up very close to the house, my guess is that when the robot initially gets out of the car it will scan all around using something akin to SLAM to map its surroundings. The car is probably a prominent landmark that the algorithm can use to localize the robot so that it always knows where it is in relation to the car. Then, with the use of computer vision machine learning, it can probably detect where the front door is from previous data. At this point it has mapped out its destination, it knows its starting point, and it has detected the nearby enviorment. With this information all you need is a global plan. I would guess that they use A* to map out a goal. This is because the robot clearly avoids the scooter laying down which I would guess it detected from its original lidar scans. A* then finds the shortest path around it to the door. In terms of control, it definitely has a lot more degrees of freedom than our 2d robot had so its hard to say what all the controls are. Perhaps some machine learning and a gyroscope allows it to stay upright while the fine motors that control the leg are what the feedback control is controlling. The video only gives a short snippet of it actually working so there is not a lot of correction seen or any indication of poorly set gains for whatever controller they are using. (probably because of what the boston dynamics guy said, for every success video theres a million fails). Some scenrios I could see this not working well is if the driveway is blocked and it cannot get close enough to the house originally to scan the door. Or, since this thing looks pretty futuristic, if in the future people had glass houses and glass scooters then the lidar would not be able to effectively detect it.

## Citations
I used this matlab tutorial https://www.mathworks.com/matlabcentral/fileexchange/26248-a-a-star-search-for-path-planning-tutorial for the sole reason of seeing how to implement a nice user input interface. I did NOT use/look at any of the actual matlab implementation of the algorithm. The code I directly referenced is in a matlab file called reference.m  
  
I also watched a few videos from Sebastian League, a youtuber who makes video games. He has a great visualization/explanation of A* https://youtu.be/-L-WgKMFuhE
