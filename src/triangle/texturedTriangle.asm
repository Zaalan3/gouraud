public _TexturedTriangle

extern _edge 
extern _canvas_data
extern __frameset

extern _DivideHLBC
extern _MultiplyHLBC
extern _fixedHLmulBC

width equ 160
height equ 120 

av equ ix-3 
bv equ ix-6 
cv equ ix-9 
dv equ ix-12 
miny equ ix-15
maxy equ ix-18
vi equ ix-21
ui equ ix-24
dvdy equ ix-27 
dudy equ ix-30
dvdx equ ix-33 
dudx equ ix-36 
u equ ix-39
v equ ix-42
denom equ ix-45

x0 equ ix+6 
y0 equ ix+9 
x1 equ ix+12 
y1 equ ix+15 
x2 equ ix+18 
y2 equ ix+21
texture equ ix+24 


_TexturedTriangle: 
	ld hl,-45 
	call __frameset 
	; a = x1 - x0 
	di	; tendency to crash if interrupted 
	ld hl,(x1)
	ld de,(x0) 
	or a,a 
	sbc hl,de 
	ld (av),hl 
	; c = x2 - x0 
	ld hl,(x2) 
	or a,a 
	sbc hl,de 
	ld (cv),hl 
	; b = y1 - y0 
	ld hl,(y1)
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	ld (bv),hl 
	; d = y2 - y0 
	ld hl,(y2) 
	or a,a 
	sbc hl,de 
	ld (dv),hl
	; denom = 1 / (a*d - b*c)
	ld hl,(bv) 
	ld bc,(cv)
	call _MultiplyHLBC
	push hl 
	ld hl,(av) 
	ld bc,(dv)
	call _MultiplyHLBC
	pop de
	or a,a
	sbc hl,de 
	push hl 
	pop bc 
	ld hl,65536*16 
	call _DivideHLBC
	ld (denom),hl 
	; du/dx = d/Det
	ld bc,(denom) 
	ld hl,(dv) 
	call _fixedHLmulBC
	ld (dudx),hl 
	; du/dy = -c/Det 
	ld bc,(denom) 
	ld hl,(cv) 
	call _fixedHLmulBC
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld (dudy),hl
	; dv/dx = -b/Det
	ld bc,(denom) 
	ld hl,(bv) 
	call _fixedHLmulBC
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld (dvdx),hl
	; dv/dy = a/Det
	ld bc,(denom) 
	ld hl,(av) 
	call _fixedHLmulBC 
	ld (dvdy),hl
	
	;find miny and maxy for triangle
min1: 
	ld hl,(y0) 
	ld de,(y1) 
	or a,a
	sbc hl,de 
	jp p,min2 ; if y0>y1, goto 
	add hl,de
	ld (miny),hl 
	ld (maxy),de
	jr min3 
min2: 
	add hl,de 
	ld (miny),de 
	ld (maxy),hl
min3: 
	ld hl,(y2)
	ld de,(miny) 
	or a,a 
	sbc hl,de 
	jp p,max1 ; if y2 > miny 
	add hl,de
	ld (miny),hl 
	jr floorminy 
max1: 
	add hl,de 
	ld de,(maxy) 
	or a,a 
	sbc hl,de
	jp m,floorminy ; if y2 < maxy
	add hl,de 
	ld (maxy),hl 
floorminy: 
	ld de,(miny) 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	jp m,ceilmaxy 
	add hl,de 
	ld (miny),hl 
ceilmaxy: 
	ld hl,height-1
	ld de,(maxy) 
	or a,a 
	sbc hl,de 
	jp p,computeuivi 
	add hl,de 
	ld (maxy),hl 
	
computeuivi:
	ld hl,(miny) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	push hl 
	ex de,hl 
	ld bc,(x0) 
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
	ld (ui),hl 
	
	ld hl,(dvdx) 
	pop bc 
	call _MultiplyHLBC
	pop bc 
	push hl 
	ld hl,(dvdy) 
	call _MultiplyHLBC
	pop bc 
	add hl,bc 
	ld (vi),hl
		
renderTriangle: 
	ld de,(miny) 
	ld iy,_edge 
	add iy,de
	add iy,de
	ld a,(maxy) 
	sub a,e 
	ld c,a 
	ld hl,_canvas_data+2  ; current draw buffer 
	ld d,width
	mlt de 
	add hl,de 
yloop: 
	ld a,(iy+0) 
	cp a,(iy+1) 
	jp z,skipLine	; one pixel wide lines are skipped
	ex hl,de 
	or a,a
	sbc hl,hl  
	ld l,a 
	add hl,de 
	push de 
	push hl 
	exx 
	
	; u = ui + dudx*start
	ld hl,(dudx)
	ld b,a  
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
	ld a,b 
	ld de,(ui) 
	add hl,de 
	ld (u),hl
	ld hl,(dudy) 
	add hl,de 
	ld (ui),hl ; ui += dudy 
	; v = vi + dvdx*start
	ld hl,(dvdx) 
	ld b,a  
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
	ld a,b 
	ld de,(vi) 
	add hl,de 
	ld (v),hl
	ld hl,(dvdy) 
	add hl,de 
	ld (vi),hl
	
	ld hl,(dudx)
	add hl,hl 
	push hl 
	pop bc 
	
	ld hl,(dvdx)
	add hl,hl 
	ex de,hl
	
	pop hl
	exx 
	ld b,a 
	ld a,(iy+1)
	sub a,b 
	ld b,a 
	ld de,(texture) 
	
	push iy
	push ix 
	ld iy,(v) 
	ld ix,(u) 
;	de = texture 
;	b = x counter 
;	c = y counter
;	hl' = canvas 
;	bc' = 2*du/dx 
;	de' = 2*dv/dx 
;	ix = u 
;	iy = v 
	
; typically draw 2 pixels at a time

xloop:  
	ld a,iyh 
	and a,0fh 
	ld l,a 
	ld h,16 
	mlt hl 
	ld a,ixh 
	and a,0fh
	add a,l 
	ld l,a 
	add hl,de 
	ld a,(hl) 
	exx 
	ld (hl),a 
	inc hl 
	ld (hl),a 
	inc hl 
	add ix,bc 
	add iy,de 
	exx  
	dec b
	jr z,onePixel 
	djnz xloop 
	
cont: 
	pop ix 
	pop iy 
	pop hl 
	ld de,width 
	add hl,de 
	lea iy,iy+2 
	dec c 
	jp nz,yloop
	
	ld sp,ix 
	pop ix 
	ret 
	
; xloop, only draws one pixel and skips counter logic
onePixel: 
	ld a,iyh 
	and a,0fh 
	ld l,a 
	ld h,16 
	mlt hl 
	ld a,ixh 
	and a,0fh 
	add a,l 
	ld l,a 
	add hl,de 
	ld a,(hl) 
	exx 
	ld (hl),a
	exx 
	jr cont
	
skipLine: 
	exx 
	ld hl,(ui) 
	ld de,(dudy) 
	add hl,de 
	ld (ui),hl 
	ld hl,(vi) 
	ld de,(dvdy) 
	add hl,de 
	ld (vi),hl
	exx
	ld de,width 
	add hl,de 
	lea iy,iy+2 
	dec c 
	jp nz,yloop
	
	ld sp,ix 
	pop ix 
	ret 	
