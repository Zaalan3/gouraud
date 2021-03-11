public _GouraudTriangle

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
ui equ ix-21
dudy equ ix-24
dudx equ ix-27 
denom equ ix-30
dc1 equ ix-33
dc2 equ ix-36

x0 equ ix+6 
y0 equ ix+9 
x1 equ ix+12 
y1 equ ix+15 
x2 equ ix+18 
y2 equ ix+21
color0 equ ix+24
color1 equ ix+27
color2 equ ix+30


_GouraudTriangle: 
	ld hl,-36 
	call __frameset 
	di	; tendency to crash if interrupted 
	
	; dc1 = color1 - color0 
	ld de,(color0) 
	ld hl,(color1)
	or a,a 
	sbc hl,de 
	ld (dc1),hl 
	; dc2 = color2 - color0
	ld hl,(color2)
	or a,a 
	sbc hl,de
	ld (dc2),hl
	
	; a = x1 - x0 	
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
	
	; denom = 1/(a*d-b*c) 
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
	ld hl,65536
	call _DivideHLBC
	ld (denom),hl
	
	; dudx = (dc1*dv - dc2*bv)*denom 
	ld hl,(dc2) 
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
	jp p,computeui
	add hl,de 
	ld (maxy),hl
	
computeui: 
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
	ex de,hl 
	ld hl,(color0) 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
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
	ld hl,_canvas_data+2
	ld d,width
	ld e,(miny) 
	mlt de 
	add hl,de
	; de' = dudx 
	ld de,(dudx) 
	; ix = ui 
	push ix 
	ld ix,(ui)
	
	ld bc,0 
	exx 
yloop: 
	lea iy,ix+0 ; iy = ui
	add ix,de	; ui += dudy 
	ld a,(hl) ; start of line 
	inc hl 
	exx 
	ld c,a 
	push hl 	
	add hl,bc 	; start of line offset 
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
	sub a,c 	; end - start -> x counter  
	jr z,skipxloop
	ld b,a 		; b = x counter 
	
xloop: 
	ld a,iyh ; plot color 
	ld (hl),a
	inc hl 
	add iy,de ; u += dudx 
	djnz xloop 
	
skipxloop: 	
	pop hl 
	ld b,0
	ld c,width 
	add hl,bc 	; offset for next line 
	exx 
	djnz yloop 
	
	pop ix 
	ld sp,ix 
	pop ix 
	ret 
		