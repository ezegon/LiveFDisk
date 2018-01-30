[BITS 16]

section .text
global menu

;----------------------------------!
;Main menu
menu:
    mov sp, 0x8000
    xor ax,ax
    mov ss, ax
    
    jmp loop_menu

loop_menu:
    mov al, 0x03
    int 0x10
    
    mov si, welcome
    call print_string
    
    mov si, option1
    call print_string

    mov ah, 0x0
    int 0x16
    
    cmp al, 0x31
    je general
    
    jmp loop_menu
;----------------------------------¡

;----------------------------------!
general:
    xor ax, ax ;Clear ax
    mov ah, 0x02 ;Read sectors
    mov al, 1 ;Read one sector
    mov ch, 0 ;Cylinder 0
    mov cl, 1 ;First Sector
    mov dh, 0 ;Head 0
    mov dl, 0x80 ;HDD #0
    mov bx, 0x9000 ;Save buffer in 0x9000
    mov es, bx
    xor bx,bx ;Clear bx
    int 0x13 ;Drives interrupt
    jc reading_error
    
    mov ah, 0x03
    mov si, header
    call print_string
    mov bx, 0x01AE
    
read_partition_table:
	add bx, 0x10
    cmp bx, 0x01EE
	jg partition_tables_done

read_partition_status:
	movzx si, byte [es:bx]
	call print_int
	
read_partition_first_head:
	movzx si, byte [es:bx+1]
	call print_int
	
read_partition_first_sector:
	movzx si, byte [es:bx+2]
	push si
    shl si, 2
	ror si, 2
	call print_int

read_partition_first_cylinder:
    xor si, si
	pop si
	shr si, 6
	shl si, 8
	xor dx, dx
	movzx dx, byte [es:bx+3]
	or  si, dx
	call print_int
	xor si, si
	
read_partition_type:
	movzx si, byte [es:bx+4]
	call print_int
	
read_partition_last_head:
	movzx si, byte [es:bx+5]
	call print_int
	
read_partition_last_sector:
	movzx si, byte [es:bx+6]
	push si
    shl si, 2
	ror si, 2
	call print_int

read_partition_last_cylinder:
	pop si
	shr si, 6
	shl si, 8
	movzx dx, byte [es:bx+7]
	or  si, dx
	call print_int
	xor si, si

read_number_of_sectors:
	mov si, [es:bx+12]
	mov si, big_number
	
    
step_done:
	push ax
	mov ah, 0x0E
	mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    pop ax
    
partition_tables_done:
	jmp loop_menu

reading_error:
    mov si, errorreading
    call print_string
    jmp loop_menu

;----------------------------------¡

;----------------------------------!
;Print String Function
; si = string to print

print_string:
    pusha ;pushea todos los registros al stack

_print_handler:
    lodsb ; copia en al lo que contiene la direccion que tiene si
    mov ah, 0x0E
    cmp al, 0
    je _done
    int 0x10
    jmp _print_handler

_done:
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
	
_print_handler_byte:
	mov ax, si
	mov ah, 0x0E
	int 0x10
	jmp _done
	
    
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

print_hex:
	pusha
	xor cx, cx
	mov bx, [si]
	mov dx, [si+2]
	mov ah, 0x0E
	
loop_hex:
	
loop_hex_1:
	cmp cx, 1
	jge loop_hex_2
	
	mov al, bh
	shr al, 4
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx

loop_hex_2:	
	cmp cx, 2
	jge loop_hex_3

	mov al, bh
	and al, 0xF
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx	
	
loop_hex_3:
	cmp cx, 3
	jge loop_hex_4
	
	mov al, bl
	shr al, 4
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx
	
loop_hex_4:
	cmp cx, 4
	jge loop_hex_5
	
	mov al, bl
	and al, 0xF
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx
	
loop_hex_5:
	cmp cx, 5
	jge loop_hex_6
	
	mov al, dh
	shr al, 4
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx
	
loop_hex_6:
	cmp cx, 6
	jge loop_hex_7
	
	mov al, dh
	and al, 0xF
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx
	
loop_hex_7:
	cmp cx, 7
	jge loop_hex_8
	
	mov al, dl
	shr al, 4
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10
	inc cx

loop_hex_8:	
	mov al, dl
	and al, 0xF
	
	add al, 0x30
	cmp al, 0x3A
	jge char_hex
	
	int 0x10

char_hex:
	add al, 7
	int 0x10
	inc cx
	jmp loop_hex

;----------------------------------¡

;----------------------------------¡    

;Variables
big_number dd 0x234589A

;Messages
welcome db "Welcome to monOS",0
option1 db "1-Show partition table",0
errorreading db "Error reading from disk",0
header db "Partition N          Status          Partition Type          Number of sectors"
    
;END NO TOCAR
times 0x800-($-$$) db 0
