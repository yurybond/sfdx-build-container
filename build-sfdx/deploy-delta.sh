#!/bin/bash
IFS=$"
"

BRANCH_NAME="$1"

if [ $# -eq 0 ]; then
	BRANCH_NAME="master"
fi;
echo "This is a custom shell script that check difference betwen $BRANCH_NAME branch deploy this difference to the org where you are currently authorized with Force.com CLI"
echo "Prerequisites: Git installed, Force.com CLI installed"

FILES_CHANGED=$(git diff $BRANCH_NAME --name-only --diff-filter=AM src/)
LATEST_MASTER_MERGE=$(git --no-pager log --all --grep="Merged .* into ${BRANCH_NAME}" | grep -m 1 -owh "[0-9A-fa-f]*")

if [[ ${FILES_CHANGED} != *"src/"* ]]; then
	FILES_CHANGED="$(git diff $LATEST_MASTER_MERGE --name-only --diff-filter=AM src/)"
fi;

if [[ $FILES_CHANGED ]]; then
	echo "The following files will be deployed:"
	echo "$FILES_CHANGED"
else 
	echo "There is no difference between current branch and $BRANCH_NAME"
	exit 0
fi;

DEPLOY_COMMAND="force push "
for item in ${FILES_CHANGED}
do
#for files from aura component folder we are going to pull full component directory
	if [[ ${item} = *"src/aura/"* ]]; then
		AURA_COMPONENT_DIR=$(dirname "${item}")
		DEPLOY_COMMAND+=" -f "
		DEPLOY_COMMAND+="\"${AURA_COMPONENT_DIR}\""
	fi;
	
	if [[ ${item} = *"src/package.xml"* ]]; then
		echo "Ignore ${item}"
	else
		DEPLOY_COMMAND+=" -f "
		DEPLOY_COMMAND+="\"${item}\""
	fi;
done


eval $DEPLOY_COMMAND