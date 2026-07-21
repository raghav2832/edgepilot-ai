.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

.global Reset_Handler
.global Default_Handler

/* ---------- Vector Table ---------- */
.section .isr_vector,"a",%progbits
.type g_pfnVectors, %object
g_pfnVectors:
  .word _estack               /* initial stack pointer */
  .word Reset_Handler         /* Reset */
  .word NMI_Handler
  .word HardFault_Handler
  .word MemManage_Handler
  .word BusFault_Handler
  .word UsageFault_Handler
  .word 0                     /* reserved */
  .word 0
  .word 0
  .word 0
  .word SVC_Handler
  .word DebugMon_Handler
  .word 0                     /* reserved */
  .word PendSV_Handler
  .word SysTick_Handler
  /* device IRQs (position 16+) come after this — empty for now, we'll
     extend this table in Phase 2/3 when we enable UART/ADC/timer IRQs */

.size g_pfnVectors, .-g_pfnVectors

/* ---------- Reset Handler ---------- */
.section .text.Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
  /* copy .data section from flash (LMA) to RAM (VMA) */
  ldr r0, =_sidata
  ldr r1, =_sdata
  ldr r2, =_edata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r0, r3]
  str r4, [r1, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r1, r3
  cmp r4, r2
  bcc CopyDataInit

  /* zero-fill .bss */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

  /* jump to main() */
  bl main
  bx lr

.size Reset_Handler, .-Reset_Handler

/* ---------- Default Handler (infinite loop trap) ---------- */
.section .text.Default_Handler,"ax",%progbits
Default_Handler:
  b Default_Handler
.size Default_Handler, .-Default_Handler

/* ---------- Weak aliases: any unimplemented handler falls back to Default_Handler ---------- */
.weak NMI_Handler
.thumb_set NMI_Handler,Default_Handler
.weak HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler
.weak MemManage_Handler
.thumb_set MemManage_Handler,Default_Handler
.weak BusFault_Handler
.thumb_set BusFault_Handler,Default_Handler
.weak UsageFault_Handler
.thumb_set UsageFault_Handler,Default_Handler
.weak SVC_Handler
.thumb_set SVC_Handler,Default_Handler
.weak DebugMon_Handler
.thumb_set DebugMon_Handler,Default_Handler
.weak PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler
.weak SysTick_Handler
.thumb_set SysTick_Handler,Default_Handler
