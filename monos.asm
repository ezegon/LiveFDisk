[BITS 16]
[ORG 0x7C00]

section .text
global start
start:
    xor ax, ax ;Clear ax
    mov ah, 0x02 ;Read sectors
    mov al, 1 ;Read one sector
    mov ch, 0 ;Cylinder 0
    mov cl, 1 ;First Sector
    mov dh, 0 ;Head 0
    mov dl, 0x80 ;HDD #0
    mov es, 0x9000 ;Save buffer in 0x9000
    xor bx,bx ;Clear bx
    int 0x13 ;Drives interrupt
    jc reading_error
    
read_sectors:
    mov bx, 0x01BE
    mov 

reading_error:


;Variables
partition_count db 0
    
;END NO TOCAR
times 510-($-$$) db 0
dw 0xAA55
