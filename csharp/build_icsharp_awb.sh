. /opt/mono/env.sh
# without mozroot http certificates nuget does not work
mozroots --import --sync
 
cd /home/condauser/icsharp 
mkdir /home/condauser/icsharp/packages 
mono ./.nuget/NuGet.exe restore ./iCSharp.sln 
xbuild ./iCSharp.sln /property:Configuration=Release /nologo /verbosity:normal
