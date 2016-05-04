# Workspace should contain directories:
# - libfuzzer-bot (checkout of https://github.com/google/libfuzzer-bot/)
# - freetype2 (checkout of )
FROM libfuzzer/base-fuzzer
MAINTAINER aizatsky@google.com

RUN apt-get install -y autoconf libtool libarchive-dev

ADD libfuzzer-bot/dockerfiles/freetype2/build.sh /src/
CMD /src/build.sh
