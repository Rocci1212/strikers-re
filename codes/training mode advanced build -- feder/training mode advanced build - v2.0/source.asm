# This is a C0 code, it runs once per frame
# BETTER TRAINING MODE v2
# FEATURING: ITEM SELECTOR, INVISI-WALL AT CENTER FIELD, AUTO-TELEPORT BALL TO CAPTAIN, etc...
# Exception vector area bytes usage:
# 0x80001550-0x80001552 - item stuff
# 0x80001553 - training mode status 0 = off, 1 = away, 2 = home
# 0x80001554 - invisible wall 0 = off 1 = on
# 0x80001558-0x8000155f - enabled players: for each byte 0 = disabled, 1 = enabled
# They're in this order: The four home players come first, then there's away players. Each team is ordered like this: Captain, top, bottom, back


##### PART 1 - BASIC BUTTON COMBOS #####
# Load 8056767C, pointer to player 1's inputs
lis r12, 0x8056			
lwz r12, 0x767C (r12)
# Button inputs are at offset 0x12, load them
lhz r11, 0x12 (r12)

# Load useful values
li r9, 1
li r5, 1
lis r12, 0x8000

# ENABLE T.MODE FOR HOME (2+)
# Check if 2 and + are pressed
cmpwi r11, 0x0110 			
bne+ DONT_KILL_AWAY
    # SET TRAINING MODE STATUS TO 2 (enabled for home)
    li r10, 2		
    stb r10, 0x1553 (r12)	
    # Set r5 to 0, this way away players will disappear
    li r5, 0
    b KILL_PLAYERS_CAUSE_TRAININGMODE_JUST_ENABLED
DONT_KILL_AWAY:

# ENABLE T.MODE FOR AWAY (2-)
# Check if 2 and - are pressed
cmpwi r11, 0x1100 			
bne+ DONT_KILL_HOME
    # SET TRAINING MODE STATUS TO 1 (enabled for away)
    li r10, 1
    stb r10, 0x1553 (r12)
    # Set r9 to 0, this way home players will disappear
    li r9, 0

KILL_PLAYERS_CAUSE_TRAININGMODE_JUST_ENABLED:
# Make unwanted players disappear (and leave the other ones on the field)
stb r9, 0x1558 (r12) # Hcap
stb r9, 0x1559 (r12) # Htop
stb r9, 0x155a (r12) # Hbtm
stb r9, 0x155b (r12) # Hbck
stb r5, 0x155c (r12) # Acap
stb r5, 0x155d (r12) # Atop
stb r5, 0x155e (r12) # Abtm
stb r5, 0x155f (r12) # Abck
DONT_KILL_HOME:


# DISABLE TRAINING MODE (2B)
cmpwi r11, 0x0500 			
beq- TRAINING_MODE_NOT_ACTIVE



##### PART 2 - STOP TIMER #####
lis r9, 0x80c6			# Load 0x80c60000 in r9
lbz r10, 0xFFFFf340 (r9)	# Load "isOnline", then Disable training mode if playing online
cmpwi r10, 1
beq+ TRAINING_MODE_NOT_ACTIVE
# LOAD TRAINING MODE STATUS, then stop this code if it's 0, this way timer doesn't stop and nobody gets teleported around.
lbz r10, 0x1553 (r12)			
cmpwi cr7, r10, 1
blt+ cr7, TRAINING_MODE_NOT_ACTIVE
# Set gamemode to first to X goals
li r5, 1			
stb r5, 0xFFFFf22b (r9)
# If you're playing in abc mode, you cannot set the gamemode to first to x, so attempt to lock the timer
# lis r9, 0x80cf	
# stw r5, 0x50f8 (r9)		
# Update value of goals needed in order to win and set it to something really high
lis r9, 0x80c6
li r0, 6666			
stw r0, 0xFFFFf230 (r9)			
	


##### PART3 - MANAGE WHICH PLAYERS MUST DISAPPEAR WITH BUTTON COMBOS #####
# r12 is 0x8000
# r11 holds the value of inputs
# r5 is 1
# BUTTON COMBOES TO ENABLE PLAYERS:
# home
cmpwi r11, 0x3002
bne DONT_ENABLE_HOME_CAP
    stb r5, 0x1558 (r12)
