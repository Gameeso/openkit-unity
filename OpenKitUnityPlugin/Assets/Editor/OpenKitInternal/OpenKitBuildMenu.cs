using System;
using UnityEditor;
using UnityEngine;
using OpenKit;

public class OpenKitBuildMenu : EditorWindow {

	[MenuItem("OpenKit/ExportPackage")]
	public static void ShowWindow()
	{
		string[] OpenKitAssetPaths = {
			"Assets/Editor/OpenKitPostprocessBuildPlayer.cs"
		};

		string SDKVersion = OKManager.OPENKIT_SDK_VERSION;

		string PackageName = "SDKPackages/Gameeso-Unity-SDK.unitypackage";

		AssetDatabase.ExportPackage(OpenKitAssetPaths,PackageName,ExportPackageOptions.Recurse | ExportPackageOptions.Interactive);

		Debug.Log ("Exported Gameeso Package");
	}

}
