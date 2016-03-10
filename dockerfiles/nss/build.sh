#!/bin/bash
set -e

mkdir -p /work/nss

cp -u -r /src/nss/* /work/nss/

cd /work/nss/nss/
make BUILD_OPT=1 USE_64=1 NSS_DISABLE_GTESTS=1 CC="$CC $CFLAGS" CXX="$CXX $CXXFLAGS" LD="$CC $CFLAGS" ZDEFS_FLAG= nss_build_all

mkdir -p /work/nss/include

# install libraries to /usr/lib and includes to /work/nss/include
cd /work/nss/dist
cp Linux*/lib/*.so /usr/lib
cp Linux*/lib/{*.chk,libcrmf.a} /usr/lib
cp -rL Linux*/include/* /work/nss/include
cp -rL {public,private}/nss/* /work/nss/include

# -Iinclude -L.libs -lxml2 -llzma \
$CXX $CXXFLAGS -std=c++11 /src/nss/asn1_bitstring_fuzzer.cc \
   -I/work/nss/include \
   -lnss3 -lnssutil3 -lnspr4 -lplc4 -lplds4 \
    $LIBFUZZER_OBJS \
   -o /work/nss/asn1_bitstring_fuzzer

export LD_LIBRARY_PATH=/work/nss/lib:$LD_LIBRARY_PATH

echo $(umask -S)
