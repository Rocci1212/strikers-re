#To be inserted at 803aae4c
# PAL rev2:
# NTSC-U:
# NTSC-J:
# NTSC-K:

# TRAINING MODE WITH BUILT-IN ITEM MODIFIER!
# Version 1.5
# Exception vector area bytes used: 0x80001550-0x80001553
# Known safe registers: r12, r11, r3, r5, r15, r16, r17, r18, r10
# Useful registers: r8 input bitfield, r28 controller number (starting from 0)


CHECK_INPUT_ENABLE_FOR_HOME:
    lis r12, 0x8000             # r12 needs to remain untouched for the rest of the code
    cmpwi r8, 0x0110 			# Check if 2 and + are pressed
    bne+ CHECK_INPUT_ENABLE_FOR_AWAY
    li r10, 2		
    stb r10, 0x1553 (r12)			# SET TRAINING MODE STATUS TO 2 (for home)

CHECK_INPUT_ENABLE_FOR_AWAY:
    cmpwi r8, 0x1100 			# Check if 2 and - are pressed
    bne+ CHECK_INPUT_DISABLE
    li r10, 1
    stb r10, 0x1553 (r12)			# SET TRAINING MODE STATUS TO 1 (for away)

CHECK_INPUT_DISABLE:
    cmpwi r8, 0x0500 			# Check if 2 and B are pressed
    beq- DISABLE_TRAINING_MODE


CHECK_TRAINING_MODE_ACTIVE:
    lis r15, 0x80c6			# Load 0x80c60000 in r15
    # First check: load "isOnline" and disable training mode if true
    lbz r10, 0xFFFFf340 (r15)	
    # PAL rev1: 80C5F340
    # PAL rev2:
    # NTSC-U:
    # NTSC-J:
    # NTSC-K:
    cmpwi r10, 1
    beq+ DISABLE_TRAINING_MODE
    # Second check: load training mode status and skip the training mode code if 0
    lbz r10, 0x1553 (r12)			
    cmpwi cr7, r10, 1       # from now on, cr7 will be LESS if t-mode disabled, EQUAL if active for away, GREATER if active for home
    blt cr7, DISABLE_TRAINING_MODE

STOP_TIMER:
    lis r5, 0			
    stb r5, 0xFFFFf22b (r15)  # Store 0 at the address that holds "isFirstToX" boolean value (set the gamemode to timed) 
    lis r15, 0x80cf			# Load 0x80cf50f8, address with timer
    # PAL rev1: 80C5F22B
    # PAL rev2:
    # NTSC-U:
    # NTSC-J:
    # NTSC-K:
    stw r5, 0x50f8 (r15)	# Set it to 0


MAKE_TEAM_DISAPPEAR:    
    li r15, 4               # r15 is the loop counter. 4 iterations.
    lis r11, 0x4100         # r11 = float 6     Y coord we're sending everyone to        
    lis r10, 0xC1B0         # r10 = float -22   X coord we're sending home sidekicks to
    # r5 = float 0      X coord we're sending the captain to
    lis r17, 0x8056			# Load address for Player objects in r16
    ori r16, r17, 0xA740
    # PAL rev1: 8056A740
    # PAL rev2:
    # NTSC-U:
    # NTSC-J:
    # NTSC-K:
    beq cr7, TEAM_DISAPPEAR_LOOP    # if training mode status == 1, we need to kill home
    addi r16, r16, 0x10             # else, we need to kill away, so increment address by 0x10...
    lis r10, 0x41B0                 # and set r10 = float +22. We'll need to send them to positive coords

TEAM_DISAPPEAR_LOOP:
    lwz r3, 0 (r16)     # load the object
    cmpwi r3, 0         # check if object null and disable training mode if so
    beq DISABLE_TRAINING_MODE
    stw r5, 0x5d0 (r3)  # update X position
    stw r11, 0x5d4 (r3) # update Y position
    mr r5, r10			# from the second iteration, r5 will become +22 (or -22) insead of 0
    addi r16, r16, 4    # increment address (move on to the next player)
    subi r15, r15, 1    # decrement counter and check if it reached zero
    cmpwi r15, 0
    bgt+ TEAM_DISAPPEAR_LOOP


ITEM_STUFF:
    # r12 needs to still be 0x80000000
    lbz r5, 0x1550 (r12)			# Load current selected item
    lbz r10, 0x1551 (r12)			# Load current selected item's quantity
    cmpwi r5, 0xff			# If r5 = 0xff then it becomes 0xffffffff, otherwise it would break the game
    bne SET_ITEM_QUANTITY_NOT_ZERO
    li r5, 0xFFFFFFFF

