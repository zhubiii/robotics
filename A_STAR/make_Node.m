function Node = make_Node(x,y,id,varargin)
Node.x = x;
Node.y = y;
Node.id = id;

if nargin>3
    for i=4:2:nargin
        prop = varargin{i-3};
        val = varargin{i-2};
        if strcmpi( prop, 'isBlocked' )
            Node.isBlocked = val;
        elseif strcmpi( prop, 'gscore' )
            Node.gscore = val;
            gexists = true;
        elseif strcmpi( prop, 'targetNode' )
            Node.targetNode = val;
            hexists = true;
        elseif strcmpi( prop, 'parentNode' )
            Node.parentNode = val;   
        else
            error('Unrecognized argument for make_Node'); 
        end
    end
end


% if(Node.hexists&&Node.gexists)
%     Node.fscore = Node.hscore + Node.gscore;
% else
%     Node.fscore = -1;
% end