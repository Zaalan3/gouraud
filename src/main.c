/* Keep these headers */
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <tice.h>
#include <compression.h>
/* Standard headers (recommended) */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <graphx.h>
#include <keypadc.h>

#include "asm/fast_sp.h"

#include "triangle/tri.h" 
#include "vectormath/vectormath.h"

#include "gfx/gfx.h" 

#define startTimer() timer_1_Counter = 0; \
					timer_Control = TIMER1_ENABLE|TIMER1_CPU|TIMER1_UP;
#define stopTimer() timer_Control = TIMER1_DISABLE; 
#define getTimer() timer_1_Counter

extern uint8_t edge[120*2];

void main(void) {
	uint8_t y = 0;
	triangle_data_t tri0 = {TYPE_TEXTURED,{20,30},{50,20},{20,60},48,64,48,15,15,-15,-15}; 
	triangle_data_t tri1 = {TYPE_GOURAUD,{10,90},{30,30},{45,20},32,50,48,0,15,15,-15};

/* use tail of cursorImage for stack memory */
	begin_fast_sp();

	initRasterizer(); 
	gfx_SetPalette(global_palette,sizeof_global_palette,0); 
	loadTextureMapCompressed(tileset_compressed);
	gfx_SetColor(0xFF); 
	gfx_SetTextBGColor(0x00);
	gfx_SetTextFGColor(0xFF);
	gfx_SetTextTransparentColor(0x00);
	
	
	for(uint8_t i = 0;i <= 32;i++) {
		gfx_palette[i+32] = i;
	} 
	
	
	
	startTimer(); 
	rasterize(&tri0);
	stopTimer(); 
	blitBlitBuffer(); 
	
	gfx_SetTextXY(0,0);
	gfx_PrintUInt(getTimer(),0);
	
	gfx_HorizLine_NoClip(80,60,160); 
	gfx_HorizLine_NoClip(80,180,160); 
	gfx_VertLine_NoClip(80,60,120); 
	gfx_VertLine_NoClip(240,60,120);
	
	while(!kb_AnyKey()){};
	
	
	gfx_ZeroScreen(); 
	clearBlitBuffer(); 
	
	startTimer(); 
	rasterize(&tri1);
	stopTimer();
	
	blitBlitBuffer();

	gfx_SetTextXY(0,0);
	gfx_PrintUInt(getTimer(),0);

	gfx_HorizLine_NoClip(80,60,160); 
	gfx_HorizLine_NoClip(80,180,160); 
	gfx_VertLine_NoClip(80,60,120); 
	gfx_VertLine_NoClip(240,60,120);
	
	delay(333); 
	while(!kb_AnyKey()){};
	
	
	gfx_End();

/* restore stack pointer */
	end_fast_sp();

} 

