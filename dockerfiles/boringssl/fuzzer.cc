// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

#include <assert.h>
#include <openssl/err.h>
#include <openssl/ssl.h>

SSL_CTX *sctx;
int Init() {
  SSL_library_init();
  SSL_load_error_strings();
  ERR_load_BIO_strings();
  OpenSSL_add_all_algorithms();
  assert(sctx = SSL_CTX_new(TLSv1_method()));
  assert(SSL_CTX_use_certificate_file(sctx, "server.pem", SSL_FILETYPE_PEM));
  assert(SSL_CTX_use_PrivateKey_file(sctx, "server.key", SSL_FILETYPE_PEM));
  return 0;
}

extern "C" int LLVMFuzzerTestOneInput(unsigned char *Data, size_t Size) {
  static int unused = Init();
  SSL *server = SSL_new(sctx);
  BIO *sinbio = BIO_new(BIO_s_mem());
  BIO *soutbio = BIO_new(BIO_s_mem());
  SSL_set_bio(server, sinbio, soutbio);
  SSL_set_accept_state(server);
  BIO_write(sinbio, Data, Size);
  SSL_do_handshake(server);
  SSL_free(server);
  return 0;
}
