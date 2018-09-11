;----------------------------------¡

;----------------------------------¡
;print_int

;Prints in int whatever is pointed by SI in memory, CX must contain the length (In bytes) of the int
print_int_from_memory:
    pusha
    
loop_int_:
    xor ax, ax
    lodsb
    loop into_digit
    movzx cx, [int_digits]
    mov si, cx
    call print_int
    jmp print_int_
    ret
    
into_digit:
    xor dx, dx
    mov bx, 10
    div bx
    add dx, '0'
    ;~ push dx
    ;~ xor dx, dx
    ;~ inc byte [int_digits]
    cmp ax, 0
    je add_digit
    ;~ je loop_int_
    xor dx, dx
    jmp into_digit
    
add_digit:
    push dx
    xor dx, dx
    inc byte [int_digits]
    jmp loop_int_
    
print_int_:
    ;~ call print_canada
    xor dx, dx
    pop dx
    call print_char_at_pos
    call increase_cursor_pos
    loop print_int_
    
exit_int_:
	call increase_cursor_pos
	popa
	ret

;Prints in int whatever is pointed by SI in memory, CX must contain the length (In bytes) of the int
print_int:
	pusha
    xor ax, ax
    mov ax, si
    
    xor si, si
    xor bx, bx

loop_int:
    xor dx, dx
    mov bx, 10
	div bx       ;The result of the division is stored in AX and the remainder in DX.
	add dx, 0x30 ;30 is Hex
	push dx
	inc si
	cmp ax, 0
	je next_int
	jmp loop_int

next_int: 
	cmp si, 0
	je exit_int
	dec si
	pop ax
    mov dl, al
    call print_char_at_pos
	call increase_cursor_pos
    jmp  next_int

exit_int:
	call increase_cursor_pos
	popa
	ret

;----------------------------------¡

;----------------------------------¡    
;Print Hexa
;SI must contain the direction of what is to be printed

print_hex:
	pusha
    mov bx, cx
	xor cx, cx
	;~ xor bx, bx
	xor dx, dx

loop_hex:
    xor ax, ax
	lodsb
	movzx dx, al
	
	and dl, 0x0F ;Sets to 0 the higher 4 bits of dl (Keep the lower part)
	shr al, 4    ;Sets to 0 the higher 4 bits of al (Keep the high part)
	
	add dl, 0x30
	add al, 0x30
	
    xor dh, dh
	push dx
    xor ah, ah
	push ax

	add cx, 2
	cmp cx, bx
	jge printing_hex
	jmp loop_hex
	
printing_hex:
	cmp cx, 0
	je exit_hex
    
    xor ax, ax
	pop ax
	cmp ax, 0x3A
	jge char_hex
    xor dx, dx
    mov dl, al
	call print_char_at_pos
    call increase_cursor_pos
	dec cx
	jmp  printing_hex

char_hex:
	add al, 7
    xor dx, dx
    mov dl, al
	call print_char_at_pos
    call increase_cursor_pos
	dec cx
	jmp  printing_hex
	
exit_hex:
	;~ mov ah, 0x0E
	;~ mov al, 0x20
	;~ int 0x10
    call increase_cursor_pos
	popa
	ret

;----------------------------------¡

;----------------------------------¡    
;Print Canada

print_canada:
    push di
    mov di, canada
    call print_string_at_pos
    call new_line_generic
    pop di
    ret
