#include <xc.inc>
    
global  kp_setup, kp_read_60ms
global	key, keyUp, keyLo

psect	udata_acs   ; reserve data space in access ram
state:	    ds	1	    ; reserve 1 byte
key:	    ds	1	    ; reserve 1 byte
key_temp:	    ds 1
kp_rc:   ds	1
kp_dc: ds 1	    ; reserve 1 byte
keyUp:	    ds	1
keyLo:	    ds	1
kprcms1:    ds	1
kprcms2:    ds	1

psect	keypad_code,class=CODE

kp_setup:
	clrf	LATE
	movlb	0x0F
	bsf	REPU
	call	kp_reset
	return
	
kp_reset:
	clrf	key
	movlw	0xF0
	movwf	state, A
	movwf	TRISE, A
	movlw	0
 	movwf	key, A
	return
	
	
kp_read:
	call	kp_get_keyUp
	call	kp_switch
	call	delay_880ns
	call	kp_get_keyLo
	movf	keyUp, W, A
	addwf	keyLo, W, A
	movwf	key_temp, A
	movlw	0xFF
	xorwf	key_temp, F, A
	call	kp_switch
	call	delay_880ns
	return
	
	
kp_switch:
	swapf	state, F, A
	movff	state, TRISE, A
	return
	
kp_get_keyUp:
	movff	PORTE, keyUp
	;movf	state, W, A
	;andwf	keyUp, W, A
	;movwf	keyUp, A
	return
	
kp_get_keyLo:
	movff	PORTE, keyLo
	;movf	state, W, A
	;andwf	keyLo, W, A
	;movwf	keyLo, A
	return

keys_and:
	movf	key_temp, W, A
	iorwf	key, F, A
	return

kp_read_60ms:
	call	kp_reset
	movlw	0x01
	movwf	kprcms1, A
	movwf	kprcms2, A
	movlw	0x01
	movwf	kp_rc, A
kprlms:
	movff	key_temp, key, A
	call	kp_read
	call	keys_and
	decfsz	kprcms1, F, A
	goto	kprlms
	
	movff	key_temp, key
	call	kp_read
	call	keys_and
	decfsz	kprcms2, F, A
	goto	kprlms
	
	movff	key_temp, key
	call	kp_read
	call	keys_and
	decfsz	kp_rc, F, A
	goto	kprlms
	retlw	key

delay_880ns:
	movlw	0x5A
	movwf	kp_dc
kpdloop:
	decfsz	kp_dc, F, A
	goto	kpdloop
	return
	
	
	end
	
