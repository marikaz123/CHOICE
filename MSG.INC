;    --- napisy ---
err2 DB 8,8," v1.3 - (c)1994 'marikaz'",13,10,13,10
form DB '  CHOICE.COM [/C[:]choices] [/N] [/S] [/T[:]c,nn] [text]',13,10,0

cont DB 13,10
     DB '/C[:]choices Specifies allowable keys. Default is YN',13,10
     DB '/N           Do not display choices and ? at end of prompt string.',13,10
     DB '/S           Treat choice keys as case sensitive.',13,10
     DB '/T[:]c,nn    Default choice to c after nn seconds.',13,10
     DB 'text         Prompt string to display.',13,10,13,10
     DB 'ERRORLEVEL is set to offset of key user presses in choices.',13,10,0

prog DB 'CHOICE: ',0
err4 DB 'Invalid switch on command line. Expected form:',13,10,0
errA DB 'Invalid choice switch syntax. Expected form: /C[:]choices',0
err6 DB 'Incorrect timeout syntax.  Expected form Tc,nn or T:c,nn',0
errC DB 'Timeout default not in specified (or default) choices.',0
err8 DB 'Only one prompt string allowed. Expected Form:',13,10,0
errE DB 'Requires MS-DOS version 2.0 or later.',13,10,0
