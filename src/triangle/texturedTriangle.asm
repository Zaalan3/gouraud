public _TexturedTriangle

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
	
	; du/dx = uw*d/Det
	ld hl,(uw) 
	ld bc,(dv) 
	call _MultiplyHLBC
	ld bc,(denom)
	call _fixedHLmulBC
	ld (dudx),hl 
	ld (SMCLoadDUDX1+1),hl 
	ld (SMCLoadDUDX2+1),hl 
	; du/dy = -uw*c/Det
	
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
	ld (SMCLoadDUDY1+1),hl
	ld (SMCLoadDUDY2+1),hl
	
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
	ld (SMCLoadDVDX1+1),hl 
	ld (SMCLoadDVDX2+1),hl
	
	; dv/dy = vh*a/Det
	ld hl,(vh) 
	ld bc,(av) 
	call _MultiplyHLBC
	ld bc,(denom)
	call _fixedHLmulBC 
	ld (dvdy),hl
	ld (SMCLoadDVDY1+1),hl
	ld (SMCLoadDVDY2+1),hl
	computeuivi:
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
	ld.sis sp,hl	; sps = ui	

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
	pop bc	; bc = vi
	exx 

	ld de,(miny) 
	ld a,(maxy) 
	sub a,e 
	ld c,a ; c = y counter 
	ld hl,vram  
	ld h,e ; hl = draw buffer
	
	ld iy,_edge ; iy = edge pointer
	add iy,de
	add iy,de
	
	ld de,vram 	; texture area is upper half of page ( h = v + 0x80, l = u )
	push ix 
renderTriangle: 
yloop: 
	ld a,(iy+0) 
	ld l,a 		; x = start 
	ld a,(iy+1) ; a = x end
	sub a,l 
	jr z,skipLine	; zero/one pixel wide lines are skipped
	ld b,a 	; b = x counter
	ld a,l
	exx 	
	pea iy+2
	; v = vi + dvdx*start
SMCLoadDVDX1:ld hl,0
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
	add hl,bc 
	push hl 
	pop iy 
SMCLoadDVDY1:ld hl,0
	add hl,bc 
	push hl 
	pop bc 
	
	ex af,af' 
	; u = ui + dudx*start
SMCLoadDUDX1:ld hl,0
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
	or a,a 
	sbc hl,hl 
	add.sis hl,sp 
	ex de,hl 
	add hl,de 
	push hl 
	pop ix
SMCLoadDUDY1:ld hl,0
	add hl,de 
	ld.sis sp,hl ; ui += dudy 
	
	or a,a 
	sbc hl,hl
	add hl,sp 
SMCLoadDUDX2:ld sp,0
SMCLoadDVDX2:ld de,0
	
	
;	de = texture  
;	hl = canvas 
;	b = x counter 
;	c = y counter 
;	bc' = vi
;	sp' = du/dx 
;	de' = dv/dx 
;	ix = u 
;	iy = v 
	exx 
xloop:  
	ld d,iyh 
	ld e,ixh 
	ld a,(de) 
	ld (hl),a 
	inc l 
	exx 
	add ix,sp 
	add iy,de 
	exx 
	djnz xloop 
	
cont: 
	exx 
	ld sp,hl 
	exx 
	pop iy
	inc h ; y++ 
	
endyloop: 
	dec c 
	jr nz,yloop
	
	pop ix
	ld sp,ix 
	pop ix 
	ret
	
skipLine: 
	exx 
	or a,a 
	sbc hl,hl 
	add.sis hl,sp 
SMCLoadDUDY2:ld de,0
	add hl,de 
	ld.sis sp,hl 
	
SMCLoadDVDY2:ld hl,0 
	add hl,bc
	push hl 
	pop bc
	
	exx
	inc h 
	lea iy,iy+2 
	jr endyloop
