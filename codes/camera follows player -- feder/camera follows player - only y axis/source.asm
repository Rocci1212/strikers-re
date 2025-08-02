#To be inserted at 800f4e78
# get the pointer to the player
lis r12, 0x8056
ori r12, r12, 0xa740
lwz r12, 0 (r12)
# get position Y of the player 
lfs f1, 0x5d4 (r12)
# get number -30 and subtract it to player's position
lis r12, 0x8000
lis r11, 0x41f0
stw r11, 0x3fc (r12)
lfs f13, 0x3fc (r12)
fsubs f1, f1, f13
# store it in the camera position Y
stfs f1, 0x0058 (r31) # default instruction