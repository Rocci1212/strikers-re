# This is a C0 code, meaning that it doesn't have an insertion address, but it's executed once per frame (60 times per second)
# Couldn't find the source code for ASM codes 2-8, so I decompilated them. It's similar to the first code, but for a different direction
loc_0x0:
  lis r12, 0x8057
  lwz r10, -22688(r12)
  lfs f2, 1660(r10)
  lis r11, 0x3E4C
  ori r11, r11, 0xCCCD
  stw r11, 1660(r10)
  lfs f3, 1660(r10)
  fsubs f2, f2, f3
  stfs f2, 1660(r10)
  blr 