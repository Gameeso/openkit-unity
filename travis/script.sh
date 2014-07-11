#!/bin/bash

if [[ ! -z "$TRAVIS_TAG" ]]
then
	
	# Vars
	UNITY_PLUGINS_IOS_FOLDER="Assets/Plugins/iOS"
	GAMEESO_IOS_FOLDER="../../Downloads/OpenKitSDK_iOS"

	UNITY_PLUGINS_ANDROID_FOLDER="Assets/Plugins/Android"
	GAMEESO_ANDROID_FOLDER="../../Downloads/OpenKitSDK_Android"

	INCLUDES_FOLDER="$GAMEESO_IOS_FOLDER/include/"
	RESOURCES_FOLDER="$GAMEESO_IOS_FOLDER/Resources/"

	LIB_OPENKIT_UNITY_BUILD_PATH="$GAMEESO_IOS_FOLDER/libOpenKitUnity.a"
	LIB_OPENKIT_BUILD_PATH="$GAMEESO_IOS_FOLDER/libOpenKit.a"
	GIT_DIR=`pwd`

	function blue
	{
	  tput setaf 7; tput setab 4
	  echo "$1"
	  tput op
	}

	function red
	{
	  tput setaf 7; tput setab 1
	  echo "$1"
	  tput op
	}

	ERROR=0

	function check_error
	{
		if [ $? != 0 ]
		then
			red "There was an error with the previous command"
			ERROR=1
			exit 1
		fi
	}

	echo "GIT_DIR: $GIT_DIR"
	echo "Setting up staging"

	sudo mkdir /var/unity_staging
	sudo chmod 7777 /var/unity_staging
	cd /var/unity_staging

	mkdir openkit-unity
	cp -r "$GIT_DIR/.git/" openkit-unity/

	cd openkit-unity
	git reset --hard HEAD

	cd ..
	mkdir Downloads && cd Downloads
	echo "Downloading & unzipping native iOS and Android SDK"

	wget https://github.com/Gameeso/openkit-ios/releases/download/latest/Gameeso-iOS-SDK.zip
	unzip -o Gameeso-iOS-SDK.zip

	# So it wont collapse with android sdk
	mv OpenKitSDK OpenKitSDK_iOS

	wget https://github.com/Gameeso/openkit-android/releases/download/latest/Gameeso-Android-SDK.zip
	unzip -o Gameeso-Android-SDK.zip

	# So it wont collapse with android sdk
	mv OpenKitSDK OpenKitSDK_Android

	cd ..
	cd openkit-unity/OpenKitUnityPlugin

	blue "Deleting OpenKitSDK folder and copying over OpenKitSDK folder"
	rm -rf Assets/Plugins/Android/OpenKitSDK
	check_error
	cp -r -v $GAMEESO_ANDROID_FOLDER $UNITY_PLUGINS_ANDROID_FOLDER/OpenKitSDK
	check_error

	blue "Copying OpenKitUnity JAR"
	cp -v "$GAMEESO_ANDROID_FOLDER/../OpenKitUnity/bin/jars/openkit-unity-plugin.jar" $UNITY_PLUGINS_ANDROID_FOLDER/OpenKitSDK/libs
	check_error

	blue "Deleting include and resources folders"
	rm -rf Assets/Plugins/iOS/OpenKitResources/Resources
	rm -rf Assets/Plugins/iOS/OpenKitResources/include
	
	echo "Copying files"
	cp -r -v "$GAMEESO_IOS_FOLDER/include" "Assets/Plugins/iOS/OpenKitResources/include"

	blue "Copying libOpenKitUnity.a file"
	cp -v $LIB_OPENKIT_UNITY_BUILD_PATH $UNITY_PLUGINS_IOS_FOLDER

	blue "Copying libOpenKit.a to Unity project"
	cp -v $LIB_OPENKIT_BUILD_PATH $UNITY_PLUGINS_IOS_FOLDER

	blue "Deleting include and resources folders"
	rm -rf Assets/Plugins/iOS/OpenKitResources/Resources
	check_error
	rm -rf Assets/Plugins/iOS/OpenKitResources/include
	check_error

	blue "Copying include folder"
	cp -r -v $INCLUDES_FOLDER Assets/Plugins/iOS/OpenKitResources/include
	check_error

	blue "Copying Resources folder"
	cp -r -v $RESOURCES_FOLDER Assets/Plugins/iOS/OpenKitResources/Resources
	check_error

	echo "Packaging SDK"
	python "$GIT_DIR/travis/package_sdk.py"

	echo "Moving zip to build folder"
	mv Gameeso-Unity-SDK.zip "$GIT_DIR"
fi