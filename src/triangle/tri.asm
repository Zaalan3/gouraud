public _blitBlitBuffer 

public _initRasterizer

extern _gfx_Begin 
extern _gfx_ZeroScreen 
extern _gfx_SwapDraw 
extern _gfx_SetDraw 

extern _renderGouraudShader
extern _renderGouraudShader_src
extern _renderGouraudShader_len
extern _renderTexturedShader
extern _renderTexturedShader_src
extern _renderTexturedShader_len

extern _fastram_malloc
extern _fastram_init_malloc_cache
extern __TexturedTriangle
extern __GouraudTriangle
extern _load_dynamic_routine

vram equ 0D40000h 
screen equ 0D52C00h 

width equ 160 
height equ 120

_initRasterizer:
	call	_gfx_Begin
	call	_gfx_ZeroScreen
	call	_gfx_SwapDraw
	call	_gfx_ZeroScreen
	call	_gfx_SwapDraw
	or	a, a
	sbc	hl, hl
	push	hl
	call	_gfx_SetDraw
	pop bc

	ld hl,_renderGouraudShader_src
	ld bc,_renderGouraudShader_len
	ld de,_renderGouraudShader
	ldir
	
	ld hl,_renderTexturedShader_src
	ld bc,_renderTexturedShader_len
	ld de,_renderTexturedShader
	ldir

	ret


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