SET_ITEM_QUANTITY_NOT_ZERO:
    cmpwi r10, 0			# If r10 = 0 then certain items won't work because quantity = 0
    bne CHECK_IF_INPUTS_LOCKED
    li r10, 1

CHECK_IF_INPUTS_LOCKED:
    lbz r16, 0x1552 (r12)      # load controller number of who pressed dpad on this or on last frame. 4 if nobody
    cmpwi r16, 4
    bne- CHECK_IF_SAME_CONTROLLER

CHECK_INPUT_LEFT:
    cmpwi r8, 0x0101 			# Check if 2 and D-Pad Left are pressed
    bne+ CHECK_INPUT_RIGHT
    subi r5, r5, 1              # decrement item ID
	cmpwi r5, 0xFFFFfffe        # if too low, loop to 12 (bowser special)
	bne CHECK_INPUT_RIGHT
	li r5, 0x0c 
	
CHECK_INPUT_RIGHT:
    cmpwi r8, 0x0102 			# Check if 2 and D-Pad Right are pressed
    bne+ CHECK_INPUT_DOWN
    addi r5, r5, 1              # increment item ID
	cmpwi r5, 0x0d              # if too high, loop to -1 (no item)
	bne CHECK_INPUT_DOWN
	li r5, 0xFFFFffff
    
CHECK_INPUT_DOWN:
    cmpwi r8, 0x0104 			# Check if 2 and D-Pad Down are pressed
    bne+ CHECK_INPUT_UP        
	cmpwi r10, 1                # if quantiy is 1 (minimum), skip this
	ble CHECK_INPUT_UP
	subi r10, r10, 1            # decrement quantity

CHECK_INPUT_UP:
    cmpwi r8, 0x0108 			# Check if 2 and D-Pad Up are pressed
    bne+ CHECK_IF_SAME_CONTROLLER
	cmpwi r10, 25               # if quantity is 25 (maximum), skip this
	bge CHECK_IF_SAME_CONTROLLER
	addi r10, r10, 1            # increment quantity

CHECK_IF_SAME_CONTROLLER:
    cmpwi r16, 4            # If nobody pressed dpad on last frame, check if somebody is now.
    beq DETERMINE_IF_SHOULD_LOCK_INPUTS
    cmpw r16, r28           # If this is not the same controller that started holding d-pad, skip this. The input lock byte will stay as is.
    bne UPDATE_INPUT_LOCK_BYTE 
    li r16, 4               # If this is the same controller that started holding d-pad, check if is still holding. If not store 4 at 80001552

DETERMINE_IF_SHOULD_LOCK_INPUTS:
    andi. r0, r8, 0x000f	# Do a bitwise AND between r8 and 0x000f. Each of the four d-pad buttons sets one of the last bits high and we want the code to take the branch if none is pressed.
    beq+ UPDATE_INPUT_LOCK_BYTE
    # D-PAD HAS BEEN PRESSED ON THIS FRAME, therefore player's input will be ignored starting from the next frame until the player who pressed the button releases it.
	
LOCK_INPUTS:
    mr r16, r28			    # If a d-pad button was pressed by this controller, save its number

UPDATE_INPUT_LOCK_BYTE:
    stb r16, 0x1552 (r12)	# Update the value at 0x80001552

SAVE_ITEM_SELECTION:
    stb r5, 0x1550	(r12)		# Store the item you picked into 0x80001550
    stb r10, 0x1551	(r12)		# Store item quantity into 0x80001551
    li r11, 0xFFFFffff	        # r11 = -1. Away will have its items removed
    bgt cr7, GIVE_ITEMS         # Check if training mode is on for home or if it's for away

AWAY_GETS_ITEMS:
    mr r11, r5                  # Give items to away
    li r5, 0xFFFFffff	        # r5 = -1. Home will have its items removed

GIVE_ITEMS:
    lis r16, 0x806E
    lwz r16, 0xFFFFF9D8 (r16)	# Load pointer to the struct that contains the player's item
    # PAL rev1: 806DF9D8
    # PAL rev2:
    # NTSC-U:
    # NTSC-J:
    # NTSC-K:
    stw r5, 0x8C (r16)		    # Store home's new item
    stw r10, 0x90 (r16)		    # Store home's new item quantity
    stw r11, 0xBF4 (r16)	    # Remove away's items
    stw r10, 0xBF8 (r16)        # away quantity
    b END


DISABLE_TRAINING_MODE:
    stb r12, 0x1553 (r12)			# SET TRAINING MODE STATUS TO 0 (Off)

END:
    lwz	r3, 0 (r31)	# Original instruction

