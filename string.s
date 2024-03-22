#include <xc.inc>
extrn	LCDClear, LCDWriteMessage, LCDSecondLine    ; external functions
    
global	StringSetup, StringToLCD    ; global functions

psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
StringSpace:    ds 0x80 ; reserve 128 bytes for message data
psect	udata_acs
string_counter:	ds 1
psect	data    
	; ******* StringMessage, data in programme memory, and its length *****
StringMessage:
	db	'C','o','n','n','e','c','t','i','n','g','.','.','.',0x0a    ; message, plus carriage return
	string_length   EQU    13	; length of data

	align	2
	
psect	string_code,class=CODE
	
StringSetup:
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	return
	
StringToLCD:
	call	LCDClear
	lfsr	0, StringSpace		; Load FSR0 with address in RAM	
	movlw	low highword(StringMessage)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(StringMessage)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(StringMessage)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	string_length		; bytes to read
	movwf 	string_counter, A		; our counter register
stringLoop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	string_counter, A		; count down to zero
	bra	stringLoop		; keep going until finished
		
	movlw	string_length		; output message to LCD
	lfsr	2, StringSpace
	call	LCDWriteMessage
	return


