#!/bin/bash -eu
#
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

set -e -x

docker build $* -t libfuzzer/base base/
docker build $* -t libfuzzer/base-clang base-clang/
docker build $* -t libfuzzer/base-fuzzer base-fuzzer/

docker build $* -t libfuzzer/freetype2 freetype2/
docker build $* -t libfuzzer/openssl openssl/

#
# docker build $* -t libfuzzer/nss nss/
# docker build $* -t libfuzzer/libxml libxml/
# docker build $* -t libfuzzer/pcre2 pcre2/
# docker build $* -t libfuzzer/boringssl boringssl/
# docker build $* -t libfuzzer/jenkins jenkins/
# docker build $* -t libfuzzer/jenkins-slave jenkins-slave/
# docker build $* -t libfuzzer/libfuzzer-slave libfuzzer-slave/
