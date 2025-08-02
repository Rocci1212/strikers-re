# THIS CODE MAKES USE OF E.V.A. BYTES 0x1e0-0x1e3 (only to load floats)
# Must add this non-asm line at the beginning: 040001e0 40000000 (it sets the speed constant)
# You can change that to a different float if you want slower/faster speed
lis r11, 0x8058
lfs f11, 0x5F40 (r11) # load stick X
lfs f12, 0x5F44 (r11) # load stick Y

lis r9, 0x8057
lis r10, 0x8000
lfs f2, 0x73a0 (r9)  # load cursorX
lfs f3, 0x73a4 (r9)  # load cursorY
lfs f13, 0x1e0 (r10) # load speed constant

fmuls f11, f11, f13  # multiply stick X and Y by speed constant
fmuls f12, f12, f13
fadds f2, f2, f11  # update cursorX
fadds f3, f3, f12  # update cursorY

lhz r11, 0x5ee2 (r11)
andi. r0, r11, 0x0400 # check if B pressed
beq+ NOT_RECENTER
lfs f2, 0x1e0 (r10) # set x to (almost) 0
lfs f3, 0x1e0 (r10) # set y to (almost) 0
NOT_RECENTER:

stfs f2, 0x73a0 (r9)  # store cursorX
stfs f3, 0x73a4 (r9)  # store cursorY
blr
