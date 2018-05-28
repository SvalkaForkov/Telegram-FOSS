#!/bin/bash

function build_one {
	mkdir build${CPU}
	cd build${CPU}

	echo "Configuring..."
	cmake -DANDROID_NATIVE_API_LEVEL=android-8 -DANDROID_ABI=${CPU} -DCMAKE_BUILD_TYPE=Release -DANDROID_NDK=${NDK} -DCMAKE_TOOLCHAIN_FILE=third_party/android-cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=16 -GNinja -DCMAKE_MAKE_PROGRAM=${NINJA_PATH} ..
	
	echo "Building..."
	cmake --build .
	
	cd ..
}

function checkPreRequisites {

    if ! [ -d "boringssl" ] || ! [ "$(ls -A boringssl)" ]; then
        echo -e "\033[31mFailed! Submodule 'boringssl' not found!\033[0m"
        echo -e "\033[31mTry to run: 'git submodule init && git submodule update'\033[0m"
        exit
    fi

    if [ -z "$NDK" -a "$NDK" == "" ]; then
        echo -e "\033[31mFailed! NDK is empty. Run 'export NDK=[PATH_TO_NDK]'\033[0m"
        exit
    fi
    
    if [ -z "$NINJA_PATH" -a "$NINJA_PATH" == "" ]; then
        echo -e "\033[31mFailed! NINJA_PATH is empty. Run 'export NINJA_PATH=[PATH_TO_NINJA]'\033[0m"
        exit
    fi
}

ANDROID_NDK=$NDK
checkPreRequisites

cd boringssl

CPU=armeabi-v7a
build_one

CPU=x86
build_one

CPU=armeabi
build_one

# arm64 would require api21+
