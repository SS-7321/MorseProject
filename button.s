#include <xc.inc>
    
global  button, ButtonSetup, ButtonReadCycle


psect	udata_acs   ; reserve data space in access ram
button:			  ds	1   ; reserve 1 byte for each variables
previous_button:	  ds	1
button_read_counter_1:    ds	1
button_read_counter_2:    ds	1


psect	button_code,class=CODE

ButtonSetup:
	
	setf	TRISD, A	; sets PORT D for input
	call	ButtonReset	; clears related byte addresses
	return
	
ButtonReset:
	clrf	button, A		; clears address for current button
	clrf	previous_button, A	; clears address for previous button
	return	
	
ButtonRead:	    ;   reads value of PORT D and saves it to button and saves 
	movff	PORTD, button	
	return

ButtonIOR:
	movf	previous_button, W, A	; takes IOR of previous button and current button
	iorwf	button, F, A		; and save it as the current button
	return

ButtonReadCycle:    ;	reads PORT D for a specific amount of time (20ms)
	call	ButtonReset
	movlw	0xFF
	movwf	button_read_counter_1, A
	movlw	0x90
	movwf	button_read_counter_2, A
buttonReadLoop:
	movff	button, previous_button, A  ; moves last read input to previous button address
	call	ButtonRead		    ; reads current state and saves it
	call	ButtonIOR		    ; takes IOR of current and previous state
	
	decfsz	button_read_counter_1, F, A ; repeats
	goto	buttonReadLoop
	
	decfsz	button_read_counter_2, F, A
	goto	buttonReadLoop
	movf	button, W, A

	return				    ; end of read cycle

	
	
	end