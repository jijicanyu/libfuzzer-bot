// Copyright 2015 Google Inc. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
#include <stddef.h>
#include <stdint.h>
#include "sqlite3.h"
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  if (size < 1) return 0;
  sqlite3* db;
  if (SQLITE_OK != sqlite3_open(":memory:", &db)) return 0;
  sqlite3_stmt* statement = NULL;
  const char* tail = NULL;
  if (SQLITE_OK ==
      sqlite3_prepare_v2(db, (const char*)(data), size, &statement, NULL))
    sqlite3_finalize(statement);
  sqlite3_close(db);
  return 0;
}
