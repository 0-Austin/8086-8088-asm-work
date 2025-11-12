DATAS SEGMENT
	x      DB 25H
    y      DB 28H
    z      DB 27H
    media  DB 00H
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    MOV AL, x
    CMP AL, y
    JL  X_LE_Y       ; 若 x < y，跳到 X_LE_Y
    JMP Y_LE_X       ; 否则 y < x,跳到 Y_LE_X
;情况1:x < y
X_LE_Y:
	MOV AL,y
    CMP AL,z
    JL  Y_LE_Z       ; 若 y < z → x < y < z → media = y
    MOV AL,x
    CMP AL,z
    JL  X_LE_Z       ; 若 x < z < y → media = z
    ; 否则 z < x < y → media = x
    MOV AL,x
    MOV media,AL
    JMP ENDING
Y_LE_Z:
    MOV AL, y        ; x < y < z
    MOV media, AL
    JMP ENDING
X_LE_Z:
    MOV AL, z        ; x < z < y
    MOV media, AL
    JMP ENDING
; 情况2:y < x
Y_LE_X:
	MOV AL,x
    CMP AL,z
    JL  X_LE_Z2      ; 若 x < z → y < x < z → media = x
    MOV AL,y
    CMP AL,z
    JL  Y_LE_Z2      ; 若 y < z < x → media = z
    ; 否则 z < y < x → media = y
    MOV AL,y
    MOV media, AL
    JMP ENDING
X_LE_Z2:
    MOV AL,x        ; y < x < z
    MOV media,AL
    JMP ENDING
Y_LE_Z2:
    MOV AL,z        ; y < z < x
    MOV media,AL
    JMP ENDING
ENDING:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
