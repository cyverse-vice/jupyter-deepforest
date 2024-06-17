# jupyter-deepforest


This repository contains information to create a docker image for jupyterlab. The main python library that is installed is [DeepForest](https://deepforest.readthedocs.io/en/latest/). It has been created to utilize GPUs in Cyverse Discover Environment.

### Dockerfile

The docker image is based on the [jupyter/minimal-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook) image. It has python 3.11 installed and includes some command line tools like curl, git, and nano. 

`FROM quay.io/jupyter/minimal-notebook:lab-4.2.1`

### Build and Run Locally

`git clone git@github.com:cyverse-vice/jupyterlab-deepforest.git`

`cd jupyterlab-deepforest`

`docker build -t harbor.cyverse.org/vice/jupyter/deepforest:gpu-061424 .`

`docker run -it --rm --gpus=all -p 8888:8888 harbor.cyverse.org/vice/jupyter/deepforest:gpu-061424`

Open your browser and go to https://localhost:8888

### Push to Cyverse Harbor

`docker push harbor.cyverse.org/vice/jupyter/deepforest:gpu-061424`

### Create Cyverse DE Tool

Go to the Cyverse DE and go to 'Tools'



<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool.png" width=600>

<br/>

<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool2.png" width=200>

<br/>

Fill out the tool information as such

<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool3.png" width=400>

<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool4.png" width=400>

<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool5.png" width=400>

<br/>

Go to the 'Tools' under the Admin. You need admin privaledges for this to be visible. 

<img src="https://github.com/cyverse-vice/jupyterlab-minimal/blob/main/images/cyverse_tool6.png" width=400>

### Create a Cyverse App 

From the Tool you created, create an interactive Cyverse App

I created an app called 'JupyterLab Minimal GPU'

### How do I know if the GPU is Enabled?

After launching the Cyverse App, open a terminal in the jupyterlab and type:

`nvidia-smi -L`

The output should say the name of the GPU (e.g., NVIDIA GeForce RTX 2080)
