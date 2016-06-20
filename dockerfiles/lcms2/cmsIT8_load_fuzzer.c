#include <stdint.h>

#include "lcms2.h"

// The main sink
int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  if (size == 0)
    return 0;

  cmsHANDLE handle = cmsIT8LoadFromMem(0, (void*)data, size);
  if (handle)
    cmsIT8Free(handle);

  return 0;
}


