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
    call increase_cursor_pos
	jmp loop_psap
psap_end:
    call increase_cursor_pos
	jmp generic_end
    
print_char_at_pos:
;di: pos x, si: pos y, dl: char
;there are 80 characters per line, each character takes 2 bits
	pusha
	xor bx, bx
	mov word di, [cursor_x]
	mov word si, [cursor_y]

    cmp word di, 80
    jl place_char
    call new_line_generic

place_char:
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
    call increase_cursor_pos
    ;~ je add_y increase_cursor_pos handles this
compare:
    loop loop_clrscrn
	mov word [cursor_x], 0
	mov word [cursor_y], 0
    jmp generic_end

;~ add_y:
    ;~ mov word [cursor_x], 0
    ;~ inc word [cursor_y]
    ;~ jmp compare

increase_cursor_pos:
    cmp word [cursor_x], 80
    jge new_line_generic
    inc word [cursor_x]
    ret

new_line_generic:
   	mov word [cursor_x], 0
    cmp word [cursor_y], 25
    jge refresh
    inc word [cursor_y]
	ret
refresh:
    call clearscreen
    ret
