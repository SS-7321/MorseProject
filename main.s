#include <xc.inc>



extrn	button, ButtonSetup, ButtonReadCycle	; from button
extrn	LCDSetup				; from LCD
extrn	ButtonToLCD, DecodeSetup		; from decode
extrn	EncryptSetup, Encrypt, RNG_counter	; from encryption
extrn	BuzzerSetup, BuzzerStart, BuzzerStop	; from buzzer
extrn	UARTInterrupt, UARTSetup, byte_higher, byte_lower   ; from UART
    
global	key, encoded_byte
    
psect	udata_acs   ; reserve data space in access ram
previous_cycle: ds  1
on_cycles:	ds  1
off_cycles:	ds  1
bit_position:	ds  1
encoded_byte:   ds  1
boolean_do_send:ds  1
key:		ds  1


psect	code, abs

rst:	org	0x0000	; reset vector
	
	bsf	GIE
	goto	start

int_hi:	org	0x0008	; high vector, no low vector
	
	call	UARTInterrupt
	return
	
start:	
        call	ButtonSetup
	call	DecodeSetup
	call	LCDSetup
	call	EncryptSetup
	call	BuzzerSetup
	call	UARTSetup
	call	ResetValues
	goto	loop
	
loop:	
	movff	button, previous_cycle	; new read cycle, move current to prev
	call	ButtonReadCycle		; check current state
	call	CheckCycle
	
	tstfsz	byte_higher, A
	goto	PrintSequence
	goto	loop

	
ResetValues:
	movlw	0x01
	movwf	bit_position, A
	clrf	encoded_byte
	clrf	on_cycles
	clrf	boolean_do_send
	return
	
PrintSequence:
	call	ButtonToLCD
	clrf	byte_higher
	clrf	byte_lower
	goto	loop
	
CheckCycle:
        tstfsz	button, A   ; check if the button is pressed
	goto	CycleIsOn    ; pressed
	goto	CycleIsOff   ; not pressed
	
	
CycleIsOn:
	call	BuzzerStart
	incf	on_cycles
	incf	RNG_counter
	clrf	off_cycles
	setf	boolean_do_send, A
	return
	
	
CycleIsOff:
	call	BuzzerStop
    	incf	off_cycles
;   was the previous cycle off?
	tstfsz	previous_cycle, A
;   if previous cycle was on:
	goto	checkOnLength	    ; just finished input, goto encode result
;   if previous cycle was off:
	goto	checkOffLength    ; check current pause length
	return

checkOffLength:
;   is pause long enough for new character?
	movlw	10
	cpfsgt	off_cycles, A
	return	;   return if not a new character
;   if long enough:
;   Encrypted a byte before within this pause?
 	tstfsz	boolean_do_send, A
	goto	wrap
	return
	
wrap:
;   if not Encrypted before:
;   set the identifier bit
	movf	bit_position, W, A
	xorwf	encoded_byte, F, A
	call	finishEncoding
	clrf	encoded_byte
	clrf	boolean_do_send, A
	clrf	off_cycles
	
	return
	
checkOnLength:
;   is prev input dot or dash?
	movlw	20
	cpfsgt	on_cycles, A
	goto	dotOrDash
	
	setf	encoded_byte, A
	clrf	on_cycles
	goto	finishEncoding
	return
	
dotOrDash:
	movlw	8      ; dash if 8 cycles long (12x20ms)
	cpfsgt	on_cycles, A
	goto	encodeDot
	goto	encodeDash
	
	return

encodeDash:
	movf	bit_position, W, A
	xorwf	encoded_byte, F, A
	rlncf	bit_position, F, A
	clrf	on_cycles

	
	return
encodeDot:

	rlncf	bit_position, F, A
	clrf	on_cycles
	return
	
finishEncoding:

;   move encoded byte to Wreg
	call	Encrypt
	call	ResetValues
	return
end	rst


