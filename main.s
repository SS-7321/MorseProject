#include <xc.inc>
; edited


extrn	btn, bt_setup, bt_read_cycle	; methods
extrn	LCD_Setup, LCD_Send_Byte_D
    
psect	udata_acs   ; reserve data space in access ram
prev_cycle: ds	1
on_cycles:  ds	1
off_cycles:  ds	1
bit_pos:    ds	1
enc_byte:   ds	1
rand_byte:  ds	1
new_char_bool:    ds	1


psect	code, abs
rst:	org	0x0000	; reset vector
	
	bsf	GIE
	goto	start

int_hi:	org	0x0008	; high vector, no low vector

	
start:	call	bt_setup
	call	LCD_Setup
	


loop:	movff	btn, prev_cycle	;   new read cycle, move current to prev
	call	bt_read_cycle	;   check current state
	call	check_cycle
	
	
	
	goto	loop

check_cycle:
	tstfsz	btn, A	    ;	check if the button is pressed
	goto	cycle_on    ;	pressed
	goto	cycle_off   ;	not pressed
	
	
cycle_on:
	incf	on_cycles
	tstfsz	new_char_bool, A
	clrf	new_char_bool, A
	return
	
	
cycle_off:
    	incf	off_cycles
;   was the prev cycle off?
	tstfsz	prev_cycle, A
;   if prev on:
	goto	check_on_length	    ;	just finished input, goto encode result
;   if prev off:
	goto	check_off_length    ;	prev cycle was not off, encode prev input
	return

check_off_length:
;   is pause long enough for new character?
	movlw	0xF0
	cpfsgt	off_cycles, A
	return	;   return if not a new character
;   if long enough:
;   encrypted a byte before during this pause?
	tstfsz	new_char_bool, A
	return
;   if not encrypted before:
	call	enc_finish
;	call	encrypt
;	call	UART_send
	clrf	enc_byte
	setf	new_char_bool, A
	return
	
check_on_length:
;   is prev input dot or dash?
	movlw	0xF0
	cpfsgt	on_cycles, A
	call	enc_dot
	call	enc_dash
	clrf	on_cycles
	return

enc_dash:
	bsf	enc_byte, bit_pos, A
	incf	bit_pos, F, A
	return
enc_dot:
	incf	bit_pos, F, A
	return
	
enc_finish:
	bsf	enc_byte, bit_pos, A
	clrf	bit_pos, A
	movf	enc_byte, W, A
	return
end	rst


