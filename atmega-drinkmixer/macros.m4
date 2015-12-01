divert(-1)
define(INIT_STACK,`
    ldi tmp, 0xff; (0xFF & RAMEND) ; ram end low
    out SPL, tmp
    ldi tmp, 0x08; (0xFF & (RAMEND >> 8)) ; ram end high bit
    out SPH, tmp 
')
define(low,  `($1 & 0xFF)')
define(high, `(($1 >> 8) & 0xFF)')

# forloop(i, from, to, stmt)
define(forloop, 
    `pushdef(`$1', `$2')_forloop(`$1', `$2', `$3', `$4')popdef(`$1')')
define(_forloop, 
    `$4`'ifelse($1, `$3', ,
        `define(`$1', incr($1))_forloop(`$1', `$2', `$3', `$4')')')

define(repeat,_`forloop(`i', `1', `$1', `$2')' )

divert
