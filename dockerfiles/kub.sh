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

docker build $* -t gcr.io/meta-iterator-105109/jenkins jenkins/
docker build $* -t gcr.io/meta-iterator-105109/libfuzzer-slave libfuzzer-slave/
docker build $* -t gcr.io/meta-iterator-105109/docker-slave docker-slave/
docker build $* -t gcr.io/meta-iterator-105109/tpm2-slave tpm2-slave/
docker build $* -t gcr.io/meta-iterator-105109/freetype2-slave freetype2-slave/

gcloud docker push gcr.io/meta-iterator-105109/jenkins
gcloud docker push gcr.io/meta-iterator-105109/libfuzzer-slave
gcloud docker push gcr.io/meta-iterator-105109/tpm2-slave
gcloud docker push gcr.io/meta-iterator-105109/freetype2-slave
gcloud docker push gcr.io/meta-iterator-105109/docker-slave
