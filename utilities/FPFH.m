function [A_corr,B_corr] = FPFH(A_ply,B_ply)

%voxel_size = 0.5; %% appartment
%voxel_size = 0.5;
voxel_size = 0.1; %% 9 nov 2024 exp reales
%voxel_size = 0.05;
%voxel_size = 0.05*0.95;

cmd = 'bash -i ./methods/FPFH_py/run.sh';
fname = './methods/FPFH_py/FPFHData.json'; 

cmd = [cmd ' ' A_ply ' ' B_ply ' ' num2str(voxel_size)];

delete(fname)
system(cmd);

fname = './methods/FPFH_py/FPFHData.json';
fid = fopen(fname); 
raw = fread(fid,inf);
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

A_corr = val.Acorr;
B_corr = val.Bcorr;

ACloud = pointCloud(A_corr');
BCloud = pointCloud(B_corr');
end