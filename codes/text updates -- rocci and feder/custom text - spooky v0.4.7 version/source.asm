#To be inserted at 803014AC
# Used at [$Required: Text Updates] at R4QP01.ini
  # push r14-r31 into the stack
  stwu sp, -0x0050 (sp)  # make space for 18 registers
  stmw r14, 0x8 (sp)     # push r14-r31 onto the stack pointer
  mflr r31 # back the value of the link register up

  lis r30, 0x80c2
  lwz r30, 0x29d0 (r30)  # Load text pointer into r30
  lis r28, 0x9000
  cmpw r30, r28
  blt END  

  lis r29, 0	 # r29 will count the number of the string you're writing

  ### Load location of "SELECT ANY OF THE SEVEN ICONS..." text ###
  lis r14, 0
  ori r14, r14, 0x8cea  # set r14 to it's new offset (0x18442, offset of "POWER SHORTAGE" text)
  add r14, r30, r14     # r14 = text pointer + offset of the text we want to edit

  bl BRANCH_LINK_1
  .long 0x53504F4F 		# SPOO
  .long 0x4B59204D 		# KY M
  .long 0x53432076 		# SC v
  .long 0x302E342E 		# 0.4.	
  .long 0x37004353 		# 7(null)CS
  .long 0x4C205354   # L ST
  .long 0x41444941   # ADIA
  .long 0x004F5249   # (null)ORI
  .long 0x47494E41   # GINA
  .long 0x4C204649   # L FI
  .long 0x454C4420   # ELD 
  .long 0x53504545   # SPEE
  .long 0x44530000   # DS(null)

  BRANCH_LINK_1:
  mflr r17           

  NEXT_STRING:  
  addi r29, r29, 1   # Increment r29 so the code knows which offset to load when the loop has ended

  TEXT_LOOP_1:
  lbz r18, 0 (r17)   # LOAD the next character from the branch link trick
  addi r17, r17, 1   # INCREMENT r17 by 1 to point to the next character of the branch link trick
  sth r18, 0 (r14)   # STORE a null followed by the character in the place you need to store it
  addi r14, r14, 2   # INCREMENT r14 by 2 to point to the next address you need to write on
  cmpwi cr2, r18, 0  # check if last character was a null. if so, EXIT the loop
  bne cr2, TEXT_LOOP_1  

  ### Load location of "POWER SHORTAGE" text ###
  lis r14, 1
  ori r14, r14, 0x8442  # set r14 to it's new offset (0x18442, offset of "POWER SHORTAGE" text)
  add r14, r30, r14     # r14 = text pointer + offset of the text we want to edit
  cmpwi r29, 1
  beq NEXT_STRING
  ### Load location of "ELECTRIC FENCE DOESN'T HURT PLAYERS" text ###
  lis r14, 2
  ori r14, r14, 0x8eca  # set r14 to it's new offset (0x28eca, offset of "ELECTRIC FENCE DOESN'T HURT PLAYERS" text)
  add r14, r30, r14     # r14 = text pointer + offset of the text we want to edit
  cmpwi r29, 2
  beq NEXT_STRING

  END:
  mtlr r31 # restore the value of the link register back
  lmw r14, 0x8 (sp)      # pop r14-r31 off the stack pointer
  addi sp, sp, 0x0050    # release the space
  lwz r0, 20 (r1)        # original instruction at 803014AC
