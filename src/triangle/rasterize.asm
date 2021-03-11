public _rasterize

extern _MultiplyHLBC
extern _fill

x0 equ ix+6 
y0 equ ix+9 
x1 equ ix+12
y1 equ ix+15 
x2 equ ix+18
y2 equ ix+21

fillRight equ 1

_rasterize: 
	push ix 
	ld ix,0 
	add ix,sp 
	
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
	
swapv1v2: 
	ld hl,(y2) 
	ld de,(y1) 
	or a,a 
	sbc hl,de 
	jp p,findDeterminant 
	add hl,de 
	ld (y1),hl 
	ld (y2),de 
	ld hl,(x2) 
	ld de,(x1) 
	ld (x1),hl 
	ld (x2),de
	; potentially useful for backface culling 
findDeterminant: 
	ld hl,(x1) 
	ld de,(x0) 
	or a,a 
	sbc hl,de 
	push hl  
	pop bc
	ld hl,(y2) 
	ld de,(y0) 
	or a,a 
	sbc hl,de
	call _MultiplyHLBC
	push hl 
	
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	push hl  
	pop bc
	ld hl,(x2) 
	ld de,(x0) 
	or a,a 
	sbc hl,de
	call _MultiplyHLBC
	
	pop de 
	ex hl,de
	or a,a 
	sbc hl,de 
	
	jp m,determinantNegative 

determinantPositive: 
	ld bc,6 
	ld a,fillRight
	call _fill
	ld bc,12
	ld a,fillRight
	call _fill 
	
	ld hl,(x0) 
	ld (x1),hl 
	ld hl,(y0) 
	ld (y1),hl
	ld bc,12
	xor a,a 
	call _fill
	
	ld sp,ix 
	pop ix 
	ret 
	
determinantNegative: 
	ld bc,6 
	xor a,a 
	call _fill
	ld bc,12
	xor a,a
	call _fill
	
	ld hl,(x0) 
	ld (x1),hl 
	ld hl,(y0) 
	ld (y1),hl
	ld bc,12
	ld a,fillRight
	call _fill
	
	ld sp,ix 
	pop ix 
	ret	
	
