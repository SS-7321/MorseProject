#include <xc.inc>
global  UARTSetup, UARTTransmitByte, UARTInterrupt, UARTClearBytes ; global functions
global  byte_higher, byte_lower	; global variables

psect	udata_acs   ; reserve data space in access ram
UART_counter:	ds  1	    ; reserve 1 byte for variable UART_counter
byte_higher:	ds  1
byte_lower:	ds  1
byte_counter:	ds  1

psect	uart_code,class=CODE
UARTSetup:
    bsf	    SPEN	;   enable
    bcf	    SYNC	;   synchronous
    bcf	    BRGH	;   slow speed
    bsf	    TXEN	;   enable transmit
    bcf	    BRG16	;   8-bit generator only
    movlw   103		;   gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	;   set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	;   TX1 pin is output on RC6 pin
    bsf	    RC1IE	;   interrupt
    bsf	    CREN	;   Receiving bit
    bsf	    GIE
    bsf	    PEIE
    clrf    byte_counter
    call    UARTClearBytes

    
    return
    
UARTClearBytes:	;   clears received byte addresses
    clrf    byte_lower
    clrf    byte_higher
    return

UARTTransmitMessage:	    ;	Message stored at FSR1, length stored in W
    movwf   UART_counter, A

UARTLoopMessage:
    movf    POSTINC2, W, A
    call    UARTTransmitByte
    decfsz  UART_counter, A
    bra	    UARTLoopMessage
    return

UARTTransmitByte:	    ;	Transmits byte stored in W
    btfss   TX1IF	    ;	TX1IF is set when TXREG1 is empty
    bra	    UARTTransmitByte
    movwf   TXREG1, A
    return

UARTInterrupt:
    btfss   RC1IF		;   check that flag bit is set
    retfie  f			;   if not then return
    
    tstfsz  byte_counter, A	;   check if this is the first or second byte
    goto    receiveHigherByte	;   goes to respective routines
    goto    receiveLowerByte
    
receiveHigherByte:
    movff   RCREG1, byte_higher	;   move value from register to higher byte
    clrf    byte_counter, A
    bcf	    RC1IF		;   clear interrupt flag
    retfie  f			;   fast return from interrupts
  
receiveLowerByte:
    movff   RCREG1, byte_lower	;   move value from register to lower byte
    incf    byte_counter, F, A
    bcf	    RC1IF		;   clear interrupt flag
    retfie  f			;   fast return from interrupts
    
