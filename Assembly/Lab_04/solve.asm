PUBLIC REPLACE_SPACE
PUBLIC MATRIX_PROCESS
PUBLIC MAX

EXTRN MAT: BYTE
EXTRN ROW_NUM: BYTE
EXTRN COL_NUM: BYTE
EXTRN COL_INDEX: BYTE
EXTRN OUTPUT_SYM: NEAR

DATAS SEGMENT WORD PUBLIC 'DATA'
	COUNT db 0
	MAX db 0
DATAS ENDS

CODES SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CODES, DS:DATAS
	
REPLACE_SPACE:
	
	XOR BX, BX; Bx = 0000 BX= 0A1d (0A1D xor 0A1D = 0000)
	mov BL, COL_INDEX
	XOR DX, DX
	MOV DL, COL_NUM
	mov SI, BX
	
	xor CX, CX
	mov CL, ROW_NUM
	REPLACE_LOOP:
		mov MAT[SI], '-'
		ADD SI, DX
		LOOP REPLACE_LOOP
	END_REPLACE_LOOP:
	
	ret

FIND_COL:

	XOR DI, DI
	xor BX, BX
	mov bl, COL_NUM
	xor DX, DX
	mov DL, ROW_NUM
	
	COL_LOOP:
		cmp DI, BX
		je END_COL_LOOP
		
		mov COUNT, 0
		
		;xor CX, CX
		mov CX, DX
		mov SI, DI

		ROW_LOOP:
			cmp MAT[SI], 'A'
			jnge END_IF
			cmp MAT[SI], 'Z'
			jnle END_IF
			THEN:
			add COUNT, 1
			END_IF:
			add SI, BX
			LOOP ROW_LOOP
		END_ROW_LOOP:
		;*
		mov AL, COUNT
		cmp MAX, AL
		jge END_UPDATE 
		UPDATE:
		mov MAX, AL
		MOV AX, DI
		MOV COL_INDEX, AL
		END_UPDATE:
		add DI, 1
		LOOP COL_LOOP
	END_COL_LOOP:
	
	ret

MATRIX_PROCESS:
	call FIND_COL
	call REPLACE_SPACE
	ret

;END_MATRIX_PROCESS:

CODES ENDS

END