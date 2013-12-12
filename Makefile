all: test

Inc.o: Inc.c
	gcc -c -o Inc.o Inc.c

libInc.a: Inc.o
	ar rv libInc.a Inc.o

main.o: main.c Inc.h
	gcc -c -o main.o -I. main.c

main.exe: main.o libInc.a
	gcc -o main.exe main.o -L. -lInc -Wl,--export-all-symbols -Wl,--out-implib=libmain.a

libmain.a: main.exe

IncThenInc.o: IncThenInc.c Inc.h
	gcc -c -o IncThenInc.o -I. IncThenInc.c

IncThenInc.so: IncThenInc.o libmain.a libmain.a
	gcc -shared -o IncThenInc.so IncThenInc.o -L. -lmain

test: main.exe IncThenInc.so
	LD_LIBRARY_PATH=. ./main.exe IncThenInc.so

.PHONY: clean

clean:
	rm -f Inc.o
	rm -f libInc.a
	rm -f main.o
	rm -f main.exe
	rm -f libmain.a
	rm -f IncThenInc.o
	rm -f IncThenInc.so
