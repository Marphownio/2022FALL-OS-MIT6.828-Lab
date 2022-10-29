/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_TRAP_H
#define JOS_KERN_TRAP_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/trap.h>
#include <inc/mmu.h>

/* The kernel's interrupt descriptor table */
extern struct Gatedesc idt[];
extern struct Pseudodesc idt_pd;

void trap_init(void);
void trap_init_percpu(void);
void print_regs(struct PushRegs *regs);
void print_trapframe(struct Trapframe *tf);
void page_fault_handler(struct Trapframe *);
void backtrace(struct Trapframe *);

//lab3 code
void th_divide();
void th_debug();
void th_nmi();
void th_brkpt();
void th_oflow();
void th_bound();
void th_illop();
void th_device();
void th_dblflt();
void th_tss();
void th_segnp();
void th_stack();
void th_gpflt();
void th_pgflt();
void th_fperr();
void th_align();
void th_mchk();
void th_simderr();
void th_syscall();


#endif /* JOS_KERN_TRAP_H */
