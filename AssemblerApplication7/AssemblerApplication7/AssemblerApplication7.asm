/*
 * AssemblerApplication7.asm
 *
 *  Created: 11/21/2013 11:23:50 AM
 *   Author: cad
 */ 

 
 //Setup ports
 ldi r16,0xfe				;turn pnp transistors off
 out portb,r16				
 ldi r16,0b11000111
 out ddrb,r16

 ldi r16,0b00000011			;set 2 pins of portc to input
 out ddrc, r16
 ldi r16,0xff				;set all pins of port d to output
 out ddrd,r16
 //defines the registers
 .def ticks=r16				;defines r16 as ticks
 .def secs=r17				;defines r17 as seconds
 .def mins=r18				;defines r18 as minutes
 .def hours=r19				;defines r19 as hours
 //clears all registers
 clr ticks					
 clr secs
 clr mins
 clr hours

 //tick loop
tick:		
        sbis pinc,7
        rjmp tick
        inc ticks
        cpi ticks, 60
        brne display 
        clr ticks
		rjmp inc_button

inc_button:
		cbi portc,0
		sbic pinb,4
		rjmp set_button
		sbi portc,0
		inc mins
		cpi mins,60
		brne set_button
		clr mins
		rjmp set_button

set_button:
		cbi portc,0
		sbic pinb,5
		rjmp tock1
		sbi portc,0
		inc hours
		cpi hours,24
		brne tock1
		clr hours
		rjmp tock1
		
tock1:        
        inc secs
        cpi secs,60
        brne display
        clr secs
        inc mins
        cpi mins,60
        brne display
        clr mins        
        inc hours
        cpi hours,24
        brne display
        clr hours

 display:
 com secs					;inverts the value in seconds
 out portd,secs				;ouputs the value in seconds to portd
 com secs					;inverts seconds
 cbi portd,6				;clears bit 6 in portd
 cbi portd,7				;clears bit 7 in portd
 cbi portb,0				;clears bit 0 in portb
 rcall delay_21k			;calls the delay subroutine
 sbi portb,0				;sets bit 0 in portb

 mov r20,hours				;copies the value in hours to register 20
 rcall get_segs				;call sthe subroutine get_segs

 out portd,r21				;outputs the value in r21 to portd
 cbi portb,1				;clears bit 1 in portb
 rcall delay_21k			;calls the delay subroutine
 sbi portb,1				;sets bit 1 in portb

 out portd,r22				;outputs the value in r22 to portd
 cbi portb,2				;clears bit 2 in portb
 rcall delay_21k			;calls the delay subroutine
 sbi portb,2				;sets bit 2 in portb
 
 mov r20, mins				;copies the value in minutes to r20
 rcall get_segs				;calls the get_segs subroutine

 out portd,r21				;outputs the value in r21 to portd
 cbi portb,6				;clears bit 6 in portb
 rcall delay_21k			;calls the delay subroutine
 sbi portb,6				;sets bit 6 in portb
  
 out portd,r22				;outputs the value in r22 to portd
 cbi portb,7				;clears bit 7 in portb
 rcall delay_21k			;calls the delay subroutine
 sbi portb,7				;sets bit 7 in portb
 
  
 tock:
 sbis pinc,7				;checks to see if the pin when to 0
 rjmp tock					;jumps to tock
 rjmp tick					;jumps to tick




 /*get_segs_m takes an argument in scr and returns the most significant LED
  segments (segs_h) and least significant LED segment (segs_l). The scr 
  register is 0 to 59 for minutes 

  
  		writes: clr, tens,zl, zh, segs_l, segs_h	*/
get_segs:
	clr r0				;clear tens register
div_m:
	cpi r20,10			;bigger than ten?		
	brlo done_div_m		;	no, done
	inc r0				;increment tens count
	subi r20,10			;subtract 10 from scr 
	rjmp div_m          ;repeat until r20 is less than 10
done_div_m:
	ldi zh,high(seg_table<<1)	;load z register for indirect read
	ldi zl,low(seg_table<<1)
	add zl,r0			;compute offset into the table
	brcc nc1_m			;carry required?
	inc zh				;carry
nc1_m:
	lpm r21,z			;read segments from data table
	ldi zh,high(seg_table<<1)	;load z register for indirect read
	ldi zl,low(seg_table<<1)
	add zl,r20			;compute offset into the table
	brcc nc2_m			;carry required?
	inc zh				;carry
nc2_m:
	lpm r22,z			;read segments from data table
	ret	                ;return


// delay_21k simply calls delay 21 times
delay_21k:
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	ret


// delay takes 1003 cycles to execute
delay:               	;the label that identifies the subroutine to the assembler
    clr r31             ;initialize register 31 (this can be any unused register)
delay_loop:             ;a label for the brne instruction
    inc r31             ;increment r31
    cpi r31,0xf9        ;compare r31 to the final value
    brne delay_loop     ;jump to delay_loop if the count has not reached the final value
    ret                 ;return. The microcontroller 'remembers' where it came from


	// initialize LED segment table
seg_table:		
	.dw 0xeb09				;1,0
	.dw 0xc185				;3,2
	.dw	0x5163				;5,4
	.dw 0xcb11				;7,6
	.dw 0x4101				;9,8
	.dw 0x00ff				;on,off





	/*Prelab 12 Code
	*/
	
	.include "tn48def.inc"
	//setup portb
		ldi r16,0xff	;turn pnp transistors off, pullups on
		out portb,r16
		ldi r16,0b11000111
		out ddrb,r16

	//setup portc
		ldi r16,0b01111100	;enable pullups, set speaker and led off
		out portc,r16
		ldi r16,0b00000011
		out ddrc,r16

	//setup portd
		ldi r16,0b11111111	;set all pins as output, initialize high
		out portd,r16
		out ddrd,r16

		start:
		sbis pinb,3
		rjmp delay_sequence1
		sbis pinb,5
		rjmp delay_sequence2
		sbis pinb,4				
		rjmp delay_sequence3
		cbi portc,0				;turns LED off
		rjmp start

		delay_sequence1:
		sbi portc,1			;122 cycle delay loop
		rcall delay_122		
		cbi portc,1
		rcall delay_122
		sbi portc,0
		rjmp start

		delay_sequence2:
		sbi portc,1			;97 cycle delay loop
		rcall delay_97
		cbi portc,1
		rcall delay_97
		sbi portc,0
		rjmp start

		delay_sequence3:
		sbi portc,1			;82 cycle delay loop
	    rcall delay_82
		cbi portc,1
		rcall delay_82
		sbi portc,0
		rjmp start

		//delay subroutines
		delay_122:
		clr r31
		delay_loop1:
		inc r31
		cpi r31,48
		brne delay_loop1
		ret

		delay_97:
		clr r31
		delay_loop2:
		inc r31
		cpi r31,38
		brne delay_loop2
		ret

		delay_82:
		clr r31
		delay_loop3:
		inc r31
		cpi r31,31
		brne delay_loop3
		ret

	