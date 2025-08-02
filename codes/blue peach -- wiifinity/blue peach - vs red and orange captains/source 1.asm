#To be inserted at 801C51F0
# PAL, rev2: 801C54A0
# NTSC-U: 801C5E78
# NTSC-J: 801C5E50
# NTSC-K: 801C5ED4

.loc_0x0:
  stw       r29, 0x8(r3)
  # PAL, rev1: 80504ECC
  # PAL, rev2: 8050544C
  # NTSC-U: 80505B5C
  # NTSC-J: 80505F9C
  # NTSC-K: 804D05BC
  lis       r3, 0x8050
  addi      r3, r3, 0x4ECC
  cmpwi     r29, 0x3
  bne-      .loc_0x1C
  li        r4, 0x4
  b         .loc_0x20

.loc_0x1C:
  li        r4, 0x5 # red=true, pink=true

.loc_0x20:
  stw       r4, 0x0(r3)
