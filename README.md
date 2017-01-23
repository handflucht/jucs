# jupyter ICSharp Kernel - Docker image
## forked from Jupyter ICSharp Kernel (https://github.com/awb99/jupyter-icsharp-docker)

Goal: Run C# kernel in ipython/jupyter easily via a docker image.

I assume docker is already installed and running.


# Build image
```
git clone https://github.com/handflucht/jupyter-icsharp-docker
cd jupyter-icsharp-docker/
docker build -t jupc_original .
```

# Run docker image (will start Jupyter/C# kernel)
```
docker run -i -t -p 8888:8888 jupc_bash jupyter notebook --Session.key="b''" 
```

# Run docker image and start kernel manual
For some reasons, the kernel crashes if you start it like the above line. if you start it from inside the container, it works:

Start container with bash
```
docker run -it --name jupc_bash -p 8888:8888 jupc_original /bin/bash
```

run in new bash (inside container:)
```
jupyter notebook --Session.key="b''"

```
# Notes

code is in /home/condauser

The docker image uses a forked version of scriptcs and of icsharp which was necessary so that it would compile/run with the latest mono+scriptcs version.

In case mono is not found the execute this script to set the environment variables
```
/opt/mono/env.sh
```


In case docker needs to be rebuild completely then run:
```
docker build -t ic1 . --no-cache=true
```

# notes on forks of scriptcs and icsharp

scriptcs:
* changed to common.logging 3.3
* changed one windows \\ path to Path combine in src/ScriptCs/Argument/ArgumentHandler.cs
* removed String.Format (for some reason, only string.Format is available on mono)
* added a testproject app that will test if 13+7 equals to 20; a very simple test app required to be sure the engine works

* Roslyn engine does not yet work on mono (it throws directory related exceptions)
README.md
