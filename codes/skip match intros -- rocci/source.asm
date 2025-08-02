#To be inserted at 80284110
# Requires FlagGameState gecko code
CHECK_GAMESTATE:
  lis r5, 0x8000        # Safe to use this register as it was just reset before this
  lbz r5, 0x2FF (r5)    # Load byte at 0x800002FF into r5
  cmpwi r5, 4           # Check if game state is starting - this is safe because a compare happens right after this routine
  bne+ FINALLY          # if so, just end the function
  li r3, 0x1            # This is where the magic happens - hijack r3 to indicate that the cutscene is being skipped

FINALLY:
  lwz	r5, 0x0150 (r31)  # We used r5, so reset it here
  stb r3, 0xb1 (r31)    # Original Instruction at this location, which saves whether the cutscene is being skipped
