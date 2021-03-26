public _fill

extern _edge 

extern _MultiplyHLBC
extern _getReciprocal
extern _fixedHLmulBC

width equ 160 
height equ 120 

x0 equ (iy+0)
y0 equ (iy+3) 
x1 equ (iy+6)
y1 equ (iy+9) 

; fills edge buffer 
;in: a = 0 -> fill left buffer (  ) 
; OR a = 1 -> fill right buffer (  ) 
; bc = ptr to points
; Assumes no clipping right now.
_fill: 
	push iy 
	push bc 
	pop iy 
	ld (SMCbuffer),a 
	ld (SMCbuffer2),a
dy: 
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	jp z,endfill
	call _getReciprocal
	push hl 
dx: 
	ld hl,(x1) 
	ld bc,(x0) 
	or a,a 
	sbc hl,bc
	jp z,straight 	; straight line special case
	pop bc 
	call _fixedHLmulBC  ; dx/dy 
	ex hl,de 
	
	ld hl,(x0)
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	exx 
	
	ld de,(y0) 
	or a,a 
	sbc hl,hl 
	sbc hl,de 
	jp p,find0 	; find line intersection with 0 if y0 < 0
	
clipY1: 
	push de 
	ld de,(y1)	; go to y1 if y1 < height
	ld hl,height-1 
	or a,a 
	sbc hl,de 
	jr nc,noclip 
	ld a,height-1
	jr ycounter 
noclip: 
	ld a,e 	; a = y1 
ycounter: 
	pop de 
	sub a,e 	; a = y counter 
		
	ld iy,_edge ; iy = edge pointer 
	add iy,de
	add iy,de 
	
	exx 
	ld b,a 
	
yloop: 
	add hl,de
storeEdge: 
	ld (iy+0),h
SMCbuffer:=$-1 
	lea iy,iy+2  
	djnz yloop 
endfill: 
	pop iy 
	ret 
	
find0: 
	exx 
	push de
	exx 
	pop bc 
	call _MultiplyHLBC ; hl = (dx/dy)*abs(y0)
	
	push hl 
	exx 
	pop bc 
	add hl,bc 
	exx 
	ld de,0 
	jp clipY1
	
;-------------------------------------------
; special case for dx = 0 	
straight: 	
	pop bc 
	ld bc,(x0) 
	; clip y coordinates 
s_clipy0: 
	ld de,(y0) 
	or a,a 
	sbc hl,hl 
	sbc hl,de
	jp m,s_clipy1 
	add hl,de 
	ex de,hl 
s_clipy1: 
	push de 
	ld de,(y1)	; go to y1 if y1 < height
	ld hl,height-1 
	or a,a 
	sbc hl,de 
	jr nc,s_noclip 
	ld a,height-1
	jr s_ycounter 
s_noclip: 
	ld a,e 	; a = y1 
s_ycounter: 
	pop de 
	sub a,e 	; a = y counter 
	
	ld iy,_edge ; iy = edge pointer 
	add iy,de
	add iy,de
	
	; clip x value
s_floorx: 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	jp m,s_ceilx 
	ld c,0 
	jr s_storeEdge 
s_ceilx: 
	ld hl,width-1
	sbc hl,hl 
	sbc hl,bc 
	jr nc,s_storeEdge 
	ld c,width-1
	
s_storeEdge: 
	ld l,c 
	ld b,a
s_loop:
	ld (iy+0),l ; store in edge buffer 
SMCbuffer2:=$-1 
	lea iy,iy+2 
	djnz s_loop
	
	pop iy
	ret 