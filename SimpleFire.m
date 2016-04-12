%% Cellular Automata Model for Forest Fire Spreading
%written by Emily Fairfax
%with guidance from Angela Shiftlet at http://nifty.stanford.edu/2007/shiflet-fire/
%April 10th, 2016

%% Initialize
%Create a World of Cells
sz = [300 300]; %size of the world to spread the fire in
world = zeros(sz(1),sz(2));%the world starts as all empty cells, value 0. No trees.

%Probabilities of transition between states
p = 1-10^-3;  % growth probability
f = 1-10^-5; % lightning probability
pburn = .5; %probability trees catch if neighbor is on fire
 
%States of Being
EMPTY   = 0; %if a cell is empty, assign value 0, color blue
TREE    = 1; %if a cell has a live tree, assign value 1, color green
BURNING = 2; %if a cell has a burning tree, assign value 2, color yellow


%% Run 
for i=1:2000
    
    %States and Transitions
    % new trees can grow in empty cells
    newgrowth = double(world==EMPTY).*double(rand(sz(1),sz(2))>p);
    
    %this is where to look in the array for various cells states
    tileworld = world([end 1:end 1], [end 1:end 1]);

    % 2d convolution, count the neighboring trees around each burning cell,
    % this part was confusing and I got help on it and do not 100%
    % understand it yet
    nconv = conv2(double(tileworld==BURNING),[1 1 1; 1 0 1; 1 1 1],'same');
    neighbors = nconv(2:end-1,2:end-1);
 
    % if a tree is burning, there is a defined probability that its
    % neighboring trees will burn too, neighboring empty cells cannot burn
    toburn = double(world==TREE).*double(neighbors > 0).*double(rand(sz(1),sz(2))>pburn);
     
    % even if a tree is not near a burning tree, there is a probability
    % that it gets hit by lightning and starts burning
    lightning = double(world==TREE).*double(rand(sz(1),sz(2))>f);
     
    % unaffected trees do not change state, trees that have burning
    % neighbors and do catch fire or trees struck by lightning get
    % reassigned as burning (value 2)
    trees = double(world==TREE)+double(toburn + lightning > 0);
 
    % the world is composed of trees (can be burning or alive) and empty cells 
    world = (newgrowth + trees);
    
    %Plotting
    % Show the World at this iteration in time
    imagesc(world); 
    % Colors ranging from 0 to 2
    caxis([0 2]);
    drawnow;
end