import sys
import os
from pathlib import Path
import re
import shutil
from xml.dom import minidom
from distutils.dir_util import copy_tree

arg_must_project_headers = ""
arg_must_project_sources = ""
arg_must_ndk_path = ""
arg_must_sdk_path = ""
arg_opt_build_type = "debug"
arg_opt_project_assets = ""
arg_opt_alternative_rde_path = ""
arg_opt_output_path = ""
arg_rde_android_path = str(Path(__file__).parent)
arg_opt_log_trace = " > /dev/null"
arg_opt_force_rebuild = False
arg_opt_app_name = "RDEAndroid_App"
arg_opt_package_name = "com.example.android"
arg_opt_app_icon = "ic_launcher_default"
arg_opt_app_version = "1.0.0.0"
arg_opt_app_orientation = "portrait"
arg_opt_clean = False
arg_opt_install_after_build = False
arg_opt_install_location = "internalOnly"
arg_opt_is_game = False
arg_opt_description = "No description."
arg_opt_app_category = "game"

def trace_to_string(trace):
    if " > /dev/null" in trace:
        return "error"
    elif " > /dev/null 2>&1" in trace:
        return "none"
    elif trace == "":
        return "full"

for arg in sys.argv:
    if "--trace" in arg:
        trace = arg.replace("--trace=", "")
        if trace == "none":
            arg_opt_log_trace = " > /dev/null 2>&1"
        elif trace == "error":
            arg_opt_log_trace = " > /dev/null"
        elif trace == "full":
            arg_opt_log_trace = ""
        else:
            print("ERROR: argument --trace must use an option between [none,full,error], the option will be ignored.")
    elif "--headers" in arg:
        arg_must_project_headers = arg.replace("--headers=", "")
    elif "--sources" in arg:
        arg_must_project_sources = arg.replace("--sources=", "")
    elif "--android_ndk" in arg:
        arg_must_ndk_path = arg.replace("--android_ndk=", "")
    elif "--android_sdk" in arg:
        arg_must_sdk_path = arg.replace("--android_sdk=", "")
    elif "--build_type" in arg:
        arg_opt_build_type = arg.replace("--build_type=", "").lower()
    elif "--output_path" in arg:
        arg_opt_output_path = arg.replace("--output_path=", "")
    elif "--rde_path" in arg:
        arg_opt_alternative_rde_path = arg.replace("--rde_path=", "")
    elif "--force_rebuild" in arg:
        arg_opt_force_rebuild = True
    elif "--assets" in arg:
        arg_opt_project_assets = arg.replace("--assets=", "")
    elif "--app_name" in arg:
        arg_opt_app_name = arg.replace("--app_name=", "")
    elif "--app_icon" in arg:
        arg_opt_app_icon = arg.replace("--app_icon=", "")
    elif "--app_version" in arg:
        arg_opt_app_version = arg.replace("--app_version=", "")
    elif "--app_orientation" in arg:
        arg_opt_app_orientation = arg.replace("--app_orientation=", "")
    elif "--clean" in arg:
        arg_opt_clean = True
    elif "--install" in arg:
        arg_opt_install_after_build = True
    elif "--app_category" in arg:
        arg_opt_app_category = arg.replace("--app_category=", "")
    elif "--device_install_location" in arg:
        arg_opt_install_location = arg.replace("--device_install_location=", "")
    elif "--description" in arg:
        arg_opt_description = arg.replace("--description=", "")
    elif arg == "-h" or arg == "--help" or arg == "help":
        print("The script builds the project for Android, the following parameters are a must to be provided:")
        print("     --headers=<path/to/your/headers>")
        print("     --sources=<path/to/your/sources>")
        print("     --android_ndk=<path/to/android/ndk>")
        print("     --android_sdk=<path/to/android/sdk>")
        print("")
        print("The script will assume that the project RDEAndroid is in the same root level as RDE project, if not, these arguments must be provided:")
        print("     --rde_path=<path/to/RDE>")
        print("IT IS RECOMENDED, to have both together.")
        print("")
        print("Other optional parameters are:")
        print("     --build_type=<release,debug> If not specified, it will be debug.")
        print("     --output_path=<path/to/export/apk> If not specified, it will be apk/build_type.")
        print("     --assets=<path/to/your/assets> This sets the assets to be included in the build.")
        print("     --trace=<none, error or full> This sets the level of logs during building.")
        print("     --force_rebuild Will rebuild all libraries if passed as parameter.")
        print("     --clean Will clean the project before compile.")
        print("     --install Will install the apk after compiling.")
        print("     --device_install_location=<internalOnly,auto,preferExternal> Whether to install the app inside the phone, on an external drive or let the phone choose. By default internalOnly")
        print("     --app_name=<name of your app> Sets the name of the app (RDEAndroid_App by default)")
        print("     --app_icon=<path/to/icon/folder> To create the icons I recomend using https://icon.kitchen/ which will create the folder we need! Rename the downloaded folder as the name of the icon")
        print("     --app_version=<1.0.0.0> Must be in the this format, 4 numbers separated by dots.")
        print("     --app_orientation=<portrait,reversePortrait,landscape,reverseLandscape> Any of the 4 versions can be added.")
        print("     --app_category=<accessibility,audio,game,image,maps,news,productivity,social,vide> Set the type of application.")
        print("     --description=<\"Your Description\"> App description readable for players.")

