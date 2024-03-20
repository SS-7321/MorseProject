#include <xc.inc>
extrn	StringSetup, StringToLCD	; from string
extrn	UARTTransmitByte, byte_higher   ; from UART
extrn	LCDSecondLine, LCDSendByteData	; from LCD

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
;   was a specific message received? (FF FF?)
	tstfsz	byte_higher, A
;   if received:
	goto	receivedFF
;   if not received:
	goto	GetConnection

receivedFF:
    