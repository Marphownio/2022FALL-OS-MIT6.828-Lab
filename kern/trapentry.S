/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
/*
Table 9-1. Interrupt and Exception ID Assignments

Identifier   Description

0            Divide error
1            Debug exceptions
2            Nonmaskable interrupt
3            Breakpoint (one-byte INT 3 instruction)
4            Overflow (INTO instruction)
5            Bounds check (BOUND instruction)
6            Invalid opcode
7            Coprocessor not available
8            Double fault
9            (reserved)
10           Invalid TSS
11           Segment not present
12           Stack exception
13           General protection
14           Page fault
15           (reserved)
16           Coprecessor error
17-31        (reserved)
32-255       Available for external interrupts via INTR pin

*/
TRAPHANDLER_NOEC(th_divide, T_DIVIDE)          //0
TRAPHANDLER_NOEC(th_debug, T_DEBUG)            //1
TRAPHANDLER_NOEC(th_nmi, T_NMI)                //2
TRAPHANDLER_NOEC(th_brkpt, T_BRKPT)            //3
TRAPHANDLER_NOEC(th_oflow, T_OFLOW)            //4
TRAPHANDLER_NOEC(th_bound, T_BOUND)            //5
TRAPHANDLER_NOEC(th_illop, T_ILLOP)            //6
TRAPHANDLER_NOEC(th_device, T_DEVICE)          //7
TRAPHANDLER(th_dblflt, T_DBLFLT)               //8
TRAPHANDLER(th_tss, T_TSS)                     //10
TRAPHANDLER(th_segnp, T_SEGNP)                 //11
TRAPHANDLER(th_stack, T_STACK)                 //12
TRAPHANDLER(th_gpflt, T_GPFLT)                 //13
TRAPHANDLER(th_pgflt, T_PGFLT)                 //14
TRAPHANDLER_NOEC(th_fperr, T_FPERR)            //16
TRAPHANDLER(th_align, T_ALIGN)                 //17
TRAPHANDLER_NOEC(th_mchk, T_MCHK)              //18
TRAPHANDLER_NOEC(th_simderr, T_SIMDERR)        //19
TRAPHANDLER_NOEC(th_syscall, T_SYSCALL)        //48
/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	//1.push values to make the stack look like a struct Trapframe
	//2.load GD_KD into %ds and %es
	//3.pushl %esp to pass a pointer to the Trapframe as an argument to trap()
	//4.call trap (can trap ever return?)
	//that stack grows from high address to low address, but a struct is from low to high
	//build trap frame :in inc/trap.h the tf_trapno(trap number) has been pushed therefore we only need to push ds&es
	pushl %ds
    pushl %es
    pushal

	//an immediate value should be first moved to a general-purpose register like ax, then be moved to the segment register. 
	//set up data segments
	movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es

    //call trap(tf) where tf=esp
	pushl %esp
    call trap