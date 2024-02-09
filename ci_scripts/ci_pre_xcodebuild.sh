#!/bin/sh

#  ci_pre_xcodebuild.sh
#  DragToSpeak
#
#  Created by Gavin Henderson on 09/02/2024.
#  

echo "Stage: PRE-Xcode Build is activated .... "

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
#cd $CI_WORKSPACE/ci_scripts || exit 1

pwd

# Write a JSON File containing all the environment variables and secrets.
printf "{\"AZURE_USER_PASS\":\"%s\"}" "$AZURE_USER_PASS" >> ../secrets.json

echo "Wrote Secrets.json file."

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
