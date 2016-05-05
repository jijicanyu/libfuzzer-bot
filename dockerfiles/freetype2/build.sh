#!/bin/bash
set -e

. /work/llvm/env

cd /workspace/freetype2

./autogen.sh
./configure
make

$CXX $CXXFLAGS -std=c++11 ./src/tools/ftfuzzer/ftfuzzer.cc \
  ./objs/*.o /work/libfuzzer/*.o \
  -larchive -I./include -I. ./objs/.libs/libfreetype.a  \
   -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc \
   -Wl,-Bstatic -lc++ -lc++abi \
   -o /out/freetype2_fuzzer
