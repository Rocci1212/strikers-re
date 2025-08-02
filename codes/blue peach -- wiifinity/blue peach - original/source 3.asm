#To be inserted at 8008EEB4
# PAL, rev2: 8008F188
# NTSC-U: 8008F4C0
# NTSC-J: 8008F4C0
# NTSC-K: 8008F664

.loc_0x0:
  lwz       r5, 0x0(r29)
  cmpwi     r5, 0x5
  bne+      .loc_0x10
  li        r3, 0

.loc_0x10:
  cmpwi     r3, 0
