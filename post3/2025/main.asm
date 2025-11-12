DATAS SEGMENT
	BUFFER DB 10,0,10 DUP(0)     ;最多输入10个字符
    COUNT  DB 0                    ; 记录 'a' 出现次数
    MSG1   DB 'enter:$'
    MSG2   DB 0DH,0AH,'return: $'
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
    MOV DX, OFFSET MSG1
    MOV AH, 09H
    INT 21H
    ; 从键盘输入字符串 (DOS 0Ah)缓冲式键盘输入，DX指向缓冲区
    MOV DX, OFFSET BUFFER
    MOV AH, 0AH
    INT 21H
    ; 初始化
    ;BUFFER偏移量+0为最大可输入字符，+1为实际输入字符，+2为输入的第一个字符。。。
    MOV CL, BUFFER[1]   ; 实际输入字符个数
    MOV SI, OFFSET BUFFER + 2 ; 指向输入内容
    MOV COUNT,0
CHECK_LOOP:
    CMP CL, 0
    JE SHOW_RESULT       ; 若扫描完则结束
    MOV AL, [SI]         ; 取当前字符
    CMP AL, 'a'
    JNE NEXT_CHAR
    INC COUNT            ; 若等于 'a'，计数加1
NEXT_CHAR:
    INC SI	;偏移量+1，指向下一个字符
    DEC CL	;CL-1，要处理的字符数减1
    JMP CHECK_LOOP
; 显示结果
SHOW_RESULT:
    MOV DX,OFFSET MSG2
    MOV AH,09H
    INT 21H
    ; COUNT 是数字，把它转成 ASCII 并显示
    MOV AL,COUNT
    ADD AL,30H          ; 转成字符
    MOV DL,AL
    MOV AH,02H
    INT 21H

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

