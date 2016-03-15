docker run -i -t -p 8888:8888 -v \
./csharp_notebooks:/home/condauser/notebooks ic1 \
/home/condauser/anaconda3/bin/ipython notebook --profile=icsharp --Session.key='' --Session.keyfile=''
