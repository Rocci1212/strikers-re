#To be inserted at 80271c04
# if you need to edit anything in this code keep in
# mind there's no safe reisters here (aside for r20),
# so you're gonna need to push the stack
lis r20, 0x8000
lwz r20, 0x3fc (r20)
stw r20, 0x14 (r31) # default instruction