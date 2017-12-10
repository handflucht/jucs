# Constants
SRC_DIR=$1
HOME=/home/condauser
Anaconda3=https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh

if [ ! -f $SRC_DIR/Anaconda.sh ];
then
	# Normal build will download Anaconda
	wget -q $Anaconda3 -O $HOME/Anaconda.sh
else
	# If you predownload Anaconda, or for testing the build it should be in /src, named Anaconda.sh
	cp $SRC_DIR/Anaconda.sh $HOME/Anaconda.sh
fi

chown condauser:condauser $HOME/Anaconda.sh
