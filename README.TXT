-----------------------------------------------------------------------------
 mCHOICE ver. 1.0                                           (c)1994 'marikaz'
-----------------------------------------------------------------------------

 mCHOICE moze zastapic CHOICE wystepujace w MS-DOS lub FreeDOS, dziala
 poprawnie w MS-DOS 5.0.
 Powstal.. z blizej nieokreslonych powodow. No ale byl na odkurzonej
 dyskietce i w ramach hobby zostal troche poprawiony i wyladowal tu.

        CECHY

 - Zastosowano skladnie z MS-DOS 6.22:
     mCHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nnn] [text | "text"]
 - Kompatybilny i przetestowany na maszynach wirtualnych z MS-DOS 5.0,
   MS-DOS 6.22, FreeDOS 1.3 (poza ctrl-c)
 - dziala identycznie jak CHOICE z MS-DOS 6.22 oraz FreeDOS, patrz UWAGA.
   Dlatego dokumentacja CHOICE MS-DOS 6.22 jest literalnie zgodna z mCHOICE.
   (W MS-DOS parametr nn = 99, w mCHOICE jest nnn = 999)


        UWAGI

 - Parametr "/t:c,nn"
   cyt. dokumentacja MS-DOS 6.22:
   | nn - Specifies the number of seconds to pause. Acceptable values
   | are from 0 to 99. If 0 is specified, there will be no pause before
   | defaulting.

   DOS-owe CHOICE jednak zatrzymuje sie na prompt-cie. Tak wlasciwie to sie
   nie zatrzymuje, ale to inny temat.

   mCHOICE jest pozbawiony tej 'przypadlosci' i dziala zgodnie z zacytowanym
   fragmentem dokumentacji.

 - Kombinacja CTRL-C
   cyt. dokumentacja MS-DOS 6.22:
   | If the user presses CTRL+BREAK or CTRL+C, CHOICE returns an ERRORLEVEL
   | value of 0.

   Ta wersja mCHOICE jest komaptybilna z MS-DOS, natomiast we FreeDOS nie
   dziala prawidlowo (zwraca inny ERRORLEVEL).
