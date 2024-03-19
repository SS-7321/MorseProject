#include <xc.inc>
    
global  BuzzerSetup, BuzzerStart, BuzzerStop


psect	buzzer_code,class=CODE

BuzzerSetup:	;   sets up CCP8 module to be a PWM of 2.44Hz
	bsf	TRISB, 6, A
	clrf	TRISE, A    ; outputs PWM signal to PORT E pin 4
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

BuzzerStart:	;   starts PWM by starting the timer (TIMER 2)
	btfss	T2CON, 2    ; check if timer is on (TMR2ON bit set?)
	bsf	T2CON, 2    ; turn on if it was off
	return
	
BuzzerStop:	;   stops PWM by stopping the timer (TIMER 2)
	btfsc	T2CON, 2    ; check if timer is off (TMR2ON bit cleared?)
	bcf	T2CON, 2    ; turn off if it was on
	return

