#! /bin/bash

# To be run from the root directory of the module
# But will create directories outside, so watch out!

#export MODULE_REPO=git://github.com/webinowebinos-api-geolocation.git

# Fail if anything fails
set -e

export API_DIR=`pwd`
export TMP=~/tmp
export WEBINOS_PZP_DIR=$TMP/webinos-pzp
export TOOLS_DIR=$API_DIR/test/tools
export API_TEST_NAME=SpecRunner.html
export API_TEST_PATH=$API_DIR/test/jasmine/

# move to a temporary directory 
mkdir -p $TMP
cd $TMP
echo "Made directory $TMP " 

# Empty it, and check out the PZP
if [ -d "$WEBINOS_PZP_DIR" ]; then
  rm -rf $WEBINOS_PZP_DIR
fi

echo "Deleted directory $WEBINOS_PZP_DIR"

git clone https://github.com/webinos/webinos-pzp.git $WEBINOS_PZP_DIR
cd $WEBINOS_PZP_DIR

echo "Cloned the PZP into $WEBINOS_PZP_DIR " 

# install the PZP and save dependencies
npm install --save-dev
echo "Installed the PZP" 

# copy the module.  We'll assume it has been made.
cd node_modules
cp -r $API_DIR .

# start the PZP
cd ..
node ./webinos_pzp.js &

# wait 5 secs for it to start
sleep 5
echo "Started the PZP and waited" 

# Fix the test script to point to the PZP
mkdir $WEBINOS_PZP_DIR/test-tmp
cp $API_TEST_PATH/* $WEBINOS_PZP_DIR/test-tmp
echo "Copied the API tests"


# run the node test script
# note that we're in the webinos-pzp directory at the moment.
export CURR=`pwd`
node $TOOLS_DIR/zombie-test.js $CURR/test-tmp/AutomatedSpec.html

# Kill the PZP (dangerous!)
killall node



