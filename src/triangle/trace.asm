public _fill

extern _edge 
extern _DivideHLBC
extern _MultiplyHLBC

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
;
_fill: 
	push iy 
	push bc 
	pop iy 
	ld (SMCbuffer+2),a 
	ld (SMCbuffer2+2),a
dy: 
	ld hl,(y1) 
	ld de,(y0) 
	or a,a 
	sbc hl,de 
	jp z,endfill
	ex de,hl ; de = dy 
dx: 
	ld a,03h	; inc bc 
	ld hl,(x1) 
	ld bc,(x0) 
	or a,a 
	sbc hl,bc
	jp z,straight 	; straight line special case 
	jp p,positive 
	ld a,0Bh	; dec bc 
	push hl 
	pop bc 
	or a,a 
	sbc hl,hl 
	sbc hl,bc ; negate dx 
positive: 
	ld (SMCxdir),a 
	ld (SMCxdir2),a 
	push hl 
	pop bc ; bc = dx 
	
	or a,a 
	sbc hl,hl ; err = 0 
	
	exx 
	ld bc,(x0) 
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
	
yloop: 
floorx: 
	or a,a 
	sbc hl,hl 
	sbc hl,bc 
	jp m,ceilx 
	ld l,0 
	jr SMCbuffer 
ceilx: 
	ld hl,width-1
	sbc hl,hl 
	sbc hl,bc 
	jr nc,storeEdge 
	ld l,width-1
	jr SMCbuffer
	
storeEdge: 
	ld l,c 
SMCbuffer: ld (iy+0),l
	lea iy,iy+2 
	exx 
	add hl,bc ; err += dx 
xloop: 
	or a,a 
	sbc hl,de ; err -= dy  
	jr c,endxloop ; stop if err < dy 
	exx 
SMCxdir: nop 	; x += xdir 
	exx 
	jr xloop 
endxloop: 
	add hl,de 
	exx 
	
	dec a 
	jr nz,yloop
	
endfill:
	pop iy
	ret
;-------------------------------------------
find0: 
	push bc 
	exx 
	push bc 
	exx 
	pop bc 
	call _MultiplyHLBC ; hl = dx*abs(y0)
	pop bc 
	push hl 
	exx 
	pop hl ; err = abs(dx)*y0
	
find0loop: 
	or a,a 
	sbc hl,de ; err -= dy  
	jr c,endfind0 ; stop if err < dy 
	exx 
SMCxdir2: nop 	; x += xdir 
	exx 
	jr find0loop
endfind0: 
	add hl,de 
	exx 
	ld de,0 
	jp clipY1
	
;-------------------------------------------
; special case for dx = 0 
straight: 	
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
SMCbuffer2: ld (iy+0),l ; store in edge buffer 
	lea iy,iy+2 
	djnz SMCbuffer2
	
	pop iy
	ret 
	
	