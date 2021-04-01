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
	triangle_data_t tri = {TYPE_TEXTURED,{20,15},{50,13},{60,40},48,64,48,0,0,16,16};
	triangle_data_t temp; 
	
	begin_fast_sp();
	
	initRasterizer(); 
	gfx_SetPalette(global_palette,sizeof_global_palette,0); 
	loadTextureMapCompressed(tileset_compressed);
	gfx_SetColor(0xFF); 
	
	gfx_HorizLine(80,59,160);
	gfx_HorizLine(80,180,160);
	gfx_VertLine(79,60,120);
	gfx_VertLine(240,60,120);
	gfx_SetTextBGColor(0x00);
	gfx_SetTextFGColor(0xFF);
	gfx_SetTextTransparentColor(0xFE);
	gfx_SetColor(0); 
	
	for(uint8_t i = 0;i <= 32;i++) {
		gfx_palette[i+32] = i;
	} 
	
	
	kb_Scan();
	
	while(!kb_IsDown(kb_KeyClear)) {
		
		if(kb_AnyKey()) { 
		kb_Scan();
		if(kb_IsDown(kb_KeyUp))  { 
			tri.p1.y-=2; 
		} else if(kb_IsDown(kb_KeyDown)) { 
			tri.p1.y+=2;
		} 
		
		if(kb_IsDown(kb_KeyLeft))  { 
			tri.p1.x-=2; 
		} else if(kb_IsDown(kb_KeyRight))  { 
			tri.p1.x+=2;
		} 
		
		if(kb_IsDown(kb_Key8))  { 
			tri.p2.y-=2; 
		} else if(kb_IsDown(kb_Key2))  { 
			tri.p2.y+=2;
		}

		if(kb_IsDown(kb_Key4))  { 
			tri.p2.x-=2; 
		} else if(kb_IsDown(kb_Key6))  { 
			tri.p2.x+=2;
		} 
		
		if(kb_IsDown(kb_Key0))  { 
			if(tri.type == TYPE_TEXTURED) { 
				tri.type = TYPE_GOURAUD; 
			} else { 
				tri.type = TYPE_TEXTURED;
			} 
		} 
		
		temp = tri; 
		clearCanvas(); 
		
		startTimer(); 
		rasterize(&temp);
		stopTimer();
		
		blitCanvas(); 
		
		gfx_FillRectangle_NoClip(0,0,60,16); 
		gfx_SetTextXY(0,0);
		gfx_PrintUInt(getTimer(),0);
		gfx_SetTextXY(0,8); 
		int det = (tri.p1.x - tri.p0.x)*(tri.p2.y - tri.p0.y) - (tri.p2.x - tri.p0.x)*(tri.p1.y - tri.p0.y);
		gfx_PrintInt(det,0);
		delay(100);
		} 
				
	};
		
	gfx_End();
	
	end_fast_sp();
} 

