%Brian Zhu
%CSE 298 Foundations of Robotics
%Summer 2020
%FINAL EXAM: Implementing A*

%First we must choose a size for our adjacency matrix
%I will go with a 10x10 for simplicitys sake
%This means there exists 100 nodes:
%   64 of which will have all 8 edges
%   4 corners will have 3 edges
%   32 non-corner perimeter nodes will have 5 edges

num_row = 10;
num_col = 10;
total_nodes = num_row*num_col;

counter = 1;

%initializing our edge list for adjacency matrix
%There is no edge to a node to itself so we need the diagonal to be zeroes
x = 1:total_nodes;
y = 1:total_nodes; 
edges = ones(total_nodes,total_nodes);
edges(sub2ind(size(edges),x,y)) = 0;

%now lets set the correct edge values, 1 means there is an edge, 0 means
%there exists no edge
%Please see attatched images to see the logic for what is going on here
for node=1:total_nodes %represents each current node
    corner = false;
    non_corner_perimeter = false;
    for neighbor=1:total_nodes%represents the current nodes relationship to every other node
        %checking for corner nodes on grid
        %if it is a corner node we will set their edges accordingly(see
        %attatched image for neighbor determination)
        switch(node)
            case 1
                %corner1 '1'
                corner = true;
                if(neighbor==(node+1))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node+num_col))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node+num_col+1))
                    edges(node,neighbor) = 1;
                else
                    edges(node,neighbor) = 0;
                end
            case num_col
                %corner2 '10'
                corner = true;
                if(neighbor==(node-1))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node+num_col))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node+num_col-1))
                    edges(node,neighbor) = 1;
                else
                    edges(node,neighbor) = 0;
                end
            case (num_col*(num_row-1)+1)
                %corner3 '91'
                corner = true;
                if(neighbor==(node+1))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node-num_col))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node-num_col+1))
                    edges(node,neighbor) = 1;
                else
                    edges(node,neighbor) = 0;
                end
            case total_nodes
                %corner4 '100'
                corner = true;
                if(neighbor==(node-1))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node-num_col))
                    edges(node,neighbor) = 1;
                elseif(neighbor==(node-num_col-1))
                    edges(node,neighbor) = 1;
                else
                    edges(node,neighbor) = 0;
                end
        end
        
        if(~corner)
            if(mod((node-1),num_col)==0) %left side wall
                    non_corner_perimeter = true;
                    if(neighbor==(node-num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-num_col+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+1))
                        edges(node,neighbor) = 1;
                    else
                        edges(node,neighbor) = 0;
                    end
            elseif(mod(node,num_col)==0) %right side wall
                    non_corner_perimeter = true;
                    if(neighbor==(node-num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-num_col-1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col-1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-1))
                        edges(node,neighbor) = 1;
                    else
                        edges(node,neighbor) = 0;
                    end
            elseif(node<num_col) %bottom side wall
                    non_corner_perimeter = true;
                    if(neighbor==(node+num_col-1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+num_col+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-1))
                        edges(node,neighbor) = 1;
                    else
                        edges(node,neighbor) = 0;
                    end
            elseif(num_row^2<node && node<num_col^2)%top side wall
                    non_corner_perimeter = true;
                    if(neighbor==(node-num_col))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-num_col+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-num_col-1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node+1))
                        edges(node,neighbor) = 1;
                    elseif(neighbor==(node-1))
                        edges(node,neighbor) = 1;
                    else
                        edges(node,neighbor) = 0;
                    end
            end
        end
        
        %for middle nodes in the graph
        if(~corner&&~non_corner_perimeter)
            if(neighbor==(node-num_col))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node-num_col+1))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node-num_col-1))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node+1))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node-1))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node+num_col))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node+num_col-1))
                edges(node,neighbor) = 1;
            elseif(neighbor==(node+num_col+1))
                edges(node,neighbor) = 1;
            else
                edges(node,neighbor) = 0;
            end
        end
    end
end

    %so we have an easy way to map coordinate points to the name of the
    %node/cell
    for i=1:10
        for j=1:10
            nodes(i,j) = make_Node(i,j,counter);
            counter = counter+1;
        end
    end

