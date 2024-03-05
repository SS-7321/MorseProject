#include <xc.inc>

extrn	DAC_Setup, DAC_Int_Hi
extrn	ADC_Setup, ADC_Read, ADC_Alternate, AMPLH

psect	code, abs
rst:	org	0x0000	; reset vector
	
	bsf	TMR0IE
	bsf	GIE
	goto	start

int_hi:	org	0x0008	; high vector, no low vector
	goto	DAC_Int_Hi
	
start:	call	DAC_Setup
	call	ADC_Setup
	clrf	TRISD, A
;	movlw	0x0F
;	movwf	PORTD, A
;	goto	$	; Sit in infinite loop



loop:	movlw	0x0F
	movwf	PORTD, A
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	movlw	0x00
	movwf	PORTD, A
	
	call	ADC_Alternate
	goto	loop	
	
end	rst