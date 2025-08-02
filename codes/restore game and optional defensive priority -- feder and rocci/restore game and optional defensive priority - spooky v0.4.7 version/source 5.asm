# To be inserted at 8033338c
# Used at [$Required: Flag Game Status and Restore Game State if Necessary] at R4QP01.ini
  lis r3, 0x8000
  ori r3, r3, 2       # load 80000002 into r3
  stb r3, 0x2fd (r3)  # store 2 at 0x800002ff
  lis r4, 0x80c5
  ori r4, r4, 0xf2d8  # store 80c5f2d8 (location of cheats) to r4
  stb r3, 0x57 (r4)   # set player cheat to Restore Status
  addi r4, r22, 10308 # original instruction at 80333380
  li r3, 16           # original instruction at 8033338c