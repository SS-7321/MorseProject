#include <xc.inc>
    
global  btn, bt_setup, bt_read_cycle


psect	udata_acs   ; reserve data space in access ram
btn:		    ds	1	    ; reserve 1 byte
prev_btn:	    ds	1
bt_readCounter1:    ds	1
bt_readCounter2:    ds	1
;bt_readCounter3:    ds	1


psect	button_code,class=CODE

bt_setup:
	setf	TRISE, A	; sets PORT H for input
	call	bt_reset
	return
	
bt_reset:
	clrf	btn, A		; clears value for button
	clrf	prev_btn, A	;clears previous button
	return	
	
bt_read:
	movff	PORTE, btn	; reads vlaue of PORT H and saves it to button
	return	; and saves 

bt_and:
	movf	prev_btn, W, A	;   takes IOR of prev button and current button
	iorwf	btn, F, A	;   and save it as the current button
	return

bt_read_cycle:		    ; reads PORT H for a specific amount of time
	call	bt_reset
	movlw	0xFF
	movwf	bt_readCounter1, A
	movlw	0xA0
	movwf	bt_readCounter2, A
	;movlw	0x01
	;movwf	bt_readCounter1, A
btrlms:
	movff	btn, prev_btn, A
	call	bt_read
	call	bt_and
	decfsz	bt_readCounter1, F, A
	goto	btrlms
	
	decfsz	bt_readCounter2, F, A
	goto	btrlms
	movf	btn, W, A
	return

	
	
	end