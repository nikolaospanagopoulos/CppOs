section .asm

global idtLoad
global int21h
global noInterrupt
extern noInterruptHandler
extern int21Handler
idtLoad:
   push ebp
   mov ebp, esp

   mov ebx, [ebp + 8]

   lidt [ebx]


   pop ebp
   ret

int21h:
   cli
   pushad

   call int21Handler

   popad
   sti
   ret

noInterrupt:
   cli
   pushad

   call noInterruptHandler

   popad
   sti
   ret
