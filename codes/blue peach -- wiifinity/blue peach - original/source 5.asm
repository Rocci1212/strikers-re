#To be inserted at 802784A8
# PAL, rev2: 80278734
# NTSC-U: 80279C90
# NTSC-J: 8027A0E8
# NTSC-K: 8027EBA8

.loc_0x0:
  lwz       r5, 0x0(r28)
  cmpwi     r5, 0x5
  bne+      .loc_0x10
  li        r3, 0

.loc_0x10:
  cmpwi     r3, 0
