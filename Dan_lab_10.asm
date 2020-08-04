/*
 * Dan_lab_10.asm
 *
 *  Created: 11/11/2013 7:22:20 PM
 *   Author: cad
 */ 

 .def ticks = r16		;defines r16 as ticks
 .def secs = r17		;defines r17 as seconds
 
 //setup ports//
 ldi r20, 0b00000011	;1 for output pins, 0 for inputs
 out ddrc,r20			;program pc0 and pc1 as outputs
 ldi r20, 0xff			;load 11111111 (255) in r20 
 out ddrd,r20			;program all of portd as outputs

 tick:
 sbis pinc,7			;checks bit 7 of portc
 rjmp tick				;jumps back if zero
 inc ticks				;increments ticks by one
 cpi ticks,60			;compares the value in ticks to 60
 brne tock				;breaks to tock if not equal to 60
 clr ticks				;clears the value in ticks
 inc secs				;increments seconds by one
 com secs				;complements seconds (inverts the value)
 out portc,secs			;copies the value in seconds to portc
 com secs				;inverts the value in seconds (back to the original)

 tock:
 sbic pinc,7			;sets the but in bit 7 if the register is clear
 rjmp tock				;jumps to tock 
 rjmp tick				;jumps to tick