# To be inserted at 8023B1EC
# Used at [$Required: Flag Game Status and Restore Game State if Necessary] at R4QP01.ini
BEGIN:
  lis r30, 0x8000
  lbz r30, 0x2ff (r30)

# load game status,so the game knows if it needs to show custom text
  andi. r30, r30, 2
  cmpwi cr4, r30, 2

########### PUSH r14-r31 INTO THE STACK
  stwu sp, -0x0050 (sp) # make space for 18 registers
  stmw r14, 0x8 (sp)    # push r14-r31 onto the stack pointer

  #mflr r14              # back up the link register to r14 don't think i need this

  # r15 = pointer to the constants array
  # r16 = cursor in constants array to write
  # r17 = cursor traversing the BL trick
  # r18 = ascii value of chracter to write


  lis r15, 0x80C2       
  ori r15, r15, 0x29D0  # load 80c229d0 into r15

  lwz r15, 0 (r15)      # grab it's value since it's a pointer to a pointer
  lis r16, 0x1          
  ori r16, r16, 0xFDEC
  add r16, r15, r16     # offset it by 0x1fdec (location of "SAFE MEGASTRIKES" text)

##### RESTORE STATUS - CHEAT TEXT ######
  bl BRANCH_LINK_1
  .long 0x52455354 		# REST
  .long 0x4F524500 		# ORE(null)
  .long 0x52455355 		# RESU
  .long 0x4D45204D 		# ME M	
  .long 0x41544348 		# ATCH
  .long 0x00000000		# (null)

BRANCH_LINK_1:
  mflr r17           

RESTORESTATUS_LOOP:
  lbz r18, 0 (r17)   # load the next character from the branch link trick
  addi r17, r17, 1   # increment r17 by 1 to point to the next character of the branch link trick
  sth r18, 0 (r16)   # store a null followed by the character in the place you need to store it
  addi r16, r16, 2   # increment r16 by 2 to point to the next address you need to write on
  cmpwi cr2, r18, 0  # check if last character was a null. if so, exit the loop
  bne cr2, RESTORESTATUS_LOOP  

##### RESTORE STATUS - CHEAT SUB TEXT #####
  lis r16, 2
  ori r16, r16, 0xd2a8  # set r16 to it's new offset
  add r16, r15, r16     # set r16 to the offset + pointer to constants array

CHEAT_SUB_TEXT_LOOP:
  lbz r18, 0 (r17)      # load the next character from the branch link trick
  addi r17, r17, 1      # increment r17 by 1 to point to the next character of the branch link trick
  sth r18, 0 (r16)      # store a null followed by the character in the place you need to store it
  addi r16, r16, 2      # increment r16 by 2 to point to the next address you need to write on
  cmpwi cr2, r18, 0     # check if last character was a null. if so, exit the loop
  bne cr2, CHEAT_SUB_TEXT_LOOP


##### DEFENSIVE PRIORITY - CHEAT TEXT ######
addi r16, r15, 0x7548 
  bl BRANCH_LINK_2
  .long 0x44454620 		# DEF
  .long 0x5052494F 		# PRIO
  .long 0x00000000		# (null)

BRANCH_LINK_2:
mflr r17

DEFPRIO_LOOP:
  lbz r18, 0 (r17)   # load the next character from the branch link trick
  addi r17, r17, 1   # increment r17 by 1 to point to the next character of the branch link trick
  sth r18, 0 (r16)   # store a null followed by the character in the place you need to store it
  addi r16, r16, 2   # increment r16 by 2 to point to the next address you need to write on
  cmpwi cr2, r18, 0  # check if last character was a null. if so, exit the loop
  bne cr2, DEFPRIO_LOOP

##### DEFENSIVE PRIORITY - CHEAT SUB TEXT ######
  lis r16, 2
  ori r16, r16, 0x555e  # set r16 to 0x2555e(location of "MORE POWER TO THE ELECTRIC FENCE" text)
  add r16, r15, r16     # set r16 to the offset + pointer to constants array
  sth r18, 0 (r16)   # store a null halfword to "delete" the cheat subtext

