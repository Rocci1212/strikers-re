#To be inserted at 802849A4
# Used at [$Required: Flag Game Status and Restore Game State if Necessary] at R4QP01.ini
# Flag Game Status
GAME_BEGIN:
  lis r28, 0x8000       # Load 0x80000000 into r28
  cmpwi cr2, r6, 0x9    # Check if GameBegin is being called
  bne+ cr2, GAME_END    # If not, go to next check
  li r4, 0x4            # Load 4 into r4
  stb r4, 0x2FF (r28)   # Store 4 into 0x800002FF

GET_IS_ONLINE:
  lis r4, 0x80c5
  ori r4, r4, 0xf340    # load 80c5f340 into r4
  lbz r4, 0 (r4)        # load the value in (0 if off-line, 1 if online)
  cmpwi cr3, r4, 0      # are we online, or offline? store it in condition register 3
  lis r4, 0x80c5        # get ready for finding the address of the player cheat
  bne cr3, GET_PLAYER_CHEAT_ONLINE  # if r4 = 1, then we're online, get the value there

GET_PLAYER_CHEAT_OFFLINE:
  ori r4, r4, 0xf307    
  lbz r4, 0 (r4)        # load value in the player cheats (offline) into memory
  b STORE_PLAYER_CHEAT  # go to place where we store it

GET_PLAYER_CHEAT_ONLINE:
  ori r4, r4, 0xf29f    
  lbz r4, 0 (r4)        # load value in the player cheats (online) into memory
  cmpwi r4, 2           # check if safe megas selected - if so, restore match status
  bne STORE_PLAYER_CHEAT

STORE_PLAYER_CHEAT:
  stb r4, 0x2fd (r28)   # Store Player Cheat into 0x800002FD
  b FINALLY             # Go to original instruction

GAME_END:
  cmpwi cr2, r6, 0x12   # Check if GameEndSuddenDeath is being called
  bne+ cr2, IDLE_START  # If not, go to next check
  lis r4, 0x80c5       	# Load 0 into r4
  stb r4, 0x2FF (r28)  	# Store 0 into 0x800002FF
  ori r4, r4, 0xf29f
  lbz r5, 0 (r4)        # load value in the player cheats (online) into memory
  cmpwi r5, 2           # check if safe megas selected - if so, reset back to 0
  bne FINALLY
  li r5, 0
  stb r5, 0 (r4)
  stb r5, 0x90 (r4)
  b FINALLY        	    # Go to original instruction

IDLE_START:
  cmpwi cr2, r6, 4      # Check if Idle is being called
  bne+ cr2, FINALLY     # If not, go to end of function
  lbz r28, 0x2FF (r28)	# Load flag of game status in r28
  cmpw cr2, r6, r28     # Check the game status
  bne+ cr2, FINALLY     # Get out if the game status is not (cutscenes started)
  lis r28, 0x8000  			# Load 0x80000000 back into r28
  li r4, 0x1       			# Load 1 into r4
  stb r4, 0x2FF (r28)   # Store 1 into 0x800002FF

RESTORE_MATCH_STATUS:
  stwu sp, -0x50 (sp)   # make some space for registers
  stmw r14, 0x8 (sp)    # push r14-r31 onto the stack pointer

  lis r23, 0x806d
  ori r23, r23, 0xf9d8  # load 806df9d8 into r23 - this is the game state struct
  lwz r23, 0 (r23)      # load value from it's address into it

  lis r27, 0x80c6
  lbz r26, 0xfffff29f (r27) # load 80c5f29f (location of player cheat) into r26
  lbz r28, 0xfffff29b (r27) # load 80c5f29b (location of stadium cheat) into r28

  lis r22, 0x8000       # load 80000000 into r22 - we'll be able to access feder's game backup from there

  cmpwi r26, 2           # compare with 2 (safe megas - this will be the restore match status cheat)
  bne REMOVE_HAZARDS_FROM_DEF_PRIO

LOAD_THE_BACKUP:
  lbz r24, 0x1cc (r22)    # load current home score
  lbz r25, 0x1cd (r22)  # load current away score
  lwz r14, 0x1c0 (r22)   # home item 1
  lbz r15, 0x1b9 (r22)   # home item 1 quantity
  lwz r16, 0x1bc (r22)   # home item 2
  lbz r17, 0x1b8 (r22)   # home item 2 quantity
  lwz r18, 0x1c4 (r22)  # away item 1
  lbz r19, 0x1ba (r22)  # away item 1 quantity
  lwz r20, 0x1c8 (r22)  # away item 2
  lbz r21, 0x1bb (r22)  # away item 2 quantity

RESTORE_THE_BACKUP:
  stb r24, 0x7 (r23)				# Update current home score
  stb r24, 0x182b (r23)				# Update current home score (visually)
  stb r25, 0xb6f (r23)				# Update current away score
  stb r25, 0x182f (r23)				# Update current away score (visually)
  stw r14, 0x8c (r23)				# home item 1
  stb r15, 0x93 (r23)				# home item 1 quantity
  stw r16, 0x98 (r23)				# home item 2
  stb r17, 0x9f (r23)				# home item 2 quantity
  stw r18, 0xbf4 (r23)				# away item 1
  stb r19, 0xbfb (r23)				# away item 1 quantity
  stw r20, 0xc00 (r23)				# away item 2
  stb r21, 0xc07 (r23)				# away item 2 quantity

REMOVE_HAZARDS_FROM_DEF_PRIO:
  cmpwi r28, 0x3                # check if stadium cheat is 3 (defensive priority)
  li r28, 0                     # wipe r28
  bne END_RESTORE_MATCH_STATUS  # go to end of function if not defensive priority
  li r28, 1                     # set r28 to 1 (secure stadia)
  stb r28, 0xfffff29b (r27)     # set secure stadia to stadium cheat

END_RESTORE_MATCH_STATUS:
  stb r28, 0x1ff (r22)  # store stadium cheat to feder's game backup
  lmw r14, 0x8 (sp)     # pop r14-r31 off the stack pointer
  addi sp, sp, 0x0050   # release the space

FINALLY:
  add r3, r29, r6  			# Original instruction at 0x802849a4

###
