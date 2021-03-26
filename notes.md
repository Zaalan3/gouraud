
# Relocated code offsets and sizes in fast RAM
- 0x000: 128 (0x080) bytes of I'm not sure why this isn't being used
- 0x080: 157 (0x09D) bytes Textured Triangle shader
- 0x120:  59 (0x03B) bytes Gouraud Triangle shader
- 0x160: 416 (0x1A0) bytes unused
- 0x300: 252 (0x0FC) bytes stack

# Program test times

## Default stack location
- 81742 approx. cycles textured triangle
- 66267 approx. cycles gouraud shaded triangle

## Stack located in fast RAM
- 64774 approx. cycles textures triangle (~126.2% faster)
- 59338 approx. cycles gouraud shaded triangle (~111.7% faster)
In the current build the stack never exceeds 60 bytes in size.
Reserving memory range 0xE30B00 to 0xE30BFC for stack memory would be optimal.
