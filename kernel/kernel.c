#include "kernel.h"
#include "paging.h"

void kernel_main() {

	init_paging();
}
