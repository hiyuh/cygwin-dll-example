Inc.o: Inc.c
	gcc -c -o Inc.o Inc.c

libInc.a: Inc.o
	ar rv libInc.a Inc.o

main.o: main.c Inc.h
	gcc -c -o main.o -I. main.c

main.exe: main.o libInc.a
	gcc -o main.exe main.o -L. -lInc -Wl,--export-all-symbols -Wl,--out-implib=libmain.a

IncThenInc.o: IncThenInc.c Inc.h
	gcc -c -o IncThenInc.o -I. IncThenInc.c

cygIncThenInc.$(SO_EXT): IncThenInc.o libInc.a
	gcc -shared -o cygIncThenInc.$(SO_EXT) \
		-Wl,--out-implib=libIncThenInc.$(SO_EXT).a \
		-Wl,--export-all-symbols \
		-Wl,--enable-auto-import \
		-Wl,--whole-archive IncThenInc.o \
		-Wl,--no-whole-archive -L. -lInc

cygIncThenInc-import.$(SO_EXT): IncThenInc.o main.exe
	gcc -shared -o cygIncThenInc-import.$(SO_EXT) \
		-Wl,--out-implib=libIncThenInc-import.$(SO_EXT).a \
		-Wl,--export-all-symbols \
		-Wl,--enable-auto-import \
		-Wl,--whole-archive IncThenInc.o \
		-Wl,--no-whole-archive -L. -lmain

libIncThenInc.$(SO_EXT): IncThenInc.o libInc.a
	gcc -shared -o libIncThenInc.$(SO_EXT) IncThenInc.o -L. -lInc

libIncThenInc-import.$(SO_EXT): IncThenInc.o libmain.a main.exe
	gcc -shared -o libIncThenInc-import.$(SO_EXT) IncThenInc.o -L. -lmain

IncThenInc.$(SO_EXT): IncThenInc.o libInc.a
	gcc -shared -o IncThenInc.$(SO_EXT) IncThenInc.o -L. -lInc

IncThenInc-import.$(SO_EXT): IncThenInc.o libmain.a main.exe
	gcc -shared -o IncThenInc-import.$(SO_EXT) IncThenInc.o -L. -lmain

test:                              \
	main.exe                       \
	cygIncThenInc.$(SO_EXT)        \
	cygIncThenInc-import.$(SO_EXT) \
	libIncThenInc.$(SO_EXT)        \
	libIncThenInc-import.$(SO_EXT) \
	   IncThenInc.$(SO_EXT)        \
	   IncThenInc-import.$(SO_EXT)
	LD_LIBRARY_PATH=. ./main.exe cygIncThenInc                  || true
	LD_LIBRARY_PATH=. ./main.exe cygIncThenInc.$(SO_EXT)        || true
	LD_LIBRARY_PATH=. ./main.exe libIncThenInc                  || true
	LD_LIBRARY_PATH=. ./main.exe libIncThenInc.$(SO_EXT)        || true
	LD_LIBRARY_PATH=. ./main.exe    IncThenInc                  || true
	LD_LIBRARY_PATH=. ./main.exe    IncThenInc.$(SO_EXT)        || true
	LD_LIBRARY_PATH=. ./main.exe cygIncThenInc-import           || true
	LD_LIBRARY_PATH=. ./main.exe cygIncThenInc-import.$(SO_EXT) || true
	LD_LIBRARY_PATH=. ./main.exe libIncThenInc-import           || true
	LD_LIBRARY_PATH=. ./main.exe libIncThenInc-import.$(SO_EXT) || true
	LD_LIBRARY_PATH=. ./main.exe    IncThenInc-import           || true
	LD_LIBRARY_PATH=. ./main.exe    IncThenInc-import.$(SO_EXT) || true

.PHONY: clean

clean:
	rm -f Inc.o
	rm -f libInc.a
	rm -f main.o
	rm -f main.exe
	rm -f libmain.a
	rm -f IncThenInc.o
	rm -f cygIncThenInc.$(SO_EXT)
	rm -f libIncThenInc.$(SO_EXT).a
	rm -f cygIncThenInc-import.$(SO_EXT)
	rm -f libIncThenInc-import.$(SO_EXT).a
	rm -f libIncThenInc.$(SO_EXT)
	rm -f libIncThenInc-import.$(SO_EXT)
	rm -f IncThenInc.$(SO_EXT)
	rm -f IncThenInc-import.$(SO_EXT)

