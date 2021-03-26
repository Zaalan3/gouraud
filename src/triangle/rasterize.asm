public _rasterize

extern __frameset
extern _MultiplyHLBC
extern _DivideHLBC
extern _getReciprocal
extern _fill
extern _TexturedTriangle
extern _GouraudTriangle


width equ 160 
height equ 120 

typeTextured equ 1 
typeGouraud equ 2 

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

fillRight equ 1

_rasterize: 
	ld hl,-60 	; maximum amount needed by shaders 
	call __frameset
	ld iy,(ix+6)
	di 		; tendency to crash if interrupts enabled
	
findDeterminant: 
	; a = x1 - x0 
	ld hl,(x1) 
	ld de,(x0) 
	or a,a 
	sbc hl,de 
	ld (av),hl 
	push hl  
	pop bc		; bc = a 
	
	; d = y2 - y0 
	ld hl,(y2) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 	; hl = d
	ld (dv),hl 
	; a*d 
	call _MultiplyHLBC
	push hl
	
	; b = y1 - y0 
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	ld (bv),hl 
	push hl  
	pop bc 		; bc = b 
	
	; c = x2 - x0 
	ld hl,(x2) 
	ld de,(x0) 
	or a,a 
	sbc hl,de	; hl = c 
	ld (cv),hl 
	
	; b*c 
	call _MultiplyHLBC
	
	; det = ad - bc 
	pop de 
	ex hl,de
	or a,a 
	sbc hl,de
	
	jp p,positive 
	;return if determinant negative(counterclockwise)? 
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	call _getReciprocal
	ex de,hl 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	ld (denom),hl 
	ld a,0FFh 
	jr copyvert
positive: 
	call _getReciprocal
	ld (denom),hl 
	xor a,a
copyvert: 
	; copy vertices for sorting 
	ld de,(y0) 
	ld hl,(x0) 
	ld (argx0),hl 
	ld (argy0),de 
	
swapv0v1: 
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	jp p,swapv0v2 
	add hl,de 
	ld (y0),hl 
	ld (y1),de 
	ld hl,(x1) 
	ld de,(x0) 
	ld (x0),hl 
	ld (x1),de 
	cpl ; swapping vertices negates sign of determinant 
swapv0v2: 
	ld hl,(y2) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	jp p,swapv1v2 
	add hl,de 
	ld (y0),hl 
	ld (y2),de 
	ld hl,(x2) 
	ld de,(x0) 
	ld (x0),hl 
	ld (x2),de
	cpl	
swapv1v2: 
	ld hl,(y2) 
	ld de,(y1) 
	or a,a 
	sbc hl,de 
	jp p,floorminy  
	add hl,de 
	ld (y1),hl 
	ld (y2),de 
	ld hl,(x2) 
	ld de,(x1) 
	ld (x1),hl 
	ld (x2),de
	cpl
floorminy: 
	ld de,(y0) 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	jp m,ceilmaxy 
	add hl,de 
	ex de,hl
ceilmaxy: 
	ld (miny),de 
	
	ld hl,height-1
	ld de,(y2) 
	or a,a 
	sbc hl,de 
	jp p,detSign 
	add hl,de 
	ex de,hl
detSign: 
	ld (maxy),de
	
	rlca 
	jr c,determinantNegative
	
	; if winding order is clockwise: 
	; x0 to x1 fills right
	; x1 to x2 fills right
	; x0 to x2 fills left 
determinantPositive: 
	lea bc,x0
	ld a,fillRight
	call _fill
	lea bc,x1 
	ld a,fillRight
	call _fill 
	
	lea bc,x1 
	ld hl,(x0) 
	ld (x1),hl 
	ld hl,(y0) 
	ld (y1),hl
	
	xor a,a 
	call _fill
	
	jr callShader 

	; if winding order is counterclockwise: 
	; x0 to x1 fills left
	; x1 to x2 fills left
	; x0 to x2 fills right
determinantNegative: 
	lea bc,x0
	xor a,a
	call _fill
	lea bc,x1 
	xor a,a
	call _fill 
	
	lea bc,x1 
	ld hl,(x0) 
	ld (x1),hl 
	ld hl,(y0) 
	ld (y1),hl
	
	ld a,fillRight
	call _fill
	
		
callShader: 
	ld a,(type) 
	
	cp a,typeTextured 
	jp z,_TexturedTriangle 
	
	cp a,typeGouraud 
	jp z,_GouraudTriangle 
	
endUndefined:	
	; return if shader undefined 
	ld sp,ix 
	pop ix 
	ret 