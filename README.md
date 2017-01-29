# Introduction
This project runs Jupyter with an IC#/ICSharp-kernel in a docker image.
The project forked from Jupyter ICSharp kernel (https://github.com/awb99/jupyter-icsharp-docker) but has been modified in many ways.

# Goal
Run Jupyter with a C#-kernel without any configuration needed.

# Docker operations
This chapter describes how to build and run the container in different ways.

## Build docker image
Prerequisites:
* Docker is already installed

Clone the repository start the docker build:
```
git clone https://github.com/handflucht/jucs
cd jucs/
docker build -t jucs .
```

## About the docker image
For those who are familiar with the `Dockerfile`-commands, here some information which are useful for understanding who to run the image:

```
USER condauser
ENV HOME=/home/condauser
ENV SHELL=/bin/bash
ENV USER=condauser
```

```
EXPOSE 8888
WORKDIR /home/condauser/jupyterbooks
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["jupyter notebook"]
```

### Run docker image (will start Jupyter with CSharp kernel)
```
docker run -itp 8888:8888 jucs 
```

### Run docker image with shell
```
docker run -itp 8888:8888 jucs /bin/bash
```

# Notes
If you need more information about this project, please read the following information:

* **Adding notebooks**
 You can store notebooks in `src/notebooks` before build. These books will automatically be added during build and will be accessible after running the container.

* **Changing Anaconda version**
 In `src/get_anaconda.sh` point the URL to the new location.

* **Changing ICSharp-kernel version**
 In `src/get_icsharp.sh` you can change the path to the repository which contains the data of the ICSharp-kernel. Just make sure the data is in a directory called `icsharp` after the checkout.

* **Speeding up build**
 You can place the `Anaconda`-installation-file at `src/Anaconda.sh` and the C#-kernel at `src/icsharp/`. If this file/directory exists while building, there are used and no data is downloaded. 
This is very helpful while testing custom modifications or running many builds for other reasons.

* **In case docker needs to be rebuild completely then run:**
 `docker build --no-cache=true -t jucs .`
