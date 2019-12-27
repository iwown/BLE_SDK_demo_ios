#bin/bash

rm -rf ./iwown_blesdk_ios/AutumnTest/BLEMidAutumn.framework/*
cp -R ./Products/BLEMidAutumn.framework/* ./iwown_blesdk_ios/AutumnTest/BLEMidAutumn.framework/

echo 'finished cp framework'
