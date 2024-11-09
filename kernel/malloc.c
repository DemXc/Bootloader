#include "malloc.c"
#include <unistd.h>

typedef struct MBlock {
    size_t size;
    struct MBlock* next;
    int free;
} MBlock;

static MBlock* free_list = NULL;

void* malloc(size_t size) {
    if (size <= 0) return NULL;
    size = (size + sizeof(MBlock) + 7) & ~7;

    MBlock* current = free_list;
    MBlock* prev = NULL;
    
    while (current) {
        if (current->free && current->size >= size) {
            if (current->size > size + sizeof(MBlock)) {
                MBlock* new_block = (MBlock*)((char*)current + size);
                new_block->size = current->size - size - sizeof(MBlock);
                new_block->free = 1;
                new_block->next = current->next;
                current->next = new_block;
                current->size = size;
            }
            current->free = 0;
            return (void*)((char*)current + sizeof(MBlock));
        }
        prev = current;
        current = current->next;
    }

    MBlock* new_block = sbrk(size + sizeof(MBlock));
    if (new_block == (void*)-1) {
        return NULL;
    }
    new_block->size = size;
    new_block->free = 0;
    new_block->next = NULL;

    if (prev) {
        prev->next = new_block;
    } else {
        free_list = new_block;
    }

    return (void*)((char*)new_block + sizeof(MBlock));
}

void free(void* ptr) {
    if (!ptr) return;

    MBlock* block_to_free = (MBlock*)((char*)ptr - sizeof(MBlock));
    block_to_free->free = 1;

    MBlock* current = free_list;
    while (current) {
        if (current->free && (char*)current + current->size + sizeof(MBlock) == (char*)block_to_free) {
            current->size += block_to_free->size + sizeof(MBlock);
            block_to_free = current;
        } else if (current->free && (char*)block_to_free + block_to_free->size + sizeof(MBlock) == (char*)current) {
            block_to_free->size += current->size + sizeof(MBlock);
            block_to_free->next = current->next;
        }
        current = current->next;
    }
}

void* calloc(size_t num, size_t size) {
    void* ptr = malloc(num * size);
    if (ptr) {
        memset(ptr, 0, num * size);
    }
    return ptr;
}
