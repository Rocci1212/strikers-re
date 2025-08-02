#To be inserted at 80100fdc
addi r20, r20, 1
lis r19, 0x80c5
ori r19, r19, 0xf2fc    # load the offset for cheat values in r19

# UPDATE STADIUM CHEAT
lwz r18, 4(r19)
cmpwi r18, 5
bge reset

addi r18, r18, 1    # increment cheat
b end

reset:
li r18, 0           # set cheat to none

end:
stw r18, 4(r19)

# UPDATE ITEM CHEAT 
lwz r18, 0(r19)
cmpwi r18, 11
bge reset_2

addi r18, r18, 1    # increment cheat
b end_2

reset_2:
li r18, 0           # set cheat to none

end_2:
stw r18, 0(r19)

# UPDATE PLAYER CHEAT
lwz r18, 8(r19)
cmpwi r18, 4
bge reset_3

addi r18, r18, 1    # increment cheat
b end_3

reset_3:
li r18, 0           # set cheat to none

end_3:
stw r18, 8(r19)