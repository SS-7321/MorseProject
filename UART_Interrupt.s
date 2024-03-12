#include <xc.inc>
	
global	UART_Setup, UART_Int
    
psect	dac_code, class=CODE

UART_Setup:
	bsf	SPEN		; enable
	bcf	SYNC		; synchronous
	bcf	BRGH		; slow speed
	bsf	TXEN		; enable transmit
	bcf	BRG16		; 8-bit generator only
	movlw   103		; gives 9600 Baud rate (actually 9615)
	movwf   SPBRG1, A	; set baud rate
	bsf	TRISC, PORTC_TX1_POSN, A    ; TX1 pin is output on RC6 pin
					    ; must set TRISC6 to 1
	bsf	RCxIE		; interrupt
	bsf	CREN		; Receiving bit
	bsf	GIE
	bsf	PEIE
					    
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
    
