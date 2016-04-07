#!/bin/bash
set -e -x

docker build $* -t libfuzzer/base base/
docker build $* -t libfuzzer/base-clang base-clang/
docker build $* -t libfuzzer/base-fuzzer base-fuzzer/

docker build $* -t libfuzzer/nss nss/
docker build $* -t libfuzzer/libxml libxml/
docker build $* -t libfuzzer/pcre2 pcre2/
docker build $* -t libfuzzer/boringssl boringssl/
docker build $* -t libfuzzer/freetype2 freetype2/
docker build $* -t libfuzzer/jenkins jenkins/
docker build $* -t libfuzzer/jenkins-slave jenkins-slave/
docker build $* -t libfuzzer/libfuzzer-slave libfuzzer-slave/
