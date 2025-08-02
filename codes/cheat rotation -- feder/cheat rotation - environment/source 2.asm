#To be inserted at 80100fdc
addi r20, r20, 1
lis r19, 0x80c5
ori r19, r19, 0xf300

lwz r18, 0(r19)
cmpwi r18, 5
bge azzera

addi r18, r18, 1
b end

azzera:
li r18, 0

end:
stw r18, 0(r19)
