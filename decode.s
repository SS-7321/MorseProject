#include <xc.inc>

global	bt_enc_A
    
PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
m_byte:	    ds 1

psect	decode_code, class=CODE
    
bt_enc_A:
	movlw	0x05		;A
	cpfseq	m_byte,a
	goto	bt_enc_B
	retlw	0x41
	
bt_enc_B:
	movlw	0x18		;B
	cpfseq	m_byte,a
	goto	bt_enc_C
	retlw	0x42
	
bt_enc_C:
	movlw	0x1A		;C
	cpfseq	m_byte,a
	goto	bt_enc_D
	retlw	0x43
	
bt_enc_D:
	movlw	0x0C		;D
	cpfseq	m_byte,a
	goto	bt_enc_E
	retlw	0x44
	
bt_enc_E:
	movlw	0x02		;E
	cpfseq	m_byte,a
	goto	bt_enc_F
	retlw	0x45
	
bt_enc_F:
	movlw	0x12		;F
	cpfseq	m_byte,a
	goto	bt_enc_G
	retlw	0x46
	
bt_enc_G:
	movlw	0x0E		;G
	cpfseq	m_byte,a
	goto	bt_enc_H
	retlw	0x47
	
bt_enc_H:
	movlw	0x10		;H
	cpfseq	m_byte,a
	goto	bt_enc_I
	retlw	0x48
	
bt_enc_I:
	movlw	0x04		;I
	cpfseq	m_byte,a
	goto	bt_enc_J
	retlw	0x49
	
bt_enc_J:
	movlw	0x23		;J
	cpfseq	m_byte,a
	goto	bt_enc_K
	retlw	0x4A
	
bt_enc_K:
	movlw	0x0D		;K
	cpfseq	m_byte,a
	goto	bt_enc_L
	retlw	0x4B
	
bt_enc_L:
	movlw	0x14		;L
	cpfseq	m_byte,a
	goto	bt_enc_M
	retlw	0x4C
	
bt_enc_M:
	movlw	0x07		;M
	cpfseq	m_byte,a
	goto	bt_enc_N
	retlw	0x4D
	
bt_enc_N:
	movlw	0x06		;N
	cpfseq	m_byte,a
	goto	bt_enc_O
	retlw	0x4E
	
bt_enc_O:
	movlw	0x0F		;O
	cpfseq	m_byte,a
	goto	bt_enc_P
	retlw	0x4F
	
bt_enc_P:
	movlw	0x16		;P
	cpfseq	m_byte,a
	goto	bt_enc_Q
	retlw	0x50

bt_enc_Q:
	movlw	0x1D		;Q
	cpfseq	m_byte,a
	goto	bt_enc_R
	retlw	0x51

bt_enc_R:
	movlw	0x0A		;R
	cpfseq	m_byte,a
	goto	bt_enc_S
	retlw	0x52
	
bt_enc_S:
	movlw	0x08		;S
	cpfseq	m_byte,a
	goto	bt_enc_T
	retlw	0x53
	
bt_enc_T:
	movlw	0x03		;T
	cpfseq	m_byte,a
	goto	bt_enc_U
	retlw	0x54
	
bt_enc_U:
	movlw	0x09		;U
	cpfseq	m_byte,a
	goto	bt_enc_V
	retlw	0x55
	
bt_enc_V:
	movlw	0x11		;V
	cpfseq	m_byte,a
	goto	bt_enc_W
	retlw	0x56
	
bt_enc_W:
	movlw	0x0B		;W
	cpfseq	m_byte,a
	goto	bt_enc_X
	retlw	0x57
	
bt_enc_X:
	movlw	0x19		;X
	cpfseq	m_byte,a
	goto	bt_enc_Y
	retlw	0x58
	
bt_enc_Y:
	movlw	0x18		;Y
	cpfseq	m_byte,a
	goto	bt_enc_Z
	retlw	0x59
	
bt_enc_Z:
	movlw	0x1C		;Z
	cpfseq	m_byte,a
	goto	bt_enc_1
	retlw	0x5A
	
bt_enc_1:
	movlw	0x2F		;1
	cpfseq	m_byte,a
	goto	bt_enc_2
	retlw	0x31
	
bt_enc_2:
	movlw	0x27		;2
	cpfseq	m_byte,a
	goto	bt_enc_3
	retlw	0x32

bt_enc_3:
	movlw	0x23		;3
	cpfseq	m_byte,a
	goto	bt_enc_4
	retlw	0x33
	
bt_enc_4:
	movlw	0x21		;4
	cpfseq	m_byte,a
	goto	bt_enc_5
	retlw	0x34
	
bt_enc_5:
	movlw	0x20		;5
	cpfseq	m_byte,a
	goto	bt_enc_6
	retlw	0x35
	
bt_enc_6:
	movlw	0x30		;6
	cpfseq	m_byte,a
	goto	bt_enc_7
	retlw	0x36
	
bt_enc_7:
	movlw	0x38		;7
	cpfseq	m_byte,a
	goto	bt_enc_8
	retlw	0x37
	
bt_enc_8:
	movlw	0x3C		;8
	cpfseq	m_byte,a
	goto	bt_enc_9
	retlw	0x38
	
bt_enc_9:
	movlw	0x3E		;9
	cpfseq	m_byte,a
	goto	bt_enc_0
	retlw	0x39
	
bt_enc_0:
	movlw	0x3F		;0
	cpfseq	m_byte,a
	goto	bt_enc_qm
	retlw	0x30
	
bt_enc_qm:
	movlw	0x4c		;?
	cpfseq	m_byte,a
	goto	bt_enc_em
	retlw	0x3F
	
bt_enc_em:
	movlw	0x6B		;!
	cpfseq	m_byte,a
	goto	bt_enc_fs
	retlw	0x21
	
bt_enc_fs:
	movlw	0x55		;.
	cpfseq	m_byte,a
	goto	bt_enc_cm
	retlw	0x2E
	
bt_enc_cm:
	movlw	0x73		;,
	cpfseq	m_byte,a
	goto	bt_enc_sc
	retlw	0x2C
	
bt_enc_sc:
	movlw	0x6A		;;
	cpfseq	m_byte,a
	goto	bt_enc_cl
	retlw	0x3B
	
bt_enc_cl:
	movlw	0x78		;:
	cpfseq	m_byte,a
	goto	bt_enc_pl
	retlw	0x3A
	
bt_enc_pl:
	movlw	0x2A		;+
	cpfseq	m_byte,a
	goto	bt_enc_mn
	retlw	0x2B
	
bt_enc_mn:
	movlw	0x61		;-
	cpfseq	m_byte,a
	goto	bt_enc_ds
	retlw	0x2D
	
bt_enc_ds:
	movlw	0x32		;/
	cpfseq	m_byte,a
	goto	bt_enc_eq
	retlw	0x2F
	
bt_enc_eq:
	movlw	0x31		;=
	cpfseq	m_byte,a
	goto	bt_enc_ERROR
	retlw	0x3D

bt_enc_ERROR:
	retlw	0x98		;~

	
	end
