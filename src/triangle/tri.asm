public _blitBlitBuffer 
public _clearBlitBuffer

vram equ 0D40000h 
screen equ 0D52C00h 

width equ 160 
height equ 120

; blits buffer to (80,60) 
_blitBlitBuffer:
	ld a,height 
	ld hl,vram
	exx 
	ld hl,screen + 60*320 + 80 
	ld de,320
	exx
loop: 
	exx 
	push hl 
	add hl,de 
	exx 
	pop de 
	ld bc,width 
	ldir 
	inc h 
	ld l,0 
	dec a 
	jr nz,loop 
	ret 