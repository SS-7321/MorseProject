#include <xc.inc>
;   external functions 
extrn	StringSetup, StringToLCD	    ; from string
extrn	UARTTransmitByte, UARTClearBytes    ; from UART
extrn	LCDClear, LCDSecondLine, LCDSendByteData, DelayMS   ; from LCD
extrn	MersenneTwister	    ; from encryption
    
;   external variables
extrn	key, byte_higher, byte_lower, RNG_counter, random_byte, MT_coefficient
   
    
global	ConnectSetup, GetConnection	; global functions
psect	udata_acs
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
	incf	RNG_counter, F, A
	call	MersenneTwister
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
	incf	RNG_counter, F, A
	call	MersenneTwister
	movff	random_byte, MT_coefficient
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
	call	MersenneTwister
	
check0x0F:
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movf	random_byte, W, A
	call	DelayMS
	movlw	0x0F
;   received connection confirmation byte? (F0 0F?) 
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
	
	call	MersenneTwister
	movlw	4
	addwf	random_byte, W, A
	call	DelayMS
	
	movff	random_byte, key
	movf	random_byte, W, A
	call	UARTTransmitByte
	movf	random_byte, W, A
	call	UARTTransmitByte
	
	movlw	0xFF
	call	DelayMS
	
	movff	byte_higher, key
	movlw	0x34		    ; 4
	call	LCDSendByteData
	
timeDelay:
	movlw	0xFF		    ; waits 9x255ms
	call	DelayMS
	decfsz	time_counter, A
	goto	timeDelay
	
	call	LCDClear
	call	UARTClearBytes
	return