public _fxMul 
public _fxDiv
public _fxtoi 
public _sqrtInt 
public _normalize
public _fxSin

public _fixedHLmulBC
public _fixedHLdivBC
public _sqrtHL

public _MultiplyHLBC 
public _DivideHLBC 


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
	push hl 
	pop bc 
	
	ld de,65536 
DivideDEBC:
	xor	a,a
	sbc	hl,hl
	sbc	hl,bc
	jp	p,nnext0
	push	hl
	pop	bc
	inc	a
nnext0:
	or	a,a
	sbc	hl,hl
	sbc	hl,de
	jp	m,nnext1
	ex	de,hl
	inc	a
nnext1:
	add	hl,de
	rra
	ld	a,24
nloop:
	ex	de,hl
	adc	hl,hl
	ex	de,hl
	adc	hl,hl
	add	hl,bc
	jr	c,nspill
	sbc	hl,bc
nspill:
	dec	a
	jr	nz,nloop

	ex	de,hl
	adc	hl,hl
	jr	c,enddiv
	ex	de,hl
	sbc	hl,hl
	sbc	hl,de

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
	ld bc,fixedSinTable
	add hl,bc 
	ld hl,(hl)
	
	or a,a 
	ret p		; return if angle is positive, so it doesn't need to be negated
	ex de,hl 
	or a,a
	sbc hl,hl 
	sbc hl,de 
	ret 
	
	
fixedSinTable: 
	emit 3: 0,6,13,19,25,31,38,44,50,56,62,68,74,80,86,92
	emit 3: 98,104,109,115,121,126,132,137,142,147,152,157,162,167,172,177
	emit 3: 181,185,190,194,198,202,206,209,213,216,220,223,226,229,231,234
	emit 3: 237,239,241,243,245,247,248,250,251,252,253,254,255,255,256,256
	emit 3: 256,256,255,255,254,253,252,251,250,248,247,245,243,241,239,237
	emit 3: 234,231,229,226,223,220,216,213,209,206,202,198,194,190,185,181
	emit 3: 177,172,167,162,157,152,147,142,137,132,126,121,115,109,104,98
	emit 3: 92,86,80,74,68,62,56,50,44,38,31,25,19,13,6,0
	
	