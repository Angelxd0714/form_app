#!/bin/bash

# Set the NDK version we want to use
NDK_VERSION="27.0.12077973"

# Update local.properties to use the correct NDK version
if [ -f "local.properties" ]; then
    # Remove any existing NDK path
    sed -i '/ndk.dir/d' local.properties
    # Add the correct NDK path
    echo "ndk.dir=$HOME/Android/Sdk/ndk/$NDK_VERSION" >> local.properties
else
    echo "ndk.dir=$HOME/Android/Sdk/ndk/$NDK_VERSION" > local.properties
fi

echo "Updated local.properties to use NDK version $NDK_VERSION"
