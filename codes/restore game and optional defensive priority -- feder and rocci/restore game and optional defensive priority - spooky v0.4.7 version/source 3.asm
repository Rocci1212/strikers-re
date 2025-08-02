#To be inserted at 8031c638
# Used at [$Required: Flag Game Status and Restore Game State if Necessary] at R4QP01.ini
START:
########### PUSH r14-r31 INTO THE STACK
  stwu sp, -0x0050 (sp) #make space for 18 registers
  stmw r14, 0x8 (sp) #push r14-r31 onto the stack pointer
###########

# =========================================================================== #
##### PART 1 - CHECK IF CONDITIONS TO ACTIVATE THIS CODE ARE SATISFIED #####
  lis r22, 0x806e
  lwz r22, 0xFFFFf9d8 (r22)			# Load pointer to match status struct
  lis r23, 0x80c6
  
### CLEAR THE BACK UP ###
  lis r30, 0				# r30 = 0
  subi r31, r30, 1				# r31 = -1

### CHECK IF ONLINE ###
  lbz r23, 0xFFFFf340 (r23)
  cmpwi r23, 1
  bne END			# Don't execute code if playing offline
  lis r23, 0x8000

STRUCT_IS_LOADED:
  lbz r24, 0x7 (r22)				# Load current home score
  lbz r25, 0xb6f (r22)				# Load current away score
  lwz r14, 0x8c (r22)				# home item 1
  lbz r15, 0x93 (r22)				# home item 1 quantity
  lwz r16, 0x98 (r22)				# home item 2
  lbz r17, 0x9f (r22)				# home item 2 quantity
  lwz r18, 0xbf4 (r22)				# away item 1
  lbz r19, 0xbfb (r22)				# away item 1 quantity
  lwz r20, 0xc00 (r22)				# away item 2
  lbz r21, 0xc07 (r22)				# away item 2 quantity

# =========================================================================== #
##### PART 2 - BACK UP MATCH STATUS #####
### COPY CURRENT SCORE/ITEMS INTO THE EXCEPTION VECTOR AREA ###
  stb r24, 0x1cc (r23)				# Update copy of home score 
  stb r25, 0x1cd (r23)				# Update copy of away score
  stw r14, 0x1c0 (r23)				# home item 1
  stb r15, 0x1b9 (r23)				# home item 1 quantity
  stw r16, 0x1bc (r23)				# home item 2
  stb r17, 0x1b8 (r23)				# home item 2 quantity
  stw r18, 0x1c4 (r23)				# away item 1
  stb r19, 0x1ba (r23)				# away item 1 quantity
  stw r20, 0x1c8 (r23)				# away item 2
  stb r21, 0x1bb (r23)				# away item 2 quantity
  b END

# =========================================================================== #
##### END #####
END:
########### POP r14-r31 FROM THE STACK
  lmw r14, 0x8 (sp) #pop r14-r31 off the stack pointer
  addi sp, sp, 0x0050 #release the space
blr		# Original instruction