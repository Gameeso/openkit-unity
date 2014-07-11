import zipfile
import sys
import os

def zip_folder(zip_file, folder_path):
    """Zip the contents of an entire folder (with that folder included
        in the archive). Empty subfolders will be included in the archive
        as well.
        """
    parent_folder = os.path.dirname(folder_path)
    # Retrieve the paths of the folder contents.
    contents = os.walk(folder_path)
    try:
        for root, folders, files in contents:
            # Include all subfolders, including empty ones.
            for folder_name in folders:
                absolute_path = os.path.join(root, folder_name)
                relative_path = absolute_path.replace(parent_folder + '\\',
                                                      '')
                print "Adding '%s' to archive." % absolute_path
                zip_file.write(absolute_path, relative_path)
            for file_name in files:
                absolute_path = os.path.join(root, file_name)
                relative_path = absolute_path.replace(parent_folder + '\\',
                                                      '')
                print "Adding '%s' to archive." % absolute_path
                zip_file.write(absolute_path, relative_path)
    except IOError, message:
        print message
        sys.exit(1)
    except OSError, message:
        print message
        sys.exit(1)
    except zipfile.BadZipfile, message:
        print message
        sys.exit(1)

print 'creating archive'
filename = 'Gameeso-Unity-SDK.zip'
zf = zipfile.ZipFile(filename, mode='w')
try:
    for f in ["Assets/Editor/OpenKitPostprocessBuildPlayer.cs",
            "Assets/Editor/OpenKitSettingsWindow.cs",
            "Assets/Examples/OKDemoScene.cs",
            "Assets/Examples/OKDemoScene.unity",
            "Assets/Plugins/Android/OpenKitSDK",
            "Assets/Plugins/iOS/libOpenKit.a",
            "Assets/Plugins/iOS/libOpenKitUnity.a",
            "Assets/Plugins/iOS/OpenKit_Vendor",
            "Assets/Plugins/iOS/OpenKitResources",
            "Assets/Plugins/OpenKit",
            "Assets/Plugins/RestSharp.dll",
            "Assets/Prefabs/OpenKitPrefab.prefab"]:
        print "Adding '%s' to archive." % f
        if os.path.isfile(f):
            zf.write(f)
        else:
            zip_folder(zf, f)
finally:
    zf.close()

print 'SDK has been built!'
