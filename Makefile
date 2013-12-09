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

main.exe: main.c cygIncThenInc.dll
	gcc -o main.exe main.c -L. -lIncThenInc

test: main.exe
	./main.exe

