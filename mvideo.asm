print_string_at_pos:
;in: di: char pointer
	pusha
	xor ax, ax
	xor bx, bx
	mov bx, di
loop_psap:
	mov si, bx
	lodsb
	cmp al, 0
	je psap_end
	mov bx, si
	mov dl, al

	call print_char_at_pos
	inc word [cursor_x]
	cmp word [cursor_x], 80
	je new_line
	jmp loop_psap
	
new_line:
	mov word [cursor_x], 0
	inc word [cursor_y]
	jmp loop_psap

psap_end:
	mov word [cursor_x], 0
	inc word [cursor_y]
	jmp generic_end
    
print_char_at_pos:
	pusha
;di: pos x, si: pos y, dl: char
;there are 80 characters per line, each character takes 2 bits
	xor bx, bx
	mov word di, [cursor_x]
	mov word si, [cursor_y]
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
	mov ah, 0x02
	mov [es:bx], ax
	
	jmp generic_end
	
clearscreen:
    pusha
    
    mov word [cursor_x], 0
    mov word [cursor_y], 0
    mov dl, ' '	
    mov cx, 2000
loop_clrscrn:
    call print_char_at_pos
    inc word [cursor_x]
    cmp word [cursor_x], 80
    je addy
compare:
    loop loop_clrscrn
	mov word [cursor_x], 0
	mov word [cursor_y], 0
    jmp generic_end    
addy:
    mov word [cursor_x], 0
    inc word [cursor_y]
    jmp compare












