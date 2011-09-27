#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <string.h>
#include <arpa/inet.h>
#include <stdint.h>
#include <limits.h>
#include "lzf.h"

typedef struct {
    int strings;
    int lists;
    int sets;
    int zsets;
    int hashes;
    int total_keys;
    int total_expires;
    size_t match_count;
    char *matches[25];
    int match_counts[25];
} db_stat;

void processDumpFile(int argc, char **argv);
void printDbStats();
