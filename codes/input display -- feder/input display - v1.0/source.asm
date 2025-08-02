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
bne- DPAD_PRESS			# If it is then take the branch

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
andi. r10, r3, 0x4000			# Check if C pressed
bne- C_AND_Z_PRESS			# If it is then take the branch
# YELLOW ffff00
lis r5, 0x00ff			
ori r5, r5, 0xff00
b UPDATE_INDICATOR

# GREEN-ISH YELLOW 88ff00
B_AND_Z_PRESS:
lis r5, 0x0088          
# GREEN 00ff00
B_PRESS:
ori r5, r5, 0xff00			
andi. r10, r3, 0x000f			# Check if D-Pad pressed
bne- DPAD_AND_B_PRESS			# If it is then take the branch
b UPDATE_INDICATOR

# ORANGE ff8800
A_AND_Z_PRESS:
lis r5, 0x00ff          
ori r5, r5, 0x8800
b UPDATE_INDICATOR

# RED ff0000
A_PRESS:
lis r5, 0x00ff				
b UPDATE_INDICATOR

# LIGHT BLUE 00ffff
DPAD_AND_B_PRESS:
ori r5, r5, 0xffff		
b UPDATE_INDICATOR

# PURPLE ff00ff
C_PRESS:
lis r5, 0x00ff
ori r5, r5, 0x00ff
b UPDATE_INDICATOR

DPAD_PRESS:
andi. r10, r3, 0x4000			# Check if C pressed
bne- C_AND_DPAD_PRESS			# If it is then take the branch
# BLUE 0000ff
ori r5, r5, 0x00ff			
b UPDATE_INDICATOR

# PINK ff9999
C_AND_Z_PRESS:
lis r5, 0x00ff
ori r5, r5, 0x9999
b UPDATE_INDICATOR

# DARK PURPLE 440088
C_AND_DPAD_PRESS:
lis r5, 0x0044
ori r5, r5, 0x0088

# Location of local inputs = 80C41E24 (?)
# Pointer to whos controlling Home cap: [[[0x8056A740] + 0x30C] + 0x2dc]

### PART 3: STORE NEW COLORS ###
UPDATE_INDICATOR:
lis r12, 0x8000
# Check if enabled already. Skip the enable code, this way you avoid overwriting the backup of the original character color
# this value in r0 is really important, because if it's set to 0 it means it won't back the original color up.
li r0, 0
lbz r11, 0x1570 (r12)
cmpwi r11, 0
bgt ALREADY_ENABLED

    # Check if players are loaded, if not then end this crap so the cheat doesn't get activated outside of a match (which would cause weird stuff and even possible crash)
    lis r9, 0x8057
    lwz r9, 0xFFFFa740 (r9)
    cmpwi r9, 0
    beq END     # If Player = null then jump to end

    li r0, 1 # enable color backup
    # Check if - pressed
    andi. r10, r3, 0x1000			
    beq+ MINUS_NOT_PRESSED
        li r11, 1
        stb r11, 0x1570 (r12)
    MINUS_NOT_PRESSED:
    # Check if + pressed
    andi. r10, r3, 0x0010			
    beq+ PLUS_NOT_PRESSED
        li r11, 2
        stb r11, 0x1570 (r12)
    PLUS_NOT_PRESSED:

ALREADY_ENABLED:


# Check if 2 pressed, if so disable the input displayer
andi. r10, r3, 0x0100			
bne- DISABLE


cmpwi r11, 0
beq NOT_ENABLED
    lis r9, 0x8056
    ori r9, r9, 0xa740
    cmpwi r11, 1
    beq ENABLED_FOR_HOME
        addi r9, r9, 0x10           # This is if you need to enable it for away instead of home
    ENABLED_FOR_HOME:
    # Load Captain object pointer
    lwz r9, 0 (r9)
    cmpwi r9, 0
    beq DISABLE
    # Load captain ID
    lwz r9, 0x24 (r9)
    # Now multiply it by 0x5c
    lis r11, 0
    MULTIPLY:
        cmpwi r9, 0
        ble BREAK_LOOP
        addi r11, r11, 0x5c
        subi r9, r9, 1
    b MULTIPLY
    BREAK_LOOP:
    # Now find the address of the specific captain color
    lis r10, 0x8050
    ori r10, r10, 0x4d08
    # Add ID*0x5c as offset
    add r10, r10, r11
    # Now back the original values up
    cmpwi r0, 0
    beq SKIP_BACKUP
        lwz r11, 0 (r10)
        stw r11, 0x1560 (r12) # color 1
        lwz r11, 4 (r10)
        stw r11, 0x1564 (r12) # color 2
        stw r10, 0x1568 (r12) # address of color
    SKIP_BACKUP:
    # Now replace the value
    stw r5, 0 (r10)
    # Now replace the value (on secondary outfit)
    stw r5, 0x4 (r10)
NOT_ENABLED:
b END

DISABLE:
# disable the cheat
li r11, 0
stb r11, 0x1570 (r12)
# load address of color
lwz r10, 0x1568 (r12)
# restore original color 1
lwz r11, 0x1560 (r12)
stw r11, 0 (r10)
# restore original color 2
lwz r11, 0x1564 (r12)
stw r11, 4 (r10)

END:
blr

