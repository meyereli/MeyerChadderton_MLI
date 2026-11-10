function [colmap] = generate_colours(data, indexValue, largest, smallest)

L = 10;             %number of datapoints
%data = length(data);
%L = size(data,1) + size(data,2);% create example data set with values ranging from 0 to 3.6
%L = 100;
%indexValue = 1;     % value for which to set a particular color
topColor = [1 0 0];
%topColor = [1 0.7 0.7];% color for maximum data value (red = [1 0 0])
indexColor = [1 1 1];       % color for indexed data value (white = [1 1 1])
%indexColor = [1 0.7 0.7];
bottomcolor = [[0.844444444444444,0.844444444444444,0.99]]; % use this for activity heat plots, color for minimum data value (blue = [0 0 1])0.996940740740741

%for black and white: 
% topColor = [0 0 0];
% indexColor = [0.8 0.8 0.8]; 
% bottomcolor = [1 1 1];

%bottomcolor = [1 0.7 0.7];
%bottomcolor = [1 1 1];
% Calculate where proportionally indexValue lies between minimum and
% maximum values

if ~exist ('largest')
    largest = max(max(data));
end 
if ~exist ('smallest')
    smallest = min(min(data));
end



index = L*abs(indexValue-smallest)/(largest-smallest);
% Create color map ranging from bottom color to index color
% Multipling number of points by 100 adds more resolution
customCMap1 = [linspace(bottomcolor(1),indexColor(1),100*index)',...
            linspace(bottomcolor(2),indexColor(2),100*index)',...
            linspace(bottomcolor(3),indexColor(3),100*index)'];
% Create color map ranging from index color to top color
% Multipling number of points by 100 adds more resolution
customCMap2 = [linspace(indexColor(1),topColor(1),100*(L-index))',...
            linspace(indexColor(2),topColor(2),100*(L-index))',...
            linspace(indexColor(3),topColor(3),100*(L-index))'];
colmap = [customCMap1;customCMap2];  % Combine colormaps
% colormap(customCMap)
% psudo = pcolor(data);
% colorbar