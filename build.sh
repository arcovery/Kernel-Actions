#!/bin/bash

# Clone Repo
echo
echo "Cloning mkdtimg repo"
echo
git clone https://github.com/ZeruxVayu/MKDTIMG.git mkdtimg
chmod +x mkdtimg/mkdtimg

echo
echo "Cloning Android Kernel Tools repo"
echo
git clone --depth=1 https://github.com/daoudeddy/clang.git
git clone --depth=1 https://github.com/daoudeddy/gcc.git

echo
echo "Cloning Kernel Repo"
echo
git clone --depth=1 https://github.com/AndroidGX/SimpleGX-P3-bluecross.git kernel

echo
echo "Setting up env"
echo

sudo apt install -y device-tree-compiler bc

mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=$PWD/clang/clang-4691093/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$PWD/gcc/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$PWD/gcc/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

echo
echo "Moving to kernel dir"
echo

cd kernel

echo
echo "Patching Files"
echo

git apply ../kernel.patch

cp ../b1c1-docker_defconfig arch/arm64/configs/
cp ../wireguard.tar ./

tar -xvf wireguard.tar

echo
echo "Clean Build Directory"
echo 

make clean && make mrproper

echo
echo "Issue Build Commands"
echo

mkdir -p out
df -h

echo
echo "Set DEFCONFIG"
echo 
make CC=clang O=out b1c1_defconfig

echo
echo "Build The Good Stuff"
echo 

make CC=clang O=out -j4
