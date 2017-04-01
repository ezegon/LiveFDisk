[BITS 16]
[ORG 0x7C00]

section .bss
tita resb 256

section .data
pos_tita db 0
keyflag db 0

section .text
global start
start:
    call getchar
    call putchar_cursor
    ;call store
    mov bx, tita
    jmp start

getchar:
    xor ax,ax
    int 0x16
    ret

_checkchar:
    cmp ah, 0x4B
    je _setleft
    cmp ah, 0x4D
    je _setright  
    ret

_setleft:
    call getcursor
    cmp dl, 0
    je _exit_char
    dec dl
    call setcursor
    ret

_setright:
    call getcursor    
    cmp dl, 63
    je _exit_char
    inc dl
    call setcursor
    ret

_exit_char:
    mov ah, -1
    ret

getcursor:
    mov ah, 0x03
    mov bh, 0x00
    int 0x10
    ret

setcursor:
    mov ah, 0x02
    int 0x10
    ret

putchar_cursor:
    call _checkchar
    cmp ah, 0x02
    je _exit
    cmp ah, -1
    je _exit
    mov ah, 0x0E ;aca va la funcion a ejecutar, 0E imprime un caracter
    mov bh, 0x00 ;en los registros que siguen van los argumentos de la funcion, 00 es el numero de pagina
    mov bl, 0x20 ;el formato del texto
    int 0x10
    call store
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
    
_exit:
    ret

;END NO TOCAR
times 510-($-$$) db 0
dw 0xAA55
