;~ SI must contain the value for the partition type

partition_type:
	pusha
	xor cx, cx
	xor dx, dx
	xor bx, bx
	mov dx, si
	mov si, partition_types
	
partition_type_tag:
	lodsb
	cmp al, dl ;Compares the partition type with the tag of the stored values
	je print_partition_type
	cmp cx, [n_types] ;We check if we have already compared with all the stored values
	je unknown_type
	inc cx

partition_type_loop: ;Cycle until this partition type ends since it isn't the right type
	lodsb ;Load next charecter within type
	cmp al, 0 ;See if it's the last
	jne partition_type_loop ;If it isn't we keep going
	jmp partition_type_tag ;Then we succesfuly skiped the type

unknown_type:
	mov si, unknown
	
print_partition_type:
	;~ lodsb
	;~ cmp al,0
	;~ je partition_type_done
	;~ mov ah, 0x0E
	;~ int 0x10
	;~ jmp print_partition_type

    mov di, si
    call print_string_at_pos
	
partition_type_done:
	call increase_cursor_pos
    popa
	ret

partition_types db 0x00,"Empty",0
				db 0x01,"FAT12,CHS",0
				db 0x04,"FAT16 16-32MB,CHS",0
				db 0x05,"Microsoft Extended",0
				db 0x06,"FAT16 32MB,CHS",0
				db 0x07,"NTFS",0
				db 0x0b,"FAT32,CHS",0
				db 0x0c,"FAT32,LBA",0
				db 0x0e,"FAT16, 32MB-2GB,LBA",0
				db 0x0f,"Microsoft Extended, LBA",0
				db 0x11,"Hidden FAT12,CHS",0
				db 0x14,"Hidden FAT16,16-32MB,CHS",0
				db 0x16,"Hidden FAT16,32MB-2GB,CHS",0
				db 0x18,"AST SmartSleep Partition",0
				db 0x1b,"Hidden FAT32,CHS",0
				db 0x1c,"Hidden FAT32,LBA",0
				db 0x1e,"Hidden FAT16,32MB-2GB,LBA",0
				db 0x27,"PQservice",0
				db 0x39,"Plan 9 partition",0
				db 0x3c,"PartitionMagic recovery partition",0
				db 0x42,"Microsoft MBR,Dynamic Disk",0
				db 0x44,"GoBack partition",0
				db 0x51,"Novell",0
				db 0x52,"CP/M",0
				db 0x63,"Unix System V",0
				db 0x64,"PC-ARMOUR protected partition",0
				db 0x82,"Solaris x86 or Linux Swap",0
				db 0x83,"Linux",0
				db 0x84,"Hibernation",0
				db 0x85,"Linux Extended",0
				db 0x86,"NTFS Volume Set",0
				db 0x87,"NTFS Volume Set",0
				db 0x9f,"BSD/OS",0
				db 0xa0,"Hibernation",0
				db 0xa1,"Hibernation",0
				db 0xa5,"FreeBSD",0
				db 0xa6,"OpenBSD",0
				db 0xa8,"Mac OSX",0
				db 0xa9,"NetBSD",0
				db 0xab,"Mac OSX Boot",0
				db 0xaf,"MacOS X HFS",0
				db 0xb7,"BSDI",0
				db 0xb8,"BSDI Swap",0
				db 0xbb,"Boot Wizard hidden",0
				db 0xbe,"Solaris 8 boot partition",0
				db 0xd8,"CP/M-86",0
				db 0xde,"Dell PowerEdge Server utilities (FAT fs)",0
				db 0xdf,"DG/UX virtual disk manager partition",0
				db 0xeb,"BeOS BFS",0
				db 0xee,"EFI GPT Disk",0
				db 0xef,"EFI System Parition",0
				db 0xfb,"VMWare File System",0
				db 0xfc,"VMWare Swap",0 ;52 starting @ 0
				
n_types db 52
				
unknown	db "Unkown",0
