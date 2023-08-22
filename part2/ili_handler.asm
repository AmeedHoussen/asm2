.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######

    push %rbp
    movq %rsp, %rbp
    pushq %rax
 
    #initialize both registers to zero then we use them 
    xor %rax, %rax
    movq 8(%rbp), %rax 
    xor %rdi, %rdi
    movb (%rax), %dil                     
    pushq %r10
    
    # we save these registers   
    pushq %r8
    pushq %r9
    pushq %r11
    pushq %rcx
    pushq %rsi
    pushq %rdx
    pushq %rdi

    xor %r10 , %r10
    cmpb $0x0f, (%rax)                  
    je two_bytes_HW2
    jmp one_bytes_HW2

two_bytes_HW2:

    movb 1(%rax),%dil
    inc %r10                                      

one_bytes_HW2:

    inc %r10                                     
    pushq %r10
    #pushq %rax
    call what_to_do
    #popq %rax
    popq %r10
    cmp $0, %al

    je original_treatment_HW2
    jne new_treatment_HW2

 

original_treatment_HW2:

    # we should retake the registers
    popq %rdi
    popq %rdx
    popq %rsi
    popq %rcx
    popq %r11
    popq %r9
    popq %r8
    popq %r10
    popq %rax

    movq %rbp, %rsp
    popq %rbp
    jmp *old_ili_handler

 

new_treatment_HW2:

    # as well here we should retake the registers
    popq %rdi
    popq %rdx
    popq %rsi
    popq %rcx
    popq %r11
    popq %r9
    popq %r8

    movl %eax, %edi
    addq %r10, 8(%rbp)
    popq %r10
    popq %rax
    movq %rbp, %rsp
    popq %rbp

  iretq