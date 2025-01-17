[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov [BOOT_DRIVE], dl
    mov ax, 03h
    int 10h
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE 
    call print
    call print_nl

    call load_kernel 
    call switch_to_pm 
    jmp $
%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/32bit_print.asm"
%include "boot/switch_pm.asm"
[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl
    mov bx, KERNEL_OFFSET
    mov dh, 31 
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret
[bits 32]
BEGIN_PM:
    mov bx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET 
    jmp $ 
; -----------------------------------------------
BOOT_DRIVE db 0 
MSG_REAL_MODE db "HOLY SHAT, FUCKOS BOOTED!", 0
MSG_PROT_MODE db "", 0
MSG_LOAD_KERNEL db "Wasting your time...", 0
MSG_RETURNED_KERNEL db "Could not waste your time.", 0
; padding
times 510 - ($-$$) db 0
dw 0xaa55
