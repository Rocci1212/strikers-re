#To be inserted at 80275070
# PAL, rev2: 80275390
# NTSC-U: 802768EC
# NTSC-J: 80276D44
# NTSC-K: 8027B804

.loc_0x0:
  lwz       r5, 0x0(r29)
  cmpwi     r5, 0x5
  bne+      .loc_0x10
  li        r3, 0

.loc_0x10:
  cmpwi     r3, 0
