# Workspace should contain directories:
# - libfuzzer-bot (checkout of https://github.com/google/libfuzzer-bot/)
# - libarchive (checkout of https://github.com/libarchive/libarchive.git)
FROM libfuzzer/base-fuzzer

MAINTAINER ochang@google.com

RUN apt-get install -y autoconf libtool pkg-config

CMD /workspace/libfuzzer-bot/dockerfiles/lcms2/build.sh
