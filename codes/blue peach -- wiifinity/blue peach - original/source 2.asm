#To be inserted at 801A34CC
# PAL, rev2: 801A39CC
# NTSC-U: 801A4278
# NTSC-J: 801A4278
# NTSC-K: 801A4480

.loc_0x0:
  lwz       r5, 0x0(r30)
  cmpwi     r5, 0x5
  bne+      .loc_0x10
  li        r3, 0

.loc_0x10:
  cmpwi     r3, 0
