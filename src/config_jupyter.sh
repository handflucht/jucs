# Constants
SRC_DIR=$1
HOME=/home/condauser
BASH_RC=/home/condauser/.bashrc
PREFIX=/home/condauser/anaconda3

PY3PATH=$PREFIX/bin

# make anaconda's python default for our user
echo "
# added by Anaconda-Notebook
export PATH=\"$PY3PATH:\$PATH\"" >> $BASH_RC

# create profile to connect from outside
mkdir $HOME/.jupyter
cp $SRC_DIR/jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py

# copy example notebook
mkdir $HOME/jupyterbooks
cp -a $SRC_DIR/notebooks/* $HOME/jupyterbooks/
