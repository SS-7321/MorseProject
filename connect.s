#include <xc.inc>
extrn	StringSetup, StringToLCD	; from string
extrn	UARTTransmitByte, byte_higher, UARTClearBytes   ; from UART
extrn	LCDClear, LCDSecondLine, LCDSendByteData, DelayMS	; from LCD

global	ConnectSetup, GetConnection
psect	udata_acs
string_counter:	ds 1
	
psect	connect_code,class=CODE
	
ConnectSetup:
	call	StringSetup
	call	StringToLCD
	call	LCDSecondLine
	return

GetConnection:
	movlw	0x31		    ; 1
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
check0xFF:
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
	movlw	0x32		    ; 2
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0x3E		    ; >>
	call	LCDSendByteData
	movlw	0xFF		    ; waits 100ms
	call	DelayMS
	movlw	0x0F
	call	UARTTransmitByte    ; send confirmation byte
	
check0x0F:
	movlw	0x0F
;   received connection confirmation byte? (F0 0F?) 
	cpfseq	byte_higher, A
;   if not received:
	goto	check0x0F
;   if received	:
	movlw	0x33		    ; 3
	call	LCDSendByteData
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	movlw	0xFF		    ; waits 255ms
	call	DelayMS
	call	LCDClear
	call	UARTClearBytes
	return