# Jupyter ICSharp Kernel - Docker image 
## forked from Anaconda-Notebook, so includes also python3 kernel

Goal: Run C# kernel in ipython/jupyter easily via a docker image.

I assume docker is already installed and running.

To build the docker image:  (ic1 is the name of the to be created docker image)
```
git clone https://github.com/awb99/jupyter-icsharp-docker.git
docker build -t ic1 . 
```

Run docker image (will start Jupyter/C# kernel)
/tmp/notebooks needs to be changed the path of the host machine into which notebooks will be saved

```
docker run -i -t -p 8888:8888 -v \
/tmp/notebooks:/home/condauser/notebooks ic1 \
/home/condauser/anaconda3/bin/ipython notebook --profile=icsharp --Session.key='' --Session.keyfile=''
```


# notes to develop the docker image more:

Run a terminal in the docker image (with CTRL D can exit)
```
docker run -t -i ic1 /bin/bash        
```

run ipython:  (change to the path where the notebooks are first)
```
ipython notebook --profile=icsharp --Session.key='' --Session.keyfile=''    
```

code is in /home/condauser

The docker image uses a forked version of scriptcs and of icsharp which was necessary so that it would compile/run with the latest mono+scriptcs version.

In case mono is not found the execute this script to set the environment variables
```
/opt/mono/env.sh
```


In case docker needs to be rebuild completely then run:
```
docker build -t ic1 .  --no-cache=true
```


