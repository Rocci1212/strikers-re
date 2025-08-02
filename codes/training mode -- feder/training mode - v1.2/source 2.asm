# This is a C0 code, it runs once per frame
# TRAINING MODE WITH BUILT-IN ITEM MODIFIER!
# Version 1.2 - ASM code 2
# Exception vector area bytes used: 0x1b6, 0x1550, 0x1551, 0x1552

# In this outdated version of "source 2.asm" the player's item slot addresses are treated as static addresses, when in reality, they change dinamically
# As a consequence of this, the item modifier feture doesn't work on certain stadiums

##### PART 1 - CHECK IF TRAINING MODE IS ON #####
lis r9, 0x8000			# Load 0x800001b6, address of training mode status
lbz r3, 0x1b6 (r9)			# Load TRAINING MODE STATUS in r3
cmpwi r3, 0			# Check if Training mode is off and if so, jump to end 
beq+ END

##### PART 2 - BUTTON COMBOS #####
lis r12, 0x8058			# Load 0x80585ee2, address of controller inputs
lhz r11, 0x5ee2 (r12)			# Load current inputs in r11
lbz r5, 0x1550 (r9)			# Load current selected item
lbz r10, 0x1551 (r9)			# Load current selected item's quantity

cmpwi r5, 0xff			# If r5 = 0xff then it becomes 0xffffffff, otherwise it would break the game
bne DONT_ADJUST_ID_VALUE
li r5, 0xFFFFffff
DONT_ADJUST_ID_VALUE:
cmpwi r10, 0			# If r10 = 0 then certain items won't work because quantity = 0
bne DONT_ADJUST_QUANTITY_VALUE
li r10, 1
DONT_ADJUST_QUANTITY_VALUE:


lbz r12, 0x1552 (r9)			# Load a value that tells the code if a button was pressed in the last frame
cmpwi r12, 0
bne- DPAD_WAS_PRESSED_LAST_FRAME

cmpwi r11, 0x0101 			# Check if 2 and D-Pad Left are pressed
bne+ DONT_DECREASE_ITEM
subi r5, r5, 1
	cmpwi r5, 0xFFFFfffe
	bne DONT_LOOP_A
	li r5, 0x14
	DONT_LOOP_A:
DONT_DECREASE_ITEM:

cmpwi r11, 0x0102 			# Check if 2 and D-Pad Right are pressed
bne+ DONT_INCREASE_ITEM
addi r5, r5, 1
	cmpwi r5, 0x15
	bne DONT_LOOP_B
	li r5, 0xFFFFffff
	DONT_LOOP_B:
DONT_INCREASE_ITEM:

cmpwi r11, 0x0104 			# Check if 2 and D-Pad Down are pressed
bne+ DONT_DECREASE_QUANTITY
subi r10, r10, 1	
	cmpwi r10, 0
	bne DONT_LOOP_C
	li r10, 25
	DONT_LOOP_C:
DONT_DECREASE_QUANTITY:

cmpwi r11, 0x0108 			# Check if 2 and D-Pad Up are pressed
bne+ DONT_INCREASE_QUANTITY
addi r10, r10, 1
	cmpwi r10, 26
	bne DONT_LOOP_D
	li r10, 1
	DONT_LOOP_D:
DONT_INCREASE_QUANTITY:

DPAD_WAS_PRESSED_LAST_FRAME:
li r12, 0
andi. r0, r11, 0x000f
beq+ BUTTON_NOT_HELD
	li r12, 1			# D-PAD HAS BEEN PRESSED THIS FRAME
BUTTON_NOT_HELD:
	

stb r5, 0x1550	(r9)		# Store item you picked into 0x80001550
stb r10, 0x1551	(r9)		# Store item quantity into 0x80001551
stb r12, 0x1552 (r9)			# Update the value in 0x80001552

##### PART 3 - STORE ITEMS #####
li r11, 0xFFFFffff			# Load -1 in r11
lis r12, 0x80cf
cmpwi r3, 1			# Check if training mode is on for home or if it's for away
beq- GIVE_ITEM_TO_AWAY 
stw r5, 0x597c (r12)			# Store home's new item
stw r10, 0x5980 (r12)			# Store home's new item quantity
stw r11, 0x64e4 (r12)			# Remove away's items
b END

GIVE_ITEM_TO_AWAY:
stw r5, 0x64e4 (r12)			# Store away's new item
stw r10, 0x64e8 (r12)			# Store away's new item quantity
stw r11, 0x597c (r12)			# Remove home's items

END:
blr