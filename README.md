# ARO-COLA-FPFH

# About

# Installing

## Matlab Installation
ARO-COLA-FPFH requires the following libraries installed:
- Computer Vision Toolbox
- Image Processing Toolbox


Also, ARO-COLA-FPFH was tested with Matlab R2018b

Clone the repo to your local directory. To do this. Run the following command:
```shell script
git clone https://github.com/RedMerk/ARO-COLA-FPFH.git
```

Open the repo folder in Matlab, and compile the file assignmentoptimal.c running the command:
```shell Matlab
mex -largeArrayDims methods/COLA/assignmentoptimal.c -lut
```
For Windows users, we recommend using Microsoft Visual Studio 2017 with c++ compiler

# Running

A basic usage example is included in Main.m, for the Appartment, Wood Summer and Stairs datasets
