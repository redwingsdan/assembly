/*
 * AssemblerApplication1.asm
 *
 *  Created: 11/7/2013 4:48:54 PM
 *   Author: Bench
 */ 


 LDI r16,0b00000010		;Loads the number 2 into register 16
OUT ddrc,r16			;Outputs the value in register 16 to the ddrc
start:					;The beginning of the operation
SBI portc,1				;Sets the value of bit 1 in port c
nop nop nop nop nop
nop nop nop nop nop
nop nop nop nop nop
nop nop nop nop nop
nop nop nop nop nop
nop nop nop nop
CBI portc,1				;Clears bit 1 in port c
nop nop nop nop nop 
nop nop nop nop nop
nop nop nop nop nop 
nop nop nop nop nop
nop nop nop nop nop
nop nop nop nop
rjmp start				;Jumps back to the start operation