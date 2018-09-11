[BITS 16]


section .text
	global menu

;----------------------------------!
;Main menu
menu:
    mov sp, 0x8000
    xor ax,ax
    mov ss, ax
    
    mov ah, 0x02
    xor bx,bx
    mov dh, 25
    mov dl, 80
    int 0x10
    
	call clearscreen
	
    mov di, welcome
    call print_string_at_pos
    call new_line_generic

loop_menu:
    
    mov di, option1
    call print_string_at_pos
    call new_line_generic
	
    mov di, option2
    call print_string_at_pos
    call new_line_generic
    
    mov ah, 0x00
    int 0x16; Get keystroke
    
    cmp al, 0x31; 1 in ASCII
    je opt_1
	
	cmp al, 0x32; 2 in ASCII
	je opt_2
    
    jmp loop_menu
    
opt_1:
    jmp general
    
opt_2:
    call clearscreen
    jmp loop_menu
    
;----------------------------------¡
;----------------------------------!

general:
    xor ax, ax ;Clear ax
    mov ah, 0x02 ;Read sectors
    mov al, 1 ;Read one sector

    xor cx, cx;Clear cx
    mov ch, 0 ;Cylinder 0
    mov cl, 1 ;First Sector

    xor dx, dx;Clear dx
    mov dh, 0 ;Head 0
    mov dl, 0x80 ;HDD #0

    xor bx, bx
    mov bx, 0x9000 ;Save buffer in 0x9000
    mov es, bx
    xor bx, bx ;Clear bx
    int 0x13 ;Drives interrupt
    jc reading_error
    
    ;~ mov ah, 0x03
    mov di, header
    call print_string_at_pos
    call new_line_generic
    mov bx, 0x01AE
        
read_partition_table:
	add bx, 0x10
    cmp bx, 0x01EE
	jg partition_tables_done
    
    mov [dummy], bx
    mov si, dummy
    mov cx, 4
    call print_hex

read_partition_status:
	movzx si, byte [es:bx]
    mov cx, 2
	call print_hex ;Should this be printed as Hex?
	
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
	call partition_type
    ;~ mov cx, 2
    ;~ call print_hex
	;~ call print_int
	
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

read_number_of_sectors:
	mov si, [es:bx+12]
	call print_int
    
step_done:
	call new_line_generic
    jmp read_partition_table
    
partition_tables_done:
	call new_line_generic
    jmp loop_menu

reading_error:
    mov di, errorreading
    call print_string_at_pos
    jmp loop_menu

generic_end:
    popa
    ret

%include "mprint.asm"    
%include "msysid.asm"
%include "mvideo.asm"
;section .data
;Variables
	cursor_x dw 0
	cursor_y dw	0
    quotient db 0
    
    int_digits db 0
    dummy db 0
    
;Messages
    canada db "Canada",0
	welcome db "Welcome to MonOS!!",0
	option1 db "1-Show partition table",0
	option2 db "2-Clear Screen",0
	errorreading db "Error reading from disk",0
	header db "Status - Fst Head - Fst Sector - Fst Cylinder - Partition type - N. Sectors",0

;END NO TOCAR
times 0x800-($-$$) db 0
