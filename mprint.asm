
;----------------------------------¡

;----------------------------------!
;Print String Function
; si = string to print

print_string:
    pusha ;pushea todos los registros al stack
    
loop_string:
    lodsb ; copia en al lo que contiene la direccion que tiene si
    cmp al, 0
    je exit_string
    mov ah, 0x0E
    int 0x10
    jmp loop_string

exit_string:
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    popa
    ret

;----------------------------------¡

;----------------------------------!
;Print Byte Function
; si = Byte to print

print_byte:
	pusha
	;~ add byte [si], $30
	
loop_byte:
	mov ax, si
	mov ah, 0x0E
	int 0x10
	jmp loop_byte
	
exit_byte:
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    popa
    ret
    
;----------------------------------¡

;----------------------------------!
;Clear String Function

clear_screen:
    popa
    mov ah, 0x06
    mov al, 0x0
    mov bh, 0x07
    mov cx, 0x0
    mov dx, 0x184f
    int 0x10
    pusha
    ret
 
;----------------------------------¡

;----------------------------------¡
;print_int

print_int: ;prints in int whatever is in AX
	pusha
	mov ax, si
	xor si, si

loop_int:
	mov dx, 0
	mov bx, 10
	div bx ;The result of the division is stored in AX and the remainder in DX.
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
	mov ah, 0x0E
	int 0x10
	jmp  next_int

exit_int:
	mov ah, 0x0E
	mov al, 0x20
	int 0x10
	popa
	ret

;----------------------------------¡

;----------------------------------¡    
;Print Hexa
;SI must contain the direction of what is to be printed

print_hex:
	pusha
	xor cx, cx
	xor bx, bx
	xor dx, dx
	mov ah, 0x0E
	
loop_hex:
	lodsb
	movzx dx, al
	
	and dl, 0x0F
	shr al, 4
	
	add dl, 0x30
	add al, 0x30
	
	push dx
	push ax

	add cx, 2
	cmp cx, 8
	je printing_hex
	jmp loop_hex
	
printing_hex:
	cmp cx, 0
	je exit_hex
	pop ax
	cmp al, 0x3A
	jge char_hex
	mov ah, 0x0E
	int 0x10
	dec cx
	jmp  printing_hex

char_hex:
	add al, 7
	mov ah, 0x0E
	int 0x10
	dec cx
	jmp  printing_hex
	
exit_hex:
	mov ah, 0x0E
	mov al, 0x20
	int 0x10
	popa
	ret

;----------------------------------¡

;----------------------------------¡    
