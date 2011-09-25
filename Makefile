CC=gcc
CFLAGS=-I.
PROGNAME = pm
OBJ = lzf_c.o lzf_d.o redis-check-dump.o pianoman.o

all: $(OBJ)
	$(CC) -o $(PROGNAME) $(OBJ)

lzf_c.o: lzf_c.c lzfP.h
lzf_d.o: lzf_d.c lzfP.h
redis-check-dump.o: redis-check-dump.h redis-check-dump.c lzf.h
pianoman.o: pianoman.h pianoman.c

clean:
	rm -rf *.o $(PROGNAME)
