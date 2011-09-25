#include "pianoman.h"

int main(int argc, char **argv) {
    if (argc <= 1) {
        printf("Usage: %s <dump.rdb>\n", argv[0]);
        exit(0);
    } else if (argc > 2){
        int i = 2;
        while(argv[i++]){
            printf("num %i\n\n",i);
        }
    };

    processDumpFile(argv[1]);
    printDbStats();

    return 0;
};
