cygwin dll black magic exmaple to find simplest way to share *nix env.

result:

 * shared object prefix and extension are not matter.
 * create import library on link to executable, **only if on cygwin**.
 * link above import libray on link to shared object, **only if on cygwin**.
 * use real path to above shared object for dlopen().

```
$ make
gcc -c -o main.o -I. main.c
gcc -c -o Inc.o Inc.c
ar rv libInc.a Inc.o
ar: creating libInc.a
a - Inc.o
gcc -o main.exe main.o -L. -lInc -Wl,--export-all-symbols -Wl,--out-implib=libmain.a
gcc -c -o IncThenInc.o -I. IncThenInc.c
gcc -shared -o IncThenInc.so IncThenInc.o -L. -lmain
LD_LIBRARY_PATH=. ./main.exe IncThenInc.so
Inc(Inc(0)) = 2
IncThenInc(0) = 2

$ ldd IncThenInc.so
        ntdll.dll => /cygdrive/c/Windows/SysWOW64/ntdll.dll (0x77290000)
        kernel32.dll => /cygdrive/c/Windows/syswow64/kernel32.dll (0x76860000)
        KERNELBASE.dll => /cygdrive/c/Windows/syswow64/KERNELBASE.dll (0x759a0000)
        main.exe => /home/hiyuh/git-repos/cygwin-dll-example/main.exe (0x320000)
        cygwin1.dll => /usr/bin/cygwin1.dll (0x61000000)

$ ldd main.exe
        ntdll.dll => /cygdrive/c/Windows/SysWOW64/ntdll.dll (0x77290000)
        kernel32.dll => /cygdrive/c/Windows/syswow64/kernel32.dll (0x76860000)
        KERNELBASE.dll => /cygdrive/c/Windows/syswow64/KERNELBASE.dll (0x759a0000)
        cygwin1.dll => /usr/bin/cygwin1.dll (0x61000000)

```
