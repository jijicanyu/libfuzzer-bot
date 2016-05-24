#!/bin/bash
set -e

. /work/llvm/env

cd /workspace/freetype2

./autogen.sh
./configure
make

$CXX $CXXFLAGS -std=c++11 ./src/tools/ftfuzzer/ftfuzzer.cc \
  ./objs/*.o /work/libfuzzer/*.o \
   -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc \
   -Wl,-Bstatic -lc++ -lc++abi \
   -larchive -I./include -I. ./objs/.libs/libfreetype.a  \
   -o /out/freetype2_fuzzer
