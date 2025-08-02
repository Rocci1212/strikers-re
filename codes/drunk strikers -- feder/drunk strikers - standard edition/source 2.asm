# this code uses addresses 0x3f7-0x3ff
# set the floating point numbers up
lis r10, 0x8000
lfs f2, 0x3fc (r10)
lis r12, 0x3d40  # hex for 1/24 float
stw r12, 0x3f8 (r10)
lfs f3, 0x3f8 (r10)

# Load the byte we'll use as timer
# This timer byte will behave this way:
# It will update once per frame and cycle between 0 and 255
# If it's between 0 and 127 included then nothing strange happens
# If it's between 128 and 255 included then the float value decrements
lbz r11, 0x3f7 (r10)
cmpwi cr2, r11, 63
ble cr2, DONT_NEGATE
cmpwi cr2, r11, 192
bge cr2, DONT_NEGATE
fneg f3, f3
DONT_NEGATE:
# Store the timer byte back
addi r11, r11, 1
stb r11, 0x3f7 (r10)

# Now Update the float
fadds f2, f2, f3
stfs f2, 0x3fc (r10)

blr