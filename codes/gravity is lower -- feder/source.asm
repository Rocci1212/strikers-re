#To be inserted at 80356a8c
# 80356a8c loads ball's z vel i think

# Load number 
lis r12, 0x3f20
stw r12, 0x009c (r3)
lfs f13, 0x009c (r3)
# Load vel
lfs f2, 0x00F0 (r3)	# Default instruction
# Manipulate vel
fadds f2, f2, f13