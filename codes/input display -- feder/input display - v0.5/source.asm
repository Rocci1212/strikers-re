# Player indicator color as Input indicator (PAL, Rev1)
# C0 code (runs once per frame)

### PART 1: DETECT CURRENT INPUT ###
lis r12, 0x8058			# Load 0x80585ee2 (controller 1 inputs) in r12
lhz r3, 0x5ee2 (r12)			# Load inputs in r3

andi. r10, r3, 0x2000			# Check if Z pressed
bne- Z_PRESS			# If it is then take the branch

andi. r10, r3, 0x0400			# Check if B pressed
bne- B_PRESS			# If it is then take the branch

andi. r10, r3, 0x0800			# Check if A pressed
bne- A_PRESS			# If it is then take the branch

andi. r10, r3, 0x000f			# Check if D-Pad pressed
bne- D_PAD_PRESS			# If it is then take the branch

andi. r10, r3, 0x4000			# Check if C pressed
bne- C_PRESS			# If it is then take the branch



### PART 2: COLORS ###
lis r5, 0x0000			# Load Black RGB in r5 (DEFAULT COLOR)
b UPDATE_INDICATOR

Z_PRESS:
andi. r10, r3, 0x0400			# Check if B pressed
bne- B_AND_Z_PRESS			# If it is then take the branch
andi. r10, r3, 0x0800			# Check if A pressed
bne- A_AND_Z_PRESS			# If it is then take the branch
# YELLOW
lis r5, 0x00ff			
ori r5, r5, 0xff00
b UPDATE_INDICATOR


# GREEN-ISH YELLOW
B_AND_Z_PRESS:
lis r5, 0x0088          
# GREEN
B_PRESS:
ori r5, r5, 0xff00			
andi. r10, r3, 0x000f			# Check if D-Pad pressed
bne- D_PAD_AND_B_PRESS			# If it is then take the branch
b UPDATE_INDICATOR

# ORANGE
A_AND_Z_PRESS:
lis r5, 0x00ff          
ori r5, r5, 0x8800
b UPDATE_INDICATOR

# RED
A_PRESS:
lis r5, 0x00ff				
b UPDATE_INDICATOR

# LIGHT BLUE
D_PAD_AND_B_PRESS:
ori r5, r5, 0xffff		
b UPDATE_INDICATOR

# PURPLE
C_PRESS:
lis r5, 0x00ff			
# BLUE
D_PAD_PRESS:			
ori r5, r5, 0x00ff			


### PART 3: STORE NEW COLORS ###
UPDATE_INDICATOR:
lis r11, 0x8050			# Load 0x80504d04 (Address for character colors) in r11
ori r11, r11, 0x4d08

li r12, 12

THE_LOOP:
stw r5, 0 (r11)			# store value of r5 instead of original character's RGB
stw r5, 4 (r11)
addi r11, r11, 0x5c			# increment r11
cmpwi r12, 0
subi r12, r12, 1
bgt+ THE_LOOP			# If r12 > 0 don't stop looping

blr

