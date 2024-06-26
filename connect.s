#include <xc.inc>
;   external functions 
extrn	StringSetup, StringToLCD	    ; from string
extrn	UARTTransmitByte, UARTClearBytes    ; from UART
extrn	LCDClear, LCDSecondLine, LCDSendByteData, DelayMS   ; from LCD
extrn	LCG	    ; from encryption
    
;   external variables
extrn	key, byte_higher, byte_lower, RNG_counter, random_byte, LCG_coefficient
   
    
global	ConnectSetup, GetConnection	; global functions
PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
time_counter:	ds 1
	
psect	connect_code,class=CODE
	
ConnectSetup:
	movlw	9
	movwf	time_counter, A
	call	StringSetup
	call	StringToLCD
	call	LCDSecondLine
	return

GetConnection:
	incf	RNG_counter, F, A
	movlw	0x31		    ; 1
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
check0xFF:
	incf	RNG_counter, F, A   ; generates random number
	call	LCG
	movlw	0xFF
	call	UARTTransmitByte    ; transmit byte to check for connection
	movlw	100		    ; waits 100ms
	call	DelayMS
;   was a specific message received? (FF FF?)
	tstfsz	byte_higher, A
;   if received:
	goto	receivedFF
;   if not received:
	goto	check0xFF

receivedFF:
	incf	RNG_counter, F, A   ; generates random number to set as coeff for LCG
	call	LCG
	movff	random_byte, LCG_coefficient
	movlw	0x32		    ; 2
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0x0F
	call	UARTTransmitByte    ; send confirmation byte
	call	LCG
	
check0x0F:
	movlw	0xFF		    ; waits a random number of ms
	call	DelayMS
	movf	random_byte, W, A
	call	DelayMS
	movlw	0x0F
;   received connection confirmation byte? (0F 0F?) 
	cpfseq	byte_higher, A
;   if not received:
	goto	check0x0F
;   if received	:
	call	UARTClearBytes
	movlw	0x33		    ; 3
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	goto	timeDelay
	
sendKey:
	
	call	LCG	    ; waits a random number of ms
	movlw	4
	addwf	random_byte, W, A
	call	DelayMS
	
	movff	random_byte, byte_higher    ; random number generated --> key
	movf	random_byte, W, A	    ; send the random key via UART
	call	UARTTransmitByte
	movf	random_byte, W, A
	call	UARTTransmitByte
	
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	
	movff	byte_higher, key    ; received byte --> key
	
	movlw	0x34		    ; 4
	call	LCDSendByteData
	
timeDelay:
	movlw	0xFF		    ; waits 9x255ms
	call	DelayMS
	decfsz	time_counter, A
	goto	timeDelay
	
	call	LCDClear	    ; clears LCD and received byte addresses                   
	call	UARTClearBytes
	return
