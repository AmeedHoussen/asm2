.global	keyMixing, byteSubstitution, shiftRows, cipher

.section .data
sbox:	.byte	99,124,119,123,-14,107,111,-59,48,1,103,43,-2,-41,-85,118
		.byte	-54,-126,-55,125,-6,89,71,-16,-83,-44,-94,-81,-100,-92,114,-64
		.byte	-73,-3,-109,38,54,63,-9,-52,52,-91,-27,-15,113,-40,49,21
		.byte	4,-57,35,-61,24,-106,5,-102,7,18,-128,-30,-21,39,-78,117
		.byte	9,-125,44,26,27,110,90,-96,82,59,-42,-77,41,-29,47,-124
		.byte	83,-47,0,-19,32,-4,-79,91,106,-53,-66,57,74,76,88,-49
		.byte	-48,-17,-86,-5,67,77,51,-123,69,-7,2,127,80,60,-97,-88
		.byte	81,-93,64,-113,-110,-99,56,-11,-68,-74,-38,33,16,-1,-13,-46
		.byte	-51,12,19,-20,95,-105,68,23,-60,-89,126,61,100,93,25,115
		.byte	96,-127,79,-36,34,42,-112,-120,70,-18,-72,20,-34,94,11,-37
		.byte	-32,50,58,10,73,6,36,92,-62,-45,-84,98,-111,-107,-28,121
		.byte	-25,-56,55,109,-115,-43,78,-87,108,86,-12,-22,101,122,-82,8
		.byte	-70,120,37,46,28,-90,-76,-58,-24,-35,116,31,75,-67,-117,-118
		.byte	112,62,-75,102,72,3,-10,14,97,53,87,-71,-122,-63,29,-98
		.byte	-31,-8,-104,17,105,-39,-114,-108,-101,30,-121,-23,-50,85,40,-33
		.byte	-116,-95,-119,13,-65,-26,66,104,65,-103,45,15,-80,84,-69,22

.section	.text
 keyMixing:
    # doing the xor as we were asked in the question  
 	movq (%rdi), %rax
    movq (%rsi), %r8
    xorq %r8, %rax
    movq %rax, (%rdi)
    movq 8(%rdi), %rax
	movq 8(%rsi), %r8
	xorq %r8, %rax
    movq %rax, 8(%rdi)
      
	ret
	
byteSubstitution:
  	movq $16, %r9
    leaq sbox(%rip), %r8

check_done_HW2:
    # checking if we finished and did for them all
 	cmpq $0, %r9
 	jne copy_byte_HW2
    ret

copy_byte_HW2:
    # here we r doing the main thing which is copying
    dec %r9
 	mov (%rdi, %r9), %cl 
 	mov (%r8, %rcx),%al
 	mov %al, (%rdi, %r9)
 	jmp check_done_HW2

shiftRows:
        pushq %rbx
	
        movb 6(%rdi), %al
        movb 7(%rdi), %bl
        movb %bl, 6(%rdi)
        movb 5(%rdi), %bl
        movb %al, 5(%rdi)
        movb 4(%rdi), %al
        movb %bl, 4(%rdi)
        movb %al, 7(%rdi)

        movw 8(%rdi), %ax
        movw 10(%rdi), %bx
        movw %bx, 8(%rdi)
        movw %ax, 10(%rdi)

	    movb 12(%rdi),%al
        movb 13(%rdi),%bl
        movb %al,13(%rdi)
        movb 14(%rdi),%al
        movb %bl,14(%rdi)
        movb 15(%rdi),%bl
        movb %al,15(%rdi)
        movb %bl,12(%rdi)
        
        popq %rbx
	ret

cipher:
key_mix_arr_HW2:
    mov $0, %rcx 	
	pushq %rdi
	pushq %rsi
	pushq %r8
        pushq %rax
	call keyMixing 
        popq %rax
        popq %r8
        popq %rsi
        popq %rdi

mixing_HW2:
        pushq %rdi
        pushq %rcx
        pushq %r9
        pushq %rax
        call byteSubstitution
        popq %rax
        popq %r9
        popq %rcx
        popq %rdi
     
        pushq %rdi
        pushq %rax
        call shiftRows
        popq %rax
        popq %rdi
       
        pushq %rdx	
        pushq %rdi
        pushq %rsi
        pushq %rcx
        call mixColumns
        popq %rcx
        popq %rsi
        popq %rdi
        popq %rdx
        
        pushq %rdi
	pushq %rsi
	pushq %r8
        pushq %rax
	call keyMixing
        popq %rax
        popq %r8
        popq %rsi
        popq %rdi
        
        inc %rcx
        cmpq $9, %rcx
        jne mixing_HW2

        pushq %rdi
        pushq %rcx
        pushq %r9
        pushq %rax
        call byteSubstitution
        popq %rax
        popq %r9
        popq %rcx
        popq %rdi
     
        
        pushq %rax	
        pushq %rdi
        call shiftRows
        popq %rdi
        popq %rax

        pushq %rdi
	pushq %rsi
	pushq %r8
         pushq %rax
	call keyMixing 
        popq %rax
        popq %r8
        popq %rsi
        popq %rdi

        lea 16(%rdi), %rdi
        dec %rdx
        cmpq $0, %rdx
        jne key_mix_arr_HW2
	
	ret	
     