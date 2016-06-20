#!/bin/bash
set -x -e

. /work/llvm/env

cd Little-CMS
./configure
make AM_DEFAULT_VERBOSITY=1 -j

fuzzers=(cmsIT8_load_fuzzer cms_open_profile_fuzzer)

for fuzzer in "${fuzzers[@]}"; do
  $CC $CFLAGS /workspace/libfuzzer-bot/dockerfiles/lcms2/$fuzzer.c \
    -I./include ./src/.libs/liblcms2.a \
    /work/libfuzzer/*.o -nodefaultlibs -Wl,-Bdynamic -lgcc_s -lgcc -lc \
    -lpthread -lm -ldl -lrt -Wl,-Bstatic -lc++ -lc++abi \
    -o /out/$fuzzer
done

