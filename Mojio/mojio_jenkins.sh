#!/usr/bin/env bash
source ~/.bash_profile

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -sdk iphonesimulator \
	   -workspace Mojio.xcodeproj/project.xcworkspace \
	   -scheme Mojio \
	   -configuration Debug test \
	   -RUN_APPLICATION_WITH_IOS_SIM=YES \
	   -ONLY_ACTIVE_ARCH=NO \
	   clean build 2>&1
