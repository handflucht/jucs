SRC_DIR=$1
cd /home/condauser/
 
# Try to get the icsharp-folder from the src-folder. 
# If it doesn't exists, the repository gets cloned
if [ ! -d "$SRC_DIR/icsharp" ]
then
	echo "icsharp-folder does not exist -> cloning"
	git clone --recursive https://github.com/handflucht/icsharp.git icsharp
else
	echo "icsharp-folder does exist -> move"
	mv $SRC_DIR/icsharp ./
fi

cd  icsharp
chmod +x ./build.sh 
