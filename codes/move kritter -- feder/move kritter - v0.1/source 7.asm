ASM-Code 7:
# This is a C0 code, meaning that it doesn't have an insertion address, but it's executed once per frame (60 times per second)
loc_0x0:
  lis r12, 0x8057
  lwz r10, -22684(r12)
  lfs f2, 1656(r10)
  lis r11, 0x3E4C
  ori r11, r11, 0xCCCD
  stw r11, 1656(r10)
  lfs f3, 1656(r10)
  fsubs f2, f2, f3
  stfs f2, 1656(r10)
  blr 