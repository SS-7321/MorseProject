#include <xc.inc>
    
global  mult_16x16, m_setup, mult_24x0A, mult_HtoD
global	ARG1H, ARG1M, ARG1L, RES0, RES1, RES2, RES3, msbH, msbL, temp

psect	udata_acs   ; reserve data space in access ram
m_counter:  ds 1
ARG1H:	ds 1
ARG1M:	ds 1
ARG1L:	ds 1

RES0:	ds 1
RES1:	ds 1
RES2:	ds 1
RES3:	ds 1
    
msbH:	ds 1
msbL:   ds 1

PSECT	udata_acs_ovr,space=1,ovrld,class=COMRAM
ARG2H:	ds 1
ARG2L:	ds 1
temp:	ds 1
    
psect	mult_code,class=CODE

m_setup:
	
	movlw	0x41
	movwf	ARG2H, A
	movlw	0x8A
	movwf	ARG2L, A
	return


mult_16x16:
	MOVF ARG1L, W , A   
	MULWF ARG2L  , A   ; ARG1L * ARG2L -> PRODH:PRODL
	MOVFF PRODH, RES1  , A   ;
	MOVFF PRODL, RES0  , A   ;

	MOVF ARG1H, W , A   
	MULWF ARG2H  , A   ; ARG1H * ARG2H -> PRODH:PRODL
	MOVFF PRODH, RES3 ;
	MOVFF PRODL, RES2 ;

	MOVF ARG1L, W , A   
	MULWF ARG2H  , A   ; ARG1L * ARG2H -> PRODH:PRODL
	MOVF PRODL, W ;
	ADDWF RES1, F  , A   ; Add cross
	MOVF PRODH, W ; products
	ADDWFC RES2, F  , A   ;
	CLRF WREG ;
	ADDWFC RES3, F  , A   ;

	MOVF ARG1H, W  , A   ;
        MULWF ARG2L  , A   ; ARG1H * ARG2L -> PRODH:PRODL
	MOVF PRODL, W ;
	ADDWF RES1, F , A   ; Add cross
	MOVF PRODH, W ; products
	ADDWFC RES2, F , A    ;
	CLRF WREG ;
	ADDWFC RES3, F  , A   ;
	return
	
mult_24x0A:
	movlw	0x0A
	mulwf	ARG1L, A
	movff	PRODL, RES0, A
	movff	PRODH, RES1, A
	
	movlw	0x0A
	mulwf	ARG1H, A
	movff	PRODH, RES3, A
	movff	PRODL, RES2, A
	
	movlw	0x0A
	mulwf	ARG1M, A
	movf	PRODL, W
	addwf	RES1, F, A
	movf	PRODH, W
	addwf	RES2, F, A
	return
	
mult_HtoD:
	call	m_setup
	call	mult_16x16
	movlw	0x10
	mulwf	RES3, A
	movff	PRODL, msbH, A
	call	load_24
	call	mult_24x0A
	
	
	movlw	0x10
	mulwf	RES3, A
	movff	PRODL, temp, A
	swapf	temp, F, A
	movf	temp, W, A
	addwf	msbH, F, A
	;call	shift
	call	load_24
	call	mult_24x0A
	
	movlw	0x10
	mulwf	RES3, A
	movff	PRODL, msbL, A
	;call	shift
	call	load_24
	call	mult_24x0A
	
	movlw	0x10
	mulwf	RES3, A
	movff	PRODL, temp, A
	swapf	temp, F, A
	movf	temp, W, A
	addwf	msbL, F, A
	return
	
	
    
shift:
	movlw	0x10
	mulwf	RES3, A
	movff	PRODL, RES3, A
	
	movlw	0x10
	mulwf	RES2, A
	movf	PRODH, W
	addwf	RES3, F, A
	movff	PRODL, RES2, A
	
	movlw	0x10
	mulwf	RES1, A
	movf	PRODH, W
	addwf	RES2, F, A
	movff	PRODL, RES1, A
	
	movlw	0x10
	mulwf	RES0, A
	movf	PRODH, W
	addwf	RES1, F, A
	movff	PRODL, RES0, A
	return
	
	
load_24:
    movff   RES2, ARG1H, A
    movff   RES1, ARG1M, A
    movff   RES0, ARG1L, A
    return
    
    
    
	

	end

