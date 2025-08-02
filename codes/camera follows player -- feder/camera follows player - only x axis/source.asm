#To be inserted at 800f4d9c
# r3, r4, r5, r30 are all safe to use
# get the pointer to the player
lis r30, 0x8056
ori r30, 30, 0xa740
lwz r30, 0 (r30)
# get position X of the player and store it in the camer position
lfs f3, 0x5d0 (r30)
stfs f3, 0x000c (r31) # default instruction