SO_EXT=so

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

IncThenInc.$(SO_EXT): IncThenInc.o libmain.a main.exe
	gcc -shared -o IncThenInc.$(SO_EXT) IncThenInc.o -L. -lmain

test: main.exe IncThenInc.$(SO_EXT)
	LD_LIBRARY_PATH=. ./main.exe IncThenInc.$(SO_EXT)

.PHONY: clean

clean:
	rm -f Inc.o
	rm -f libInc.a
	rm -f main.o
	rm -f main.exe
	rm -f libmain.a
	rm -f IncThenInc.o
	rm -f IncThenInc.$(SO_EXT)
