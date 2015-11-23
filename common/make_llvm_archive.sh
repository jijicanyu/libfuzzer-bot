#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
BUILD_DIR=/tmp/llvm-build
INSTALL_DIR=/tmp/llvm-inst

get_llvm() {
  (
  rm -rf $BUILD_DIR
  mkdir $BUILD_DIR
  cd $BUILD_DIR
  svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
  cd llvm
  R=$(svn info | grep Revision: | awk '{print $2}')
  (cd tools && svn co -r $R http://llvm.org/svn/llvm-project/cfe/trunk clang)
  (cd projects && svn co -r $R http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt)
  )
}

build_llvm() {
  (
  rm -rf $BUILD_DIR/build
  mkdir $BUILD_DIR/build
  cd $BUILD_DIR/build
  cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DCMAKE_BUILD_TYPE=Release -G Ninja ../llvm
  ninja check-all
  rm -rf $INSTALL_DIR
  ninja install
  )
}

pack_llvm() {
  tar zcf llvm-inst.tgz -C  /tmp llvm-inst  -v
  gsutil cp llvm-inst.tgz gs://libfuzzer-bot-binaries/llvm-prebuild
  rm llvm-inst.tgz
}

get_llvm
build_llvm
pack_llvm
rm -rf $BUILD_DIR $INSTALL_DIR

