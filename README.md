# ICSharp Kernel notebook 
##(forked from Anaconda-Notebook, so includes also python3 kernel)

Goal: Run C# kernel in ipython/jupyter in a fresh docker image.

I assume docker is already installed and running.

To build the kernel:
```
git clone https://github.com/awb99/anaconda-notebook.git
docker build -t ic1 .  --no-cache=true
```

In case docker needs to be rebuild completely then run:
```
docker build -t ic1 .  --no-cache=true
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

```
docker run -i -t -p 8888:8888 -v \
<path to your ipython notebooks on host>:/home/condauser/notebooks rothnic/anaconda-notebook \
/home/condauser/anaconda3/bin/ipython notebook
```

