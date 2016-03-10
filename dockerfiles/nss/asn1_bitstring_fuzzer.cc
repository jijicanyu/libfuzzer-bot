// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <stddef.h>
#include <stdint.h>

#include <nspr.h>
#include <nss.h>
#include <secasn1.h>
#include <secder.h>
#include <secport.h>

// Entry point for LibFuzzer.
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  const SEC_ASN1Template* the_template = SEC_ASN1_GET(SEC_BitStringTemplate);
  SECItem quick_dest = {siBuffer, nullptr, 0};
  SECItem legacy_dest = {siBuffer, nullptr, 0};

  // Attempt the QuickDER path.
  PLArenaPool* quick_arena = PORT_NewArena(DER_DEFAULT_CHUNKSIZE);
  if (!quick_arena) return 0;
  SECItem quick_src = {siBuffer, const_cast<unsigned char*>(
                                     static_cast<const unsigned char*>(data)),
                       static_cast<unsigned int>(size)};
  SEC_QuickDERDecodeItem(quick_arena, &quick_dest, the_template, &quick_src);
  PORT_FreeArena(quick_arena, PR_TRUE);

  // Attempt the Legacy path.
  PLArenaPool* legacy_arena = PORT_NewArena(DER_DEFAULT_CHUNKSIZE);
  if (!legacy_arena) return 0;

  SECItem legacy_src = {siBuffer, const_cast<unsigned char*>(
                                      static_cast<const unsigned char*>(data)),
                        static_cast<unsigned int>(size)};

  SEC_ASN1DecodeItem(legacy_arena, &legacy_dest, the_template, &legacy_src);

  // Legacy allocates everything in the context of |legacy_arena|.
  PORT_FreeArena(legacy_arena, PR_TRUE);

  return 0;
}
