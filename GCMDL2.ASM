; GetParam:PROC - rev. B :: iCHOICE :: 1994 'marikaz'
;
;parse line:
; [/c[:]choices] [/n] [/s] [/t:c,nn] [text]
;
;Arguments without errors                                 (ret 0)
;Help [/?]                                                (ret 2)
;Invalid switch on command line.                          (ret 4)
;Incorrect timeout syntax.                                (ret 6)
;Only one prompt string allowed.                          (ret 8)
;Invalid choice switch syntax.                           (ret 10)
;Timeout default not in specified (or default) choices. (in main)
;-----------------------------------------------------------------

;QUO = 27h
QUO = 22h

GetParam PROC
         LOCALS
         mov si,80h
         or BYTE PTR [si],0
         je @@eop0
         inc si
gpar:
         cmp BYTE PTR [si],20h
         je gpar-1
         cmp BYTE PTR [si],9
         je gpar-1
         cmp BYTE PTR [si],0dh
         je @@eop0        ; ---> jedyne wyjscie bez bledu
         cmp BYTE PTR [si],'/'
         je switch
         cmp BYTE PTR [si],20h
         jl @@eop4        ;czyli poza podst. ASCII

prmpt:   ;-----------------------------------------------------/ PROMPT /---
         test [fl],MASK x
         jnz @@eop8
         or [fl],MASK x
         mov cx,LENGTH prompt
         lea di,prompt
         xor ax,ax
         lodsb
         cmp al,QUO
         je getpq
         dec si ;wyrownaj param
getp:
         lodsb
         cmp al,20h
         jb eotx
         cmp al,'/'
         jne @@cq
         cmp BYTE PTR [si-2],20h
         jbe eqsi ;i do parametrow
         jmp @@eop4
   @@cq:
         cmp al,QUO
         je @@eop8
         stosb
         loop getp
         jmp @@eop4
eqsi:
         dec si ;nizej jeszcze raz, wszystko oK
eotx:
         dec si
         mov BYTE PTR [di],0
         jmp gpar

;-----------------------------------------
getpq:
         lodsb
         cmp al,QUO ;! tu tylko zamykajacy
         jne noq
         cmp BYTE PTR [si],20h
         ja @@eop8
         mov BYTE PTR [di],0
         jmp gpar
  noq:
         stosb
         loop getpq
         jmp @@eop8

switch:
         inc si ;za '/'
         lodsb
         cmp al,'?'
         je @@eop2
         or al,20h
         cmp al,'c'
         je caseC
         cmp al,'n'
         je caseN
         cmp al,'s'
         je caseS
         cmp al,'t'
         je caseT
         jmp @@eop4
caseC: ;-/ choices /--------------------------------------------/ C /---
         test fl,MASK c
         jnz @@eop4
         or fl,MASK c
         mov di,OFFSET choices
         cmp BYTE PTR [si],':'
         jne @@c
         inc si
    @@c:
         cmp BYTE PTR [si],20h ; samo '/c[:]' bedzie traktowane
         jna gpar              ; jak '/c[:]yn'
         mov cx,32
gchoi:
         cmp BYTE PTR [si],20h
         ja @@ned
         neg cx
         add cx,32
         mov WORD PTR [lcho],cx ;ilosc znakow
         jmp gpar
  @@ned:
         cmp BYTE PTR [si],'/'
         je @@eop10
         cmp BYTE PTR [si],'~' ;jako koniec prawidlowych znakow
         ja @@eop10
         movsb
         loop gchoi
         jmp @@eop10
caseN: ;-do not display choices----------------------------------/ N /-----
         test fl,MASK n
         jnz @@eop4
         or fl,MASK n
         cmp BYTE PTR [si],20h
         ja @@eop4
         jmp gpar
caseS: ;-case sensitive------------------------------------------/ S /-----
         test fl,MASK s
         jnz @@eop4
         or fl,MASK s
         cmp BYTE PTR [si],20h
         ja @@eop4
         jmp gpar
caseT: ;-timer---------------------------------------------------/ T /-----
         test fl,MASK t
         jnz @@eop4
         or fl,MASK t
         cmp BYTE PTR [si],':'
         jne @@t0
         inc si
   @@t0:
         lodsb
         cmp al,20h
         jna @@eop6
         mov tchr,al
         lodsb
         cmp al,',' ;obowiazkowy
         jne @@eop6
         ;----------------------
         lodsw
         cmp al,'0'
         jb @@eop6
         cmp al,'9'
         ja @@eop6
         cmp ah,20h ; jesli ah<=20h to jedna cyfra
         jbe @@sd   ;
         cmp ah,'0'
         jb @@eop6
         cmp ah,'9'
         ja @@eop6
         sub ax,3030h
         mov bl,10
         mov bh,ah
         mul bl
         add al,bh
   @@wr:
         mov tdly,al
         cmp BYTE PTR [si],20h
         ja @@eop6
         jmp gpar
   @@sd:
         dec si ;korekta poz.
         sub al,30h
         jmp @@wr

@@eop0:
         mov ax,0
         ret
@@eop2:
         mov ax,2
         ret
@@eop4:
         mov ax,4
         ret
@@eop6:
         mov ax,6
         ret
@@eop8:
         mov ax,8
         ret
@@eop10:
         mov ax,10
         ret
         ENDP
