#To be inserted at 80271c04
# This code makes use of addresses 0x800003f0-0x800003ff
# This code creates a distortion visual effect
# It uses a timer that keeps incrementing every frame, then calculates the sine of the timer
# The intensity of the distortion is determined by the result of the sine

# push the stack
stwu sp, -0x0080 (sp) #make space for 18 registers
stmw r3, 0x8 (sp) #push r14-r31 onto the stack pointer

lis r20, 0x8000
lis r21, 0
# floating point constant of increment (0.0625)
lis r14, 0x3fb0
stw r14, 0x3f0 (r20)
stw r21, 0x3f4 (r20)
lfd f13, 0x3f0 (r20)
 
# Load a value we'll call "timer", then increment it, then calculate its sine      
lfd f1, 0x3f8 (r20)
fadd f1, f1, f13 
stfd f1, 0x3f8 (r20)

# CALL SINE
# Push stack, make space for 29 registers
#stwu sp,-0x80 (sp) 
#stmw r3, 0x8 (sp)
#mr r11, r0 #Copy r0's value to r11
# Load address of Math.sin() and call it passing f1 as argument
lis r15, 0x8038
ori r15, r15, 0xb390
mtlr r15
blrl
# Pop stack
#lmw r3, 0x8 (sp)
#addi sp, sp, 0x80 #Pop stack
#mr r0, r11 #Restore r0's value

# f1 now holds the sine's return which is a double. 
# With the following instruction we'll convert it to single, which is what we need.
frsp f1, f1

# pop the stack
lmw r3, 0x8 (sp) #pop r14-r31 off the stack pointer
addi sp, sp, 0x0080 #release the space

# Store the float in memory
stfs f1, 0x14 (r31) # this is the equivalent of the default instruction


