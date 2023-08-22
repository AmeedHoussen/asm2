#include <asm/desc.h>


// The aim of the function is to recover the curr value of idtr registerand.
void my_store_idt(struct desc_ptr* idtr) {
    // <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
    __asm volatile ("sidt %0"
    : "=memory"(*idtr));
    // </STUDENT FILL>
}

// The aim of the function is to load the curr.
void my_load_idt(struct desc_ptr* idtr) {
    // <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
    __asm volatile ("lidt %0"
    :: "memory"(*idtr));
    // <STUDENT FILL>
}

// updating the gate  
void my_set_gate_offset(gate_desc* gate, unsigned long addr) {
    // <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
    gate->offset_low = addr & 0xFFFF;
    gate->offset_high = (addr >> 32);
    gate->offset_middle = (addr >> 16);

    // </STUDENT FILL>
}

// get the gate
unsigned long my_get_gate_offset(gate_desc* gate) {
    // <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY
    unsigned long gate_offset = gate->offset_high;
    gate_offset = gate_offset << 16;
    gate_offset += gate->offset_middle;
    gate_offset = gate_offset << 16;
    gate_offset += gate->offset_low;
    return gate_offset;
    // </STUDENT FILL>
}