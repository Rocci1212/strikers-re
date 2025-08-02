# Code for away kritter movement
lis r12, 0x8000
lbz r5, 0x1b5 (r12) # check if a player is trying to control this kritter
cmpwi r5, 1
blt end

lis r12, 0x8057
lwz r10, 0xffffA764 (r12) # load the pointer of away kritter
cmplw r10, r12
blt end # check if r10 actually loaded the pointer or it loaded something else that would make the game crash

	
	### CHECK WHAT CONTROLLER IS CONTROLLING KRITTER ###
	lis r9, 0x8058
	cmpwi r5, 1
	bne NotController1
		lhz r9, 0x5ee2 (r9) # load current controller1 input in r9
	NotController1:

	cmpwi r5, 2
	bne NotController2
		lhz r9, 0x60d2 (r9) # load current controller2 input in r9
	NotController2:

	cmpwi r5, 3
	bne NotController3
		lhz r9, 0x62c2 (r9) # load current controller3 input in r9
	NotController3:

	cmpwi r5, 4
	bne NotController4
		lhz r9, 0x64b2 (r9) # load current controller4 input in r9
	NotController4:



	### CHECK WHAT INPUTS THE PLAYER IS DOING AND MOVE KRITTER ###
	lfs f2, 0x67c (r10) # load kritter's Y position
	lis r11, 0x3e00  # float value for 0.125 (Speed of kritter movement)
	stw r11, 0x67c (r10)
	lfs f3, 0x67c (r10)


	andi. r5, r9, 0x0008 # check if the player is pressing up
	beq dontMoveUp
		fadds f2, f2, f3  # increase the value
	dontMoveUp:


	andi. r5, r9, 0x0004 # check if the player is pressing down
	beq dontMoveDown
		fsubs f2, f2, f3  # decrease the value
	dontMoveDown:


	stfs f2, 0x67c (r10) # store the new Y position value
	lfs f2, 0x678 (r10) # load kritter's X position


	andi. r5, r9, 0x0002 # check if the player is pressing right
	beq dontMoveRight
		fadds f2, f2, f3  # increase the value
	dontMoveRight:


	andi. r5, r9, 0x0001 # check if the player is pressing left
	beq dontMoveLeft
		fsubs f2, f2, f3  # decrease the value
	dontMoveLeft:


	stfs f2, 0x678 (r10) # store the new X position value

end:
blr

