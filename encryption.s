#include <xc.inc>

extrn	key, encoded_byte
extrn	UARTTransmitByte
global	encrypted_byte_lower, encrypted_byte_higher, EncryptSetup, Encrypt, RNG_counter

psect	udata_acs
RNG_counter:	ds  1
MT_coefficient:	ds  1
random_byte:	ds  1

PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM

encrypted_byte_higher:	ds  1
encrypted_byte_lower:	ds  1


    
psect	Encrypt_code, class=CODE
    
EncryptSetup:
	movlw   0xA0
	movwf   RNG_counter
	movlw   0x04
	movwf   MT_coefficient, A
	

EncryptReset:
	clrf	random_byte
	clrf	encrypted_byte_higher
	clrf	encrypted_byte_lower
	return
	
MixRandomBytes:	;   mix encoded byte and rnadom number
		;   example - random: FA and encoded byte: EB
		;   final mixed bytes are FE BA
	movlw	0x0F			    ; Filter A from FA as OA
	andwf	random_byte, W, A	    ;   
	movwf	encrypted_byte_lower, A	    ; moves OA to lower Encrypted byte (encrypted_byte_lower)
	
	movlw	0xF0			    ; filter F from FA as F0
	andwf	random_byte, W, A	    ;
	movwf	encrypted_byte_higher, A    ; moves that to encrypted_byte_higher
	
	movlw	0x10			 
	mulwf	encoded_byte, A		    ; splits EB into 0E B0
	movf	PRODH, W, A		 
	addwf	encrypted_byte_higher, F, A ; adds 0E to encrypted_byte_higher to get FE
	
	movf	PRODL, W, A		    ; gets BO from PRODL register
	addwf	encrypted_byte_lower, F, A  ; adds B0 to encrypted_byte_lower to get BA
	return
	
XORLowHigh:	;   XOR FE with BA and saves it in place of FE
	movf	encrypted_byte_lower, W, A
	xorwf	encrypted_byte_higher, F, A
	return
	
MersenneTwister:    ;	simple mersenne twister algorithm of modulus 255 (FFh)
	movf	MT_coefficient, W, A
	mulwf	random_byte, A
	movff	PRODL, random_byte
	movf	RNG_counter, W, A   ; counter determined by previous number of on cycles
	addwf	random_byte, F, A
	return

Encrypt:
	movf	key, W, A		    ; XOR encoded byte with predefined key
	xorwf	encoded_byte, F, A
	call	EncryptReset		    ; resets relevant variables
	call	MersenneTwister		    ; uses mersenne twister algorithm to generate a random byte
	call	MixRandomBytes		    ; fills random byte around encoded byte
	call	XORLowHigh		    ; XORs the higher and lower byte
	movf	encrypted_byte_lower, W, A  
	call	UARTTransmitByte	    ; send the lower encrypted byte via UART
	movf	encrypted_byte_higher, W, A
	call	UARTTransmitByte	    ; send the higher encrypted byte via UART

	return
	
end