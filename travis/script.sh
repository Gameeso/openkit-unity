#!/bin/bash

if [[ $TRAVIS_BRANCH == 'master' ]]
then
	echo "Setting up staging"
	mkdir unity_staging
	cd unity_staging

	alias unity='/Applications/Unity/Unity.app/Contents/MacOS/Unity'

	mkdir openkit-unity
	mv .git/ openkit-unity/

	cd openkit-unity
	git reset --hard HEAD

	cd OpenKitUnityPlugin

	echo "Moving internal api to editor for execution"
	mv Editor/OpenKitInternal/* Editor/

	echo "Executing package builder!"
	unity -quit -batchmode -projectPath . -executeMethod OpenKitBuildMenu.ShowWindow

	exit 0
fi