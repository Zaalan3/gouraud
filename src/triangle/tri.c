
#include "stdint.h"
#include "graphx.h" 

#include "tri.h" 

// edge buffer for current triangle 
uint8_t edge[120*2];

void initRasterizer(void) { 
	gfx_Begin(); 
	gfx_ZeroScreen();
	gfx_SwapDraw(); 
	gfx_ZeroScreen(); 
	gfx_SwapDraw(); // current screen = 0xD52C00
	gfx_SetDrawScreen();
}; 

