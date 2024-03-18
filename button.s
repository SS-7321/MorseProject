#include <xc.inc>
    
global  button, ButtonSetup, ButtonReadCycle


psect	udata_acs   ; reserve data space in access ram
button:		    ds	1	    ; reserve 1 byte
previous_button:	    ds	1
button_read_counter_1:    ds	1
button_read_counter_2:    ds	1


psect	button_code,class=CODE

ButtonSetup:
	
	setf	TRISD, A	; sets PORT H for input
	call	ButtonReset
	return
	
ButtonReset:
	clrf	button, A		; clears value for button
	clrf	previous_button, A	;clears previous button
	return	
	
ButtonRead:
	movff	PORTD, button	; reads vlaue of PORT H and saves it to button
	return	; and saves 

ButtonIOR:
	movf	previous_button, W, A	;   takes IOR of prev button and current button
	iorwf	button, F, A	;   and save it as the current button
	return

ButtonReadCycle:		    ; reads PORT H for a specific amount of time
	call	ButtonReset
	
	movlw	0xFF
	movwf	button_read_counter_1, A
	movlw	0x90
	movwf	button_read_counter_2, A
buttonReadLoop:
	movff	button, previous_button, A
	call	ButtonRead
	call	ButtonIOR
	
	decfsz	button_read_counter_1, F, A
	goto	buttonReadLoop
	
	decfsz	button_read_counter_2, F, A
	goto	buttonReadLoop
	movf	button, W, A
	return

	
	
	end