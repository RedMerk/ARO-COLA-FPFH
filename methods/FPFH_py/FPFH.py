import open3d as o3d
import teaserpp_python
import numpy as np 
import copy
import sys
import json
from json import JSONEncoder
from helpers import *

A_cloud_ply = sys.argv[1]
B_cloud_ply = sys.argv[2]

VOXEL_SIZE = float(sys.argv[3])
VISUALIZE = False

DOWNSAMPLE = True

class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)

# Load and visualize two point clouds from 3DMatch dataset
A_pcd_raw = o3d.io.read_point_cloud(sys.argv[1])
B_pcd_raw = o3d.io.read_point_cloud(sys.argv[2])
A_pcd_raw.paint_uniform_color([0.0, 0.0, 1.0]) # show A_pcd in blue
B_pcd_raw.paint_uniform_color([1.0, 0.0, 0.0]) # show B_pcd in red

# voxel downsample both clouds
if DOWNSAMPLE:
    A_pcd = A_pcd_raw.voxel_down_sample(voxel_size=VOXEL_SIZE)
    B_pcd = B_pcd_raw.voxel_down_sample(voxel_size=VOXEL_SIZE)
    A_xyz = pcd2xyz(A_pcd) # np array of size 3 by N
    B_xyz = pcd2xyz(B_pcd) # np array of size 3 by M
    if VISUALIZE:
        o3d.visualization.draw_geometries([A_pcd,B_pcd]) # plot downsampled A and B 
else:
    A_pcd = A_pcd_raw
    B_pcd = B_pcd_raw
    A_xyz = pcd2xyz(A_pcd_raw) # np array of size 3 by N
    B_xyz = pcd2xyz(B_pcd_raw) # np array of size 3 by M
    if VISUALIZE:
        o3d.visualization.draw_geometries([A_pcd_raw,B_pcd_raw]) # plot downsampled A and B 

# extract FPFH features
A_feats = extract_fpfh(A_pcd,VOXEL_SIZE)
B_feats = extract_fpfh(B_pcd,VOXEL_SIZE)

# establish correspondences by nearest neighbour search in feature space
corrs_A, corrs_B = find_correspondences(
    A_feats, B_feats, mutual_filter=True)
A_corr = A_xyz[:,corrs_A] # np array of size 3 by num_corrs
B_corr = B_xyz[:,corrs_B] # np array of size 3 by num_corrs

num_corrs = A_corr.shape[1]
print(f'FPFH generates {num_corrs} putative correspondences.')

# visualize the point clouds together with feature correspondences
points = np.concatenate((A_corr.T,B_corr.T),axis=0)
lines = []
for i in range(num_corrs):
    lines.append([i,i+num_corrs])
colors = [[0, 1, 0] for i in range(len(lines))] # lines are shown in green
line_set = o3d.geometry.LineSet(
    points=o3d.utility.Vector3dVector(points),
    lines=o3d.utility.Vector2iVector(lines),
)
line_set.colors = o3d.utility.Vector3dVector(colors)
if VISUALIZE:
     o3d.visualization.draw_geometries([A_pcd,B_pcd,line_set])

FPFHData = {"Afeats": A_feats, "Bfeats": B_feats, "Acorr": A_corr, "Bcorr": B_corr}
with open("./methods/FPFH_py/FPFHData.json", "w") as write_file:
    json.dump(FPFHData, write_file, cls=NumpyArrayEncoder)




