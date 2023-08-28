;----------------------------------------------------------------------------
; mCHOICE VER. 1.0 REV.07E781C0D2617                     (c)1994 by 'marikaz'
;----------------------------------------------------------------------------
; NOTES:
; mCHOICE moze zastapic CHOICE z MS-DOS 6 lub FreeDOS, dziala w MS-DOS 5.0.
; Funkcjonalnie identyczny z CHOICE z MS-DOS 6.22, FreeDOS 1.0+
;----------------------------------------------------------------------------

CHOICESLENGTH  EQU 7ah
ERRORFLAG      EQU -1

PRINTSTRING    MACRO str
               push ax
               mov dx,OFFSET str
               mov ah,9
               int 21h
               pop ax
               ENDM


code    SEGMENT PUBLIC 'code'
        ASSUME  cs:code

.386
ORG 100h
Main            PROC
                mov al,0ffh   ;czysc bufor na wszelki wypadek
                lea di,ccb
                mov cx,CHOICESLENGTH    ;dlugodc linii
                cld
                rep stosb

                mov ax,0          ;w ax kody bledow
                call GetCmdLine
                cmp statCMDL,1
                ja prnErrorMsg
                call SetupPrompt
                cmp statT,1
                jne waitForKey
                call DelayMode
                cmp ax,ERRORFLAG
                jne exit
                PRINTSTRING errDCMsg
                jmp exitNow

waitForKey:
                PRINTSTRING prompt
        getKey:
                mov ax,0c08h
                int 21h
                cmp al,3
                jne noCtrlC
                mov al,0
                jmp exitNow
       noCtrlC:

                call CheckChar
                cmp ax,ERRORFLAG
                je getKey
exit:
                PRINTSTRING defChar
exitNow:
                mov ah,4ch
                int 21h

prnErrorMsg:
                mov al,ERRORFLAG
                cmp statCMDL,2
                jne errTO
                PRINTSTRING errSwMsg
                jmp exitNow
         errTO:
                cmp statCMDL,3
                jne errPR
                PRINTSTRING errTOMsg
                jmp exitNow
         errPR:
                cmp statCMDL,4
                jne prnHL
                PRINTSTRING errPRMsg
                jmp exitNow
         prnHL:
                PRINTSTRING help
                jmp exitNow

;----------------------------------------------------------- SETUP PROMPT ---
SetupPrompt     PROC
                cmp statS,1
                je caseS
                mov si,OFFSET cChar
                mov di,si
        upCase:
                cmp BYTE PTR [si],-1
                je caseS
                lodsb
                cmp al,'a'       ;.
                jb skpUC         ;  tylko male litery na duze
                cmp al,'z'       ; .
                ja skpUC         ;.
                and al,11011111b
         skpUC:
                stosb
                jmp upCase
         caseS:
                mov si,OFFSET cChar
                mov di,prTail
                cmp statN,1
                je endPrompt      ;nie wyswietlaj prompt
                mov al,'['
                stosb
         setPr:
                cmp BYTE PTR [si],-1
                je endSetPr
                movsb
                mov al,','
                stosb
                jmp setPr
      endSetPr:
                dec di
                mov ax,'?]'
                stosw
    endPrompt:
                mov BYTE PTR [di],'$'
                ret
SetupPrompt     ENDP
;------------------------------------------------------------- CHECK CHAR ---
CheckChar       PROC
                cmp statS,1
                je skpUp     ;wazna wiekosc liter
                cmp al,'a'
                jb skpUp
                cmp al,'z'
                ja skpUp
                and al,11011111b
         skpUp:
                mov cx,CHOICESLENGTH
                lea di,cChar
                repne scasb
                cmp cx,0
                je noChar
                mov defChar,al
                mov ax,CHOICESLENGTH
                sub ax,cx
                mov defErrLvl,al
                ret
        noChar:
                mov ax,ERRORFLAG
                ret
CheckChar       ENDP
;------------------------------------------------------------- DELAY MODE ---
DelayMode       PROC
                mov al,defChar
                call CheckChar
                cmp ax,ERRORFLAG
                jne setTimer
                ret     ;ax=-1
      setTimer:
                PRINTSTRING prompt
                mov cx,delay
                or cx,cx
                jz CharFromCon ;nnn=0
                shl cx,3       ;x8 bo _wait "tyka" 8 razy na sek.
         _wait:
                push cx
                mov ah,86h
                mov cx,1
                mov dx,0e848h   ;1e848 = 1/8s
                int 15h
                pop cx
                call chkKey
                cmp ax,ERRORFLAG
                jne CharFromCon
                loop _wait
   CharFromCon:
                mov al,defErrLvl
                ret
DelayMode       ENDP
;---------------------------------------------------------------- CHK KEY ---
ChkKey          PROC
                push cx
                mov ah,0bh
                int 21h
                or al,al
                jnz gotKey
                mov ax,ERRORFLAG
                pop cx
                ret
        gotKey:
                mov ah,8
                int 21h
                cmp al,3
                jne nGK
                mov al,0
                jmp exitNow
          nGK:
                call CheckChar
                pop cx
                ret
ChkKey          ENDP

                INCLUDE gcmdl2.asm
;---------------------------------------------------------------------------
statCMDL  DB 0
statC     DB 0
statN     DB 0
statS     DB 0
statT     DB 0
statTxt   DB 0

defChar   DB ?,13,10,'$'
defErrLvl DB ?
fctr      DW 100,10,1
prTail    DW OFFSET prompt
delay     DW 0

Main            ENDP
             INCLUDE msg.inc
cChar        DB 'yn' ;domyslny zestaw
ccb          DB CHOICESLENGTH DUP (?)
prompt       LABEL BYTE
code ENDS
     END Main
