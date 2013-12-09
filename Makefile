all: main.exe

Inc.o: Inc.c
	gcc -c -o Inc.o Inc.c

Inc.dll: Inc.o
	gcc -shared -o Inc.dll Inc.o

IncThenInc.o: IncThenInc.c
	gcc -c -o IncThenInc.o IncThenInc.c

cygIncThenInc.dll: Inc.dll IncThenInc.o
	gcc -shared -o cygIncThenInc.dll \
		-Wl,--out-implib=libIncThenInc.dll.a \
		-Wl,--export-all-symbols \
		-Wl,--enable-auto-import \
		-Wl,--whole-archive IncThenInc.o \
		-Wl,--no-whole-archive -L. -lInc

main.o: main.c
	gcc -c -o main.o main.c

main.exe: main.o cygIncThenInc.dll
	gcc -o main.exe main.o -L. -lIncThenInc

test: main.exe
	./main.exe

.PHONY: clean

clean:
	rm -f Inc.o
	rm -f Inc.dll
	rm -f IncThenInc.o
	rm -f cygIncThenInc.dll
	rm -f libIncThenInc.dll.a
	rm -f main.o
	rm -f main.exe
