#!/usr/bin/env bash

# Initialization
yellow=`tput setaf 3`
reset=`tput sgr0`
arrow='\033[33m▸\033[0m'

OUTPUT_FAT_LIBRARIES_PATH="Frameworks"

cd GVLProxy

#Clean up
rm -rf Frameworks/*
rm -rf PodsProject/Pods
rm -rf PodsProject/build
rm -rf PodsProject/Podfile.lock

cd PodsProject

# Install pods
printf -- "\n$arrow Installing \033[1mPods\033[0m..."

#add --repo-update
podinstallresult=$(pod install 2>&1)
if [ ! -f "Podfile.lock" ]; then
  printf "\n❌  $podinstallresult"
  exit
fi

printf -- " ✅\n"

# Build frameworks
printf -- "$arrow Building \033[1mpod frameworks\033[0m..."

xcodebuild -project Pods/Pods.xcodeproj -target GiniVision -configuration Release ENABLE_BITCODE=NO -sdk iphonesimulator &> /dev/null
xcodebuild -project Pods/Pods.xcodeproj -target GiniVision -configuration Release ENABLE_BITCODE=NO -sdk iphoneos &> /dev/null

printf -- " ✅\n"

# Create fat libraries
cd ..
printf -- "$arrow Creating \033[1mfat libraries\033[0m..."

BUILD_DIR="PodsProject/build"
BUILD_IPHONE_RELEASE_DIR="${BUILD_DIR}/Release-iphoneos"
BUILD_SIMULATOR_RELEASE_DIR="${BUILD_DIR}/Release-iphonesimulator"

for dir in $BUILD_IPHONE_RELEASE_DIR/*/
do
    dir=${dir%*/}
    frameworkFolder=${dir##*/}
    frameworkPath=( "$dir"/*.framework )
    frameworkName=$(basename $frameworkPath .framework)

    if [ "$frameworkFolder" == "$POD_NAME" ]; then
      FINAL_FRAMEWORK_NAME="$frameworkName"
    fi

    cp -R "$BUILD_IPHONE_RELEASE_DIR/$frameworkFolder/$frameworkName.framework" "${OUTPUT_FAT_LIBRARIES_PATH}"
    lipo -create "$BUILD_SIMULATOR_RELEASE_DIR/$frameworkFolder/$frameworkName.framework/$frameworkName" "$BUILD_IPHONE_RELEASE_DIR/$frameworkFolder/$frameworkName.framework/$frameworkName" -output "${OUTPUT_FAT_LIBRARIES_PATH}/$frameworkName.framework/$frameworkName"

    SIMULATOR_MODULES_FOLDER="$BUILD_SIMULATOR_RELEASE_DIR/$frameworkFolder/$frameworkName.framework/Modules"
    if [ -d "$SIMULATOR_MODULES_FOLDER/$frameworkName.swiftmodule" ]; then
      cp "$SIMULATOR_MODULES_FOLDER/$frameworkName.swiftmodule"/* "${OUTPUT_FAT_LIBRARIES_PATH}/$frameworkName.framework/Modules/$frameworkName.swiftmodule/"
    fi
done

printf -- " ✅\n"

printf -- "$arrow Building \033[1mproxy library\033[0m..."

xcodebuild -sdk iphonesimulator -project GVLProxy.xcodeproj -configuration Release &> /dev/null
xcodebuild -sdk iphoneos -project GVLProxy.xcodeproj -configuration Release &> /dev/null

cd build
rm -rf Release-fat
cp -R Release-iphoneos Release-fat
cp -R Release-iphonesimulator/GVLProxy.framework/Modules/GVLProxy.swiftmodule Release-fat/GVLProxy.framework/Modules/GVLProxy.swiftmodule
lipo -create -output Release-fat/GVLProxy.framework/GVLProxy Release-iphoneos/GVLProxy.framework/GVLProxy Release-iphonesimulator/GVLProxy.framework/GVLProxy

printf -- " ✅\n"

printf -- "$arrow Creating \033[1mbindings\033[0m..."

sharpie bind --sdk=iphoneos --output="XamarinApiDef" --namespace="Binding" --scope=Release-fat/GVLProxy.framework/Headers Release-fat/GVLProxy.framework/Headers/GVLProxy-Swift.h &> /dev/null

# Need to pamper the bindings:

# Remove this line
sed '/using GVLProxy;/d' ./XamarinApiDef/APIDefinitions.cs > ./XamarinApiDef/APIDefinitions.cs_new
mv ./XamarinApiDef/APIDefinitions.cs_new ./XamarinApiDef/APIDefinitions.cs

printf -- " ✅\n"

# Copy to Bindings
cd ..
cp build/XamarinApiDef/APIDefinitions.cs ../Bindings/APIDefinitions.cs

printf -- "$arrow Building \033[1mGiniVision.iOS.dll\033[0m..."

# Build Bindings project
cd ../Bindings
msbuild -t:Clean > /dev/null

# This will fail
msbuild > /dev/null

# Fix Xamarin pointlessly adding I to protocol names, but not everywhere.
sed 's/GVLProxyDelegate/IGVLProxyDelegate/g' ./obj/Debug/ios/GVLProxy.g.cs > ./obj/Debug/ios/GVLProxy.g.cs_new
mv ./obj/Debug/ios/GVLProxy.g.cs_new ./obj/Debug/ios/GVLProxy.g.cs

# This should succeed
msbuild > /dev/null

printf -- " ✅\n"

cp bin/Debug/GiniVision.iOS.dll ../../GVLXamarinFormsExample/GVLXamarinFormsExample.iOS/GiniVision.iOS.dll