%display(edges);
%====================================================================
%====================================================================
%Getting user input for start, goal, and obstacles
%this is inspired by the code written in reference.m but is NOT used
%in anyway to inform or aid with the actual
%implementation of the algorithm. Additionally how I use the output of this
%will be different to accomodate my "unique" way of solving
%this problem. Refer to citations section in README.md
x_val = -1;
y_val = -1;
axis([1 num_col+1 1 num_row+1])
grid on;
hold on;
num_obstacles=0;
pause(1);
xlabel('Please Select the Target using the Left Mouse button','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is clicked
    [xval,yval,but]=ginput(1);
end
xval=floor(xval);
yval=floor(yval);
xTarget=xval;%X Coordinate of the Target
yTarget=yval;%Y Coordinate of the Target

targetNode = nodes(yTarget,xTarget);%get the node that will be the target

plot(xTarget+.5,yTarget+.5,'gd');
text(xTarget+1,yTarget+.5,'Target')
pause(1);

xlabel('Select Obstacles using the Left Mouse button,to select the last obstacle use the Right button','Color','blue');
while but == 1
    [xval,yval,but] = ginput(1);
    xval=floor(xval);
    yval=floor(yval);
    obstacles(num_obstacles+1) = nodes(yval,xval);%Store nodes that will be obstacles
    plot(xval+.5,yval+.5,'rx');
    num_obstacles = num_obstacles+1;
end

pause(1);

xlabel('Please Select the Vehicle initial position ','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
xStart=xval;%Starting Position
yStart=yval;%Starting Position
startNode = nodes(yval,xval);
plot(xval+.5,yval+.5,'bo');
%====================================================================
%====================================================================
%Now that we have the inputs and nodes to the target,starting points, and
%obstacles, we have to change our adjacency matrix to reflect that


%we know the target node, we can assign h scores to every
%node using the euclidean distance forumula
%TODO: I know this is not a very efficient way to do this, will improve
for i=1:10
    for j=1:10
        %nodes(i,j).targetNode = targetNode;
        nodes(i,j).hscore = sqrt((targetNode.x-nodes(i,j).x)^2+(targetNode.y-nodes(i,j).y)^2);
        nodes(i,j).gscore = inf;
        nodes(i,j).parent = nodes(i,j);%another placeholder
        nodes(i,j).fscore = nodes(i,j).hscore; %this isn't correct but we dont have g-scores yet so it will be a placeholder for the first iteration of the algorithm
    end
end


%obstacles will have all of their row-cols be zero so there is no edge to them
for node=1:total_nodes
    for neighbor=1:total_nodes
        for k=1:length(obstacles)
            if(obstacles(k).id==node || obstacles(k).id==neighbor)
                edges(node,neighbor) = 0;
            end
        end
    end
end
startNode = nodes(yval,xval); %update startNode
startNode.gscore = 0;


G = digraph(edges);
A = adjacency(G); %returns a sparse matrix of all points that have edges
%============================================================
%============================================================
%at this point our adjacency matrix and nodes should all be configured
%properly so that we may begin the actual algorithm
found = false;

OPEN = []; %I could imagine that you'd probably use faster data structures
CLOSED = []; %such as hash maps or such to make searching more efficient....If i have time i will see if i can implement that

%first add starting node to OPEN set
OPEN = [OPEN startNode];

while ~found
    currentNode = OPEN(1);
    currentNodeidx = 1;
    for i=1:length(OPEN) %find lowest f-score
        if OPEN(i).fscore<=currentNode.fscore
            currentNode = OPEN(i);
            currentNodeidx = i;
        end
    end
    display(currentNode.id);
    %remove currentNode from OPEN set and move to CLOSED set
    OPEN(currentNodeidx) = [];
    CLOSED = [CLOSED currentNode];
    
    %terminating condition
    if (currentNode.id == targetNode.id)
        found = true;
        targetNode = currentNode;
        break;
    end
    
    %find neighbors of current node
    neighbors = []; %an array of vectors containing the indices of the neighbor in nodes[]
    for i=1:100
        if(A(currentNode.id,i)==1 || A(i,currentNode.id)==1)
            %They have an edge to eachother, therefore are neighbors
            %now we locate the node with id == i
            for j=1:10
                for k=1:10
                    if(nodes(j,k).id==i)
                        inClosed = false;
                        %need to check if neighbor is in the CLOSED set
                        %TODO clean this nested thing up
                        for l=1:length(CLOSED)
                            if (CLOSED(l).id == nodes(j,k).id)
                                inClosed = true;
                            end
                        end
                        
                        if ~inClosed
                            neighbors = [neighbors; [j k]];
                        end
                        
                        
                    end
                end
            end
        end
    end
    %Im so sorry  for that^

    %if the neighbor is not in OPEN, or if the path to the neighbor is
    %shorter than the existing one, set new costs and parents
    for i=1:length(neighbors(:,1))
        inOpen = false;
        isShorter = false;
        isDiagonal = true;
        %check if its in OPEN
        for j=1:length(OPEN)
            if (OPEN(j).id==nodes(neighbors(i,1),neighbors(i,2)).id)
                inOpen = true;
            end
        end
        
        
        ID = nodes(neighbors(i,1),neighbors(i,2)).id;
        %find out if its a diagonal or not
        %we can generalize this process and just check all 4 straights
        %because we have already narrowed it down to the neighbors so
        %we dont have to worry about cases where it would check-off for
        %a non-neighbor node
        if currentNode.id+num_col==ID %check NORTH
            isDiagonal = false;
        elseif currentNode.id-num_col==ID %check SOUTH
            isDiagonal = false;
        elseif currentNode.id-1==ID %check WEST
            isDiagonal = false;  
        elseif currentNode.id-num_col+1==ID %check EAST
            isDiagonal = false;
        end
            

        %check if new path to neighbor is shorter
        %if its a diagonal then we set the g-score to sqrt(2) else to 1
        if isDiagonal
            path2neighbor = currentNode.gscore + 2^.5;
        else
            path2neighbor = currentNode.gscore + 1;
        end
        
%         distX = abs(nodes(neighbors(i,1),neighbors(i,2)).x-currentNode.x);
%         distY = abs(nodes(neighbors(i,1),neighbors(i,2)).y-currentNode.y);
%         
%         if(distX<distY)
%             dist = sqrt(2)*distY + (distX-distY);
%         else
%             dist = 14*distX + (distY-distX);
%         end
% 
%         path2neighbor = currentNode.gscore + dist;

        if path2neighbor<nodes(neighbors(i,1),neighbors(i,2)).gscore
            isShorter = true;
        end
        
        if ~inOpen || isShorter
            nodes(neighbors(i,1),neighbors(i,2)).gscore = path2neighbor;
            nodes(neighbors(i,1),neighbors(i,2)).hscore = sqrt((targetNode.x-nodes(neighbors(i,1),neighbors(i,2)).x)^2+(targetNode.y-nodes(neighbors(i,1),neighbors(i,2)).y)^2);
            nodes(neighbors(i,1),neighbors(i,2)).fscore = nodes(neighbors(i,1),neighbors(i,2)).gscore + nodes(neighbors(i,1),neighbors(i,2)).hscore;
            
            %set the neighbors parent node to be the current
            nodes(neighbors(i,1),neighbors(i,2)).parent = currentNode;
               
            %if its not in OPEN then we add it to OPEN
            if ~inOpen
                OPEN = [OPEN nodes(neighbors(i,1),neighbors(i,2))];
            end
        end
        
    end
        
end

%at this point we have our path through the nodes parents
path = [];
currentNode = targetNode;
while currentNode.id~=startNode.id
    path = [path currentNode];
    currentNode = currentNode.parent;
end

%lets start from the end since that will give us the path from the
%beggining
h = plot(path(length(path)).y+.5,path(length(path)).x+.5,'bo');
pathPts = [];
for i=length(path):-1:1
    pause(.6);
    set(h,'XData',path(i).y+.5,'YData',path(i).x+.5);
    pathPts = [pathPts; [path(i).y+.5 path(i).x+.5]];
    drawnow;
end
plot(pathPts(:,1),pathPts(:,2));

for i=1:length(CLOSED)
    %plot(CLOSED(i).y+.5,CLOSED(i).x+.5,'r*');
    text(CLOSED(i).y+.5,CLOSED(i).x+.5,num2str(CLOSED(i).fscore),'Color','r','FontWeight','bold');
end

for i=1:length(OPEN)
    text(OPEN(i).y+.5,OPEN(i).x+.5,num2str(OPEN(i).fscore),'Color','g','FontWeight','bold');
end




