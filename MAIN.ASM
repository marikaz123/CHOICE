;---------------------------------------------------------------------------
;  mCHOICE v1.3    /marikaz/
;---------------------------------------------------------------------------
; mCHOICE czeka az uzytkownik wybierze jeden znak z zestawu znakow do
; wyboru. Pozycja znaku w tym zestawie jest jednoczesnie wartoscia
; errorlevel zwracana do systemu.
; mCHOICE zastepuje CHOICE z systemu MS-DOS. Funkcjonalnie jest identyczny.
; Dodatkowo:
; Zdefiniowanie znaku '_' pozwala uzyc SPACE, a znaku '*' ENTER.
;
; Waits for the user to choose one of a set of choices.
; MS-DOS 'CHOICE' replacement.
; ERRORLEVEL is set to offset of key user presses in choices.
;
; ICHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nn] [text]
;---------------------------------------------------------------------------

CFL RECORD x:1,c:1,n:1,s:1,t:1

RTC  = 46Ch
QSPC = '_' ;znak dla spacji
QENT = '*' ;dla entera

        .MODEL TINY
        .CODE

JUMPS
ORG 100h

Main    PROC
        mov ax,3000h
        int 21h
        or al,al
        jnz begin
        mov si,OFFSET errE
        call PrnStr
        ret
begin:
        call GetParam
        or ax,ax
        jnz svMsgs
        mov di,OFFSET choices ;nie zmienia sie w prog.
        test fl,MASK s ;nie ma /s -tylko duze litery
        jnz chkTc
        mov cx,WORD PTR [lcho]
        mov si,di
toup:
        cmp BYTE PTR [si],'a'
        jb skup
        cmp BYTE PTR [si],'z'
        ja skup
        and BYTE PTR [si],NOT 20h
skup:
        inc si
        loop toup
        ;jeszcze dla /t
        cmp tchr,'a'
        jb chkTc
        cmp tchr,'z'
        ja chkTc
        and tchr,NOT 20h
chkTc:  ;czy /t:c ok?
        test fl,MASK t
        jz ifPrmt
        mov al,tchr
        call FindChar
        mov al,0ch
        jc svMsgs
        mov tel,bl
ifPrmt: ;czy prompt?
        test fl,MASK x
        jz ifChoi
        mov si,OFFSET prompt
        call PrnStr
ifChoi: ;czy choices
        test fl,MASK n
        jnz ifTimo
        mov si,di
        mov cx,WORD PTR [lcho]

        mov ah,6
        mov dl,'['
        int 21h
schoi:
        lodsb
        mov dl,al
        int 21h
        mov dl,','
        int 21h
        loop schoi
        mov dl,8
        int 21h
        mov dl,']'
        int 21h
        mov dl,'?'
        int 21h

ifTimo:
        test fl,MASK t
        jz gKey ; /t nie ma

        mov cx,WORD PTR [tDly]
        or cx,cx
        jz _dch    ;pisz domysly znak
        xor ax,ax
        mov es,ax ;BIOS
oloop:
        push cx    ;
        mov cx,18  ; 1s ~18*(RTC tick)
iloop:
        mov bp,es:[RTC]

gKey:
        mov ah,6  ;stdio
        mov dl,-1
        int 21h
        ;dla al=0 musi dzialac petla bo ew. timer
        cmp al,3 ;ctrl+c ?
        jne _nx1
        mov al,0  ;errlvl = 0
        pop cx
        jmp exit
_nx1:
        ;--- enter i spacja ---
        cmp al,0dh
        jne _spc2
        mov al,QENT
        jmp _ncs
_spc2:
        cmp al,20h
        jne _nspc
        mov al,QSPC
        jmp _ncs
_nspc:
        test fl,MASK s
        jnz _ncs
        cmp al,'a'
        jb _ncs
        cmp al,'z'
        ja _ncs
        and al,NOT 20h
_ncs:
        call FindChar
        jnc _chf
         IFDEF BEEP
          or al,al ;  proteza..caly czas dziala petla
          jz skip  ; '
          mov al,6
          mov dl,7
          int 21h
          skip:
         ENDIF
        test fl,MASK t
        jz gKey

        cmp bp,es:[RTC]
        je gKey
        loop iloop
        pop cx
        loop oloop
_dch:   ;koniec czasu dla /t domyslny klawisz
        mov al,tchr
        mov bl,tel
_chf:
        mov ah,6
        mov dl,al
        int 21h
        mov al,bl

exit:
        push ax
        mov ah,6
        mov dl,0dh
        int 21h
        mov dl,0ah
        int 21h
        pop ax
        mov ah,4ch
        int 21h

svMsgs:
        mov si,OFFSET prog
        call PrnStr
        mov bx,ax
        mov si,[msgPtrs+bx]
        call PrnStr
        cmp bx,2
        jne cff
        mov si,OFFSET cont
        call PrnStr
        jmp elvl
cff:
        cmp bx,4
        je pff
        cmp bx,8
        je pff
        jmp elvl
pff:
        mov si,OFFSET form
        call PrnStr
elvl:
        mov al,-1
        jmp exit
Main    ENDP

PrnStr PROC
       LOCALS
       push ax
       mov ah,6
  @@l:
       lodsb
       or al,al
       jz @@x
       mov dl,al
       int 21h
       jmp @@l
  @@x:
       pop ax
       ret
PrnStr ENDP

FindChar PROC
         LOCALS
; we:  al=kod znaku do znalezienia
; wy:  bl=pozycja znaku w ciagu (errorlenel)
;blad: cy=znaku nie ma w stringu
         push cx di es
         mov dx,ds
         mov es,dx
         mov cx,WORD PTR [lcho]
         mov bx,cx
   @@lp:
         repne scasb
         jnz @@nf
         sub bx,cx
         jmp @@rn
   @@nf:
         stc
   @@rn:
         pop es di cx
         ret
FindChar ENDP

INCLUDE gcmdl2.asm

msgPtrs DW ?,err2,err4,err6,err8,errA,errC
fl   CFL <0,0,0,0,0>
lcho DB 2,0
tdly DB 0,0
tchr DB 0
tel  DB ?

INCLUDE msg.inc

choices DB 'yn',30 DUP (?)
prompt  DB 128 DUP (?)

        END Main
