#include <xc.inc>
;editted
global	bt_dec_A, Cursor_counter, bt_to_LCD, dec_setup, Decrypt
extrn	m_byte, byte_higher, byte_lower	; byte from UART
extrn	LCD_Send_Byte_D, LCD_clear, LCD_secondLine
extrn	UART_Transmit_Byte

psect	udata_acs   ; reserve data space in access ram
Cursor_counter:	ds 1

psect	decode_code, class=CODE
    
dec_setup:
	clrf    Cursor_counter
    
bt_dec_A:
	movlw	0x06		;A
	cpfseq	m_byte,a
	goto	bt_dec_B
	retlw	0x41
	
bt_dec_B:
	movlw	0x11		;B
	cpfseq	m_byte,a
	goto	bt_dec_C
	retlw	0x42
	
bt_dec_C:
	movlw	0x15		;C
	cpfseq	m_byte,a
	goto	bt_dec_D
	retlw	0x43
	
bt_dec_D:
	movlw	0x09		;D
	cpfseq	m_byte,a
	goto	bt_dec_E
	retlw	0x44
	
bt_dec_E:
	movlw	0x02		;E
	cpfseq	m_byte,a
	goto	bt_dec_F
	retlw	0x45
	
bt_dec_F:
	movlw	0x14		;F
	cpfseq	m_byte,a
	goto	bt_dec_G
	retlw	0x46
	
bt_dec_G:
	movlw	0x0B		;G
	cpfseq	m_byte,a
	goto	bt_dec_H
	retlw	0x47
	
bt_dec_H:
	movlw	0x10		;H
	cpfseq	m_byte,a
	goto	bt_dec_I
	retlw	0x48
	
bt_dec_I:
	movlw	0x04		;I
	cpfseq	m_byte,a
	goto	bt_dec_J
	retlw	0x49
	
bt_dec_J:
	movlw	0x1E		;J
	cpfseq	m_byte,a
	goto	bt_dec_K
	retlw	0x4A
	
bt_dec_K:
	movlw	0x0D		;K
	cpfseq	m_byte,a
	goto	bt_dec_L
	retlw	0x4B
	
bt_dec_L:
	movlw	0x12		;L
	cpfseq	m_byte,a
	goto	bt_dec_M
	retlw	0x4C
	
bt_dec_M:
	movlw	0x07		;M
	cpfseq	m_byte,a
	goto	bt_dec_N
	retlw	0x4D
	
bt_dec_N:
	movlw	0x05		;N
	cpfseq	m_byte,a
	goto	bt_dec_O
	retlw	0x4E
	
bt_dec_O:
	movlw	0x0F		;O
	cpfseq	m_byte,a
	goto	bt_dec_P
	retlw	0x4F
	
bt_dec_P:
	movlw	0x16		;P
	cpfseq	m_byte,a
	goto	bt_dec_Q
	retlw	0x50

bt_dec_Q:
	movlw	0x1B		;Q
	cpfseq	m_byte,a
	goto	bt_dec_R
	retlw	0x51

bt_dec_R:
	movlw	0x0A		;R
	cpfseq	m_byte,a
	goto	bt_dec_S
	retlw	0x52
	
bt_dec_S:
	movlw	0x08		;S
	cpfseq	m_byte,a
	goto	bt_dec_T
	retlw	0x53
	
bt_dec_T:
	movlw	0x03		;T
	cpfseq	m_byte,a
	goto	bt_dec_U
	retlw	0x54
	
bt_dec_U:
	movlw	0x0C		;U
	cpfseq	m_byte,a
	goto	bt_dec_V
	retlw	0x55
	
bt_dec_V:
	movlw	0x18		;V
	cpfseq	m_byte,a
	goto	bt_dec_W
	retlw	0x56
	
bt_dec_W:
	movlw	0x0E		;W
	cpfseq	m_byte,a
	goto	bt_dec_X
	retlw	0x57
	
bt_dec_X:
	movlw	0x19		;X
	cpfseq	m_byte,a
	goto	bt_dec_Y
	retlw	0x58
	
bt_dec_Y:
	movlw	0x1D		;Y
	cpfseq	m_byte,a
	goto	bt_dec_Z
	retlw	0x59
	
