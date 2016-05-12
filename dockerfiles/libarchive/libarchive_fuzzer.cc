#include <archive.h>
#include <stddef.h>
#include <stdint.h>
#include <vector>

struct Buffer {
  const uint8_t *buf;
  size_t len;
};

ssize_t reader_callback(struct archive *a, void *client_data,
                        const void **block) {
  Buffer *buffer = reinterpret_cast<Buffer *>(client_data);
  *block = buffer->buf;
  ssize_t len = buffer->len;
  buffer->len = 0;
  return len;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *buf, size_t len) {
  struct archive *a = archive_read_new();

  archive_read_support_filter_all(a);
  archive_read_support_format_all(a);

  Buffer buffer{buf, len};
  archive_read_open(a, &buffer, NULL, reader_callback, NULL);

  std::vector<uint8_t> data_buffer(getpagesize(), 0);
  struct archive_entry *entry;
  while (archive_read_next_header(a, &entry) == ARCHIVE_OK) {
    while (archive_read_data(a, data_buffer.data(), data_buffer.size()) > 0)
      ;
  }

  archive_read_free(a);
  return 0;
}
