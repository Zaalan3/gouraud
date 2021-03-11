#ifndef VECMATH
#define VECMATH

typedef struct { 
	int x,y; 
} Vec2;

#define dotProduct(a,b) (fxMul(a.x,b.x) + fxMul(a.y,b.y))
#define determinate(a,b) (fxMul(a.x,b.y) - fxMul(a.y,b.x))
/*
#define max(x,y) ((x>y)?(x):(y))
#define min(x,y) ((x<y)?(x):(y))
*/
#define sign(x) ((x<0)?-1:1)


//https://www.cemetech.net/forum/viewtopic.php?p=253204
int sqrtInt(int x); 

// normalizes vector 
// returns length of original vector.
int normalize(Vec2* v); 

#define itofx(x) (x<<8)

int fxtoi(int x); 

// fixed 8.8 -> 8.8 operations 
int fxMul(int x,int y); 

int fxDiv(int num,int dem); 

// angle in 360 degrees/256 (1.40625)  
int fxSin(uint8_t angle); 

#define fxCos(a) fxSin(a+64)  

#endif