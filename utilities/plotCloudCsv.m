%function points = plotCloudCsv(filename,subSampleRatio)

function points = plotCloudCsv(filename)
%
% Francois Pomerleau - ETH Zurich, Switzerland
%
% This function is plot a point cloud downloaded from
% the Laser Registration Datasets:
%
% http://projects.asl.ethz.ch/datasets/doku.php?id=laserregistration:laserregistration
%
% INPUTS:
% - filename: CSV file name of the point cloud to be ploted. It can be
%                   local point cloud (ex.: Hokuyo_0.csv) or global map (ex.:
%                   PointCloud0.csv).
% - subSampleRatio: Ratio of point to be removed (used for performance
%                               reasons)
%

% Load data
cloud = importdata(filename);

% Extract coordinates
x = cloud.data(:, strcmp('x', cloud.colheaders));
y = cloud.data(:, strcmp('y', cloud.colheaders));
z = cloud.data(:, strcmp('z', cloud.colheaders));

% Subsample
% f = rand(1, length(x));
% 
% x = x(f > subSampleRatio);
% y = y(f > subSampleRatio);
% z = z(f > subSampleRatio);

points = [x y z]';
% % Plot based on height
% % Scatter3 is too slow so we split manually to plot colors
% cmap = colormap;
% d = length(cmap);
% zLow = min(z);
% zDelta = (max(z)-min(z))/d;
% 
% figure
% hold on
% for i = 1:length(cmap)
%     filter = (z > zLow & z <= zLow+zDelta);
%     plot3(x(filter), y(filter), z(filter), '.', 'Color', cmap(i,:))
%     zLow = zLow+zDelta;
% end
% 
% xlabel('x (m)')
% ylabel('y (m)')
% zlabel('z (m)')
% axis equal
% grid on
% hold off
