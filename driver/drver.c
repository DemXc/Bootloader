#include "driver.h"

void keyboard_driver(){
	unsigned char scancode;

	scancode = inb(0x60);

	char key = scancode_to_char(scancode);
	if(key != 0) {
		print_char(key);
	}
}

void keyboard_init(){
	register_interrupt_handler(IRQ1, keyboard_driver);
}
