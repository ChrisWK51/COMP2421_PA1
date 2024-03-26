#########  READ ME ################################
# Steps :
#	1. Print the prompt Message for using System call 4
#	2. Get the User input number and store in $s0
#	3. Jump to toBinary Function , Convert the inputted Number to binary in loop
#	4. After finish convert and prompt the binary number , jump back to main
#	5. Jump to toQuaternary Function , Convert the inputted Number to Quaternary in loop
#	6. After finish convert and prompt the Quaternary number, jump back to main
#	7. Jump to toOctal Function , Convert the inputted Number to Octal in loop
#	8. After finish convert and prompt the Octal number , jump back to main
#	9. Get the user input and store in $s0
#	10. If the input value is 1 (means continue to run) , back to step 1 .
#	11. If the input value is 0 , Prompt Bye Message and terminate the program using System call 10
#
# CodeFlow : 
#	Main -> toBinary -> convertForLoop (Loop for convert the input number to binary and prompt)
#	-> Main -> toQuaternary -> convertForLoop (Loop for convert the input number to quaternary and prompt)
#	-> Main -> toOctal -> convertForLoop (Loop for convert the input number to octal and prompt)
#	-> Main -> Begin of Main (if user input 1) / Terminate the program (if user input 0)
#
####################################################

.data
prompt: 		    	.asciiz "Enter a number: "
input_number_prompt: 		.asciiz "Input number is "
binary_prompt: 		    	.asciiz "\nBinary: "
quaternary_prompt: 	    	.asciiz "\nQuaternary: "
octal_prompt: 		    	.asciiz "\nOctal: "
continue_prompt:	    	.asciiz "\nContinue? (1=Yes/0=No) "
bye_prompt:		     	.asciiz "Bye!"
	.text
	.globl main
		
main:
	#Prompt "Enter a Number:"  
	
	la $a0, prompt #Load String Address of Prompt into $a0 
	li $v0, 4 #System call the print string 
	syscall  
	
	#Capture Input Number
	
	li $v0 , 5 #System call the read_int
	syscall 
	move $s0, $v0 #store the inputted integer into $s0
	
	#Prompt "input number is "
	
	la $a0, input_number_prompt #Load String input_number_prompt into $a0 
	li $v0, 4 #System call the print string 
	syscall 
	
	#print the inputted number"
	add $a0, $s0 , $0  #Load the inputted integer 
	li $v0, 1 #System call to print out the inputted integer
	syscall 

	jal toBinary   		#jump to the toBinary Function for convert the inputted Integer to Binary
	jal toQuaternary 	#jump to the toQuaternary Function for convert the inputted Integer to Quaternary 
	jal toOctal		#jump to the toOctal Function for convert the inputted Integer to Octal 
	
	#Ask if the user continue the program
	la $a0 , continue_prompt #Load String continue_prompt into $a0 
	li $v0 , 4 	#System call the print string 
	syscall  
	
	li $v0 , 5 #System call the read_int
	syscall 
	move $s0, $v0 #store the inputted integer into $s0
	
	beq $s0 , 1 , main # if the user input is 1 , back to beginning of main
	
	la $a0 , bye_prompt  #Load String bye_prompt to $a0 
	li $v0 , 4 #System call the print string 
	syscall 
	
	li $v0 , 10 #System call the exit of the program for terminating
	syscall


convertForLoopCondition:
	#for (int k = $t3 ; k > 0 ; k--), move to convertForLoopEnd if the loop ends
	beq $t3 , 0 , convertForLoopEnd 

#Loop body of the for loop
convertForLoopBody:
	
	srlv $t5 , $s0 , $t1 #shift right logical the input varible by $t1 and store into $v5 , (e.g.  0100 -> 0001 )
	#Bitwise operation for converting the value by $t5 & $t2 and store into $t5 ($t2 = the max value for digit of each base ) 
	#E.g. for Octal , $t5 = 11(dec) = 1 011  , 011 & 111 = 110 -> 3(oct)
	and $t5, $t5 , $t2 
	
	###############################################
	# Now $t5 store the value we want in each digit
	################################################
	
	add $a0 , $t5 , $zero  #Load the converted value digit into $a0
	li $v0, 1  #System call the print integer
	syscall 
	
	sub $t1 , $t1 , $t4  #substrate $t1 by $t4 for next shift right logical in the loop 
	sub $t3 , $t3 , 1  #substrate $t3 by 1 for couting the iteration
	j convertForLoopCondition  #Jump back to convertForLoopCondition for check the loop is end of not

# if the loop is end , jump back to the main for continue the program
convertForLoopEnd:

	jr $ra #jump back to main

toBinary:

	####################################################################################
	# i  = base 2 ^ i , for binary it is base 2^1  = 2 , i = 1
	# s0 = inputted value by user
	# t1 = the starting position value for right shift , 32 - 1 = 31
	# t2 = value for bitwise operation , base 2 = 1 max for each digit  , 1 = 1 (1 & right shift value last 1 digit) 
	# t3 = iteration k ,k = 32 / i = 32 / 1 = 32
	# t4 = for decrease the right shift value = i = 1 ( 32 , 31 , 30 , 29 .... ,3 , 2 , 1 , 0
	####################################################################################
	
	la $a0, binary_prompt #Load String binary_prompt to $a0 
	li $v0, 4            #System call the print string 
	syscall
	
	li $t1 , 31
	li $t2 , 1
	li $t3 , 32
	li $t4 , 1
	
	j convertForLoopCondition  #Jump to ConvertForLoopCondition for start converting the input value to binary
		
	
toQuaternary:

	####################################################################################
	# i  = base 2 ^ i, in  Quaternany it is 2 (base 2^2 = 4 , i = 2
	# s0 = inputted value by user
	# t1 = the starting position value for right shift , 32 - 2 = 30
	# t2 = value for bitwise operation  , base 4 = 3 max for each digit , 3 = 11 ( 11 & right shift value last 2 digit) 
	# t3 = iteration k ,k = 32 / i = 32 / 2 = 16 
	# t4 = for decrease the right shift value = i = 2 ( 30 , 28 , 26 , 24 , 22 ....,4, 2,0
	####################################################################################
	
	la $a0, quaternary_prompt  #Load String binary_prompt to $a0 
	li $v0, 4 		#System call the print string 
	syscall
	
	li $t1 , 30
	li $t2 , 3
	li $t3 , 16
	li $t4 , 2
	
	j convertForLoopCondition #Jump to ConvertForLoopCondition for start converting the input value to Quaternary
	
toOctal:

	####################################################################################
	# i  = base 2 ^ i, in Octal it is 3 (base 2^3 = 8 , i = 3
	# s0 =  inputted value by user
	# t1 =  the starting position for right shift , 32 - 3 = 29 -> 30  ( 29 cannot division by 3)
	#
	# 32 bits length but group of 3 -> 3 * 11 = 33 (as the division is 3 , for 3 digit in binary), pretend to have 11 groups to cover it
	# The reason why 30 is ok for Octal when it is 32-bit long  as after the shift it will pad with zero to the left
	#
	# t2 = value for bitwise operation , base 8 = 7 max for each digit , 7 = 111 ( 111 & right shift value last 3 digit) 
	# t3 = iteration k ,k = 32 / i = 32 / 3 =  10.66666 round up -> 11 ( for 11 groups we need 11 times)
	# t4 = for decrease the right shift value  = i = 3  ( 30 , 27  , 24 ...... ,6, 3 , 0
	#####################################################################################
	
	la $a0, octal_prompt  #Load String binary_prompt to $a0 
	li $v0, 4		#System call the print string 
	syscall
	
	li $t1 , 30
	li $t2 , 7
	li $t3 , 11
	li $t4 , 3

	j convertForLoopCondition #Jump to ConvertForLoopCondition for start converting the input value to Octal
	
	
##################################################################################################################################
# End of Program Code
#################################################################################################################################
	

