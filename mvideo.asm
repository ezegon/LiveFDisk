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
    
print_char_at_pos:
	pusha
;di: pos x, si: pos y, dl: char
;there are 80 characters per line, each character takes 2 bits
	xor bx, bx
    push dx

    mov ax, 2
    mul di
    mov di, ax

    mov ax, 160
    mul si
    mov si, ax

	mov ax, 0xb800
    mov es, ax
    add bx, di
    add bx, si

    pop dx
	mov al, dl
	mov ah, 0x01
	mov [es:bx], ax
	
	jmp generic_end
	
clearscreen:
    pusha
    
    mov di, 0
    mov si, 0
    mov dl, ' '	
    mov cx, 2000
loop_clrscrn:
    call print_char_at_pos
    inc di
    cmp di, 80
    je addy
compare:
    loop loop_clrscrn
    jmp generic_end    
addy:
    xor di, di
    inc si
    jmp compare












