public _GouraudTriangle
public _renderGouraudShader
public _renderGouraudShader_src
public _renderGouraudShader_len

extern _edge 
extern _canvas_data
extern __frameset

extern _DivideHLBC
extern _MultiplyHLBC
extern _fixedHLmulBC

width equ 160
height equ 120 
vram equ 0D40000h 

;fastRam equ 0E30880h

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
	ld (SMCLoadDUDX1),hl 
	ld (SMCLoadDUDX2),hl 
	add hl,hl 
	ld (SMCLoadDUDX3),hl 
	
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
	push hl 
	pop iy  ; iy = ui 
	
	; de' = canvas pointer 
	ld de,vram 
	ld d,(miny) 
	exx
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
	
	ld (SMCRestoreSP),sp 
	
	jp _renderGouraudShader
	
;-----------------------------------------------
;hl = edge pointer 
;de = dudy 
;b = y counter 
;iy = ui
;hl' = u 
;de' = canvas pointer 
;b' = x counter
virtual at $E30960
_renderGouraudShader:
yloop: 
	ld a,(hl) ; start of line 
	inc hl 
	exx 
	ld e,a 	; start of line offset 
	; u += start*dudx 
	push de 
	ld hl,0 
SMCLoadDUDX1:=$-3
	ld d,l 
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
	lea hl,iy+0
	add hl,de 
	pop de
	
	exx 
	add iy,de	; ui += dudy 
	ld a,(hl) 
	inc hl 
	exx 
	sub a,e 	; end - start -> x counter  
	jr z,skipline
	jp m,skipline
	ld b,a 		; b = x counter 
	ex af,af' 
	ld a,00000011b  ; first 4 pixels 
	and a,b
	jr z,xusetup 
	ld b,a  
	ld sp,0 
SMCLoadDUDX2:=$-3 

xloop: 
	ld a,h 
	ld (de),a 
	inc de 
	add hl,sp
	djnz xloop 

xusetup:
	ex af,af' 
	srl a 
	srl a 
	jr z,skipxunrolled 
	ld b,a ; count/4
	ld sp,0 	; doubled delta
SMCLoadDUDX3:=$-3 
xunrolled: 
	ld a,h 
	ld (de),a 
	inc de 
	ld (de),a 
	inc de 
	add hl,sp
	ld a,h 
	ld (de),a 
	inc de 
	ld (de),a 
	inc de 
	add hl,sp
	djnz xunrolled
skipxunrolled:
	ld sp,0 
SMCRestoreSP:=$-3 
skipline: 	
	inc d ;y++
	exx
	djnz yloop 
	
	ld sp,ix 
	pop ix 
	ret  

assert $ < $E309D0 ;change this if the relocated routine needs to change size
load _renderGouraudShader_data: $-$$ from $$
_renderGouraudShader_len := $-$$
end virtual
_renderGouraudShader_src:
	db _renderGouraudShader_data

