#include <string>
#include <vector>
#include "libxml/xmlversion.h"
#include "libxml/parser.h"
#include "libxml/tree.h"
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  if (auto doc = xmlReadMemory(reinterpret_cast<const char *>(data), size,
                               "noname.xml", NULL, 0)) {
    xmlFreeDoc(doc);
  }
  return 0;
}
