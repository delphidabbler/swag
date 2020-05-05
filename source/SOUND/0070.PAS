{
             ÚÄÄÄÄÄ  Amiga Protracker Module Format  ÄÄÄÄÄ¿
             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 ÚÄÄÄÄÄÄ¿ÚÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄÄ¿
 ³Offset³³Bytes³³Description³
ÚÅÄÄÄÄÄÄÁÁÄÄÄÄÄÁÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³   0     20    Module name.  Padded with spaces until the end (or should
³³                 be).  Remember to only print 20 characters.
³ÃÄSamplesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³  20( 0) 22    Sample Name.  Should be padded with nulls for the full
³³                 length of it after the sample name.
³³  42(22)  2    Sample Length.  Stored as an Amiga word which needs to be
³³                 swapped on an IBM.  This word needs to be multiplied by
³³                 two to get the real length.  If the initial length is
³³                 greater than 8000h, then the sample is greater than 64k.
³³  44(24)  1    Sample Finetune Byte.  This byte is the finetune value for the
³³                 sample.  The upper four bits should be zeroed out.  The
³³                 lower four are the fine tune value.
³³                   Value ÄÄÄÄÄ 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
³³                   Finetune ÄÄ 0 +1 +2 +3 +4 +5 +6 +7 -8 -7 -6 -5 -4 -3 -2 -1
³³  45(25)  1    Sample Volume.  The rangle is always 0-64.
³³  46(26)  2    Sample Repeat.  Stored as an Amiga word.  Multiply this by
³³                 two and add it to the beginning offset of the sample to get
³³                 the repeat point.
³³  48(28)  2    Sample Repeat Length.  Stored as an Amiga word.  Multiply this
³³                 by two to get the Repeat Length.
³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³          *** The remaining 14 or 30 samples follow this point ***
³³          *** using the same format as above.  Note that the   ***
³³          *** rest of this module format follows a 31 sample   ***
³³          *** format, which is not different from the 15       ***
³³          *** sample format except for the file offset.        ***
³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³ 950      1    The Song Length in the range of 1 to 128.
³³ 951      1    I don't know.  I was told that Noisetracker uses this byte
³³                 for a restart, but I don't use Noisetracker.  Anyone have
³³                 any information?
³³ 952    128    Play Sequences 0-127.  These indicate the appropriate
³³                 pattern to play at this given position.
³³1080      4    If this position contains:   "M.K." or "FLT4" or "FLT8"
³³                                              - the module is 31 ins.
³ÃÄPatternsÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³1084(0)   1    Upper 4 bits: MSB of the instrument.  Must be ORed with the
³³                 LSB.  Lower 4 bits:  Upper 4 bits of the period.
³³1085(1)   1    Contains the lower 8 bits of the period.
³³1086(2)   1    Upper 4 bits: LSB of the instrument.  Must be ORed with the
³³                 MSB.  Lower 4 bits: Special effects command.  Contains a
³³                 command 0-F.
³³1087(3)   1    Special effects data.
³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³          *** The number of patterns is the highest pattern    ***
³³          *** number stored in the Play Sequence list.         ***
³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³³ Each note is four bytes long.  Four notes make up a track.  They are
³³ stored like this:
³³         0-3           4-7           8-11         12-15
³³      Channel 1     Channel 2     Channel 3     Channel 4
³³        16-19         20-23         24-27         28-31
³³      Channel 1     Channel 2     Channel 3     Channel 4
³³ ...and so on.
³³
³³
³³
³³                  00           00           00           00
³³                  ||           ||           ||           ||
³³                  /\           //           /\           \\
³³  MSB of Ins.   Note        LSB Ins. Spec. Com.   Data for special
³³
³³ The samples immediately follow.
³³
ÀÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
}