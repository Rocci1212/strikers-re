# This is a C0 code, meaning that it doesn't have an insertion address, but it's executed once per frame (60 times per second)
# This gecko code has 8 ASM codes in total, 4 for each of the kritters, one of them per each direction
# This is the first ASM code
lis r12, 0x8057
lwz r10, 0xffffA760 (r12) # load the pointer

lfs f2, 0x67C (r10) # load kritter's position

lis r11, 0x3e4c  # float value for 0.2
ori r11, r11, 0xcccd
stw r11, 0x67C (r10)
lfs f3, 0x67C (r10)

fadds f2, f2, f3 # increase the value
stfs f2, 0x67C (r10) # store it back
blr