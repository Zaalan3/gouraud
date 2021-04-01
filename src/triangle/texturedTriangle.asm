public _TexturedTriangle
public _renderTexturedShader
public _renderTexturedShader_src
public _renderTexturedShader_len

extern _edge 
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
vi equ ix-30
ui equ ix-33
u equ ix-36
v equ ix-39
dvdy equ ix-42
dvdx equ ix-45
dudy equ ix-48
dudx equ ix-51

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


;98108 -> 96458
_TexturedTriangle: 

	; dv/dx = -vh*b/Det
	ld hl,(vh) 
	ld bc,(bv) 
	call _MultiplyHLBC
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de
	ld bc,(denom)
	call _fixedHLmulBC
	ld (dvdx),hl
	ld (SMCLoadDVDX),hl
	ld (SMCLoadDeltaLow),hl 
	add hl,hl
	ld (SMCLoadDeltaLow2),hl
	
	; du/dx = uw*d/Det
	ld hl,(uw) 
	ld bc,(dv) 
	call _MultiplyHLBC
	ld bc,(denom)
	call _fixedHLmulBC
	ld (dudx),hl 
	ld (SMCLoadDUDX),hl
	ld a,l 
	ld (SMCLoadDeltaLow + 2),a 
	ld a,h 
	ld (SMCLoadDeltaHigh),a
	add hl,hl
	ld a,l 
	ld (SMCLoadDeltaLow2 + 2),a 
	ld a,h 
	ld (SMCLoadDeltaHigh2),a
	
	; du/dy = -uw*c/Det11
	ld hl,(uw) 
	ld bc,(cv) 
	call _MultiplyHLBC
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld bc,(denom)
	call _fixedHLmulBC
	ld (dudy),hl
	ld (SMCLoadDUDY1),hl
	ld (SMCLoadDUDY2),hl

	; dv/dy = vh*a/Det
	ld hl,(vh) 
	ld bc,(av) 
	call _MultiplyHLBC
	ld bc,(denom)
	call _fixedHLmulBC 
	ld (dvdy),hl
	ld (SMCLoadDVDY1),hl
	ld (SMCLoadDVDY2),hl

computeuivi: ; find values of u and v at top left corner of bounding box
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
	ex hl,de 
	or a,a 
	sbc hl,hl 
	ld h,(u0) 
	add hl,de 
	ld (ui),hl 

	pop hl 
	ld bc,(dvdx) 
	call _MultiplyHLBC
	pop bc 
	push hl 
	ld hl,(dvdy) 
	call _MultiplyHLBC
	pop bc 
	add hl,bc 
	ex hl,de 
	or a,a 
	sbc hl,hl 
	ld h,(v0) 
	set 7,h
	add hl,de 
	push hl 
	pop iy 

	ld de,(miny) 
	ld a,(maxy) 
	sub a,e
	exx 
	ld c,a ; c' = y counter 
	exx
	ld hl,vram  
	ld h,e 
	push hl 
	
	ld hl,_edge ; bc = edge pointer
	add hl,de
	add hl,de
	push hl 
	pop bc 
	
	pop de; de = draw buffer
	
	push ix 
	ld ix,(ui) 
	ld (SMCRestoreSP),sp 
	jp _renderTexturedShader
;-----------------------------------------------
virtual at $E30880 ;assembler treats this code as having origin in fast ram
  
;	hl = texture aggragate high  
;	spl = texture delta high 
;	hl' = texture aggragate low 
;	de' = texture delta low  
;	de = canvas
;	b' = x counter 
;	c' = y counter 
;	bc = edge pointer
;	iy = vi
;	ix = ui 
_renderTexturedShader: 
yloop: 
	ld a,(bc) 
	inc bc
	ld e,a 		; x = start 
	ld a,(bc) ; a = x end
	inc bc 
	sub a,e 
	jp z,skipLine	; zero/one pixel wide lines are skipped
	jp m,skipLine
	exx 
	ld b,a 	; b = x counter	
	exx 
	ld a,e 
	exx 
	
	; u = ui + dudx*start
	ld hl,0
SMCLoadDUDX:=$-3
	ld d,l 
	ld e,a
	ld l,a 
	mlt hl 
	mlt de 
	ex af,af' 
	ld a,l 
	add a,d 
	ld d,a 
	ld a,h 
	rlca 
	sbc hl,hl 
	ld h,d 
	ld l,e 
	lea de,ix+0 
	add hl,de 
	ld de,0
SMCLoadDUDY1:=$-3
	add ix,de ; ui += dudy 
	
	; ld texture aggragate high 
	ex de,hl 
	ld hl,$D40000
	ld l,d 
	push hl 
	exx 
	pop hl 
	exx 
	ld a,e
	ex af,af' 
	; v = vi + dvdx*start
	ld hl,0
SMCLoadDVDX:=$-3
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
	lea de,iy+0 
	add hl,de 
	push hl 	; push v 
	ld de,0
SMCLoadDVDY1:=$-3
	add iy,de ; vi += dudy  
	
	; load texture aggragate low 
	ex af,af' 
	ld h,a 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	pop de 
	ld h,d 
	ld l,e 

	ld sp,0
SMCLoadDeltaHigh:=$-3
	ld de,0
SMCLoadDeltaLow:=$-3
	

	ld a,b 
	ex af,af' 
	ld a,00000011b  ; first 4 pixels 
	and a,b
	jr z,xusetup 
	ld b,a 
xloop: 
	add hl,de 
	ld a,h 
	exx 
	adc hl,sp 
	ld h,a 
	ld a,(hl) 
	ld (de),a 
	inc de 
	exx 
	djnz xloop 
xusetup: 
	ex af,af' 
	srl a 
	srl a 
	jr z,cont  
	ld b,a ; count/4
	ld sp,0 	; doubled deltas
SMCLoadDeltaHigh2:=$-3	
	ld de,0 
SMCLoadDeltaLow2:=$-3
	
xunrolled:
	add hl,de 
	ld a,h 
	exx 
	adc hl,sp 
	ld h,a 
	ld a,(hl) 
	ld (de),a 
	inc de
	ld (de),a 
	inc de 
	exx
	add hl,de 
	ld a,h 
	exx 
	adc hl,sp 
	ld h,a 
	ld a,(hl) 
	ld (de),a 
	inc de 
	ld (de),a 
	inc de
	exx
	djnz xunrolled
	
cont: 
	exx 
	ld sp,0 
SMCRestoreSP:=$-3 
	inc d ; y++ 
	exx 
endyloop: 
	dec c 
	exx 
	jp NZ,yloop
	
	pop ix
	ld sp,ix 
	pop ix 
	ret
	
skipLine: 
	inc d
	exx 
	ld de,0
SMCLoadDUDY2:=$-3
	add ix,de  
	
	ld de,0 
SMCLoadDVDY2:=$-3
	add iy,de 

	jr endyloop

assert $ < $E30960 ;change this if the relocated routine needs to change size

load _renderTexturedShader_data: $-$$ from $$
_renderTexturedShader_len:=$-$$
end virtual
_renderTexturedShader_src:
	db _renderTexturedShader_data