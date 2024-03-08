#include <xc.inc>
; edited
extrn	btn, bt_setup, bt_read_cycle	; methods
extrn	LCD_Setup
    
psect	udata_acs   ; reserve data space in access ram
prev_cycle: ds	1
on_cycles:  ds	1
off_cycle:  ds	1
bit_pos:    ds	1
enc_byte:   ds	1
rand_byte:  ds	1


psect	code, abs
rst:	org	0x0000	; reset vector
	
	bsf	GIE
	goto	start

int_hi:	org	0x0008	; high vector, no low vector
	goto	DAC_Int_Hi
	
start:	call	btn_setup
	call	LCD_setup
	


loop:	movff	btn, prev_cycle
	call	btn_read_cycle
	call	check_cycle
	
	
	
	goto	loop

check_cycle:
	movlw	0x00
	cpfsgt	btn, A	; check if the button is pressed
	goto	cycle_off	; not pressed
	goto	cycle_on	; pressed
	
cycle_on:
	incf	on_cycles
	return
	
	
cycle_off:
	movf	btn, W, A
	cpfseq	prev_cycle, A	;   was the prev cycle off?
	goto	check_off_length ; code for diff
	incf	check_on_length
	return

check_off_length:
	movlw	0xF0	; check if off cycles long enough for a new char input
	cpfsgt	off_cycles, A
	return	;   return if not a new character
	;   if long enough:
;	call	enc_finish
;	call	encrypt_data
;	call	UART_send
;	clrf	enc_data
	clrf	bit_pos
	return
	
check_off_length:
	movlw	0xF0
	cpfsgt	on_cycles
;	goto	enc_dot
;	goto	enc_dash
	
end	rst


