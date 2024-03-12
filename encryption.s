#include <xc.inc>

extrn	key, enc_byte
global	ENCL, ENCH
    
PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
RAND:	ds  1
ENCH:	ds  1
ENCL:	ds  1
    
    
psect	encrypt_code, class=CODE

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
	mulwf	enc_byte	;
	movf	PRODH, W, A	;   adds 0E to ENCH to get FE
	addwf	ENCH, F, A	;
	
	movf	PRODL, W, A	;   gets BO from PRODL register
	addwf	ENCL, F, A	;   adds B0 to ENCL to get BA
	return
	
xor_LH:		;   XOR FE with BA
	movf	ENCL, W, A
	xorwf	ENCH, F, A
	return
	
	
encrypt:
	call	encrypt_reset
	call	mix_rand
	call	xor_LH
	return
	
end