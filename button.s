#include <xc.inc>
    
global  bt_setup, bt_read_cycle
global	btn


psect	udata_acs   ; reserve data space in access ram
btn:		    ds	1	    ; reserve 1 byte
prev_btn:	    ds	1
bt_readCounter1:    ds	1
bt_readCounter2:    ds	1
bt_readCounter3:    ds	1
on_cycles:	    ds	1
off_cycles:	    ds	1
cycle:

psect	button_code,class=CODE

bt_setup:
	clrf	TRISH, A    ; sets PORT H for input
	movlb	0x0F
	bsf	REPU
	call	bt_reset
	return
	
bt_reset:
	clrf	btn	; clears previous value for button
	return	
	
bt_read:
	movf	PORTH, W, A	; reads vlaue of PORT H 
	movwf	btn		; and saves it to button
	return

bt_and:
	movf	prev_btn, W, A	;   takes IOR of prev button and current button
	iorwf	btn, F, A	;   and save it as the current button
	return

bt_read_cycle:		    ; reads PORT H for a specific amount of time
	call	bt_reset
	movlw	0x01
	movwf	bt_readCounter2, A
	movlw	0x01
	movwf	bt_readCounter3, A
	movlw	0x01
	movwf	bt_readCounter1, A
btrlms:
	movff	prev_btn, btn, A
	call	bt_read
	call	bt_and
	decfsz	bt_readCounter1, F, A
	goto	btrlms
	
	movff	prev_btn, btn
	call	bt_read
	call	bt_and
	decfsz	bt_readCounter2, F, A
	goto	btrlms
	
	movff	prev_btn, btn
	call	bt_read
	call	bt_and
	decfsz	bt_readCounter3, F, A
	goto	btrlms
	retlw	btn

	
	
	end