#To be inserted at 800fc3ac
# This codes resets the cheats, this way, every time you start a new game, you start with all cheats off
stw r4, 0x0008 (r28)
li r4, 0
stw r4, 0x1c(r3)
stw r4, 0x20(r3)
stw r4, 0x24(r3)