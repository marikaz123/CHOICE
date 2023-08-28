;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+ GetCMDLine:PROC * rev. C * Part of CHOICE ver. 1.0                       +
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; No parametrs                                                (ret = 0)
; Parametrs without errors                                    (ret = 1)
; Invalid switch on command line.                             (ret = 2)
; Incorrect timeout syntax.                                   (ret = 3)
; Only one prompt string allowed.                             (ret = 4)
; Timeout default not in specified (or default) choices.      (in main)
; Help - switch /?                                            (ret = 6)
;----------------------------------------------------------------------------

GetCmdLine      PROC
                mov si,80h
                cmp BYTE PTR [si],1
                jb endParametrs
                inc si
getSwitches:
                lodsb
                cmp al,20h
                je getSwitches
                cmp al,9
                je getSwitches
                cmp al,0dh
                je endParametrs
                cmp al,'/'
                je switch
                jmp text
switch:
                cmp BYTE PTR [si-2],20h
                je goSW
                cmp BYTE PTR [si-2],9
                je goSW                 ;maja byc odstepy miedzy opcjami
                mov statCMDL,2
                jmp endParametrs
          goSW:
                mov statCMDL,1
                lodsb
                cmp al,'?'
                je switchQ
                or al,100000b
                cmp al,'n'
                je switchN
                cmp al,'s'
                je switchS
                cmp al,'c'
                je switchC
                cmp al,'t'
                je switchT
                mov statCMDL,2
                jmp endParametrs
switchQ:
                mov statCMDL,6
                je endParametrs
switchN:
                mov statN,1
                cmp BYTE PTR [si],20h
                je  getSwitches
                cmp BYTE PTR [si],9
                je  getSwitches
                cmp BYTE PTR [si],0dh
                je  getSwitches
                mov statCMDL,2
                jmp endParametrs
switchS:
                mov statS,1
                cmp BYTE PTR [si],20h
                je  getSwitches
                cmp BYTE PTR [si],9
                je  getSwitches
                cmp BYTE PTR [si],0dh
                je  getSwitches
                mov statCMDL,2
                jmp endParametrs
switchC:
                cmp statC,1
                je errSwC
                mov statC,1
                lea di,cChar      ;wsk na litery
                call GetSwCParam
                cmp ax,ERRORFLAG
                jne getSwitches
        errSwC:
                mov statCMDL,2
                jmp endParametrs
switchT:
                cmp statT,1
                je errSwT
                mov statT,1
                call GetSwTParam
                cmp ax,ERRORFLAG
                jne getSwitches
        errSwT:
                mov statCMDL,3
                jmp endParametrs
;--------------------------------------------------------------/ OBSLUGA /---
text:
                cmp statTxt,1
                je errTxt
                mov statTxt,1
                mov statCMDL,1
                dec si          ;korekta, do procedury od 1 litery
                lea di,prompt
                call GetPrompt
                cmp ax,ERRORFLAG
                jne getSwitches
                mov statCMDL,2   ;blad ogolny cmdl
                jmp endParametrs
        errTxt:
                mov statCMDL,4    ;blad przelacznika /t
endParametrs:
                ret
GetCmdLine      ENDP
;------------------------------------------------------------- Get Prompt ---
GetPrompt       PROC
                cmp al,'"'
                jne getPR
                inc si
                jmp quota
        getPR:
                lodsb
                cmp al,0dh
                je endGP
                cmp al,'/'
                je chkGP
                cmp al,'"'
                je errQ
                stosb
                jmp getPR
         chkGP:
                cmp BYTE PTR [si-2],20h
                je endGP
                cmp BYTE PTR [si-2],9
                je endGP
                jmp errQ
         endGP:
                cmp BYTE PTR [di-1],20h
                je egp
                cmp BYTE PTR [di-1],9
                je egp
                mov BYTE PTR [di],20h
                inc di
           egp:
                mov prTail,di
                dec si
                ret
quota:
                lodsb
                cmp al,'"'
                je endQstr
                cmp al,0dh
                je errQ
                stosb
                jmp quota
       endQstr:
                mov prTail,di
                ret
          errQ:
                mov ax,ERRORFLAG
                ret
GetPrompt       ENDP
;------------------------------------------------------------ GetSwCParam ---
GetSwCParam     PROC
                mov cx,CHOICESLENGTH
                cmp BYTE PTR [si],':'
                jne getChoices
                inc si
    getChoices:
                lodsb
                cmp al,0dh
                je endGC
                cmp al,20h
                je endGC
                cmp al,9
                je endGC
                cmp al,'/' ;(1508) FreeDOS douszcza, MS-DOS nie...
                je errGC
                stosb
                loop getChoices
         errGC:
                mov ax,ERRORFLAG
                ret
         endGC:
                mov BYTE PTR [di],-1
                dec si
                ret
GetSwCParam     ENDP
;------------------------------------------------------------ GetSwTParam ---
GetSwTParam     PROC
                cmp BYTE PTR [si],':'
                jne getDCh
                inc si
        getDCh:
                lodsb
                mov defChar,al
                cmp BYTE PTR [si],','
                jne errGS
                inc si

                mov cx,3        ;max ilosc cyfr
                lea bx,[fctr+4]
                xor ax,ax
                xor dx,dx
    getSeconds:
                lodsb
                cmp al,20h
                je endGS
                cmp al,9
                je endGS
                cmp al,0dh
                je endGS
                cmp al,'0'
                jb errGS
                cmp al,'9'
                ja errGS
                sub al,'0'
                push ax
                loop getSeconds
                lodsb
                cmp al,20h
                je endGS
                cmp al,9
                je endGS
                cmp al,0dh
                jne errGS
         endGS:
                cmp cx,3
                je errGS
                neg cx
                add cx,3
          cnvA:
                pop ax
                mul WORD PTR [bx]
                add delay,ax
                sub bx,2
                loop cnvA
                dec si
                ret
         errGS:
                neg cx
                add cx,3
                shl cx,1
                add sp,cx
                dec si
                mov ax,ERRORFLAG
                ret
GetSwTParam     ENDP
