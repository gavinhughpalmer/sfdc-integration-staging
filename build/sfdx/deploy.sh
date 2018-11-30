#!/bin/bash

check_only=$1
# if [ ! -z $1 ]; then
#     check_only=$1
# fi

echo "Converting to Metadata API format..."
sfdx force:source:convert --outputdir src

mdapi_deploy="sfdx force:mdapi:deploy --deploydir src/ --wait -1 --testlevel RunAllTestsInOrg"
if $check_only; then
    mdapi_deploy="${mdapi_deploy} --checkonly"
fi

echo "Deploying changes & running all tests..."
echo $mdapi_deploy
eval $mdapi_deploy

if ! $check_only; then
    echo "Running post deployment scripts..."
    sfdx force:apex:execute --apexcodefile PostDeploymentScripts.cls
fi