if arg_must_project_headers == "":
    print("ERROR: parameter --headers must be provided, pointing to your .h,.hpp files.")
    exit(-1)

if arg_must_project_sources == "":
    print("ERROR: parameter --sources must be provided, pointing to your .c,.cpp files.")
    exit(-1)

if arg_must_ndk_path == "":
    print("ERROR: parameter --android_ndk must be provided, pointing to the Android NDK folder.")
    exit(-1)

if arg_must_sdk_path == "":
    print("ERROR: parameter --android_sdk must be provided, pointing to the Android SDK folder.")
    exit(-1)

def result_log(res, log, allow = False):
    if res == 0:
        print("")
        print("--------------------------------------")
        print(log)
        print("--------------------------------------")
        print("")
    else:
        if not allow:
            exit(-1)

if arg_opt_alternative_rde_path == "":
    arg_opt_alternative_rde_path = str(Path(__file__).parent.parent) + "/RDE"

if arg_opt_output_path == "":
    arg_opt_output_path = "apk/" + arg_opt_build_type


print("")
print("----------------------------------------------------")
print("REMEMBER: cmake version should be 3.18.1, if yours is not go download that version from")
print("SDK Manager and then go to app/build.gradle, there in externalNativeBuild, inside cmake add ' version '3.18.1' '")
print("Compiling with options:")
print("     RDE_PATH:           ", arg_opt_alternative_rde_path)
print("     RDE_ANDROID_PATH:   ", arg_rde_android_path)
print("     BUILD_TYPE:         ", arg_opt_build_type)
print("     TRACE:              ", trace_to_string(arg_opt_log_trace))
print("     ASSETS_PATH:        ", arg_opt_project_assets)
print("     FORCE_REBUILD:      ", arg_opt_force_rebuild)
print("     HEADERS:            ", arg_must_project_headers)
print("     SOURCES:            ", arg_must_project_sources)
print("     ANDROID_NDK_PATH:   ", arg_must_ndk_path)
print("     OUTPUT_PATH:        ", arg_opt_output_path)
print("----------------------------------------------------")
print("")


print("")
print("------------------------ SDK SETUP ------------------------")
gradle_properties = ""
with open ('gradle.properties', 'r' ) as f:
    content = f.read()
    gradle_properties = re.sub(".*sdk.*dir.*", "sdk.dir=" + arg_must_sdk_path, content)

gradle=open('gradle.properties','w')
gradle.write(gradle_properties)
gradle.close()


