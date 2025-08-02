#To be inserted at 800FCA80
# Used at [$Required: No Megastrikes] at R4QP01.ini
SHOT_RELEASE:
  # I use a technique called Pushing/Popping the stack here, as shown here:
  # https://mariokartwii.com/showthread.php?tid=873
  stwu sp, -0x0050 (sp) # make space for 18 registers
  stmw r14, 0x8 (sp)    # push r14-r31 onto the stack pointer

CHECK_VERSUS_MODE:
  lis r14, 0x80c5
  mr r16, r14
  ori r14, r14, 0xf33f  # set r14 to 80c5f33f
  lbz r14, 0 (r14)      # are we in versus mode? is this gonna be 1 for in-game ranked matches?
  cmpwi cr2, r14, 0     # versus mode = 0 | need to check in-game ranked here
  bne cr2, CLEAN_UP     # if not, get outta here
  lis r15, 0x80c5			
  ori r15, r15, 0xf340  # load 0x80c5f340 into r15 (address contains value of whether we're online)
  lbz r15, 0 (r15)      # store the value there
  cmpwi cr2, r15, 0
  bne cr2, GET_PLAYER_CHEAT_ONLINE

GET_PLAYER_CHEAT_OFFLINE:
  ori r16, r16, 0xf307    
  b THE_OL_SWITCHEROO  # go to place where we store it

GET_PLAYER_CHEAT_ONLINE:
  ori r16, r16, 0xf29f    
  b THE_OL_SWITCHEROO  # go to place where we store it

THE_OL_SWITCHEROO:
  lis r17, 0x8000
  lbz r14, 0x2fe (r17)  # set r14 now to the byte at 0x800002fe (location that flags captain possession)
  ori r17, r17, 0x2fd
  lbz r17, 0 (r17)

  cmpwi cr2, r14, 0x0   # does the sidekick have the ball?
  bne cr2, CLASSIC_MODE 
  stb r17, 0 (r16)
  b CLEAN_UP

CLASSIC_MODE:
  li r15, 4
  stb r15, 0 (r16)

CLEAN_UP:
  lmw r14, 0x8 (sp)     # pop r14-r31 off the stack pointer
  addi sp, sp, 0x50     # release the space
  lwz r3, 8(r3)

