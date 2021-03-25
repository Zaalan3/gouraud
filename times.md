
# Default stack location
- 81742 approx. cycles textured triangle
- 66267 approx. cycles gouraud shaded triangle

# Stack located in fast RAM
- 64774 approx. cycles textures triangle (~126.2% faster)
- 59338 approx. cycles gouraud shaded triangle (~111.7% faster)
In the current build the stack never exceeds 60 bytes in size.
Reserving the last 256 bytes of cursorImage (where the stack is located in this test) would be optimal.
Reserve memory range 0xE30B00 to 0xE30BFC for stack memory.
