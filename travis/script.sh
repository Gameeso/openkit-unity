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

	cd ..

	echo "Cloning iOS and Android SDK"
	git clone https://github.com/Gameeso/openkit-ios
	git clone https://github.com/Gameeso/openkit-android

	cd openkit-unity

	echo "Building native code"
	./build_native

	exit 0
fi