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
} db_stat;

void processDumpFile(char *filename);
void printDbStats();
