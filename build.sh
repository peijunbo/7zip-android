NDK=/Users/peijunbo/Library/Android/sdk/ndk/25.2.9519653

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
# export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Only choose one of these, depending on your device...
export TARGET=aarch64-linux-android
# export TARGET=armv7a-linux-androideabi
# export TARGET=i686-linux-android
# export TARGET=x86_64-linux-android
export API=21
arch=arm64-v8a
# arch=armeabi-v7a
# arch=x86
# arch=x86-64
export Output=$(pwd)/output/$arch
mkdir -p $Output
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld

# refers to https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=260329#c13
if [ "$TARGET" == "aarch64-linux-android" ]; then
    export MY_ARCH="-march=armv8-a+crc+crypto"
fi
cd CPP/7zip/Bundles/Alone2
make -j -f makefile.gcc clean
make -j -f makefile.gcc
make -j -f makefile.gcc android-install