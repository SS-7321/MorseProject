#include <xc.inc>

extrn	button, ButtonSetup, ButtonReadCycle	; from button
extrn	LCDSetup				; from LCD
extrn	ButtonToLCD, DecodeSetup		; from decode
extrn	EncryptSetup, Encrypt, RNG_counter	; from encryption
extrn	BuzzerSetup, BuzzerStart, BuzzerStop	; from buzzer
extrn	UARTInterrupt, UARTSetup, byte_higher, UARTClearBytes   ; from UART
extrn	ConnectSetup, GetConnection
    
global	key, encoded_byte
    
psect	udata_acs   ; reserve data space in access ram -------------------------
previous_cycle: ds  1
on_cycles:	ds  1
off_cycles:	ds  1
bit_position:	ds  1
encoded_byte:   ds  1
boolean_do_send:ds  1
key:		ds  1
    
psect	code, abs   ;	--------------------------------------------------------
	
rst:	org	0x0000	; reset vector
	goto	start	

int_hi:	org	0x0008	; high vector, no low vector
	
	call	UARTInterrupt
	return
	
start:	;   calls all module setups and goes to main loop
	movlw	0x65
	movwf	key, A
        call	ButtonSetup
	call	DecodeSetup
	call	LCDSetup
	call	EncryptSetup
	call	BuzzerSetup
	call	UARTSetup
	call	ResetValues
	;call	ConnectSetup
	;call	BuzzerStop
	;call	GetConnection
	goto	loop
	
loop:	;   main loop
	movff	button, previous_cycle	; new read cycle, move current to prev
	call	ButtonReadCycle		; check current state
	call	CheckCycle		; decides what to do depending on current and previous cycles
;   is both incoming bytes received?
	tstfsz	byte_higher, A	
;   if both received:
	goto	PrintSequence		; moves the the decrypt, decode and display sequence
;   if not both received:
	
	goto	loop

	
ResetValues:	; resets the values of the following variables before encoding the next character
	movlw	0x01
	movwf	bit_position, A
	clrf	encoded_byte
	clrf	on_cycles
	clrf	boolean_do_send
	return
	
PrintSequence:	; decrypts, decodes and displays the received message
	call	ButtonToLCD	; decrypt, decode, display function

	call	UARTClearBytes	; clears received byte addresses

	goto	loop
	
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
	call	BuzzerStop	; stops the buzzer
    	incf	off_cycles	; increasee the number of recorded off cycles
;   was the previous cycle off?
	tstfsz	previous_cycle, A
;   if previous cycle was on:
	goto	checkOnLength	; just finished input, goto encode result
;   if previous cycle was off:
	goto	checkOffLength	; check current pause length
	

checkOffLength:
;   is pause long enough for new character?
	movlw	10  ; new character after 10x20ms
	cpfsgt	off_cycles, A
;   if not long enough:
	return	    ; return if not a new character
;   if long enough:
    ;   encrypted a byte within this pause before? (encoding byte is true?)

 	tstfsz	boolean_do_send, A 
    ;	if not encrypted a byte yet:
	goto	wrap
    ;   if already encrypted a byte before:
	return
	
wrap:
;   if not Encrypted before:

	movf	bit_position, W, A  ; shifts the bit position up
	xorwf	encoded_byte, F, A  ; set the identifier bit in the encoded byte
	call	finishEncoding	    ; goes to sending encoded byte sequence
	clrf	off_cycles	    ; clears the number of off cycles recorded
	
	return
	
checkOnLength:
;   is previous input long enough to be a space (empty character)?
	movlw	20		    ; space if pressed for 20x20ms
	cpfsgt	on_cycles, A
;   if not long enough to be a space: (must be a dot or a dash)	
	goto	dotOrDash
;   if long enough to be a space:	
	setf	encoded_byte, A	    ; sets the encoded byte to be FFh
	clrf	on_cycles	    ; clears the number of on cycles 
	goto	finishEncoding	    ; goes to sending encoded byte sequence
	
dotOrDash:
;   is previous input long enough to be a dash?    
	movlw	8      ; dash if 8 cycles long (8x20ms)
	cpfsgt	on_cycles, A
;   if not long enough: (must be a dot)	
	goto	encodeDot
;   if long enough to be a dash:	
	goto	encodeDash

encodeDash: ;	dashes are encoded as 1
	movf	bit_position, W, A  ; XOR the bit_position and encoded byte
	xorwf	encoded_byte, F, A  ; encoded byte:     0 0 0 0 0 1 0 1
				    ; bit position:	0 0 0 0 1 0 0 0
				    ; XOR above bytes----------------------
				    ; new encoded byte: 0 0 0 0 1 1 0 1
				    
	rlncf	bit_position, F, A  ; shifts bit position up
				    ; new bit position: 0 0 0 1 0 0 0 0
	clrf	on_cycles	    ; clears the number of on cycles recorded

	return
	
encodeDot:  ;	dots are encoded as 0
				    ; encoded byte is 00h at the start - no need to set bits to be 0
	rlncf	bit_position, F, A  ; shifts bit position up
	clrf	on_cycles	    ; clears the number of on cycles recorded
	
	return
	
finishEncoding:

	call	Encrypt		; calls encryption and UART sending function
	call	ResetValues	; resets relavent values for new character input
	return
end	rst


