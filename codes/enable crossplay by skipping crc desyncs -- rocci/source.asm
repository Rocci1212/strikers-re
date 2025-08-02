#To be inserted at 803332D8
# Used at [$Required: Enable Crossplay] in R4QP01.ini
# Mark Desyncs
# Code should write a value to memory when the game desyncs
  cmplw	r3, r0         # our original instruction is a compare
  lis r3, 0x8000       # load empty space in memory
  beq WEGOOD           # skip this step if our CRCs are in sync
  li r25, 1            # runs only if CRCs not in sync - store 1 in memory
  b END

WEGOOD:
  li r25, 0            # there's no issue - store this in memory

END:
  stw r25, 0x02F8 (r3) # write r25 (0 if sync'ed, 1 if desynced) to indicate desync in memory
  li r25, 1            # instruction at 803332cc
  lwz r3, 0x11c (r26)  # instruction at 803332d0
  cmpw r3, r3          # this should skip the game's desync check