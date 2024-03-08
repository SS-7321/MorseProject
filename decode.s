#include <xc.inc>
;editted
global	bt_dec_A
extrn	m_byte	; byte from UART
extrn	LCD_Send_Byte_D


psect	decode_code, class=CODE
    

    
bt_dec_A:
	movlw	0x05		;A
	cpfseq	m_byte,a
	goto	bt_dec_B
	retlw	0x41
	
bt_dec_B:
	movlw	0x18		;B
	cpfseq	m_byte,a
	goto	bt_dec_C
	retlw	0x42
	
bt_dec_C:
	movlw	0x1A		;C
	cpfseq	m_byte,a
	goto	bt_dec_D
	retlw	0x43
	
bt_dec_D:
	movlw	0x0C		;D
	cpfseq	m_byte,a
	goto	bt_dec_E
	retlw	0x44
	
bt_dec_E:
	movlw	0x02		;E
	cpfseq	m_byte,a
	goto	bt_dec_F
	retlw	0x45
	
bt_dec_F:
	movlw	0x12		;F
	cpfseq	m_byte,a
	goto	bt_dec_G
	retlw	0x46
	
bt_dec_G:
	movlw	0x0E		;G
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
	movlw	0x23		;J
	cpfseq	m_byte,a
	goto	bt_dec_K
	retlw	0x4A
	
bt_dec_K:
	movlw	0x0D		;K
	cpfseq	m_byte,a
	goto	bt_dec_L
	retlw	0x4B
	
bt_dec_L:
	movlw	0x14		;L
	cpfseq	m_byte,a
	goto	bt_dec_M
	retlw	0x4C
	
bt_dec_M:
	movlw	0x07		;M
	cpfseq	m_byte,a
	goto	bt_dec_N
	retlw	0x4D
	
bt_dec_N:
	movlw	0x06		;N
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
	movlw	0x1D		;Q
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
	movlw	0x09		;U
	cpfseq	m_byte,a
	goto	bt_dec_V
	retlw	0x55
	
bt_dec_V:
	movlw	0x11		;V
	cpfseq	m_byte,a
	goto	bt_dec_W
	retlw	0x56
	
bt_dec_W:
	movlw	0x0B		;W
	cpfseq	m_byte,a
	goto	bt_dec_X
	retlw	0x57
	
bt_dec_X:
	movlw	0x19		;X
	cpfseq	m_byte,a
	goto	bt_dec_Y
	retlw	0x58
	
bt_dec_Y:
	movlw	0x18		;Y
	cpfseq	m_byte,a
	goto	bt_dec_Z
	retlw	0x59
	
bt_dec_Z:
	movlw	0x1C		;Z
	cpfseq	m_byte,a
	goto	bt_dec_1
	retlw	0x5A
	
bt_dec_1:
	movlw	0x2F		;1
	cpfseq	m_byte,a
	goto	bt_dec_2
	retlw	0x31
	
bt_dec_2:
	movlw	0x27		;2
	cpfseq	m_byte,a
	goto	bt_dec_3
	retlw	0x32

bt_dec_3:
	movlw	0x23		;3
	cpfseq	m_byte,a
	goto	bt_dec_4
	retlw	0x33
	
bt_dec_4:
	movlw	0x21		;4
	cpfseq	m_byte,a
	goto	bt_dec_5
	retlw	0x34
	
bt_dec_5:
	movlw	0x20		;5
	cpfseq	m_byte,a
	goto	bt_dec_6
	retlw	0x35
	
bt_dec_6:
	movlw	0x30		;6
	cpfseq	m_byte,a
	goto	bt_dec_7
	retlw	0x36
	
bt_dec_7:
	movlw	0x38		;7
	cpfseq	m_byte,a
	goto	bt_dec_8
	retlw	0x37
	
bt_dec_8:
	movlw	0x3C		;8
	cpfseq	m_byte,a
	goto	bt_dec_9
	retlw	0x38
	
bt_dec_9:
	movlw	0x3E		;9
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
	movlw	0x6B		;!
	cpfseq	m_byte,a
	goto	bt_dec_fs
	retlw	0x21
	
bt_dec_fs:
	movlw	0x55		;.
	cpfseq	m_byte,a
	goto	bt_dec_cm
	retlw	0x2E
	
bt_dec_cm:
	movlw	0x73		;,
	cpfseq	m_byte,a
	goto	bt_dec_sc
	retlw	0x2C
	
bt_dec_sc:
	movlw	0x6A		;;
	cpfseq	m_byte,a
	goto	bt_dec_cl
	retlw	0x3B
	
bt_dec_cl:
	movlw	0x78		;:
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
	movlw	0x32		;/
	cpfseq	m_byte,a
	goto	bt_dec_eq
	retlw	0x2F
	
bt_dec_eq:
	movlw	0x31		;=
	cpfseq	m_byte,a
	goto	bt_dec_ERROR
	retlw	0x3D

bt_dec_ERROR:
	retlw	0x98		;~

bt_to_LCD:	
	call	bt_dec_A
;	call	LCD_Send_Byte_D
	return
	
	end
