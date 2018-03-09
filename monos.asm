[BITS 16]


section .text
	global menu

;----------------------------------!
;Main menu
menu:
    mov sp, 0x8000
    xor ax,ax
    mov ss, ax

    mov si, welcome
    call print_string
    ;call read_char_from_string    

loop_menu:
    
    mov si, option1
    call print_string
	
	mov di, 0
	mov si, 0
	mov dl, 'A'
	call print_char_at_pos
	
	
    mov ah, 0x0
    int 0x16
    
    cmp al, 0x31
    je general
	
	cmp al, 0x32
	je clearscreen
    
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
	call partition_type
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
	call print_hex
    
step_done:
	push ax
	mov ah, 0x0E
	mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    pop ax
    jmp read_partition_table
    
partition_tables_done:
	push ax
	mov ah, 0x0E
	mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    pop ax
	jmp loop_menu

reading_error:
    mov si, errorreading
    call print_string
    jmp loop_menu

generic_end:
    popa
    ret

%include "mprint.asm"    
%include "msysid.asm"
%include "mvideo.asm"
;section .data
;Variables
	big_number dd 0x6432A

;Messages
	welcome db "Welcome to MonOS!!",0
	option1 db "1-Show partition table",0
	errorreading db "Error reading from disk",0
	header db "Partition N          Status          Partition Type          Number of sectors",0

;END NO TOCAR
times 0x800-($-$$) db 0
