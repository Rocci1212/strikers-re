#To be inserted at 801C51F0
# PAL, rev2: 801C54A0
# NTSC-U: 801C5E78
# NTSC-J: 801C5E50
# NTSC-K: 801C5ED4

.loc_0x0:
  stw       r29, 0x8(r3)
  # ADDRESSES FOR REGIONS DIFFERENT THAN PAL REV1 HAVEN'T BEEN TESTED!
  # PAL, rev1: 80504D00
  # PAL, rev2: 80505280
  # NTSC-U: 80505990
  # NTSC-J: 80505DD0
  # NTSC-K: 804D03F0
  lis       r3, 0x8050
  addi      r3, r3, 0x4D00
  cmpwi     r29, 0x3
  bne-      .loc_0x1C
  li        r4, 0x1 # red=true
  b         .loc_0x20

.loc_0x1C:
  li        r4, 0x5 # red=true, pink=true

.loc_0x20:
  # This code doesn't affect peaches color bitfield, instead it affect the bitfield of...
  stw       r4, 0x0(r3)   # Mario
  stw       r4, 0x5C(r3)  # Bowser
  stw       r4, 0x33C(r3) # Bowser jr
  stw       r4, 0x3F4(r3) # Petey
