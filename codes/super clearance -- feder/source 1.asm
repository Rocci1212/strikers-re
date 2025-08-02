# extra gecko code lines required for this asm code to work:
# 040003f8 3f800000
# 040003fc 40400000
# code uses addresses 0x800003f8-0x800003ff

lis r12, 0x8056
ori r12, r12, 0xa740

# check if players are null
lwz r11, 0 (r12)
cmpwi r11, 0
beq END
# check if home cap = daisy
lwz r11, 0x24 (r11)
cmpwi r11, 2
beq ITS_DAISY
# check if away cap = daisy
addi r12, r12, 0x10
lwz r11, 0 (r12)
lwz r11, 0x24 (r11)
cmpwi r11, 2
bne END


ITS_DAISY:
lwz r11, 0 (r12)
lwz r11, 0x30c (r11)
cmpwi r11, 0
beq END
lwz r11, 0x2dc (r11)
lhz r11, 0x12 (r11)


# do the stat manipulation stuff
lis r10, 0x8000
lwz r9, 0x3f8 (r10)
andi. r11, r11, 0x2000
beq WEAK_CLEAR
lwz r9, 0x3fc (r10)
WEAK_CLEAR:

# replace the clear distance stat
lwz r12, 0 (r12)
lwz r12, 0x324 (r12)
lwz r12, 0x80 (r12)
stw r9, 0 (r12)


END:
blr



