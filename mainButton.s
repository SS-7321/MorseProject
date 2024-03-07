#include <xc.inc>
; edited
extrn	btn, bt_setup, bt_read_cycle
    
psect	udata_acs   ; reserve data space in access ram
cycle:	    ds	1	    ; reserve 1 byte
prev_cycle: ds	1
on_cycles:  ds	1
off_cycle:  ds	1


psect	code, abs
rst:	org	0x0000	; reset vector
	
	bsf	TMR0IE
	bsf	GIE
	goto	start

int_hi:	org	0x0008	; high vector, no low vector
	goto	DAC_Int_Hi
	
start:	call	btn_setup
	



loop:	
	
	
	
	
	goto	loop	
	
end	rst


