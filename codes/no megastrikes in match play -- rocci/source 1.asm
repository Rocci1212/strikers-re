#To be inserted at 800966fc
# Used at [$Required: No Megastrikes] at R4QP01.ini
# in this code, i am moving r30 to r0 for storage, and then back to r30 at the end
# r0 gets wiped after this anyway, so it's free to use
  mr r0, r30
  cmpwi cr2, r31, 0 # make sure possession is being flagged (as opposed to dispossession which sets r31 to 0)
  beq cr2, SKICK_BALL
  lis r30, 0x8056
  ori r30, r30, 0xa740 # location of home captain player object
  lwz r30, 0 (r30)
  cmpw cr2, r30, r0 # compare if the pointer in r30 equals the pointer in r0 from the original function
  beq cr2, CAPT_BALL
  lis r30, 0x8056
  ori r30, r30, 0xa750 # location of away captain player object
  lwz r30, 0 (r30) 
  cmpw cr2, r30, r0 # compare if the pointer in r30 equals the pointer in r0 from the original function
  beq cr2, CAPT_BALL

SKICK_BALL:
  lis r30, 0x8000
  stb r30, 0x2FE (r30)
  b 0x10

CAPT_BALL:
  lis r30, 0x8000
  ori r30, r30, 0x01
  stb r30, 0x2fd (r30)

PUT_PLAYER_CHEAT_IN_R31:
  lis r31, 0x8000
  ori r31, r31, 0x2fd
  lbz r31, 0 (r31)

GET_IS_ONLINE:
  lis r30, 0x80c5
  ori r30, r30, 0xf340
  lbz r30, 0 (r30)
  cmpwi cr2, r30, 0
  lis r30, 0x80c5
  bne cr2, APPLY_PLAYER_CHEAT_ONLINE

APPLY_PLAYER_CHEAT_OFFLINE:
  ori r30, r30, 0xf307
  b FINALLY

APPLY_PLAYER_CHEAT_ONLINE:
  ori r30, r30, 0xf29f

FINALLY:
  stb r31, 0 (r30)
  lwz r31, 0xc (sp)
