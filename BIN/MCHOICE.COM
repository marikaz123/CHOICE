�����z ��  �l.�>xwI� .�>|u�� =��u)P�W�	�!X�'P��	�!X��!<u� �� =��t�P�~�	�!X�L�!��.�>xuP���	�!X��.�>xuP���	�!X��.�>xuP��	�!X��P���	�!X�.�>{t�����<�t�<ar<zw$ߪ����.�>�.�>zt�[��<�t��,���O�]?��$�.�>{t
<ar<zw$߹z ���� t.�~�z +�.��ø���.�~���=��u�P��	�!X.���t��Q��� �H��Y� =��u��.���Q��!
�u���Yô�!<u� ����t�Yþ� �<�F�< t�<	t�<�� </t�� �|� t�|�	t	.�x�� .�x�<?t <nt<st8<ctW<ttv.�x� .�x� .�z�< t��<	t��<t�.�x� .�{�< �{��<	�t��<�m�.�x�s.�>yt.�y��� =���J�.�x�P.�>|t.�|� =���*�.�x�0.�>}t".�}.�xN�� =��� �.�x�.�x�<"uF�5�<t</t<"t:����|� t�|�	t�)�}� t
�}�	t� G.�>�Nì<"t<t	���.�>�ø��ùz �<:uF�<t< t<	t</t��������Nù �<:uF�.�~�<,uHF��3�3Ҭ< t"<	t<t<0r/<9w+,0P��< t<	t<u��t�ك�X�'.�����N��ك����N����       
$ d 
    mCHOICE v1.0 * (c)1994 by 'marikaz'
Waits for the user to choose one of a set of choices.

  MCHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nnn] [text]

/C[:]choices One or more keys the user can press. Default is yn.
/N           Do not display choices and ? at end of prompt string.
/S           Make the choices case sensitive.
/T[:]c,nnn   This defaults choice to c after nnn seconds.
text         Specifies the prompt string to display.

ERRORLEVEL will return the numerical offset of choices.
$mCHOICE: Invalid switch on command line. Type MCHOICE /? for help.
$mCHOICE: Incorrect timeout syntax. Expected form: Tc,nnn or T:c,nnn
$mCHOICE: Only one prompt string allowed. Type MCHOICE /? for help.
$mCHOICE: Timeout default not in specified (or default) choices.
$yn