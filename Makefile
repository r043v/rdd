all: rdd

rdd: rdd.c
	gcc -std=c99 rdd.c -lhiredis -L/usr/lib -I/usr/include -o rdd

clean:
	rm -rf *.o rdd
