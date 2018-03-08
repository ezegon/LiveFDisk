read_char_from_string:
;string direction stored in si
    pusha
    xor bx,bx
    xor ax, ax

loop_rcfs:
    lodsb
    cmp al, 0
    je generic_end

    push ax

    mov ax, 0xb800
    mov es, ax

    pop ax

    mov ah, 0x40
    mov [es:bx], ax
    add bx, 2
    jmp loop_rcfs
    

clearscreen:
    pusha
