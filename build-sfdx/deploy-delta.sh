#!/bin/bash
BRANCH_NAME="$1"
FILES_CHANGED=""
echo "This is a custom shell script that check difference betwen Release/Master branch deploy this difference to the org where you are currently authorized with Force.com CLI"
echo "Prerequisites: Git installed, Force.com CLI installed"
if [ $# -eq 0 ]; then
	FILES_CHANGED="$(git diff origin/Release/Master --name-only src/)"
else
	FILES_CHANGED="$(git diff origin/$BRANCH_NAME --name-only src/)"
fi;

IFS=$"
"
DEPLOY_COMMAND="force push "
for item in ${FILES_CHANGED}
do
	if [[ ${item} = *"src/destructiveChanges"* ]]; then
		echo "Ignore ${item}"
	else
		DEPLOY_COMMAND+=" -f "
		DEPLOY_COMMAND+="\"${item}\""
	fi;
done
echo "The following files will be deployed:"
echo $FILES_CHANGED

eval $DEPLOY_COMMAND