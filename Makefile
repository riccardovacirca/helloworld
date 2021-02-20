
all:
	gcc -I. -I/usr/include/apr-1.0 -std=gnu99 -o hello main.c -lapr-1 -laprutil-1
