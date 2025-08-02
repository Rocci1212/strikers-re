# This is a C0 code, it runs once per frame

##### PART 1 - BUTTON COMBOS #####
# Check buttons
lis r12, 0x8058			# Load 0x80585ee2, address of controller inputs
lhz r11, 0x5ee2 (r12)

lis r12, 0x8000
cmpwi r11, 0x0110 			# Check if 2 and + are pressed
bne+ DONT_KILL_AWAY
li r10, 2		
stb r10, 0x1b6 (r12)			# SET TRAINING MODE STATUS TO 2 (Kill away)
DONT_KILL_AWAY:

cmpwi r11, 0x1100 			# Check if 2 and - are pressed
bne+ DONT_KILL_HOME
li r10, 1
stb r10, 0x1b6 (r12)			# SET TRAINING MODE STATUS TO 1 (Kill home)
DONT_KILL_HOME:

cmpwi r11, 0x0500 			# Check if 2 and B are pressed
beq- TRAINING_MODE_NOT_ACTIVE


##### PART 2 - STOP TIMER #####
lis r9, 0x80c6			# Load 0x80c60000 in r9
lbz r10, 0xFFFFf340 (r9)	# Load "isOnline", then Disable training mode if playing online
cmpwi r10, 1
beq+ TRAINING_MODE_NOT_ACTIVE
lbz r10, 0x1b6 (r12)			# LOAD TRAINING MODE STATUS, then diable training mode if it's 0
cmpwi r10, 0
beq+ TRAINING_MODE_NOT_ACTIVE
lis r5, 0			# Load 0x80c5f22b, address with isFirstToX boolean value and Set it to 0 (timed)
stb r5, 0xFFFFf22b (r9)
lis r9, 0x80cf			# Load 0x80cf50f8, address with timer
stw r5, 0x50f8 (r9)			# Set it to 0


##### PART 3 - MAKE OPPONENTS DISAPPEAR #####
cmpwi r10, 1			# Check TRAINING MODE STATUS
lis r12, 0x8057			# Load address for Player objects in r12
beq KILL_HOME_TEAM

### KILL AWAY TEAM ###
lwz r9, 0xFFFFa750 (r12) 	# Captain object
lwz r10, 0xFFFFa754 (r12) # Top sidekick object
lwz r11, 0xFFFFa758 (r12) # Bottom sidekick object
lwz r12, 0xFFFFa75c (r12)	# Back sidekick object
cmpwi r12, 0
beq PLAYERS_ARENT_LOADED
lis r5, 0x41b0			# FLOAT 22 for X Position
stw r5, 0x5d0 (r12) # move back SK to X 22
stw r5, 0x5d0 (r11) # move bottom SK to X 22
stw r5, 0x5d0 (r10) # move top SK to X 22
lis r5, 0x4100			# FLOAT 6 for Y position
stw r5, 0x5d4 (r12) # move back SK to Y 6
stw r5, 0x5d4 (r11) # move bottom SK to Y 6
stw r5, 0x5d4 (r10) # move top SK to Y 6
stw r5, 0x5d4 (r9)  # move captain to Y 6
b END

### KILL HOME TEAM ###
KILL_HOME_TEAM:
lwz r9, 0xFFFFa740 (r12) 	# Captain object
lwz r10, 0xFFFFa744 (r12) # Top sidekick object
lwz r11, 0xFFFFa748 (r12) # Bottom sidekick object
lwz r12, 0xFFFFa74c (r12)	# Back sidekick object
cmpwi r12, 0
beq PLAYERS_ARENT_LOADED
lis r5, 0xc1b0			# FLOAT -22 for X Position
stw r5, 0x5d0 (r12) # move back SK to X -22
stw r5, 0x5d0 (r11) # move bottom SK to X -22
stw r5, 0x5d0 (r10) # move top SK to X -22
lis r5, 0x4100			# FLOAT 6 for Y position
stw r5, 0x5d4 (r12) # move back SK to Y 6
stw r5, 0x5d4 (r11) # move bottom SK to Y 6
stw r5, 0x5d4 (r10) # move top SK to Y 6
stw r5, 0x5d4 (r9)  # move captain to Y 6
b END


PLAYERS_ARENT_LOADED:
TRAINING_MODE_NOT_ACTIVE:
lis r12, 0x8000
li r3, 0
stb r3, 0x1b6 (r12)			# SET TRAINING MODE STATUS TO 0 (Off)

END:
blr	