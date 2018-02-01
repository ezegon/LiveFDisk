;~ SI must contain the value for the partition type

partition_type:
	pusha
	mov cx, si
	mov si, partition_types

loop_types:
	cmp cx, 0
	je print_partition_type
	dec cx

loop_types_word:
	lodsb
	cmp al, 0
	jne loop_types_word
	jmp loop_types
	
print_partition_type:
	call print_string
	popa
	ret

partition_types db "Unknown",0                   ;00
				db "DOS FAT12",0                 ;01
				db "XENIX root",0                ;02
				db "XENIX user",0                ;03
				db "DOS FAT16",0                 ;04
				db "DOS extended FAT16",0        ;05
				db "DOS FAT16B",0                ;06
				db "NTFS/HPFS/IFS/exFAT",0       ;07 <-
				db "FAT12/FAT16/qny",0           ;08 <---
				db "qnz/OS-9 RBF",0              ;09
				db "OS/2 Boot Manager",0         ;0A
				db "FAT32 CHS",0                 ;0B
				db "FAT32 LBA",0                 ;0C
				db "Silicon Safe",0              ;0D <---
				db "FAT16B LBA",0                ;0E
				db "extended FAT16 LBA",0        ;0F
				db "OPUS",0                      ;10 <--
				db "Hidden DOS FAT12",0          ;11 <-
				db "Configuration Partition",0   ;12
				db "?",0                         ;13
				db "Hidden FAT16",0              ;14
				db "Hidden extended FAT16",0     ;15
				db "Hidden FAT16B",0             ;16
				db "Hidden IFS",0                ;17
				db "AST SmartSleep",0            ;18
				db "Error",0                     ;19 (This partition type was reserved but never used)
				db "?",0                         ;1A
				db "Hidden FAT32",0              ;1B
				db "Hidden FAT32 LBA",0          ;1C
				db "?",0                         ;1D
				db "Hidden FAT16 LBA",0          ;1E
				db "extended FAT16 LBA",0        ;1F
				db "Windows Mobile Update",0     ;20
				db "FSo2",0                      ;21
				db "OEPT",0                      ;22
				db "Windows Mobile Boot",0       ;23
				db "Logical Sectored FAT12/16",0 ;24
				db "Windows Mobile IMGFS",0      ;25
				db "?",0                         ;26
				db "FAT32/NTFS",0                ;27
				db "",0  ;28
				db "",0  ;29
				db "",0  ;2A
				db "",0  ;2B
				db "",0  ;2C
				db "",0  ;2D
				db "",0  ;2E
				db "",0  ;2F
				db "",0  ;30
				db "",0  ;31
				db "",0  ;32
				db "",0  ;33
				db "",0  ;34
				db "",0  ;35
				db "",0  ;36
				db "",0  ;37
				db "",0  ;38
				db "",0  ;39
				db "",0  ;3A
				db "",0  ;3B
				db "",0  ;3C
				db "",0  ;3D
				db "",0  ;3E
				db "",0  ;3F
				db "",0  ;40
				db "",0  ;41
				db "",0  ;42
				db "",0  ;43
				db "",0  ;44
				db "",0  ;45
				db "",0  ;46
				db "",0  ;47
				db "",0  ;48
				db "",0  ;49
				db "",0  ;4A
				db "",0  ;4B
				db "",0  ;4C
				db "",0  ;4D
				db "",0  ;4E
				db "",0  ;4F
				db "",0  ;50
				db "",0  ;51
				db "",0  ;52
				db "",0  ;53
				db "",0  ;54
				db "",0  ;55
				db "",0  ;56
				db "",0  ;57
				db "",0  ;58
				db "",0  ;59
				db "",0  ;5A
				db "",0  ;5B
				db "",0  ;5C
				db "",0  ;5D
				db "",0  ;5E
				db "",0  ;5F
				db "",0  ;60
				db "",0  ;61
				db "",0  ;62
				db "UNIX",0  ;63
				db "",0  ;64
				db "",0  ;65
				db "",0  ;66
				db "",0  ;67
				db "",0  ;68
				db "",0  ;69
				db "",0  ;6A
				db "",0  ;6B
				db "",0  ;6C
				db "",0  ;6D
				db "",0  ;6E
				db "",0  ;6F
				db "",0  ;70
				db "",0  ;71
				db "",0  ;72
				db "",0  ;73
				db "",0  ;74
				db "",0  ;75
				db "",0  ;76
				db "",0  ;77
				db "",0  ;78
				db "",0  ;79
				db "",0  ;7A
				db "",0  ;7B
				db "",0  ;7C
				db "",0  ;7D
				db "",0  ;7E
				db "",0  ;7F
				db "",0  ;80
				db "",0  ;81
				db "",0  ;82
				db "LINUX",0  ;83
