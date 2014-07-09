#!/bin/bash

echo "TRAVIS_TAG: $TRAVIS_TAG"

if [[ -z "$TRAVIS_TAG" ]]
then
	echo "Setting up staging"
	mkdir unity_staging
	cd unity_staging

	mkdir openkit-unity
	mv ../.git/ openkit-unity/

	cd openkit-unity
	git reset --hard HEAD

	cd OpenKitUnityPlugin

	echo "Moving internal api to editor for execution"
	mv Assets/Editor/OpenKitInternal/* Assets/Editor/

	echo "Executing package builder!"
	/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -projectPath . -executeMethod OpenKitBuildMenu.ShowWindow -logFile ./unity.log

	echo "Output folder:"
	ls SDKPackages

	echo "Log:"
	cat ./unity.log

	exit 0
fi