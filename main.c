#include <stdio.h>
#include <assert.h>
#include <dlfcn.h>
#include "Inc.h"

int main(int argc, char *argv[]) {
	const int i = 0;
	void *h;
	int (*f)(const int);
	char *e;

	assert(argc == 2);
	h = dlopen(argv[1], RTLD_LAZY);
	if (h == NULL) {
		fprintf(stderr, "dlopen:%s\n", dlerror());
		return 1;
	}

	dlerror();
	f = dlsym(h, "IncThenInc");
	e = dlerror();
	if (e != NULL) {
		f = dlsym(RTLD_DEFAULT, "IncThenInc");
		e = dlerror();
		if (e != NULL) {
			fprintf(stderr, "dlsym:%s\n", e);
			return 1;
		}
	}

	fprintf(stdout, "Inc(Inc(%d)) = %d\n", i, Inc(Inc(i)));
	fprintf(stdout, "IncThenInc(%d) = %d\n", i, f(i));

	dlclose(h);

	return 0;
}
