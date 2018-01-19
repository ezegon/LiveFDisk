[BITS 16]
[ORG 0x7C00]

section .text
global menu

;----------------------------------!
;Main menu
menu:
    xor ax,ax
    mov al, 0x03
    int 0x10
    
    mov si, welcome
    call print_string
    
    mov si, option1
    call print_string

    jmp loop_menu

loop_menu:
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
    
read_sectors:
    mov bx, 0x01BE
    inc byte [partition_count] ;Update count
    cmp byte [partition_count], 5; Check if last partition
    mov si, [es:bx]
    call print_byte
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
	lodsb
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
    

;Variables
partition_count db 0
row db 0
column db 0

;Messages
welcome db "Welcome to monOS",0
option1 db "1-Show partition table",0
errorreading db "Error reading from disk",0
header db "Partition N          Status          Partition Type          Number of sectors"
    
;END NO TOCAR
times 510-($-$$) db 0
dw 0xAA55
