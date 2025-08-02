#To be inserted at 801C51EC
# Exception Vector Area usage: 0x800001e4 is used to exchange information with some other gecko code
# Value of 0x800001e4 (byte): 1 = yes, we're on match loading screen; 0 = no, we're not.
# r29 = scene ID

# This code checks if you are on match loading screen or not
# It updates byte 0x800001E4 of Exception Vector Area
add	r3, r28, r0 # Original instruction
# Set r12 to 0x80000000 (we need it in order to be able to write on 0x800001E4)
lis r12, 0x8000
# Check whether the user is on match loading screen or not
li r11, 0
cmpwi r29, 0x19
bne DISABLE_BYTE
li r11, 1  # Sets it to 1. If this instruction is skipped it will remain 0.
DISABLE_BYTE:
stb r11, 0x1e4 (r12) 

