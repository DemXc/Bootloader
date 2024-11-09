#include "kernel.h"
#include "paging.h"
#include "malloc.h"

void kernel_main() {

	init_paging();
	init_malloc();
}
