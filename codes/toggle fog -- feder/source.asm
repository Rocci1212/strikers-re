# Exception vecotr area usage:
# 0x800001e4: countdown which keeps track of how many frames have passed since last '2' press

# prepare certain registers for loading data from certian addresses
lis r12, 0x8058
lis r11, 0x805a 
lis r10, 0x8000 
# load button 2 press timer
lbz r9, 0x01e4 (r10)

# load controller 1 inputs
lhz r12, 0x5ee2 (r12) 
# check if 2 pressed
andi. r0, r12, 0x0100	
beq NOT_PRESSED
# check how long ago the button '2' was pressed last
cmpwi r9, 0x20
beq BUTTON_IS_BEING_HELD
cmpwi r9, 0
beq FIRST_PRESS
# if 2 was double tapped, check if fog enabled or disabled, then toggle it
lbz r5, 0xFFFFadf6 (r11)
cmpwi r5, 0
li r5, 1
beq ENABLE_FOG
li r5, 0
ENABLE_FOG:
stb r5, 0xFFFFadf6 (r11)

# if button '2' is being pressed, then restart the timer
FIRST_PRESS:
BUTTON_IS_BEING_HELD:
li r9, 0x21


NOT_PRESSED:
# decrement timer if not 0
cmpwi r9, 0
beq END
subi r9, r9, 0x1
END:
# store timer back
stb r9, 0x01e4 (r10)
blr