; for C usage 
public _fxMul 
public _fxDiv
public _fxtoi 
public _sqrtInt 
public _normalize
public _fxSin

; for Assembly usage
public _fixedHLmulBC
public _fixedHLdivBC
public _sqrtHL
public _MultiplyHLBC 
public _DivideHLBC 
public _getReciprocal

extern _fixedSinTable
extern _recipTable
extern _recipTable2


;------------------------------------------------
_MultiplyHLBC:
; Performs (un)signed integer multiplication
; Inputs:
;  HL : Operand 1
;  BC : Operand 2
; Outputs:
;  HL = HL*BC
	push iy
	push	hl
	push	bc
	push	hl
	ld	iy,0
	ld	d,l
	ld	e,b
	mlt	de
	add	iy,de
	ld	d,c
	ld	e,h
	mlt	de
	add	iy,de
	ld	d,c
	ld	e,l
	mlt	de
	ld	c,h
	mlt	bc
	ld	a,c
	inc	sp
	inc	sp
	pop	hl
	mlt	hl
	add	a,l
	pop	hl
	inc	sp
	mlt	hl
	add	a,l
	ld	b,a
	ld	c,0
	lea	hl,iy+0
	add	hl,bc
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	pop	iy
	ret

;------------------------------------------------
_DivideHLBC:
; Performs signed interger division
; Inputs:
;  HL : Operand 1
;  BC : Operand 2
; Outputs:
;  HL = HL/BC
	ex	de,hl
	xor	a,a
	sbc	hl,hl
	sbc	hl,bc
	jp	p,.next0
	push	hl
	pop	bc
	inc	a
.next0:
	or	a,a
	sbc	hl,hl
	sbc	hl,de
	jp	m,.next1
	ex	de,hl
	inc	a
.next1:
	add	hl,de
	rra
.loop:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill1
	sbc	hl,bc
.spill1:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill2
	sbc	hl,bc
.spill2:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill3
	sbc	hl,bc
.spill3:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill4
	sbc	hl,bc
.spill4:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill5
	sbc	hl,bc
.spill5:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill6
	sbc	hl,bc
.spill6:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill7
	sbc	hl,bc
.spill7:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill8
	sbc	hl,bc
.spill8:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill9
	sbc	hl,bc
.spill9:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill10
	sbc	hl,bc
.spill10:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill11
	sbc	hl,bc
.spill11:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill12
	sbc	hl,bc
.spill12:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill13
	sbc	hl,bc
.spill13:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill14
	sbc	hl,bc
.spill14:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill15
	sbc	hl,bc
.spill15:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill16
	sbc	hl,bc
.spill16:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill17
	sbc	hl,bc
.spill17:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill18
	sbc	hl,bc
.spill18:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill19
	sbc	hl,bc
.spill19:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill20
	sbc	hl,bc
.spill20:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill21
	sbc	hl,bc
.spill21:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill22
	sbc	hl,bc
.spill22:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill23
	sbc	hl,bc
.spill23:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,.spill24
	sbc	hl,bc
.spill24:
	ex	de,hl
	adc	hl,hl
	ret	c
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de
	ret

	
;------------------------------------------------
; converts 8.8 fixed point number to integer
_fxtoi: 
	pop bc 
	inc sp 
	pop hl 
	dec sp 
	push hl 
	push bc 
	ld a,h 
	ex de,hl 
	rlca 
	sbc hl,hl 
	ld h,d 
	ld l,e 
	ret 
		
;------------------------------------------------	
;Multiplies two 8.8 fixed point numbers
_fxMul: 
	pop de 
	pop hl 
	pop bc 
	push de 
	push de 
	push de 
_fixedHLmulBC:
	ld a,0C9h	; alternate between 0(nop) and C9h(ret) 
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	jp m,noswapHLDE
	ex de,hl 
	xor a,0C9h
noswapHLDE: 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	jp m,noswapHLBC
	push hl 
	pop bc
    xor a,0C9h
noswapHLBC:  
	ld (MultSMC),a
	ex de,hl 
	
	ld d,l 
	ld e,c 
	mlt de 
	ld a,d 
	ex af,af' 
	ld a,c 
	ld c,l 
	ld l,a 
	ld d,h 
	ld e,b 
	mlt bc 
	mlt de 
	mlt hl 
	ex af,af' 
	add a,l 
	ld l,a
	ld a,h 
	adc a,0
	ld h,a 
	add hl,bc 
	ex de,hl 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,de
MultSMC: ret 
	ex de,hl
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ret 
		
;------------------------------------------------
_fxDiv:
	pop de 
	pop hl 
	pop bc 
	push de
	push de
	push de
_fixedHLdivBC: 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ex	de,hl
	xor	a,a
	sbc	hl,hl
	sbc	hl,bc
	jp	p,next0
	push	hl
	pop	bc
	inc	a
next0:
	or	a,a
	sbc	hl,hl
	sbc	hl,de
	jp	m,next1
	ex	de,hl
	inc	a
