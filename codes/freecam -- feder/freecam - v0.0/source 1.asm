#To be inserted at 80271bf8 
# Update the game's render matrix
# Using E.V.A 0x800003B0-0x800003EF


lis r16, 0x8000  # use r16 for indexing. Only safe register I could find

ONE_TIME_ONLY_CODE:

    # Write this as default matrix
    #  1 0 0 0
    #  0 1 0 0
    #  0 0 1 0
    #  0 0 0 -  <- we don't need to touch this last value. We just let the game set it to 1
    #
    # This code runs only once
    #
    lis r17, 0x3F80

    stw r17, 0x03B0 (r16)
    stw r17, 0x03C4 (r16)
    stw r17, 0x03D8 (r16)


    bl BRANCH_THING

BRANCH_THING:

    mflr r17

    # load a branch instruction into r18
    lis r18, 0x4800
    ori r18, r18, 0x0024  # offset of the branch

    # store the branch instruction, to the address after the "lis r16" instruction
    stw r18, 0xFFFFFFEC (r17)  # negative offset


    # The newly injected branch should make the PC jump here


OVERWRITE_MATRIX:
    # Override some matrix values with the ones you find in the E.V.A. addresses
    lwz r17, 0x03B0 (r16) # [0][0]
    stw r17, 0x0004 (r31) 

    lwz r17, 0x03B4 (r16) # [0][1]
    stw	r17, 0x0008 (r31) # Original instruction

    # The following 5 don't require storing inside this code. 
    # stw instructions for them are in the game's code already, after the insertion address
    lwz r18, 0x03B8 (r16) # [0][2]
    lwz r19, 0x03BC (r16) # [0][3]
    lwz r20, 0x03C0 (r16) # [1][0]
    lwz r21, 0x03C4 (r16) # [1][1]
    lwz r22, 0x03C8 (r16) # [1][2]
    lwz r15, 0x03E8 (r16) # [3][2]

    lwz r17, 0x03CC (r16) # [1][3]
    stw r17, 0x0020 (r31) 

    lwz r17, 0x03D0 (r16) # [2][0]
    stw r17, 0x0024 (r31) 

    lwz r17, 0x03D4 (r16) # [2][1]
    stw r17, 0x0028 (r31) 

    lwz r17, 0x03D8 (r16) # [2][2]
    stw r17, 0x002C (r31) 

    lwz r17, 0x03DC (r16) # [2][3]
    stw r17, 0x0030 (r31) 

    lwz r17, 0x03E0 (r16) # [3][0]
    stw r17, 0x0034 (r31) 

    lwz r17, 0x03E4 (r16) # [3][1]
    stw r17, 0x0038 (r31) 

