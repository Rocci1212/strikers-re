#To be inserted at 803aae54

# Using E.V.A 
# interval 0x800003B0-0x800003EF  matrix A
# interval 0x800004B0-0x800004EF  matrix B
# interval 0x800005B0-0x800005EF  matrix C

# input bitfield: r8
# Known safe registers: r12, r11, r5, r10 plus the ones I will push now

# push r14-r31 into the stack
stwu sp, -0x0050 (sp) 
stmw r14, 0x8 (sp)


lis r12, 0x8000

COPY_A_TO_C:
    addi r14, r12, 0x3B0  # r14 becomes 0x800003B0
    li r15, 0x40
    COPY_A_TO_C_LOOP:
        lfs f13, 0 (r14)  # load from A
        stfs f13, 0x200 (r14)  # store to B
        addi r14, r14, 4
        subi r15, r15, 4
        cmpwi r15, 0
        bgt COPY_A_TO_C_LOOP


INITIALIZE_B_AS_IDENTITY:
    lis r14, 0
    li r15, 0
    addi r16, r12, 0x4B0  # r16 becomes 0x800004B0
    MATRIX_B_ZERO:
        stwx r14, r15, r16  # store 0 at r16 (matrix pointer) + r15 (index offset)
        addi r15, r15, 4
        cmpwi r15, 0x40
        blt MATRIX_B_ZERO

    lis r14, 0x3F80
    stw r14, 0x04B0 (r12)
    stw r14, 0x04C4 (r12)
    stw r14, 0x04D8 (r12)
    stw r14, 0x04EC (r12)
    


ROTATION_CONTROLS:
    lis r14, 0x3f7f  # 0.999847... cos(+1) or cos(-1)
    ori r14, r14, 0xf605
    lis r15, 0x3c8e  # 0.0174524064 sin(+1)
    ori r15, r15, 0xf859
    lis r16, 0xBc8e  # -0.0174524064 sin(-1)
    ori r16, r16, 0xf859

    ROT_X_POSITIVE:
        cmpwi r8, 0x0100  # 2 button
        bne ROT_X_NEGATIVE
        stw r14, 0x04C4 (r12)
        stw r16, 0x04C8 (r12)
        stw r14, 0x04D8 (r12)
        stw r15, 0x04D4 (r12)

    ROT_X_NEGATIVE:
        cmpwi r8, 0x4000  # C button
        bne ROT_Z_POSITIVE
        stw r14, 0x04C4 (r12)
        stw r15, 0x04C8 (r12)
        stw r14, 0x04D8 (r12)
        stw r16, 0x04D4 (r12)

    ROT_Z_POSITIVE:
        cmpwi r8, 0x0010  # + button
        bne ROT_Z_NEGATIVE
        stw r14, 0x04B0 (r12)
        stw r16, 0x04B4 (r12)
        stw r15, 0x04C0 (r12)
        stw r14, 0x04C4 (r12)

    ROT_Z_NEGATIVE:
        cmpwi r8, 0x1000  # - button
        bne TRASLATION_CONTROLS
        stw r14, 0x04B0 (r12)
        stw r15, 0x04B4 (r12)
        stw r16, 0x04C0 (r12)
        stw r14, 0x04C4 (r12)


TRASLATION_CONTROLS:
    lis r14, 0x3D80
    lis r15, 0xBD80

    TRASL_X_POSITIVE:
        andi. r16, r8, 0x0001  # left button
        beq TRASL_X_NEGATIVE
        stw r14, 0x04E0 (r12)

    TRASL_X_NEGATIVE:
        andi. r16, r8, 0x0002  # right button
        beq TRASL_Y_POSITIVE
        stw r15, 0x04E0 (r12)

    TRASL_Y_POSITIVE:
        andi. r16, r8, 0x0004  # up button
        beq TRASL_Y_NEGATIVE
        stw r14, 0x04E4 (r12)

    TRASL_Y_NEGATIVE:
        andi. r16, r8, 0x0008  # down button
        beq TRASL_Z_POSITIVE
        stw r15, 0x04E4 (r12)

    TRASL_Z_POSITIVE:
        andi. r16, r8, 0x0800  # A button
        beq TRASL_Z_NEGATIVE
        stw r14, 0x04E8 (r12)

    TRASL_Z_NEGATIVE:
        andi. r16, r8, 0x0400  # B button
        beq MULTIPLY_BxC_AND_SAVE_TO_A
        stw r15, 0x04E8 (r12)


MULTIPLY_BxC_AND_SAVE_TO_A:
    addi r14, r12, 0x3B0  # pointer to matrix A
    addi r15, r12, 0x4B0  # pointer to matrix B
    addi r16, r12, 0x5B0  # pointer to matrix C
    li r17, 0  # A row index (times 0x10) {0x0, 0x10, 0x20, 0x30}
    LOOP_THROUGH_ROWS:
        li r18, 0  # A column index (times 0x4) {0x0, 0x4, 0x8, 0xC} 
        LOOP_THROUGH_COLS:
            mr r19, r17  # B row index (times 0x10) (same as A's, fixed during dot product)
            li r20, 0    # B col index (times 0x4)  {0x0, 0x4, 0x8, 0xC}
            li r21, 0    # C row index (times 0x10) {0x0, 0x10, 0x20, 0x30}
            mr r22, r18  # C col index (times 0x4)  (same as A's, fixed during dot product)
            lfs f13, 0x3b0 (r12)  # dot product sum accumulator (initialize as zero)
            fsubs f13, f13, f13
            DOT_PRODUCT:
                add r23, r19, r20  # B absolute index = 0x4*col_index + 0x10*row_index
                lfsx f12, r23, r15  # Load value from matrix B
                add r23, r21, r22  # C absolute index = 0x4*col_index + 0x10*row_index
                lfsx f11, r23, r16  # Load value from matrix C
                fmadds f13, f11, f12, f13  # add f11*f12 to f13
                addi r20, r20, 0x4
                addi r21, r21, 0x10
                cmpwi r20, 0x10
                blt DOT_PRODUCT

            add r23, r17, r18  # A absolute index = 0x4*col_index + 0x10*row_index
            stfsx f13, r23, r14  # Store value to A
            addi r18, r18, 0x4
            cmpwi r18, 0x10
            blt LOOP_THROUGH_COLS

        addi r17, r17, 0x10
        cmpwi r17, 0x40
        blt LOOP_THROUGH_ROWS


# pop r14-r13 from the stack
POP_STACK:
    lmw r14, 0x8 (sp) 
    addi sp, sp, 0x0050 


cmplwi r4, 2  # original instr