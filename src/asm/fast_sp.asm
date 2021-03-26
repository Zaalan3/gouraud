
public _begin_fast_sp
public _end_fast_sp

_begin_fast_sp:
	pop hl
	ld (_end_fast_sp_restoresp),sp
	ld sp,$E30800 + 1020
	jp (hl)

_end_fast_sp:
	pop hl
	ld sp,0
_end_fast_sp_restoresp:=$-3
	jp (hl)

