#!/bin/bash


SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
# set me
if [ $# -ne 2 ]
then
    echo "Usage : deploy_sfdx.sh ScratchOrgAlias DevelopperHubAlias"
    exit 1
fi

SCRATCHORGALIAS=$1
DEVHUBALIAS=$2

echo "Creating a new ScratchOrg=$SCRATCHORGALIAS in the developper hub $DEVHUBALIAS"
sfdx force:org:create -s -f config/project-scratch-def.json -a $SCRATCHORGALIAS --durationdays 30
read -p "------------- Finished, type enter to continue "

echo "Pushing all source code to the org $SCRATCHORGALIAS" 
sfdx force:source:push --forceoverwrite -u $SCRATCHORGALIAS
read -p "------------- Finished, type enter to continue " 

echo "Generating password on $SCRATCHORGALIAS for default user"
sfdx force:user:password:generate
sfdx force:org:display
read -p "------------- Finished, type enter to continue " 

echo "Creating the Integration User on $SCRATCHORGALIAS"
sfdx force:user:create --setalias integration-user --targetusername $SCRATCHORGALIAS
sfdx force:user:password:generate -u integration-user
sfdx force:org:display


echo "Updating user permissions" 
for i in `ls force-app/main/default/permissionsets/`
do
    echo 'Treating Permission file : '$i
    permissionName=`echo $i | cut -d'.' -f1`
    echo permissionName=$permissionName
    sfdx force:user:permset:assign -n $permissionName -u $SCRATCHORGALIAS
    sfdx force:user:permset:assign -n $permissionName -u integration-user
done


read -p "------------- Finished, type enter to continue " 


sfdx force:org:open 


