#To be inserted at 800fbf74
# Register safety: r5-r12 all are safe
# Exception Vector Area usage: 0x800001e4 is used to exchange information with some other gecko code
# Value of 0x800001e4 (byte): 1 = yes, we're on match loading screen; 0 = no, we're not.

# CONDITION #1: Check if r3 = 80c663f8 address that holds home captain ID
lis r12, 0x80c6
ori r12, r12, 0x63f8
cmpw cr7, r3, r12   
# CONDITION #2: Check if r0 = 0 (the offset we need)
cmpwi cr6, r0, 0    
# CONDITION #3: Check if user is on match loading screen
lis r11, 0x8000
lbz r11, 0x1e4 (r11)
cmpwi cr5, r11, 0x1 

lwzx r3, r3, r0 # Original instruction

bne cr7, SKIP
bne cr6, SKIP
bne cr5, SKIP

# EDIT AWAY CAPTAIN ID
stw r3, 4 (r12)

SKIP: