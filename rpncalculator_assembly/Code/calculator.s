#
# CMPUT 229 Student Submission License
# Version 1.0
#
# Copyright 2019 <student name>
#
# Redistribution is forbidden in all circumstances. Use of this
# software without explicit authorization from the author or CMPUT 229
# Teaching Staff is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution is confidential and remains confidential 
# after it is submitted for grading.
#
# Copying any part of this solution without including this copyright notice
# is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including 
# the URL or other repository locating information, to the following email
# address:
#
#          cmput229@ualberta.ca
#
#---------------------------------------------------------------
# CCID: 		      yaathesh              
# Lecture Section: 	  LEC B1      
# Instructor:         Felipe Banados Schwerter
# Lab Section: 		  LAB H03          
# Teaching Assistant: Christiaan V 
#---------------------------------------------------------------
# 

.include "common.s"

#----------------------------------
calculator:
    lw t0, 0(a0)           # Load a word from the input list into a0
    li t1, -3              # Load -3 into temporary register t1
    beq t0, t1, calc_end   # Compare a0 and t1, if equal, jump to calc_end

    # Update memory address to point to the next word
    addi a0, a0, 4         # Increment the address in a0 by 4 (since a word is 4 bytes)

    # Check if element is operand (non-negative integer)
    bgez t0, push_operand

    # Element is operator
    # Load top two values from stack
    lw t4, 4(a1)          # Load top value from stack
    lw t5, 8(a1)          # Load second top value from stack
    
    addi a1, a1, 8

    # Perform operation based on operator
    li t6, -1              # Load -1 into temporary register t6
    beq t0, t6, add_values    # If t0 equals -1, jump to add_values
    
    li t6, -2              # Load -2 into temporary register t6
    beq t0, t6, subtract_values  # If t0 equals -2, jump to subtract_values

add_values:
    add t6, t4, t5         # Add top two values from stack
    j push_result          # Jump to push_result

subtract_values:
    sub t6, t5, t4         # Subtract top value from second top value on stack
    j push_result          # Jump to push_result

push_operand:
    # Push operand onto stack
    sw t0, 0(a1)
    addi a1, a1, -4        # Move stack pointer
    j calculator           # Continue loop

push_result:
    # Push result onto stack
    sw t6, 0(a1)
    addi a1, a1, -4        # Move stack pointer
    j calculator           # Continue loop

calc_end:
    # Print the top value on the stack
    lw a0, 4(a1)           # Load top value from stack
    addi a1, a1, 4         # Move stack pointer
    li a7, 1               # System call number for print integer
    ecall                  # Make system call

    # Return from subroutine
    jr ra

#----------------------------------
