
# 1) 
# git clone #... (all the repos...though you might not need them if they have an UP TO DATE release with the .xar there.)

# 2) 
# if not up to date, you need to download then build

curl -LO https://github.com/BetaMasaheft/DillmannData/releases/latest/download/dill-data.xar


# 3) 
BUILD_DIR=~/projects/Ethiopic-Dillmann/build
mkdir -p $BUILD_DIR
# all into the dir where 
mv *.xar $BUILD_DIR 
cp ~/projects/BetMas/xars/*.xar $BUILD_DIR 

# 4) 
docker-compose up -d
