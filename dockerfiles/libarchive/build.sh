#!/bin/bash
set -x -e

. /work/llvm/env

cd libarchive
/bin/sh build/autogen.sh
./configure
make AM_DEFAULT_VERBOSITY=1 DEV_CFLAGS="-Wextra -Wunused -Wshadow -Wmissing-prototypes -Wcast-qual -g" -j

$CXX $CXXFLAGS -std=c++11 /workspace/libfuzzer-bot/dockerfiles/libarchive/libarchive_fuzzer.cc \
  /work/libfuzzer/*.o -Ilibarchive ./.libs/libarchive.a \
   -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc \
   -Wl,-Bstatic -lc++ -lc++abi \
   -o /out/libarchive_fuzzer
