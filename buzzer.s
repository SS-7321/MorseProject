#include <xc.inc>
    
global  buz_setup, buz_start, buz_stop


psect	buzzer_code,class=CODE

buz_setup:
	bsf	TRISB, 6, A
	clrf	TRISE, A
	clrf	CCPTMRS2
	movlw	0xFF
	movwf	PR2
	BANKSEL CCPR8L
	movlw	0x00
	movwf	CCPR8L

	movlw	00000111B
	movwf	T2CON
	BANKSEL	CCP8CON
	movlw	00111100B
	movwf	CCP8CON
	movlb	0x00
	return

buz_start:
	btfss	T2CON, 2
	bsf	T2CON, 2
	return
	
buz_stop:
	btfsc	T2CON, 2
	bcf	T2CON, 2
	return

