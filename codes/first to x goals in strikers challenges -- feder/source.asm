#To be inserted at 800FC714
# PAL revision 1
loc_0x0:
  lis r4, 0x80C8
  lwz r12, 0xfffff3bc(r4)		# Load the value of time (seconds) in r12
  cmpwi r12, 4001				# Check if it's below 4001
  blt non_cambiare
  cmpwi r12, 4100				# Check if it's below 4100
  bgt non_cambiare
  
  subi r3, r12, 4000
  stw r3, 0x10 (r28) 			# If time is between 4001 and 4100 seconds, then set the score limit to time - 4000
  li r3, 0x1				# Set gamemode to First to X instead of timed

non_cambiare:
  stw r3, 8(r28)