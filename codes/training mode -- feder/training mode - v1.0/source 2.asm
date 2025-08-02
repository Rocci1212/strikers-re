# This is a C0 code, it runs once per frame

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

cmpwi r11, 0x0101 			# Check if 2 and D-Pad Left are pressed
bne+ DONT_GIVE_SHROOM
li r5, 7
DONT_GIVE_SHROOM:

cmpwi r11, 0x0102 			# Check if 2 and D-Pad Right are pressed
bne+ DONT_GIVE_SPECIAL
li r5, 0x10
DONT_GIVE_SPECIAL:

cmpwi r11, 0x0104 			# Check if 2 and D-Pad Down are pressed
bne+ DONT_GIVE_SMOL_NANAS
li r5, 4
li r10, 25		
DONT_GIVE_SMOL_NANAS:

cmpwi r11, 0x0108 			# Check if 2 and D-Pad Up are pressed
bne+ DONT_GIVE_BEEG_NANA
li r5, 4
li r5, 1
DONT_GIVE_BEEG_NANA:
stb r5, 0x1550	(r9)		# Store item you picked into 0x80001550
stb r10, 0x1551	(r9)		# Store item you picked into 0x80001551

##### PART 3 - STORE ITEMS #####
cmpwi r5, 0			# Check if an item has been selected, otherwise jump to end (0 would usually mean green shell, but for my code it means no item (I did this to make the code simpler)
beq+ END
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