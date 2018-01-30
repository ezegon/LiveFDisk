[BITS 16]
[ORG 0x7C00]

global loader
loader:
    xor ax, ax ;Clear ax
    mov ah, 0x02 ;Read sectors
    mov al, 4 ;Read four sectors
    mov ch, 0 ;Cylinder 0
    mov cl, 2 ;First Sector
    mov dh, 0 ;Head 0
    mov dl, 0 ;Floppy
    mov bx, 0x8000 ;Save buffer in 0x8000
    mov es, bx
    xor bx,bx ;Clear bx
    int 0x13 ;Drives interrupt
    jc reading_error
    mov bx, 0x8000
    mov ds, bx
    jmp 0x8000:0
    
reading_error:
    jmp reading_error
    
times 0x1FE-($-$$) db 0
dw 0xAA55
