#To be inserted at 802b5534
lis r12, 0x8000
lbz r12, 0x1b6 (r12)
cmpwi r12, 0			# Check if status = 0
bne SKIP_INSTRUCTION
stfs f0, 0x0008 (r29)		# Default instruction
SKIP_INSTRUCTION: