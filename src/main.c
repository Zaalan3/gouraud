/* Keep these headers */
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <tice.h>

/* Standard headers (recommended) */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <graphx.h>
#include <keypadc.h>

#include "triangle/tri.h" 
#include "vectormath/vectormath.h"

#include "gfx/pal.h" 
#include "gfx/tileset.h" 

#define startTimer() timer_1_Counter = 0; \
					timer_Control = TIMER1_ENABLE|TIMER1_CPU|TIMER1_UP;
#define stopTimer() timer_Control = TIMER1_DISABLE; 
#define getTimer() timer_1_Counter

gfx_UninitedSprite(canvas,160,120); 

void main(void) {
	Vec2 p0 = {20,20}; 
	Vec2 p1 = {100,20};
	Vec2 p2 = {100,100};
	Vec2 p3 = {20,100};
	int8_t c0,c1,c2,c3; 
	uint8_t angle = 0;
	gfx_Begin(); 
	//gfx_SetPalette(pal_pal,sizeof_pal_pal,0); 
	// gotta show of that full color range
	for(uint8_t i = 0;i <= 32;i++) {
		gfx_palette[i] = i; 
	} 
	gfx_SetDrawBuffer();
	gfx_SetColor(0xFF); 
	gfx_SetTextFGColor(0xFE); 
	
	canvas->width = 160; 
	canvas->height = 120; 


	while(!kb_AnyKey()) {
		int8_t dc = fxtoi(8*fxSin(angle));
		c0 = dc + 10; 
		c1 = dc + 18;
		c2 = dc + 10;
		c3 = dc + 18;
		angle+=3;
		gfx_ZeroScreen(); 
		
		rasterize(p0,p1,p2); 
		GouraudTriangle(p0,p1,p2,c0,c1,c2);
		rasterize(p0,p2,p3);
		GouraudTriangle(p0,p2,p3,c0,c2,c3);
		
		gfx_ScaledSprite_NoClip(canvas,0,0,2,2);	
		gfx_SetTextXY(0,0); 
		gfx_PrintInt(fxSin(angle),1);
		gfx_PrintChar(' ');
		gfx_PrintInt(dc,1); 
		gfx_SwapDraw();
		memset(canvas+2,0,160*120);
	
	}
	
	gfx_End();
} 

