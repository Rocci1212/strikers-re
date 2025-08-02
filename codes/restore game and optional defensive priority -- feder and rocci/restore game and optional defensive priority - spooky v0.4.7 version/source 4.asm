#To be inserted at 803270e0
# Used at [$Required: Flag Game Status and Restore Game State if Necessary] at R4QP01.ini
  lis r3, 0x8000
  ori r3, r3, 3      # load 80000003 into r3
  stb r3, 0x2fc (r3)  # store 3 at 0x800002ff
  lis r4, 0x80c5
  ori r4, r4, 0xf2d8 # store 80c5f2d8 (location of cheats to r4)
  li r3, 2           # set r3 to 2 (Restore Status cheat)
  stb r3, 0x57 (r4)  # set player cheat to Restore Status
  lis r4, 0x8053 # original instruction at 803270dc
  li r3, 16      # original instruction at 803270e0