# C0 code
li r3, 0  # ID of the captain you want to modify the stats of

mflr r5  # Backup value of link register somewhere safe
lis r10, 0x8057 # This value will be useful later in the code

lis r12, 0x80c8
lwz r11, 0xFFFFe3b4 (r12) # Load the ID of the current HOME captain into r11
cmpw r11, r3
beq- homeCaptain  # The home captain is the character you want to modify the stats of

lwz r11, 0xFFFFe424 (r12) # Load the ID of the current AWAY captain into r11
cmpw r11, r3
bne+ theEnd  # The character you want to modify the stats of is not in the match

#Away captain
lwz r11, 0xFFFFa750 (r10) # Load pointer to away captain stats
b loadSecondPointer

homeCaptain:
#Home captain
lwz r11, 0xFFFFa740 (r10) # Load pointer to home captain stats

loadSecondPointer:
cmplw r11, r12  # If the pointer hasn't been loaded yet, don't execute the code
ble theEnd

lwz r11, 0x324 (r11) # The pointer the code loaded earlier doesn't actually lead directly to the character stats, but it leads to this other pointer         
addi r11, r11, 0x30 # Now we need to add a value of 0x30 to this pointer to find other pointers, and those pointers will lead to the character stats            
li r9, 10
mtctr r9  # Load value of 10 into CTR

bl BRANCH_LINK_TRICK
### FLOATING POINT VALUES ###
.long 0x00000000  # Blank
.long 0x00000000  # Turning radius
.long 0x00000000  # Speed
.long 0x00000000  # Accel
.long 0x00000000  # Slide tackle
.long 0x00000000  # Size (idk what it does)
.long 0x00000000  # Hitting distance (this stat doesn't affect hit tackle distance, but clearing distance. The game's files call it like that for some reason)
.long 0x3ee66666  # Shooting Windup (time to charge item shot)
.long 0x3f800000  # Shooting Total Windup (time to charge skillshot/megastrike)
.long 0x00000000  # Shooting
.long 0x40a00000  # Passing

BRANCH_LINK_TRICK:
mflr r12  # Store the link register value in r12
Loop:
	lwz r10, 0 (r11)  # Load the pointer of a specific stat
	addi r11, r11, 0x10  # Increment r11 by 0x10 so it will point to the next pointer
	lwzu r9, 0x4 (r12)  # Load the custom stat
	stw r9, 0 (r10)  # Store the custom stat

bdnz+ Loop  # if CTR > 0, Decrement CTR and loop

theEnd:
mtlr r5 # Store the original link value in the link register
blr