gradle_properties = ""
with open ('local.properties', 'r' ) as f:
    content = f.read()
    gradle_properties = re.sub(".*sdk.*dir.*", "sdk.dir=" + arg_must_sdk_path, content)

gradle=open('local.properties','w')
gradle.write(gradle_properties)
gradle.close()


print("Set sdk.dir=\"" + arg_must_sdk_path + "\"")
print("-----------------------------------------------------------")
print("")



if arg_opt_clean:
    print("")
    print("---------------- CLEANING PROJECT ------------------")
    result = os.system('./gradlew clean' + arg_opt_log_trace )
    result_log(result, "Cleaned project correctly!")
    print("----------------------------------------------------")
    print("")

#Build basic libraries
if not os.path.exists(arg_rde_android_path + "/PrecompiledLibs-" + arg_opt_build_type) or arg_opt_force_rebuild:
    print("")
    print("---------------- COMPILING LIBS FOR " + arg_opt_build_type.upper() + " ------------------")
    result = os.system("cd sdl/jni && ./buildAndroidLibs.sh " + arg_rde_android_path + " " + arg_must_ndk_path + " " + arg_opt_build_type + " " + arg_opt_log_trace )
    result_log(result, "Libs compiled correclty!")
    result = os.system("mkdir -p precompiledLibs-" + arg_opt_build_type + " " + arg_opt_log_trace )
    result_log(result, "Created folder for Precompile Libs for " + arg_opt_build_type)
    result = os.system("cp -r sdl/build/intermediates/ndkBuild/" + arg_opt_build_type + "/lib precompiledLibs-" + arg_opt_build_type + " " + arg_opt_log_trace )
    result_log(result, "Copied contents to the folder correctly!")
    print("-----------------------------------------------------------------------------------------")
else:
    print("PrecompiledLibs found for build type " + arg_opt_build_type + ", skipping this building step")
print("")


print("")
print("--------------------- SETUP CMAKELIST VARIABLES ------------------------")
replaced_vars_CMakeLists = ""
with open ('CMakeLists.txt', 'r' ) as f:
    content = f.read()
#    replaced_vars_CMakeLists = re.sub(".*set.*APP_HEADERS.*", "set(APP_HEADERS " + arg_must_project_headers + ")", content)
#    replaced_vars_CMakeLists = re.sub(".*set.*APP_SOURCES.*", "set(APP_SOURCES " + arg_must_project_sources + ")", replaced_vars_CMakeLists)
    replaced_vars_CMakeLists = re.sub(".*set.*CMAKE_BUILD_TYPE.*", "set(CMAKE_BUILD_TYPE " + arg_opt_build_type + ")", replaced_vars_CMakeLists)
    replaced_vars_CMakeLists = re.sub(".*set.*RDE_PATH.*", "set(RDE_PATH " + arg_opt_alternative_rde_path + ")", replaced_vars_CMakeLists, 1)

cmake_lists=open('CMakeLists.txt','w')
cmake_lists.write(replaced_vars_CMakeLists)
cmake_lists.close()

print("set(APP_HEADERS " + arg_must_project_headers + ")")
print("set(APP_SOURCES " + arg_must_project_sources + ")")
print("set(CMAKE_BUILD_TYPE " + arg_opt_build_type + ")")
print("set(RDE_PATH " + arg_opt_alternative_rde_path + ")")

print("-----------------------------------------------------------------------")
print("")

# print("")
# print("-------------------- LINKING ASSETS --------------------")
# result = os.system("rm -r -f app/src/main/assets/*" + " " + arg_opt_log_trace )
# result_log(result, "Removed old assets")
# result = os.system("ln -s " + arg_opt_alternative_rde_path + "/defaultAssets app/src/main/assets/" + " " + arg_opt_log_trace )
# result_log(result, "Linked default assets")
# result = os.system("ln -s " + arg_opt_project_assets + "/ app/src/main/assets/" + " " + arg_opt_log_trace )
# result_log(result, "Linked project assets")
# print("--------------------------------------------------------")
# print("")



