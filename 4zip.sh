#bin/bash

rm -rf iwown_blesdk_ios/Pods
rm -rf iwown_blesdk_ios_swift/Pods
zip -r zeroner_blesdk_iOS.zip AppleDocs Products iwown_blesdk_ios iwown_blesdk_ios_swift IVSleep_lib.zip README.md

echo "finish zip file" 