DONT_ENABLE_HOME_CAP:
cmpwi r11, 0x3008
bne DONT_ENABLE_HOME_TOP
    stb r5, 0x1559 (r12)
DONT_ENABLE_HOME_TOP:
cmpwi r11, 0x3004
bne DONT_ENABLE_HOME_BTM
    stb r5, 0x155a (r12)
DONT_ENABLE_HOME_BTM:
cmpwi r11, 0x3001
bne DONT_ENABLE_HOME_BCK
    stb r5, 0x155b (r12)
DONT_ENABLE_HOME_BCK:
# away
cmpwi r11, 0x2011
bne DONT_ENABLE_AWAY_CAP
    stb r5, 0x155c (r12)
DONT_ENABLE_AWAY_CAP:
cmpwi r11, 0x2018
bne DONT_ENABLE_AWAY_TOP
    stb r5, 0x155d (r12)
DONT_ENABLE_AWAY_TOP:
cmpwi r11, 0x2014
bne DONT_ENABLE_AWAY_BTM
    stb r5, 0x155e (r12)
DONT_ENABLE_AWAY_BTM:
cmpwi r11, 0x2012
bne DONT_ENABLE_AWAY_BCK
    stb r5, 0x155f (r12)
DONT_ENABLE_AWAY_BCK:
# BUTTON COMBOES TO DISABLE PLAYERS:
li r5, 0
# home
cmpwi r11, 0x5002
bne DONT_DISABLE_HOME_CAP
    stb r5, 0x1558 (r12)
DONT_DISABLE_HOME_CAP:
cmpwi r11, 0x5008
bne DONT_DISABLE_HOME_TOP
    stb r5, 0x1559 (r12)
DONT_DISABLE_HOME_TOP:
cmpwi r11, 0x5004
bne DONT_DISABLE_HOME_BTM
    stb r5, 0x155a (r12)
DONT_DISABLE_HOME_BTM:
cmpwi r11, 0x5001
bne DONT_DISABLE_HOME_BCK
    stb r5, 0x155b (r12)
DONT_DISABLE_HOME_BCK:
# away
cmpwi r11, 0x4011
bne DONT_DISABLE_AWAY_CAP
    stb r5, 0x155c (r12)
DONT_DISABLE_AWAY_CAP:
cmpwi r11, 0x4018
bne DONT_DISABLE_AWAY_TOP
    stb r5, 0x155d (r12)
DONT_DISABLE_AWAY_TOP:
cmpwi r11, 0x4014
bne DONT_DISABLE_AWAY_BTM
    stb r5, 0x155e (r12)
DONT_DISABLE_AWAY_BTM:
cmpwi r11, 0x4012
bne DONT_DISABLE_AWAY_BCK
    stb r5, 0x155f (r12)
DONT_DISABLE_AWAY_BCK:



##### PART 4 - MAKE PLAYERS PHISICALLY DISAPPEAR #####
# This address we're loading in r12 is what we're gonna use to load player objects
lis r12, 0x8057			
# This address we're loading in r10 is what we're gonna use to load our custom variables
lis r10, 0x8000

# The following are float values we'll need for positions of the players we want to "kill"
lis r5, 0xC1b0			# FLOAT -22 for X Position
lis r3, 0x4100			# FLOAT 6 for Y position
lis r0, 0xbf80			    # FLOAT -1 for X Position of captains

# NOW WE MOVE THE PLAYERS
# Home captain
lbz r9, 0x1558 (r10)
cmpwi r9, 1
beq SKIP_HOME_CAP
    lwz r11, 0xFFFFa740 (r12)
    stw r0, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_HOME_CAP:
