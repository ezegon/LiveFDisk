[BITS 16]
[ORG 0x7C00]

section .bss
tita resb 256

section .data
spckey db 0
pos_tita db 0
up db 0x48
down db 0x50
left db 0x4B
right db 0x4D
ent db 0x1B

section .text
global start
start:
    call getchar
    call putchar_cursor
    call store
    ;call printcmd
    jmp start

getchar:
    xor ax,ax
    int 0x16
    call checkchar
    ret

checkchar:
    cmp ah, [left]
    mov byte [spckey], -1
    je handle_cursor    
    ret

handle_cursor:
    call get_cursor
    call set_cursor
    mov byte [spckey], 0
    ret
    
get_cursor:
    mov ah, 0x03
    mov bh, 0x00
    int 0x10
    ret

set_cursor:
    mov ah, 0x02
    add di, [spckey]
    int 0x10
    ret

putchar_cursor:
    cmp byte [spckey], 0
    jne putchar_cursor_end
    mov ah, 0x0E ;aca va la funcion a ejecutar, 0E imprime un caracter
    mov bh, 0x00 ;en los registros que siguen van los argumentos de la funcion, 00 es el numero de pagina
    mov bl, 0x20 ;el formato del texto

    int 0x10
putchar_cursor_end:
    ret

store:
    cld
    mov si, [pos_tita]
    mov di, tita
    add di, si
    inc byte [pos_tita]
    stosb
    ret

printcmd:
    mov cx, [pos_tita]
loop1:
    mov si, cx
    mov al, [tita+si]
    call putchar_cursor
    loop loop1
    ret
    

;END NO TOCAR
times 510-($-$$) db 0
dw 0xAA55
