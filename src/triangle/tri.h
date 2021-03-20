#ifndef TRI_H
#define TRI_H 

#include "vectormath/vectormath.h" 

#define TYPE_NULL 0
#define TYPE_TEXTURED 1
#define TYPE_GOURAUD 2

typedef struct 
{ 
	uint8_t type; 
	Vec2 p0,p1,p2; 
	uint8_t l0,l1,l2; 
	uint8_t u0,v0; 
	int uw,vh; 
} triangle_data_t; 

void initRasterizer(void); 

#define loadTextureMap(ptr) memcpy((void *)0xD48000,(void *)ptr,32*1024)
#define loadTextureMapCompressed(ptr) zx7_Decompress((void *)0xD48000,(void *)ptr)

// copies blit buffer to (80,60) on screen
void blitBlitBuffer(void); 

#define clearBlitBuffer() memset((void *)0xD40000,0,32*1024)
 
// Fills edge buffer given points 
void rasterize(triangle_data_t* t); 

#endif