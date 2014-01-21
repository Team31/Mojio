#!/usr/bin/env bash
source ~/.bash_profile

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
~/Documents/repo/xctool/xctool.sh -sdk iphonesimulator -project Mojio/Mojio.xcodeproj/ -scheme Mojio -reporter pretty -reporter junit:test-reports/junit-report.xml clean build test
