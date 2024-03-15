#include <xc.inc>

extrn	key, enc_byte
extrn	UART_Transmit_Byte
global	ENCL, ENCH, encrypt_setup, encrypt, RNG_counter

psect	udata_acs
RNG_counter:	ds  1
ax:	ds  1
RAND:	ds  1

PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM

ENCH:	ds  1
ENCL:	ds  1


    
psect	encrypt_code, class=CODE
    
encrypt_setup:
	movlw   0xA0
	movwf   RNG_counter
	movlw   0x04
	movwf   ax, A
	

encrypt_reset:
	clrf	RAND
	clrf	ENCH
	clrf	ENCL
	return
	
mix_rand:	;   mix encoded byte and rnadom number
		;   random: FA and encoded byte: EB
		;   final bytes are FE BA
	movlw	0x0F		;   Filter A from FA as OA
	andwf	RAND, W, A	;   
	movwf	ENCL, A		;   moves OA to lower encrypted byte (ENCL)
	
	movlw	0xF0		;   filter F from FA as F0
	andwf	RAND, W, A	;
	movwf	ENCH, A		;   moves that to ENCH
	
	movlw	0x10		;   splits EB into 0E B0
	mulwf	enc_byte, A	;
	movf	PRODH, W, A	;   adds 0E to ENCH to get FE
	addwf	ENCH, F, A	;
	
	movf	PRODL, W, A	;   gets BO from PRODL register
	addwf	ENCL, F, A	;   adds B0 to ENCL to get BA
	return
	
xor_LH:		;   XOR FE with BA
	movf	ENCL, W, A
	xorwf	ENCH, F, A
	return
	
mersenne_twister:
	movf	ax, W, A
	mulwf	RAND, A
	movff	PRODL, RAND
	movf	RNG_counter, W, A
	addwf	RAND, F, A
	return

encrypt:
	call	encrypt_reset
	call	mersenne_twister
	call	mix_rand
	call	xor_LH
	movf	ENCL, W, A
	call	UART_Transmit_Byte
	movf	ENCH, W, A
	call	UART_Transmit_Byte
	
	return
	
end