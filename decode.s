#include <xc.inc>
    
extrn	byte_higher, byte_lower, key	; external variables
extrn	LCDSendByteData, LCDClear, LCDSecondLine, LCDFirstLine	; external functions
    
global	ButtonDecodeA, ButtonToLCD, DecodeSetup	    ; global functions


psect	udata_acs   ; reserve data space in access ram
cursor_counter:	ds 1
decrypted_byte: ds 1

psect	decode_code, class=CODE
    
DecodeSetup:
	clrf    cursor_counter
    
ButtonDecodeA:
	movlw	0x06		    ; byte for A
	cpfseq	decrypted_byte,a    ; compare received value to 'A' byte
	goto	ButtonDecodeB	    ; if not same, skips to next value
	retlw	0x41		    ; if true, return ASCII for 'A'
	
ButtonDecodeB:
	movlw	0x11		;B
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeC
	retlw	0x42
	
ButtonDecodeC:
	movlw	0x15		;C
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeD
	retlw	0x43
	
ButtonDecodeD:
	movlw	0x09		;D
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeE
	retlw	0x44
	
ButtonDecodeE:
	movlw	0x02		;E
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeF
	retlw	0x45
	
ButtonDecodeF:
	movlw	0x14		;F
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeG
	retlw	0x46
	
ButtonDecodeG:
	movlw	0x0B		;G
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeH
	retlw	0x47
	
ButtonDecodeH:
	movlw	0x10		;H
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeI
	retlw	0x48
	
ButtonDecodeI:
	movlw	0x04		;I
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeJ
	retlw	0x49
	
ButtonDecodeJ:
	movlw	0x1E		;J
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeK
	retlw	0x4A
	
ButtonDecodeK:
	movlw	0x0D		;K
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeL
	retlw	0x4B
	
ButtonDecodeL:
	movlw	0x12		;L
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeM
	retlw	0x4C
	
ButtonDecodeM:
	movlw	0x07		;M
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeN
	retlw	0x4D
	
ButtonDecodeN:
	movlw	0x05		;N
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeO
	retlw	0x4E
	
ButtonDecodeO:
	movlw	0x0F		;O
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeP
	retlw	0x4F
	
ButtonDecodeP:
	movlw	0x16		;P
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeQ
	retlw	0x50

ButtonDecodeQ:
	movlw	0x1B		;Q
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeR
	retlw	0x51

ButtonDecodeR:
	movlw	0x0A		;R
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeS
	retlw	0x52
	
ButtonDecodeS:
	movlw	0x08		;S
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeT
	retlw	0x53
	
ButtonDecodeT:
	movlw	0x03		;T
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeU
	retlw	0x54
	
ButtonDecodeU:
	movlw	0x0C		;U
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeV
	retlw	0x55
	
ButtonDecodeV:
	movlw	0x18		;V
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeW
	retlw	0x56
	
ButtonDecodeW:
	movlw	0x0E		;W
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeX
	retlw	0x57
	
ButtonDecodeX:
	movlw	0x19		;X
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeY
	retlw	0x58
	
ButtonDecodeY:
	movlw	0x1D		;Y
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeZ
	retlw	0x59
	
ButtonDecodeZ:
	movlw	0x13		;Z
	cpfseq	decrypted_byte,a
	goto	ButtonDecode1
	retlw	0x5A
	
ButtonDecode1:
	movlw	0x3E		;1
	cpfseq	decrypted_byte,a
	goto	ButtonDecode2
	retlw	0x31
	
ButtonDecode2:
	movlw	0x3C		;2
	cpfseq	decrypted_byte,a
	goto	ButtonDecode3
	retlw	0x32

ButtonDecode3:
	movlw	0x38		;3
	cpfseq	decrypted_byte,a
	goto	ButtonDecode4
	retlw	0x33
	
ButtonDecode4:
	movlw	0x30		;4
	cpfseq	decrypted_byte,a
	goto	ButtonDecode5
	retlw	0x34
	
ButtonDecode5:
	movlw	0x20		;5
	cpfseq	decrypted_byte,a
	goto	ButtonDecode6
	retlw	0x35
	
ButtonDecode6:
	movlw	0x21		;6
	cpfseq	decrypted_byte,a
	goto	ButtonDecode7
	retlw	0x36
	
ButtonDecode7:
	movlw	0x23		;7
	cpfseq	decrypted_byte,a
	goto	ButtonDecode8
	retlw	0x37
	
ButtonDecode8:
	movlw	0x27		;8
	cpfseq	decrypted_byte,a
	goto	ButtonDecode9
	retlw	0x38
	
ButtonDecode9:
	movlw	0x2F		;9
	cpfseq	decrypted_byte,a
	goto	ButtonDecode0
	retlw	0x39
	
ButtonDecode0:
	movlw	0x3F		;0
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeQuestionMark
	retlw	0x30
	
ButtonDecodeQuestionMark:
	movlw	0x4c		;?
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeExclamationMark
	retlw	0x3F
	
ButtonDecodeExclamationMark:
	movlw	0x75		;!
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeFullStop
	retlw	0x21
	
ButtonDecodeFullStop:
	movlw	0x6A		;.
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeFullComma
	retlw	0x2E
	
ButtonDecodeFullComma:
	movlw	0x73		;,
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeSemiColon
	retlw	0x2C
	
ButtonDecodeSemiColon:
	movlw	0x55		;;
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeColon
	retlw	0x3B
	
ButtonDecodeColon:
	movlw	0x47		;:
	cpfseq	decrypted_byte,a
	goto	ButtonDecodePlus
	retlw	0x3A
	
ButtonDecodePlus:
	movlw	0x2A		;+
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeHyphen
	retlw	0x2B
	
ButtonDecodeHyphen:
	movlw	0x61		;-
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeSlash
	retlw	0x2D
	
ButtonDecodeSlash:
	movlw	0x29		;/
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeEqual
	retlw	0x2F
	
ButtonDecodeEqual:
	movlw	0x31		;=
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeSPACE
	retlw	0x3D
	
ButtonDecodeSPACE:
	movlw	0xFF		;space
	cpfseq	decrypted_byte,a
	goto	ButtonDecodeERROR
	retlw	0x20
	

ButtonDecodeERROR:
	retlw	0x7E		;~

ButtonToLCD:	
	call	Decrypt
	call	ButtonDecodeA
	call	LCDSendByteData
	incf	cursor_counter, f, a	; increase cursor position counter
	movlw	0x10
	cpfseq	cursor_counter, a	; checks if cursor is at the end of 1st line
	goto	writeCharacter
	call	LCDSecondLine		; go to 2nd line if at end of 1st line
	
writeCharacter:
	movlw	0x20
	cpfseq	cursor_counter, a	; checks if cursor is at the end of 2nd line
	return
	call	LCDFirstLine		; goes back to 1st line if at the end of 2nd line
	clrf	cursor_counter, a	; resets cursor position
	return

Decrypt:

	movf	byte_lower, w, a    
	xorwf	byte_higher, f, a	; takes XOR of the two bytes
	movlw	0x10
	mulwf	byte_higher, a		; splits the higher byte
	movff	PRODL, decrypted_byte	; only takes the lower value
	
	movlw	0x10
	mulwf	byte_lower, a		; splits the lower byte
	movf	PRODH, W, A		; only takes the higher value
	addwf	decrypted_byte, F, A	; adds the two values to form decrypted byte
	movf	key, W, A
	xorwf	decrypted_byte, F, A	; XOR decrypted byte with predefined key

	
	return
	
	end
