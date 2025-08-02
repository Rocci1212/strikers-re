#To be inserted at 801E5074
#To be inserted at 801E5074
# This code is for when you press - in the stadium select menu

lis r12, 0x8058
lhz r12, 0x5ee2 (r12)		# Load controller inputs

andi. r12, r12, 0x2000			# Check if the bit of the Z button is high
beq+ DONT_SKIP_FIVE
subi r4, r4, 3			# If Z held, move back by 5 stadium slots
DONT_SKIP_FIVE:

cmpwi r4, 0
bge+ DONT_LOOP_BACK
addi r4, r4, 17
DONT_LOOP_BACK:

stw r4, 0x00C4 (r31)		# Default instruction (??)


