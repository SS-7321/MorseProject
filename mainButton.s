#include <xc.inc>
; edited
extrn	btn, bt_setup, bt_read_cycle	; methods
extrn	LCD_Setup
    
psect	udata_acs   ; reserve data space in access ram
prev_cycle: ds	1
on_cycles:  ds	1
off_cycle:  ds	1


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
	goto cycle_off	; not pressed
	goto cycle_on	; pressed
	
cycle_on:
	movf	btn, W, A
	cpfseq	prev_cycle, A
	nop ; goto code for diff cycles (new input)
	incf	on_cycles
	return
	
	
cycle_off:
	movf	btn, W, A
	cpfseq	prev_cycle, A
	call	check_off_length ; code for diff
	incf	off_cycles
	return

check_off_length:
	movlw	0xF0	; check if off cycles long enough for a new char input
	cpfsgt	off_cycles, A
	goto ; 
end	rst