SCORES:
  bne- cr4, END         # if it's not disconnected or connection lost, there's no need to restore
  # note: we don't have the room to store scores greater than 9
  lis r19, 0x8000       # point r19 to exception area where game status variables are kept
  lis r16, 0x1          
  ori r16, r16, 0xd0ca
  add r16, r15, r16     # offset it by 0x1d0ca (location of "SEASON TIME2 text)

  # write home score
  lbz r18, 0x1cc (r19)
  addi r18, r18, 0x30
  sth r18, 0 (r16)

  # write "-" character
  li r18, 0x2d
  sth r18, 2 (r16)

  # write away score
  lbz r18, 0x1cd (r19)
  addi r18, r18, 0x30
  sth r18, 4 (r16)

  # write space character
  li r18, 0x20
  sth r18, 6 (r16)

  bl BRANCH_LINK_3
  .long 0x4772656E			#Gren ID:0
  .long 0x52656420 			#Red  ID:1
  .long 0x5370696E 			#Spin ID:2
  .long 0x426C7565 			#Blue ID:3
  .long 0x42616E61 			#Bana ID:4
  .long 0x426F6D62 			#Bomb ID:5
  .long 0x43686D70 			#Chmp ID:6
  .long 0x5368726D 			#Shrm ID:7 
  .long 0x53746172 			#Star ID:8
  .long 0x43617074 			#Capt
  .long 0x4E4F4E45			#NONE

BRANCH_LINK_3:
  addi r20, r19, 0x1b8  # r20 now points to 0x80000xb8: address of first home item qty
  li r21, 7			# r21 value = 7. r21 will be an important register to keep track if the loop's current state. r20+r21 will always point to the item ID
  li r23, 0

ITEM_LOOP:
  mflr r17              # copy value of link register into r17
  add r22, r20, r21     # r22 will temporarily become the sum of r20 and r21 to point to the item id
  lbz r22, 0 (r22)      # load item id
  cmpwi cr2, r22, 0xff  # ff = no item
  cmpwi cr3, r22, 0x9   # >= 9 means Captain
  blt cr3, ITS_NOT_CAPT
  li r22, 0x9

ITS_NOT_CAPT:
  bne cr2, ITS_NOT_NONE
  li r22, 0xa           

ITS_NOT_NONE:
  mulli r22, r22, 4
  add r17, r17, r22     # add to the value in r17 the value of the item ID multiplied by 4. This way r11 will point to the correct item text

 # now it's time to write the item name
  lbz r18, 0 (r17)
  sth r18, 8 (r16)
  lbz r18, 1 (r17)
  sth r18, 10 (r16)
  lbz r18, 2 (r17)
  sth r18, 12 (r16)
  lbz r18, 3 (r17)
  sth r18, 14 (r16)

  # store quantity number 
  lbz r18, 0 (r20)
  addi r18, r18, 0x30
  sth r18, 16 (r16)

  # write "-" character
  li r22, 0x2d
  sth r22, 18 (r16)

  # loop conditions and counters
  addi r20, r20, 1      # increase r20 by 1, so it will point to next item's qty
  addi r21, r21, 3      # increase r21 by 3 so r20+r21 will point to next item
  addi r16, r16, 12     # increase r16 by 12 so it will point to the next string of text
  addi r23, r23, 1
  cmpwi cr2, r23, 4     # check if r21 is now bigger than r20, if so then that means the 4th iteration of the loop just concluded
  blt cr2, ITEM_LOOP

  # write null char to end string
  li r18, 0x0
  sth r18, 6 (r16)

END:
  mtlr r0               # link register is backed up at 802eb1e0 which is nice for saving a line of code

########### POP r14-r31 FROM THE STACK
  lmw r14, 0x8 (sp)     # pop r14-r31 off the stack pointer
  addi sp, sp, 0x0050   # release the space

  mr r30, r3            # original instruction at 8023B1EC
