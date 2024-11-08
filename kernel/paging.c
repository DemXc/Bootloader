#include "paging.h"
#include "stdint.h"

typedef struct {
	uint32_t pressent : 1;
	uint32_t rw : 1;
	uint32_t user : 1;
	uint32_t reserved : 2;
	uint32_t addres : 28;
} page_table_entry_t;

page_table_entry_t* page_directory;

void init_paging(){


	page_directory = (page_table_entry_t*) 0x1000;

	for(int i = 0; i < 1024; i++) {
		page_directory[i].present = 1;
		page_directory[i].rw = 1
		page_directory[i].user = 0
		page_directory[i].address = (i * 0x1000) >> 12;
	}
}
