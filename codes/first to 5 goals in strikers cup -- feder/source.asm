#To be inserted at 800fc3ac
# Region PAL revision 1
li r4, 1		# Force the game to load 1 here, so it's alway going to be first to X
stw r4, 0x0008 (r28)	# Default instruction, loads a v alue that is 0 when playing timed 1 when playing First to X