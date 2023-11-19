# Build 7-zip cli for android

This project is based on [7-Zip](https://7-zip.org/download.html) 23.01 (2023-06-20) version. I add a build script and modify some code to make the command line tool can run on android. You can directly download the `.so` files or follow next steps to build your own lib.

> UnRAR has its own license, please pay attention. If you don't need unRAR, follow `Doc/readme.txt` to disable it.

## Build Your Own Lib

Please see the 7-Zip's `DOC/readme.txt` at first.

### Modify make script

1. 

Add the following at top of `CPP/7zip/Bundles/Alone2/makefile.gcc`. That's because shared library will only be generated if `DEF_FILE` is defined.

```makefile
DEF_FILE = 7zz # the name is free to set
```

You can also add other vars like:

```makefile
DISABLE_RAR_COMPRESS = 1
```

2. 

Delete all `-Werror` in `CPP/7zip/7zip_gcc.mak`.

3. 

At `CPP/7zip/7zip_gcc.mak`:152, delete `-lpthread` because [Cannot find -lpthread (google.com)](https://groups.google.com/g/android-ndk/c/b-_gpSUSaaM). After, it's like:

```makefile
LIB2 = -ldl
```

4.

At bottom of `CPP/7zip/7zip_gcc.mak`, add this:

```makefile
android-install:
	install $(O)/$(PROG)$(SHARED_EXT) $(Output)
```



### Write build script

Add build script at project root path.

```sh
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
```

 After all, run your build script and the output files are in `Output` path

### Use in Android

In your c++ code, use `Main2(int argc, char *argv[])` function to call 7-zip cli tool.