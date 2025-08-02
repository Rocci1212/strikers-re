lis r12, 0x8057
lwz r10, 0xffffA760 (r12) # load the pointer to home kritter
lwz r9, 0xffffA764 (r12) # load the pointer to away kritter
cmpw r10, r12 # check if r10 actually loaded the pointer or if it's null
blt END 


# load kritter's X position
lfs f2, 0x678 (r10)
# copy f2 to f9. we'll use that for comparsions
fmr f9, f2

# LOAD SOME FLOATING POINT VALUES
# load 0.25 in f13 (how much to push back kritter every frame)
lis r11, 0x3e80 
stw r11, 0x678 (r10)
lfs f13, 0x678 (r10)
# copy this value into f12. It will be useful for horizontal pushing
fmr f12, f13

# load -13.6 in f3 (X coordinate of goalie box line)
lis r11, 0xc159 
ori r11, r11, 0x999a
stw r11, 0x678 (r10)
lfs f3, 0x678 (r10)

b START_LOOP



LOOP:
# load kritter's X position (on second iteration)
lfs f2, 0x678 (r10)
# f9 = negative copy of kritter's X position
fneg f9, f2

START_LOOP:
# CHECK VERTICAL LINE
# check if kritter is out of the box
fcmpo cr0, f9, f3  
cror 2, 1, 2
bne cr0, dontWarpLeft

# if he is warp him back to the goalie box
fsubs f2, f2, f12
dontWarpLeft:
stfs f2, 0x678 (r10) 



# load kritter's Y position
lfs f2, 0x67C (r10) 

# CHECK LOWER LINE
# load -4 in f11 (Y coordinate of lower goalie box line)
lis r11, 0xc080  
stw r11, 0x67C (r10)
lfs f11, 0x67C (r10)

# check if kritter is out of the box
fcmpo cr0, f2, f11  
cror 2, 1, 2
bne cr0, dontWarpUp

# if he is warp him back to the goalie box
fsubs f2, f2, f13
dontWarpUp:
stfs f2, 0x67C (r10) 


# CHECK UPPER LINE
# negate f11 so it becomes +4 (Y coordinate of upper goalie box line)
fneg f11, f11  

# check if kritter is out of the box
fcmpo cr0, f2, f11  
cror 2, 0, 2
bne cr0, dontWarpDown

# warp kritter back to the goalie box
fadds f2, f2, f13
dontWarpDown:
stfs f2, 0x67C (r10) 


# LOOP CONDITIONS
# negate f12 so that, for away kritter, instead of pushing towards negative X, it pushes him towards positive
fneg f12, f12
# Check if it's time to exit the loop or if it's time to jump back to the start of the loop to check away kritter position
cmpw r10, r9
mr r10, r9
bne LOOP


END:
blr






