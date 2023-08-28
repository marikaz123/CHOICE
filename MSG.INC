;---/ Part of mCHOICE v.1.0 /----------------------------------/ marikaz /---

help     DB "mCHOICE v1.0 * (c)1994 by 'marikaz'",13,10
         DB "Waits for the user to choose one of a set of choices.",13,10,13,10
         DB "  MCHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nnn] [text]",13,10,13,10
         DB "/C[:]choices One or more keys the user can press. Default is yn.",13,10
         DB "/N           Do not display choices and ? at end of prompt string.",13,10
         DB "/S           Make the choices case sensitive.",13,10
         DB "/T[:]c,nnn   This defaults choice to c after nnn seconds.",13,10
         DB "text         Specifies the prompt string to display.",13,10,13,10
         DB "ERRORLEVEL will return the numerical offset of choices.",13,10,'$'

errSWMsg DB "mCHOICE: Invalid switch on command line. Type MCHOICE /? for help.",13,10,'$'
errTOMsg DB "mCHOICE: Incorrect timeout syntax. Expected form: Tc,nnn or T:c,nnn",13,10,'$'
errPRMsg DB "mCHOICE: Only one prompt string allowed. Type MCHOICE /? for help.",13,10,'$'
errDCMsg DB "mCHOICE: Timeout default not in specified (or default) choices.",13,10,'$'