next1:
	add	hl,de
	rra
loop:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill1
	sbc	hl,bc
spill1:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill2
	sbc	hl,bc
spill2:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill3
	sbc	hl,bc
spill3:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill4
	sbc	hl,bc
spill4:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill5
	sbc	hl,bc
spill5:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill6
	sbc	hl,bc
spill6:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill7
	sbc	hl,bc
spill7:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill8
	sbc	hl,bc
spill8:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill9
	sbc	hl,bc
spill9:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill10
	sbc	hl,bc
spill10:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill11
	sbc	hl,bc
spill11:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill12
	sbc	hl,bc
spill12:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill13
	sbc	hl,bc
spill13:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill14
	sbc	hl,bc
spill14:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill15
	sbc	hl,bc
spill15:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill16
	sbc	hl,bc
spill16:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill17
	sbc	hl,bc
spill17:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill18
	sbc	hl,bc
spill18:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill19
	sbc	hl,bc
spill19:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill20
	sbc	hl,bc
spill20:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill21
	sbc	hl,bc
spill21:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill22
	sbc	hl,bc
spill22:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill23
	sbc	hl,bc
spill23:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,spill24
	sbc	hl,bc
spill24:
	ex	de,hl
	adc	hl,hl
	ret	c
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de
	ret
	ex	de,hl
	adc	hl,hl
	ret	c
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de
	ret

	
;------------------------------------------------
;https://www.cemetech.net/forum/viewtopic.php?p=253204
_sqrtInt:
		pop de 
		pop hl 
		push hl
		push de
; uhl = sqrt(uhl)
_sqrtHL:
        dec     sp      ; (sp) = ?
        push    hl      ; (sp) = ?uhl
        dec     sp      ; (sp) = ?uhl?
        pop     iy      ; (sp) = ?u, uiy = hl?
        dec     sp      ; (sp) = ?u?
        pop     af      ; af = u?
        or      a,a
        sbc     hl,hl
        ex      de,hl   ; de = 0
        sbc     hl,hl   ; hl = 0
        ld      bc,0C40h ; b = 12, c = 0x40
Sqrt24Loop:
        sub     a,c
        sbc     hl,de
        jr      nc,Sqrt24Skip
        add     a,c
        adc     hl,de
Sqrt24Skip:
        ccf
        rl      e
        rl      d
        add     iy,iy
        rla
        adc     hl,hl
        add     iy,iy
        rla
        adc     hl,hl
        djnz    Sqrt24Loop
        ex      de,hl
        ret
	
;------------------------------------------------	
; normalizes a vector 
; returns length of original vector 
_normalize: 
	pop de 
	pop iy 
	push de
	push de
	
	ld bc,(iy+0) 
	or a,a 
	sbc hl,hl 
	add hl,bc 
	call _fixedHLmulBC 
	push hl 
	ld bc,(iy+3) 
	or a,a 
	sbc hl,hl 
	add hl,bc
	call _fixedHLmulBC 
	pop de 
	add hl,de 
	push iy 
	call _sqrtHL
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	pop iy 
	
	push hl 
	
	call _getReciprocal
	

enddiv: 	
	push hl 
	ld	bc,(iy+0) 
	call _fixedHLmulBC
	ld (iy+0),hl 
	pop hl 
	ld bc,(iy+3) 
	call _fixedHLmulBC
	ld (iy+3),hl 
	pop hl 
	ret


;------------------------------------------------
; sin(t) = sin(pi - t)
; sin(-t) = -sin(t) 
; 
_fxSin: 
	pop bc 
	pop hl 
	push bc 
	push bc
	ld a,l 	
	
	ld h,3
	res 7,l 
	mlt hl 
	ld bc,_fixedSinTable
	add hl,bc 
	ld hl,(hl)
	
	or a,a 
	ret p		; return if angle is positive, so it doesn't need to be negated
	ex de,hl 
	or a,a
	sbc hl,hl 
	sbc hl,de 
	ret 
	
;------------------------------------------------
; returns the 8.16 reciprocal of 16-bit integer in HL 
_getReciprocal:
	dec hl
	ld a,h 
	tst a,0F0h 
	jr nz,recipdiv ; do simple division if value is higher 0x0FFF 
	tst a,0Fh 
	jr nz,recip2	; for hl>256
	add hl,hl 
	ld de,_recipTable 
	add hl,de 
	ld de,(hl) 
	or a,a 
	sbc hl,hl 
	ld h,d 
	ld l,e 
	ret 
recip2: 
	ld de,256
	or a,a 
	sbc hl,de 
	ld de,_recipTable2
	add hl,de 
	ld a,(hl) 
	or a,a 
	sbc hl,hl 
	ld l,a 
	ret 

recipdiv: 
	ex hl,de 
	xor a,a 
	ld hl,65536
rloop: 
	inc a 
	or a,a 
	sbc hl,de 
	jr nc,rloop
	dec a 
	or a,a 
	sbc hl,hl 
	ld l,a 
	ret 
	