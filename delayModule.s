#include <xc.inc>
    
global  Dloop

psect	udata_acs   ; reserve data space in access ram
delayCounter: ds    1	    ; reserve 1 byte
delayCounter2: ds    1	    ; reserve 1 byte
delayLevel: ds    1	    ; reserve 1 byte

psect	delaymodule_code,class=CODE

Dloop:
	movwf	delayLevel   ; reads the value of port D and assigns that to the delay-level (outer counter)
	call	delayBody	    ; calls the delay loop
	return			    ; keep going until finished
		
	
delayBody:
	movlw	0xFF
	movwf	delayCounter, A			; sets inner counter to 255
	movff	delayCounter, delayCounter2	; sets innter counter2 to 255
	
delayLoop:  
	decfsz  delayCounter, F			; Decrement inner loop counter, skip next instruction if 0
	goto    delayLoop			; Loop back to delayLoop if not yet 0
	
	decfsz  delayCounter2, F		; Decrement inner loop counter2, skip next instruction if 0
	goto    delayLoop			; Loop back to delayLoop if not yet 0

	decfsz  delayLevel, F			; Decrement outer loop counter, skip next instruction if 0
	goto    delayBody			; Loop back to delayBody if not yet 0
	
	return	