print("")
print("------------------- SETTING UP MANIFEST ----------------")
android_manifest = minidom.parse('app/src/main/AndroidManifest.xml')
strings = minidom.parse('app/src/main/res/values/strings.xml')

manifest = android_manifest.getElementsByTagName("manifest")[0]
application = android_manifest.getElementsByTagName("application")[0]
activity = android_manifest.getElementsByTagName("activity")[0]

string_values = strings.getElementsByTagName("string")
for value in string_values:
    if value.attributes["name"].value == "app_name":
        value.firstChild.data = arg_opt_app_name
        application.attributes["android:label"].value = "@string/" + value.attributes["name"].value
        print(value.toxml())
    elif value.attributes["name"].value == "app_description":
        value.firstChild.data = arg_opt_description
        application.attributes["android:description"].value = "@string/" + value.attributes["name"].value
        print(value.toxml())

with open('app/src/main/res/values/strings.xml', "w") as f:
    f.write(strings.toxml())



manifest.attributes["package"].value = arg_opt_package_name
manifest.attributes["android:versionName"].value = arg_opt_app_version
manifest.attributes["android:installLocation"].value = arg_opt_install_location

application.attributes["android:appCategory"].value = arg_opt_app_category

activity.attributes["android:screenOrientation"].value = arg_opt_app_orientation

dir_path = "app/src/main/res/mipmap-anydpi-v26"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

dir_path = "app/src/main/res/mipmap-hdpi"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

dir_path = "app/src/main/res/mipmap-mdpi"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

dir_path = "app/src/main/res/mipmap-xhdpi"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

dir_path = "app/src/main/res/mipmap-xxhdpi"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

dir_path = "app/src/main/res/mipmap-xxxhdpi"
if os.path.exists(dir_path) and os.path.isdir(dir_path):
    shutil.rmtree(dir_path)

copy_tree(arg_opt_app_icon + "/android/res", "app/src/main/res")
application.attributes["android:icon"].value = "@mipmap/" + os.path.basename(os.path.normpath(arg_opt_app_icon))


with open("app/src/main/AndroidManifest.xml", "w") as f:
    f.write(android_manifest.toxml())

print("Icon:                " + "@mipmap/" + os.path.basename(os.path.normpath(arg_opt_app_icon)))
print("Package:             " + arg_opt_package_name)
print("Version:             " + arg_opt_app_version)
print("Name:                " + arg_opt_app_name)
print("App Category:        " + arg_opt_app_category)
print("Install location:    " + arg_opt_install_location)
print("Description:         " + arg_opt_description)
print("Screen Orientation:  " + arg_opt_app_orientation)

print("--------------------------------------------------------")
print("")



print("")
print("------------------ BUILDING APP ------------------------")
print("Compiling, this will take a while...")
# result = os.system("mkdir -p apk" + " " + arg_opt_log_trace )
# result = os.system("mkdir -p apk/" + arg_opt_build_type + " " + arg_opt_log_trace )
result = os.system("gradlew assemble" + arg_opt_build_type.capitalize() + " --stacktrace --scan --debug")
result_log(result, "Building finishied correctly!")
print("--------------------------------------------------------")


print("")
print("------------------ MOVING APK TO OUTPUT -------------------")
result = os.system("mv app/build/outputs/apk/" + arg_opt_build_type + "/* "+ arg_opt_output_path + " " + arg_opt_log_trace )
result_log(result, "Saved APK to " + arg_opt_output_path)
print("-----------------------------------------------------------")

if arg_opt_install_after_build:
    print("")
    print("------------------ INSTALLING APK -------------------")
    for f in os.listdir(arg_rde_android_path + "/" + arg_opt_output_path):
        file_name, file_extension = os.path.splitext(f)
        if file_extension == ".apk":
            os.system("adb install " + arg_opt_output_path + "/" + file_name + ".apk")
            result_log(result, "Successfully Installed!")
    print("-----------------------------------------------------")
    print("")