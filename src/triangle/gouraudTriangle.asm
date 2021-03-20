public _GouraudTriangle

extern _edge 
extern _canvas_data
extern __frameset

extern _DivideHLBC
extern _MultiplyHLBC
extern _fixedHLmulBC

width equ 160
height equ 120 
vram equ 0D40000h 

;variables
av equ ix-3 
bv equ ix-6
cv equ ix-9
dv equ ix-12
miny equ ix-15
maxy equ ix-18 
denom equ ix-21 
argx0 equ ix-24
argy0 equ ix-27
dc1 equ ix-30 
dc2 equ ix-33 
dudx equ ix-36 
dudy equ ix-39 
ui	equ ix-42

; triangle struct 
type equ iy+0 
x0 equ iy+1
y0 equ iy+4
x1 equ iy+7
y1 equ iy+10
x2 equ iy+13
y2 equ iy+16
l0 equ iy+19
l1 equ iy+20
l2 equ iy+21
u0 equ iy+22
v0 equ iy+23
uw equ iy+24
vh equ iy+27


_GouraudTriangle: 
	or a,a 
	sbc hl,hl 
	ex de,hl 
	or a,a 
	sbc hl,hl 
	
	; dc1 = color1 - color0 
	ld e,(l0) 
	ld l,(l1)
	or a,a 
	sbc hl,de 
	ld (dc1),hl 
	; dc2 = color2 - color0
	or a,a 
	sbc hl,hl
	ld l,(l2)
	or a,a 
	sbc hl,de
	ld (dc2),hl

	
	; dudx = (dc1*dv - dc2*bv)*denom 
	ld bc,(bv) 
	call _MultiplyHLBC 
	push hl 
	ld hl,(dc1) 
	ld bc,(dv)
	call _MultiplyHLBC
	pop bc 
	or a,a 
	sbc hl,bc 
	ld bc,(denom) 
	call _fixedHLmulBC
	ld (dudx),hl 
	
	; dudy = (dc2*av - dc1*cv)*denom 
	ld hl,(dc1) 
	ld bc,(cv) 
	call _MultiplyHLBC 
	push hl 
	ld hl,(dc2) 
	ld bc,(av)
	call _MultiplyHLBC
	pop bc 
	or a,a 
	sbc hl,bc 
	ld bc,(denom) 
	call _fixedHLmulBC
	ld (dudy),hl 
	
computeui: 
	ld hl,(miny) 
	ld de,(argy0) 
	or a,a 
	sbc hl,de 
	push hl 
	ex de,hl 
	ld bc,(argx0) 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	push hl 
	ex de,hl 
	
	ld bc,(dudy) 
	call _MultiplyHLBC
	pop bc 
	push bc 
	push hl 
	ld hl,(dudx) 
	call _MultiplyHLBC
	pop bc 
	add hl,bc 
	ex de,hl 
	or a,a 
	sbc hl,hl 
	ld h,(l0) 
	add hl,de 
	ld (ui),hl 
	
renderTriangle:
	; hl = edge pointer 
	ld de,(miny) 
	ld hl,_edge
	add hl,de
	add hl,de
	; b = y counter 
	ld a,(maxy) 
	sub a,e 
	ld b,a 
	; de = dudy 
	ld de,(dudy)
	exx 
	; hl' = canvas pointer 
	ld hl,vram 
	ld h,(miny) 
	
	; de' = dudx 
	ld de,(dudx) 
	; ix = ui 
	push ix 
	ld ix,(ui)
	
	exx 
yloop: 
	lea iy,ix+0 ; iy = ui
	add ix,de	; ui += dudy 
	ld a,(hl) ; start of line 
	inc hl 
	exx 
	ld l,a 	; start of line offset 
	; u += start*dudx 
	push hl 
	push de 
	ex de,hl 
	ld d,l 
	ld e,a 
	ld l,a 
	mlt hl 
	mlt de 
	ld a,l 
	add a,d 
	ld d,a 
	ld a,h 
	rlca 
	sbc hl,hl 
	ld h,d 
	ld l,e
	ex de,hl 
	add iy,de 
	pop de 
	pop hl
	
	exx 
	ld a,(hl) 
	inc hl 
	exx 
	sub a,l 	; end - start -> x counter  
	jr z,skipxloop
	ld b,a 		; b = x counter 
	
xloop: 
	ld a,iyh ; plot color 
	ld (hl),a
	inc l 
	add iy,de ; u += dudx 
	djnz xloop 
	
skipxloop: 	
	inc h ;y++
	exx 
	djnz yloop 
	
	pop ix 
	ld sp,ix 
	pop ix 
	ret 
		