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
	setf
	
	TRISJ, a

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
	bsf	LATJ, 0, a
	
	movff	button, previous_cycle	; new read cycle, move current to prev
	call	ButtonReadCycle		; check current state
	call	CheckCycle		; decides what to do depending on current and previous cycles
;   is both incoming bytes received?
	tstfsz	byte_higher, A	
;   if both received:
	goto	PrintSequence		; moves the the decrypt, decode and display sequence
;   if not both received:
	bsf	LATJ, 3, a
	goto	loop

	
ResetValues:	; resets the values of the following variables before encoding the next character
	movlw	0x01
	movwf	bit_position, A
	clrf	encoded_byte
	clrf	on_cycles
	clrf	boolean_do_send
	return
	
PrintSequence:	; decrypts, decodes and displays the received message
	call	ButtonToLCD ; decrypt, decode, display function
	clrf	byte_higher ; clears byte adresses for higher received byte
	clrf	byte_lower  ; clears byte address for lower received byte
	goto	loop	    ; LOOPS BACK
	
CheckCycle:
;   is the button pressed?
        tstfsz	button, A   
;   if pressed:	
	goto	cycleIsOn
;   if not pressed:
	goto	cycleIsOff
	
	
cycleIsOn:
	call	BuzzerStart	    ; starts buzzer sound
	incf	on_cycles	    ; increases number of on cycles recorded
	incf	RNG_counter	    ; increments a variable for mersenne twister
	clrf	off_cycles	    ; clears number of off cycles recorded
	setf	boolean_do_send, A  ; sets the encoding boolean to be true
	return
	
	
cycleIsOff:
	call	BuzzerStop	; 
    	incf	off_cycles
;   was the previous cycle off?
	tstfsz	previous_cycle, A
;   if previous cycle was on:
	goto	checkOnLength	; just finished input, goto encode result
;   if previous cycle was off:
	goto	checkOffLength	; check current pause length
	

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
	
dotOrDash:
	movlw	8      ; dash if 8 cycles long (12x20ms)
	cpfsgt	on_cycles, A
	goto	encodeDot
	goto	encodeDash

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

	call	Encrypt
	call	ResetValues
	return
end	rst


