#include <xc.inc>

global  LCDSetup, LCDWriteMessage, LCDClear, LCDSecondLine, LCDSendByteData, LCDWriteHex, LCDFirstLine

psect	udata_acs   ; named variables in access ram
LCD_counter_lower:	ds 1	; reserve 1 byte for variable LCD_counter_lower
LCD_counter_higher:	ds 1	; reserve 1 byte for variable LCD_counter_higher
LCD_counter_ms:	ds 1	; reserve 1 byte for ms counter
LCD_temporary:	ds 1	; reserve 1 byte for temporary use
LCD_counter:	ds 1	; reserve 1 byte for counting through nessage

PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
LCD_hex_temporary:	ds 1    ; reserve 1 byte for variable LCD_hex_temporary

	LCD_E	EQU 5	; LCD enable bit
    	LCD_RS	EQU 4	; LCD register select bit

psect	lcd_code,class=CODE
    
LCDSetup:
	clrf    LATB, A
	movlw   11000000B	; RB0:5 all outputs
	movwf	TRISB, A
	movlw   40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	00110000B	; Function set 4-bit
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00101000B	; 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00101000B	; repeat, 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00001111B	; display on, cursor on, blinking on
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	movlw	00000001B	; display clear
	call	LCD_Send_Byte_I
	movlw	2		; wait 2ms
	call	LCD_delay_ms
	movlw	00000110B	; entry mode incr by 1 no shift
	call	LCD_Send_Byte_I
	movlw	10		; wait 40us
	call	LCD_delay_x4us
	return

LCDWriteHex:			; Writes byte stored in W as hex
	movwf	LCD_hex_temporary, A
	swapf	LCD_hex_temporary, W, A	; high nibble first
	call	LCD_Hex_Nib
	movf	LCD_hex_temporary, W, A	; then low nibble
LCD_Hex_Nib:			; writes low nibble as hex character
	andlw	0x0F
	movwf	LCD_temporary, A
	movlw	0x0A
	cpfslt	LCD_temporary, A
	addlw	0x07		; number is greater than 9 
	addlw	0x26
	addwf	LCD_temporary, W, A
	call	LCDSendByteData ; write out ascii
	return	
	
LCDWriteMessage:	    ; Message stored at FSR2, length stored in W
	movwf   LCD_counter, A
LCD_Loop_message:
	movf    POSTINC2, W, A
	call    LCDSendByteData
	decfsz  LCD_counter, A
	bra	LCD_Loop_message
	return

LCD_Send_Byte_I:	    ; Transmits byte stored in W to instruction reg
	movwf   LCD_temporary, A
	swapf   LCD_temporary, W, A   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bcf	LATB, LCD_RS, A	; Instruction write clear RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_temporary, W, A   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bcf	LATB, LCD_RS, A	; Instruction write clear RS bit
        call    LCD_Enable  ; Pulse enable Bit 
	return

LCDSendByteData:	    ; Transmits byte stored in W to data reg
	movwf   LCD_temporary, A
	swapf   LCD_temporary, W, A	; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bsf	LATB, LCD_RS, A	; Data write set RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_temporary, W, A	; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB, A	    ; output data bits to LCD
	bsf	LATB, LCD_RS, A	; Data write set RS bit	    
        call    LCD_Enable  ; Pulse enable Bit 
	movlw	10	    ; delay 40us
	call	LCD_delay_x4us
	return

LCD_Enable:	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	LATB, LCD_E, A	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	LATB, LCD_E, A	    ; Writes data to LCD
	return
    
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms:		    ; delay given in ms in W
	movwf	LCD_counter_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_counter_ms, A
	bra	lcdlp2
	return
    
LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_counter_lower, A	; now need to multiply by 16
	swapf   LCD_counter_lower, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_counter_lower, W, A ; move low nibble to W
	movwf	LCD_counter_higher, A	; then to LCD_counter_higher
	movlw	0xf0	    
	andwf	LCD_counter_lower, F, A ; keep high nibble in LCD_counter_lower
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	LCD_counter_lower, F, A	; no carry when 0x00 -> 0xff
	subwfb 	LCD_counter_higher, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return

LCDClear:
	movlw	00000001B	; display clear
	call	LCD_Send_Byte_I
	movlw	0xFF
	call	LCD_delay_ms
	movlw	100
	call	LCD_delay_ms
	return
	
LCDSecondLine:		; moves cursor to second line
    movlw   0xC0
    call    LCD_Send_Byte_I
    movlw   10		; wait 40us
    call    LCD_delay_x4us
    return
    
LCDFirstLine:		; moves cursor to first line
    movlw   0x40
    call    LCD_Send_Byte_I
    movlw   10		; wait 40us
    call    LCD_delay_x4us
    return

    

end