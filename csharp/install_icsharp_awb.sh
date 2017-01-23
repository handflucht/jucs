SRC_DIR=$1
cd /home/condauser/

echo "$SRC_DIR/icsharp"

if [ ! -d "$SRC_DIR/icsharp" ]
then
	echo "iicsharp-folder does not exist-> cloning"
	git clone --recursive https://github.com/awb99/icsharp.git icsharp
else
	echo "iicsharp-folder does exist-> move"
	mv $SRC_DIR/icsharp ./
fi

cd  icsharp
chmod +x ./build.sh


