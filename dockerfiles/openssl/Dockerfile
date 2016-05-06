# Workspace should contain directories:
# - libfuzzer-bot (checkout of https://github.com/google/libfuzzer-bot/)
# - openssl (checkout of https://github.com/openssl/openssl)
# - benlaurie-openssl (https://github.com/benlaurie/openssl.git fuzz branch)
FROM libfuzzer/base-fuzzer

MAINTAINER aizatsky@google.com

RUN apt-get install -y autoconf libtool libarchive-dev

ADD libfuzzer-bot/dockerfiles/openssl/build.sh /src/
CMD /src/build.sh
