// Copyright 2015 Google Inc. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
#include <stddef.h>
#include <stdint.h>
#include "sqlite3.h"
#include <stdio.h>
static int Progress(void *pNotUsed){
  // fprintf(stderr, "Progress\n");
  return 1;
}
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  if (size < 1) return 0;
  sqlite3* db;
  if (SQLITE_OK != sqlite3_open(":memory:", &db)) return 0;
  sqlite3_stmt* statement = NULL;
  const char* tail = NULL;
  sqlite3_progress_handler(db, 10000, &Progress, NULL);
  if (SQLITE_OK ==
      sqlite3_prepare_v2(db, (const char*)(data), size, &statement, NULL)) {
    for (int i = 0; i < 5 && sqlite3_step(statement) == SQLITE_ROW; i++) {}
    sqlite3_finalize(statement);
  }
  sqlite3_close(db);
  return 0;
}