# Home top
lbz r9, 0x1559 (r10)
cmpwi r9, 1
beq SKIP_HOME_TOP
    lwz r11, 0xFFFFa744 (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_HOME_TOP:
# Home bottom
lbz r9, 0x155a (r10)
cmpwi r9, 1
beq SKIP_HOME_BTM
    lwz r11, 0xFFFFa748 (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_HOME_BTM:
# Home back
lbz r9, 0x155b (r10)
cmpwi r9, 1
beq SKIP_HOME_BCK
    lwz r11, 0xFFFFa74c (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_HOME_BCK:
# Now we move away, so we set r5 to 22 instead of -22
lis r5, 0x41b0			# FLOAT 22 for X Position
# Away captain
lbz r9, 0x155c (r10)
cmpwi r9, 1
beq SKIP_AWAY_CAP
    lwz r11, 0xFFFFa750 (r12)
    stw r0, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_AWAY_CAP:
# Away top
lbz r9, 0x155d (r10)
cmpwi r9, 1
beq SKIP_AWAY_TOP
    lwz r11, 0xFFFFa754 (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_AWAY_TOP:
# Away bottom
lbz r9, 0x155e (r10)
cmpwi r9, 1
beq SKIP_AWAY_BTM
    lwz r11, 0xFFFFa758 (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_AWAY_BTM:
# Away back
lbz r9, 0x155f (r10)
cmpwi r9, 1
beq SKIP_AWAY_BCK
    lwz r11, 0xFFFFa75c (r12)
    stw r5, 0x5d0 (r11)
    stw r3, 0x5d4 (r11)
SKIP_AWAY_BCK:




# r10 contains 0x8000


##### PART 6 - BUTTON COMBOS FOR ITEMS #####
# Load 8056767C, pointer to player 1's inputs
lis r12, 0x8056			
lwz r12, 0x767C (r12)
# Button inputs are at offset 0x12, load them
lhz r11, 0x12 (r12)
lbz r5, 0x1550 (r10)			# Load current selected item
lbz r3, 0x1551 (r10)			# Load current selected item's quantity

# If r5 = 0xff then it becomes 0xffffffff, because it's word for -1, otherwise writing 0xff on the item quantity would break the game cause it's a 32bit value and it reads it as 255
cmpwi r5, 0xff			
bne DONT_ADJUST_ID_VALUE
li r5, 0xFFFFffff
DONT_ADJUST_ID_VALUE:
# If r3 = 0 then certain items won't work because quantity = 0
cmpwi r3, 0			
bne DONT_ADJUST_QUANTITY_VALUE
li r3, 1
DONT_ADJUST_QUANTITY_VALUE:


# Load a value that tells the code if a button was pressed in the last frame
lbz r12, 0x1552 (r10)			
cmpwi r12, 0
bne- DPAD_WAS_PRESSED_LAST_FRAME

# Check if 2 and D-Pad Left are pressed
cmpwi r11, 0x0101 			
bne+ DONT_DECREASE_ITEM
subi r5, r5, 1
	cmpwi r5, 0xFFFFfffe
	bne DONT_LOOP_A
	li r5, 0x0c
	DONT_LOOP_A:
DONT_DECREASE_ITEM:

# Check if 2 and D-Pad Right are pressed
cmpwi r11, 0x0102 			
bne+ DONT_INCREASE_ITEM
addi r5, r5, 1
	cmpwi r5, 0x0d
	bne DONT_LOOP_B
	li r5, 0xFFFFffff
	DONT_LOOP_B:
DONT_INCREASE_ITEM:

# Check if 2 and D-Pad Down are pressed
cmpwi r11, 0x0104 		
bne+ DONT_DECREASE_QUANTITY
    cmpwi r3, 1
    ble DONT_DECREASE_QUANTITY
        subi r3, r3, 1	
DONT_DECREASE_QUANTITY:

# Check if 2 and D-Pad Up are pressed
cmpwi r11, 0x0108 			
bne+ DONT_INCREASE_QUANTITY
	cmpwi r3, 25
	bge DONT_INCREASE_QUANTITY
	    addi r3, r3, 1
DONT_INCREASE_QUANTITY:

DPAD_WAS_PRESSED_LAST_FRAME:
li r12, 0
# Do a bitwise AND between r11 and 0x000f because each of the 4 d-pad buttons sets one of the last bits high, so if none of those is pressed, then we need the code to take the branch
andi. r0, r11, 0x000f				
beq+ BUTTON_NOT_HELD
	li r12, 1			# D-PAD HAS BEEN PRESSED THIS FRAME, therefore player's input will be ignored starting from the next frame until the player releases the button.
BUTTON_NOT_HELD:
	

stb r5, 0x1550	(r10)		# Store item you picked into 0x80001550
stb r3, 0x1551	(r10)		# Store item quantity into 0x80001551
stb r12, 0x1552 (r10)			# Update the value at 0x80001552



##### PART 7 - STORE ITEMS #####
li r9, 0xFFFFffff			# Load -1 in r9
lis r12, 0x806e
lwz r12, 0xFFFFf9d8 (r12)	# Load pointer to the struct that contains player's item
beq- cr7, GIVE_ITEM_TO_AWAY 
stw r5, 0x8c (r12)			# Store home's new item
stw r3, 0x90 (r12)			# Store home's new item quantity
stw r9, 0xbf4 (r12)			# Remove away's items
b BALL_WARPING_CODE

GIVE_ITEM_TO_AWAY:
stw r5, 0xbf4 (r12)			# Store away's new item
stw r3, 0xbf8 (r12)			# Store away's new item quantity
stw r9, 0x8c (r12)			# Remove home's items



##### PART 8 - BUTTON COMBOS FOR BALL POSITION #####
BALL_WARPING_CODE:
# Load pointer of ball struct
lis r12, 0x806e
lwz r12, 0xFFFFf7a0	(r12)	
# (current inputs are already loaded in r11)
# Check if 2 pressed, if not dont warp the ball			
cmpwi r11, 0x0100 		
bne+ DONT_WARP_BALL

# move ball position
# set z (height) to 0
lis r5, 0
stw r5, 0x220 (r12)
# set velocity to 0
stw r5, 0x268 (r12)
stw r5, 0x26c (r12)
stw r5, 0x270 (r12)

# GIVE THE BALL TO THE CAPTAIN
lis r3, 0x8056
ori r3, r3, 0xa750
beq cr7, GIVE_BALL_TO_AWAY  # beq cr7 means "branch if training mode is enabled for away"
subi r3, r3, 0x10
GIVE_BALL_TO_AWAY:
lwz r3, 0 (r3)
# update X
lwz r5, 0x5d0 (r3)
stw r5, 0x218 (r12)
# update Y
lwz r5, 0x5d4 (r3)
stw r5, 0x21c (r12)

DONT_WARP_BALL:


##### PART 9 - INVISIBLE WALL FOR BALL #####
# r10 = 0x8000
# Enable/Disable. check if only 2 and Z pressed
cmpwi r11, 0x2100
bne DONT_ENABLE_INVIS_WALL
	li r5, 1
	stb r5, 0x1554 (r10)
DONT_ENABLE_INVIS_WALL:
# check if only 2 and C pressed
cmpwi r11, 0x4100
bne DONT_DISABLE_INVIS_WALL
	li r5, 0
	stb r5, 0x1554 (r10)
DONT_DISABLE_INVIS_WALL:

# WALL PHYSICS
# check if enabled
lbz r5, 0x1554 (r10)
cmpwi r5, 1
bne END
# ball struct is already loaded into r12
# check if ball's X position is negative
lbz r5, 0x218 (r12)
andi. r5, r5, 0x80
beq BALL_ON_LEFT_HALF
# Ball is on right half, check if training mode is enabled for home
bne cr7, BALL_COLLIDING
b BALL_NOT_COLLIDING
# Ball is on left half, check if training mode is enabled for away
BALL_ON_LEFT_HALF:
bne cr7, BALL_NOT_COLLIDING

BALL_COLLIDING:
# load ball's X velocity and store it's absolute value back, so if it's going into the away field it bounces
lfs f2, 0x268 (r12)
fabs f2, f2
# Invert speed if training mode enabled for away side. THis way it becomes NEGATIVE absolute value of original speed
bne cr7, DONT_INVERT_VELOCITY
	fneg f2, f2
DONT_INVERT_VELOCITY:
stfs f2, 0x268 (r12)
BALL_NOT_COLLIDING:


b END

PLAYERS_ARENT_LOADED:
TRAINING_MODE_NOT_ACTIVE:
lis r12, 0x8000
li r3, 0
stb r3, 0x1553 (r12)			# SET TRAINING MODE STATUS TO 0 (Off)


END:
blr


