#include <stdint.h>

#include "lcms2.h"

// The main sink
int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  if (size == 0)
    return 0;

  cmsHPROFILE profile = cmsOpenProfileFromMem(data, size);
  if (profile)
    cmsCloseProfile(profile);

  return 0;
}


