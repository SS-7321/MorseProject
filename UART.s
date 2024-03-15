#include <xc.inc>
extrn	bt_to_LCD
global  UART_Setup, UART_Transmit_Byte, m_byte, byte_higher, byte_lower, UART_Int

psect	udata_acs   ; reserve data space in access ram
UART_counter:	ds  1	    ; reserve 1 byte for variable UART_counter
byte_higher:	ds  1
byte_lower:	ds  1
m_byte:	ds  1

psect	uart_code,class=CODE
UART_Setup:
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bcf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bcf	    BRG16	; 8-bit generator only
    movlw   103		; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RG6 pin
					; must set TRISG6 to 1

    bsf	    TRISC6, a
    bsf	    TRISC7, a
    bsf	    RC1IE		; interrupt
    bsf	    CREN		; enable data recption
    bsf	    GIE			; Global interrupt enable bit
    bsf	    PEIE		; Peripherals interrupt enable bit
    
    return

UART_Transmit_Message:	    ; Message stored at FSR2, length stored in W
    movwf   UART_counter, A

UART_Loop_message:
    movf    POSTINC2, W, A
    call    UART_Transmit_Byte
    decfsz  UART_counter, A
    bra	    UART_Loop_message
    return

UART_Transmit_Byte:	    ; Transmits byte stored in W
    btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
    bra	    UART_Transmit_Byte
    movwf   TXREG1, A
    return

UART_Int:
    btfss   RC1IF		; check that flag bit is set
    retfie  f			; if not then return
    movff   RCREG1, m_byte, A	; move value from register to m_byte
    call    bt_to_LCD
    bcf	    RC1IF		; clear interrupt flag
    retfie  f			; fast return from interrupts