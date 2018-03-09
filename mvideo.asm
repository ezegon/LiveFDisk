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
	xor bx, bx
	
	mov al, 80
	mul si
	add ax, 0xb800
	mov es, ax
	mov al, 2
	mul di
	mov bx, ax
	mov al, dl
	mov ah, 0x40
	mov [es:bx], ax
	
	jmp generic_end
	
clearscreen:
    pusha
	mov cx, 80
	
loop_clearscreen:
	mov ax, 0xb800
    mov es, ax
	mov al, 'A'
	mov ah, 0x40
    mov [es:bx], ax
    add bx, 2
    loop loop_clearscreen
	
	jmp generic_end