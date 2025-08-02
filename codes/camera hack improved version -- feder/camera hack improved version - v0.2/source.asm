# Region PAL revision 1
# Exception vector area usage:
# 0x800001e5: if 1 then prevent + and - buttons to chenge zoom intensity
# 0x800001e6: countdown which keeps track of how many frames have passed since '2' started being held
# 0x800001e8-0x800001eb: floating point number for how much to zoom (0.25)

# Prepare r11 for getting zoom data and r10 for getting the exception vector area data
lis r11, 0x80c6
lis r10, 0x8000
# Store floating point value 0.25 in mem and then load it in f2
lis r12, 0x3e80
stw r12, 0x1e8 (r10)
lfs f2, 0x1e8 (r10)
# Load floating point value of zoom intensity in f3
lfs f3, 0xFFFFf2dc (r11)


# Get controller inputs
lis r12, 0x8058
lhz r12, 0x5ee2 (r12)
# Load a value that will be useful to know whether or not to lock the zoom inputs (prevent spamming the same input by holdiong the button)
lbz r9, 0x1e5 (r10)
lbz r5, 0x1e6 (r10)
# Check if + or - are pressed
andi. r0, r12, 0x0010
bne PLUS_PRESSED
andi. r0, r12, 0x1000
bne MINUS_PRESSED
# If neither + or - are being held, then unlock zoom inputs so they're available from next frame
li r9, 0
b CHECK_BUTTON_TWO


PLUS_PRESSED:
cmpwi r9, 1
beq LOCK_PLUS_AND_MINUS
# if + started being held on this frame, then increment zoom
fadds f3, f3, f2
b LOCK_PLUS_AND_MINUS


MINUS_PRESSED:
cmpwi r9, 1
beq LOCK_PLUS_AND_MINUS
# if + started being held on this frame, then increment zoom
fsubs f3, f3, f2
b LOCK_PLUS_AND_MINUS


LOCK_PLUS_AND_MINUS:
li r9, 1
CHECK_BUTTON_TWO:
andi. r0, r12, 0x0100
bne TWO_PRESSED
# if 2 is not being held, reset the hold duration counter
li r5, 0
b END
TWO_PRESSED:
# if 2 is being held, increment the hold duration counter by 1 frame. If it got to 30 frames, then toggle zoom mode
addi r5, r5, 1
cmpwi r5, 30
bne END
# toggle zoom mode 
# (if it's 1 then set it to 0 and jump to end. if it's 0 then don't jump so it gets set to 1)
lbz r3, 0xFFFFf2d8 (r11)
cmpwi r3, 1
li r3, 0
beq LEAVE_R3_SET_TO_ZERO
li r3, 1
LEAVE_R3_SET_TO_ZERO:
stb r3, 0xFFFFf2d8 (r11)


END:
stfs f3, 0xFFFFf2dc (r11)
stb r9, 0x1e5 (r10)
stb r5, 0x1e6 (r10)
blr


