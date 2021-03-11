#ifndef TRI_H
#define TRI_H 

#include "vectormath/vectormath.h" 

// edge buffer for current triangle 
uint8_t edge[80][2]; 

// Fills edge buffer given points 
void rasterize(Vec2 p0,Vec2 p1,Vec2 p2); 

// Draws a textured(16x16) triangle 
// disables interrupts
void TexturedTriangle(Vec2 p0,Vec2 p1,Vec2 p2,uint8_t* texture); 

// Draws a Gouraud shaded triagle 
// disables interrupts
void GouraudTriangle(Vec2 p0,Vec2 p1,Vec2 p2,uint8_t color0,uint8_t color1,uint8_t color2);  

#endif