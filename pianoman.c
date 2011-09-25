#include "pianoman.h"

int main(int argc, char **argv) {
    if (argc <= 1) {
        printf("Usage: %s <dump.rdb> <match1> <match2> ...\n", argv[0]);
        exit(0);
    };

    processDumpFile(argc, argv);
    printDbStats();

    return 0;
};
