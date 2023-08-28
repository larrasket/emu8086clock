include 'emu8086.inc'

ORG    100h

.DATA
 VAR1 DB 7
 VAR2 DB ?
 WEEK DW 0
 msg1   DB  'Enter the number of the day of the week', 13, 10 , 13, 10 , '1 for Saturday', 13, 10 , '2 for Sunday', 13, 10 , '3 for Monday', 13, 10 , '4 for Tuesday', 13, 10 , '5 for Wednesday', 13, 10 , '6 for Thursday', 13, 10, '7 for Friday', 13, 10, 0


 DAY DW 0
 DAYMSG   DB  13, 10, 'Enter the the day', 13, 10 , 0
 MONTH DW 0
 MONTHMSG   DB  13, 10, 'Enter the month', 13, 10 , 0
 YEAR DW 0
 YEARMSG   DB  13, 10, 'Enter the year', 13, 10 , 0
 HOUR DW 0
 HOURMSG   DB  13,10, 'Enter the hour', 13, 10 , 0
 MINUTE DW 0
 MINMSG   DB  13,10, 'Enter the minute', 13, 10 , 0
 SECOND DW 0
 SECMSG   DB  13,10, 'Enter the seconds', 13, 10 , 0
 DASH   DB  '  ',  0
 YDASH   DB  '    ',  0


 DAY_1 DB 'Sat'    ,0
 DAY_2 DB 'Sun'      ,0
 DAY_3 DB 'Mon'      ,0
 DAY_4 DB 'Tue'     ,0
 DAY_5 DB 'Wed'   ,0
 DAY_6 DB 'Thu'    ,0
 DAY_7 DB 'Fri'     ,0



.CODE

    MOV AX, @DATA
    MOV DS, AX

    LEA    SI, msg1
    CALL   print_string

    ;; scan data
    CALL   scan_num

    MOV WEEK, CX


    LEA    SI, DAYMSG
    CALL   print_string
    CALL   scan_num
    MOV DAY, CX

    LEA    SI, MONTHMSG
    CALL   print_string
    CALL   scan_num
    MOV MONTH, CX

    LEA    SI, YEARMSG
    CALL   print_string
    CALL   scan_num
    MOV YEAR, CX




    MOV    AX, YEAR
    CALL   print_num

    ;; LEA DX,YEAR
    ;; MOV AH,09H
    ;; INT 21H

    LEA    SI, HOURMSG
    CALL   print_string
    CALL   scan_num
    MOV HOUR, CX

    LEA    SI, MINMSG
    CALL   print_string
    CALL   scan_num
    MOV MINUTE, CX

    ;; LEA    SI, SECMSG
    ;; CALL   print_string
    ;; CALL   scan_num
    ;; MOV SECOND, CX



    ;; end scan data

    CURSORON

    ;; print

    ;; hours
    GOTOXY 2, 20
    MOV AX, HOUR
    CALL PRINT_NUM

    ;; symbol
    GOTOXY 5, 20
    mov dl,':'
    mov ah,2
    int 21h

    ;; mintues
    GOTOXY 8, 20
    MOV AX, MINUTE
    CALL PRINT_NUM

    ;; symbol
    GOTOXY 11, 20
    mov dl,':'
    mov ah,2
    int 21h

    ;; seconds
    GOTOXY 14, 20
    MOV AX, SECOND
    CALL PRINT_NUM


    ;; years
    GOTOXY 2, 22
    MOV AX, YEAR
    CALL PRINT_NUM

    ;; symbol
    GOTOXY 8, 22
    mov dl,'/'
    mov ah,2
    int 21h

    ;; month
    GOTOXY 14, 22
    MOV AX, MONTH
    CALL PRINT_NUM

    ;; symbol
    GOTOXY 20, 22
    mov dl,'/'
    mov ah,2
    int 21h


    ;; day
    GOTOXY 26, 22
    MOV AX, DAY
    CALL PRINT_NUM


    ;; day of the week

    CALL SetWeeK
    GOTOXY 2, 23
    CALL PRINT_STRING

    ;; RET


    ;; updates

usec:
    ;; Set 1 million microseconds interval (1 second) By using below instruction



    ;; seconds
    GOTOXY 14, 20
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 14, 20
    MOV AX, SECOND
    CALL PRINT_NUM

    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H


    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H


    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H


    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H


    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H

    ADD SECOND, 5
    CMP SECOND, 60
    JE umen
    JG umen
    JMP usec
    ;; TODO PRINT
umen:


    MOV SECOND, 0
    ADD MINUTE, 1
    CMP MINUTE, 60
    JE uhour

    ;; mintues
    GOTOXY 8, 20
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 8, 20
    MOV AX, MINUTE
    CALL PRINT_NUM

    JMP usec
    ;; TODO PRINT

uhour:


    ;; mintues
    GOTOXY 8, 20
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 8, 20
    MOV MINUTE, 0
    MOV AX, MINUTE
    CALL PRINT_NUM


    MOV MINUTE, 0
    ADD HOUR, 1
    CMP HOUR, 24

    JE zhour
    JG zhour
    JMP hoursecond
zhour:
    MOV HOUR, 0
    GOTOXY 2, 20
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 2, 20
    MOV AX, HOUR
    CALL PRINT_NUM
    JMP uweek

hoursecond:
    GOTOXY 2, 20
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 2, 20
    MOV AX, HOUR
    CALL PRINT_NUM
    JMP usec

uweek:
    ADD WEEK, 1
    CMP WEEK, 8
    JE FIXWEEK
    JMP uday
FIXWEEK:
    MOV WEEK, 1
    JMP uday
uday:

    CALL SetWeeK
    GOTOXY 2, 23
    CALL PRINT_STRING

    ADD day,1
    CMP day, 31
    JE umonth
    JG umonth


    GOTOXY 26, 22
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 26, 22
    MOV AX, DAY
    CALL PRINT_NUM

    JMP usec

umonth:
    MOV DAY, 1

    GOTOXY 26, 22
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 26, 22
    MOV AX, DAY
    CALL PRINT_NUM

    ADD MONTH, 1
    CMP MONTH, 13
    JE uyear

    GOTOXY 14, 22
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 14, 22
    MOV AX, MONTH
    CALL PRINT_NUM

    JMP usec
uyear:
    MOV MONTH, 1

    GOTOXY 14, 22
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 14, 22
    MOV AX, MONTH
    CALL PRINT_NUM

    ADD YEAR, 1

    GOTOXY 2, 22
    LEA SI, DASH
    CALL PRINT_STRING
    GOTOXY 2, 22
    MOV AX, YEAR
    CALL PRINT_NUM

    JE usec


    SetWeek     PROC



    CMP WEEK, 1
    JE equal1

    CMP WEEK, 2
    JE equal2


    CMP WEEK, 3
    JE equal3


    CMP WEEK, 4
    JE equal4


    CMP WEEK, 5
    JE equal5


    CMP WEEK, 6
    JE equal6


    CMP WEEK, 7
    JE equal7

equal1:
    LEA SI, DAY_1
    JMP stopSetWeek

equal2:
    LEA SI, DAY_2
    JMP stopSetWeek
equal3:
    LEA SI, DAY_3
    JMP stopSetWeek
equal4:
    LEA SI, DAY_4
    JMP stopSetWeek
equal5:
    LEA SI, DAY_5
    JMP stopSetWeek
equal6:
    LEA SI, DAY_6
    JMP stopSetWeek
equal7:
    LEA SI, DAY_7
    JMP stopSetWeek

stopSetWeek:
RET
SetWeek     ENDP






DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS

END                   ; directive to stopSetWeek the compiler.