bt_dec_Z:
	movlw	0x13		;Z
	cpfseq	m_byte,a
	goto	bt_dec_1
	retlw	0x5A
	
bt_dec_1:
	movlw	0x3E		;1
	cpfseq	m_byte,a
	goto	bt_dec_2
	retlw	0x31
	
bt_dec_2:
	movlw	0x3C		;2
	cpfseq	m_byte,a
	goto	bt_dec_3
	retlw	0x32

bt_dec_3:
	movlw	0x38		;3
	cpfseq	m_byte,a
	goto	bt_dec_4
	retlw	0x33
	
bt_dec_4:
	movlw	0x30		;4
	cpfseq	m_byte,a
	goto	bt_dec_5
	retlw	0x34
	
bt_dec_5:
	movlw	0x20		;5
	cpfseq	m_byte,a
	goto	bt_dec_6
	retlw	0x35
	
bt_dec_6:
	movlw	0x21		;6
	cpfseq	m_byte,a
	goto	bt_dec_7
	retlw	0x36
	
bt_dec_7:
	movlw	0x23		;7
	cpfseq	m_byte,a
	goto	bt_dec_8
	retlw	0x37
	
bt_dec_8:
	movlw	0x27		;8
	cpfseq	m_byte,a
	goto	bt_dec_9
	retlw	0x38
	
bt_dec_9:
	movlw	0x2F		;9
	cpfseq	m_byte,a
	goto	bt_dec_0
	retlw	0x39
	
bt_dec_0:
	movlw	0x3F		;0
	cpfseq	m_byte,a
	goto	bt_dec_qm
	retlw	0x30
	
bt_dec_qm:
	movlw	0x4c		;?
	cpfseq	m_byte,a
	goto	bt_dec_em
	retlw	0x3F
	
bt_dec_em:
	movlw	0x75		;!
	cpfseq	m_byte,a
	goto	bt_dec_fs
	retlw	0x21
	
bt_dec_fs:
	movlw	0x6A		;.
	cpfseq	m_byte,a
	goto	bt_dec_cm
	retlw	0x2E
	
bt_dec_cm:
	movlw	0x73		;,
	cpfseq	m_byte,a
	goto	bt_dec_sc
	retlw	0x2C
	
bt_dec_sc:
	movlw	0x55		;;
	cpfseq	m_byte,a
	goto	bt_dec_cl
	retlw	0x3B
	
bt_dec_cl:
	movlw	0x47		;:
	cpfseq	m_byte,a
	goto	bt_dec_pl
	retlw	0x3A
	
bt_dec_pl:
	movlw	0x2A		;+
	cpfseq	m_byte,a
	goto	bt_dec_mn
	retlw	0x2B
	
bt_dec_mn:
	movlw	0x61		;-
	cpfseq	m_byte,a
	goto	bt_dec_ds
	retlw	0x2D
	
bt_dec_ds:
	movlw	0x29		;/
	cpfseq	m_byte,a
	goto	bt_dec_eq
	retlw	0x2F
	
bt_dec_eq:
	movlw	0x31		;=
	cpfseq	m_byte,a
	goto	bt_dec_space
	retlw	0x3D
	
bt_dec_space:
	movlw	0xFF
	cpfseq	m_byte,a
	goto	bt_dec_ERROR
	retlw	0x20
	

bt_dec_ERROR:
	retlw	0x7E		;~

bt_to_LCD:	
	;call	Decrypt
	call	bt_dec_A
	;call	UART_Transmit_Byte
	call	LCD_Send_Byte_D
	incf	Cursor_counter, f, a
	movlw	0x10
	cpfseq	Cursor_counter, a
	goto	cont
	call	LCD_secondLine
	
cont:	movlw	0x20
	cpfseq	Cursor_counter, a
	return
	call	LCD_clear
	clrf	Cursor_counter, a
	return

Decrypt:
	movf	byte_lower, w, a
	xorwf	byte_higher, f, a
	movlw	0x10
	mulwf	byte_higher, a
	movff	PRODL, m_byte
	
	movlw	0x10
	mulwf	byte_lower, a
	movf	PRODH, W, A
	addwf	m_byte, F, A
	
	return
	
	end
