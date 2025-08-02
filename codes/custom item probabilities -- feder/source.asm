#To be inserted at 8009ba24
# CODE FOR CUSTOM ITEM PROBABILITIES by Feder
# FILL THIS WITH THE VALUES YOU WANT AND THEN COMPILE
# Region: PAL, Revision 1

# KNOWN BUGS AND OTHER ISSUES:
# Doesn't work if you play with certain item cheats
# Can cause the double star/captain special/chomp glitch 

# Check what's the current probability of getting a red shell to determine what's the score difference
cmpwi r25, 26		
bge- UP_BY_6
cmpwi r25, 22		
bge- UP_BY_5
cmpwi r25, 18		
bge- UP_BY_4
cmpwi r25, 15	
bge- UP_BY_3
cmpwi r25, 13	
bge- UP_BY_2
cmpwi r25, 12	
bge- TIED_OR_1_POINT_DIFF
cmpwi r25, 11		
bge- DOWN_BY_2
cmpwi r25, 9		
bge- DOWN_BY_3
cmpwi r25, 6		
bge- DOWN_BY_4
cmpwi r25, 2		
bge- DOWN_BY_5	
b DOWN_BY_6

UP_BY_6:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 255		# Captain special
li r26, 0		# Spiny shell
li r25, 0		# Red shell
li r24, 0		# Bob-omb
li r23, 28		# Banana
li r22, 0		# Shroom
li r21, 24		# Green shells
li r31, 0		# Freeze shells
b THE_END

UP_BY_5:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 0		# Captain special
li r26, 2		# Spiny shell
li r25, 0		# Red shell
li r24, 0		# Bob-omb
li r23, 24		# Banana
li r22, 0		# Shroom
li r21, 20		# Green shells
li r31, 2		# Freeze shells
b THE_END

UP_BY_4:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 0		# Captain special
li r26, 4		# Spiny shell
li r25, 0		# Red shell
li r24, 0		# Bob-omb
li r23, 20		# Banana
li r22, 0		# Shroom
li r21, 16		# Green shells
li r31, 4		# Freeze shells
b THE_END

UP_BY_3:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 0		# Captain special
li r26, 6		# Spiny shell
li r25, 1		# Red shell
li r24, 1		# Bob-omb
li r23, 18		# Banana
li r22, 0		# Shroom
li r21, 14		# Green shells
li r31, 6		# Freeze shells
b THE_END

UP_BY_2:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 0		# Captain special
li r26, 8		# Spiny shell
li r25, 3		# Red shell
li r24, 3		# Bob-omb
li r23, 14		# Banana
li r22, 0		# Shroom
li r21, 12		# Green shells
li r31, 8		# Freeze shells
b THE_END

TIED_OR_1_POINT_DIFF:
li r30, 1		# Chomp
li r29, 0		# Star
li r27, 2		# Captain special
li r26, 10		# Spiny shell
li r25, 5		# Red shell
li r24, 5		# Bob-omb
li r23, 10		# Banana
li r22, 2		# Shroom
li r21, 10		# Green shells
li r31, 10		# Freeze shells
b THE_END

DOWN_BY_2:
li r30, 0		# Chomp
li r29, 0		# Star
li r27, 0		# Captain special
li r26, 0		# Spiny shell
li r25, 0		# Red shell
li r24, 0		# Bob-omb
li r23, 0		# Banana
li r22, 250		# Shroom
li r21, 0		# Green shells
li r31, 70		# Freeze shells
b THE_END

DOWN_BY_3:
li r30, 3		# Chomp
li r29, 2		# Star
li r27, 10		# Captain special
li r26, 9		# Spiny shell
li r25, 10		# Red shell
li r24, 10		# Bob-omb
li r23, 0		# Banana
li r22, 10		# Shroom
li r21, 0		# Green shells
li r31, 9		# Freeze shells
b THE_END

DOWN_BY_4:
li r30, 4		# Chomp
li r29, 6		# Star
li r27, 15		# Captain special
li r26, 4		# Spiny shell
li r25, 14		# Red shell
li r24, 14		# Bob-omb
li r23, 0		# Banana
li r22, 16		# Shroom
li r21, 0		# Green shells
li r31, 4		# Freeze shells
b THE_END

DOWN_BY_5:
li r30, 5		# Chomp
li r29, 10		# Star
li r27, 20		# Captain special
li r26, 2		# Spiny shell
li r25, 18		# Red shell
li r24, 18		# Bob-omb
li r23, 0		# Banana
li r22, 22		# Shroom
li r21, 0		# Green shells
li r31, 2		# Freeze shells
b THE_END

DOWN_BY_6:
li r30, 6		# Chomp
li r29, 15		# Star
li r27, 25		# Captain special
li r26, 0		# Spiny shell
li r25, 20		# Red shell
li r24, 20		# Bob-omb
li r23, 0		# Banana
li r22, 28		# Shroom
li r21, 0		# Green shells
li r31, 0		# Freeze shells

THE_END:
add r29, r29, r30 # Default instuction