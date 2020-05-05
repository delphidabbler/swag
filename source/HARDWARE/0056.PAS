{
                =======================================

                      CMOS V1.0 (c) AVC Software
                              Cardware

                 CMOS print  yours CMOS values  for a
                 paper backup.

                 With it, don't be afraid to  lose all
                 your data!  Restore  there with CMOS.

                =======================================


   The purpose of this  program is  to print  the content of  your AMI CMOS

   I've never try  it on  another Bios  than AMERICAN MEGATRENDS  INC. so I
   can't certify that this code should work on every machine.




               ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
               º                                        º°
               º          AVONTURE CHRISTOPHE           º°
               º              AVC SOFTWARE              º°
               º     BOULEVARD EDMOND MACHTENS 157/53   º°
               º           B-1080 BRUXELLES             º°
               º              BELGIQUE                  º°
               º                                        º°
               ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼°
               °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


}

Uses Printer, Crt;

Const PrnInit  = #27+#69+#27+#38+#108+#49+#79+#27+#40+#115+#49+#55+#72+#27+
                 #38+#108+#53+#46+#49+#52+#67+#27+#38+#108+#55+#48+#70+#27+
                 #38+#108+#55+#69;
      PrnReset = #12+#27+'E';

Const Line1   : String = 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿';
      Line2   : String = 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ';
      Line3   : String = 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´';
      Line4   : String = 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿';
      Line5   : String = 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ';

Var St    : Array [1..101] of String[80];
    St2   : String;

Procedure Detect;

Var Port11, Port13, Port2D, Port33, Port34, Port35, Port36 : Byte;
    Sectors      : Byte;
    Head         : Byte;
    Cylindre     : Word;
    PzCylindre   : Word;
    WCylindre    : Word;
    HddType      : Byte;
    HddType2     : Byte;
    R            : LongInt;
    Temp1, Temp2 : Byte;
    AA, BB, CC   : Word;
    TailleHdd    : LongInt;

Begin

Asm

   Mov  Al, 11h
   Out  70h, Al
   In   Al, 71h
   Mov  port11, Al

   Mov  Al, 13h
   Out  70h, Al
   In   Al, 71h
   Mov  Port13, Al

   Mov  Al, 2dh
   Out  70h, Al
   In   Al, 71h
   Mov  Port2d, Al

   Mov  Al, 34h
   Out  70h, Al
   In   Al, 71h
   Mov  Port34, Al

   Mov  Al, 35h
   Out  70h, Al
   In   Al, 71h
   Mov  Port35, Al

   Mov  Al, 33h
   Out  70h, Al
   In   Al, 71h
   Mov  Port33, Al

   Mov  Al, 36h
   Out  70h, Al
   In   Al, 71h
   Mov  Port36, Al

   mov al, 1bh
   out 70h, al
   in al, 71h
   mov temp1, al

   mov al, 1ch
   out 70h, al
   in al, 71h
   mov temp2, al

End;

cylindre := (temp2 Shl 8) + temp1;

asm
   mov al, 1dh
   out 70h, al
   in al, 71h
   mov head, al

   mov al, 23h
   out 70h, al
   in al, 71h
   mov sectors, al

   mov al, 19h
   out 70h, al
   in al, 71h
   mov hddtype, al

   mov al, 1ah
   out 70h, al
   in al, 71h
   mov hddtype2, al


   mov al, 1eh
   out 70h, al
   in al, 71h
   mov temp1, al

   mov al, 1fh
   out 70h, al
   in al, 71h
   mov temp2, al

End;

wcylindre := (temp2 Shl 8) + temp1;

asm

   mov al, 21h
   out 70h, al
   in al, 71h
   mov temp1, al

   mov al, 22h
   out 70h, al
   in al, 71h
   mov temp2, al

End;

pzcylindre := (temp2 Shl 8) + temp1;

Aa := Sectors;
Bb := Head;
Cc := Cylindre;

Asm

   Mov Ax, Aa
   Mov Bx, Bb
   Mul Bx
   Mov Bx, Cc
   Mul Bx
   Mov Word Ptr [R + 2], Dx
   Mov Word Ptr [R    ], Ax
End;

TailleHdd := (((R Div 1024) * 512) Div 1024);

if (((Port13 and 128) shr 7) = 1) then
     St[1] :='Typematic Rate Programming                           ³ Enabled'
else St[1] :='Typematic Rate Programming                           ³ Disabled';

if (((Port13 and 96) shr 5) = 0) then
     St[2] :='Typematic Rate Delay (msec)                          ³ 250'
else if (((Port13 and 96) shr 5) = 1) then
     St[2] :='Typematic Rate Delay (msec)                          ³ 500'
else if (((Port13 and 96) shr 5) = 2) then
     St[2] :='Typematic Rate Delay (msec)                          ³ 750'
else if (((Port13 and 96) shr 5) = 3) then
     St[2] :='Typematic Rate Delay (msec)                          ³ 1000';

if (((Port13 and  28) shr 2) = 0) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 6'
else if (((Port13 and  28) shr 2) = 1) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 8'
else if (((Port13 and  28) shr 2) = 2) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 10'
else if (((Port13 and  28) shr 2) = 3) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 12'
else if (((Port13 and  28) shr 2) = 4) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 15'
else if (((Port13 and  28) shr 2) = 5) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 20'
else if (((Port13 and  28) shr 2) = 6) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 24'
else if (((Port13 and  28) shr 2) = 7) then
     St[3] :='Typematic Rate (Chars/Sec)                           ³ 30';

St[4] := Line3;

if (((Port11 and  64) shr 6) = 1) then
     St[5] := 'Above 1 MB Memory Test                               ³ Enabled'
else St[5] := 'Above 1 MB Memory Test                               ³ Disabled';

if (((Port11 and  32) shr 5) = 1) then
     St[6] := 'Memory Test Tick Sound                               ³ Enabled'
else St[6] := 'Memory Test Tick Sound                               ³ Disabled';

if (((Port11 and  16) shr 4) = 1) then
     St[7] := 'Memory Parity Error Check                            ³ Enabled'
else St[7] := 'Memory Parity Error Check                            ³ Disabled';

St[8] := Line3;

if (((Port11 and   8) shr 3) = 1) then
     St[9] := 'Hit <DEL> message display                            ³ Enabled'
else St[9] := 'Hit <DEL> message display                            ³ Disabled';

if (((Port11 and   4) shr 2) = 1) then
     St[10] := 'Hard Disk Type 47 Data Area                          ³ DOS 1KB'
else St[10] := 'Hard Disk Type 47 Data Area                          ³ 0:300';

if (((Port11 and   2) shr 1) = 1) then
     St[11] := 'Wait for <F1> if any error                           ³ Enabled'
else St[11] := 'Wait for <F1> if any error                           ³ Disabled';

St[12] := Line3;

if ((Port11 and   1) = 1) then
     St[13] := 'System Boot Up Num Lock                              ³ On'
else St[13] := 'System Boot Up Num Lock                              ³ Off';

St[14] := Line3;

if ((Port35 and   1) = 1) then
     St[15] :='Numeric Processor Test                               ³ Enabled'
else St[15] :='Numeric Processor Test                               ³ Disabled';

if (((Port2d and 128) shr 7) = 1) then
     St[16] := 'Weitek Processor                                     ³ Present'
else St[16] := 'Weitek Processor                                     ³ Absent';

St[17] := Line3;

if (((Port2d and  64) shr 6) = 1) then
     St[18] := 'Floppy Drive Seek at Boot                            ³ Enabled'
else St[18] := 'Floppy Drive Seek at Boot                            ³ Disabled';

if (((Port2d and  32) shr 5) = 1) then
     St[19] := 'System Boot Up Sequence                              ³ A:, C:'
else St[19] := 'System Boot Up Sequence                              ³ C:, A:';

if (((Port2d and  16) shr 4) = 1) then
     St[20] := 'System Boot Up CPU Speed                             ³ High'
else St[20] := 'System Boot Up CPU Speed                             ³ Low';

St[21] := Line3;

if (((Port2d and   8) shr 3) = 1) then
     St[22] := 'External Cache Memory                                ³ Enabled'
else St[22] := 'External Cache Memory                                ³ Disabled';

if (((Port2d and   4) shr 2) = 1) then
     St[23] := 'Internal Cache Memory                                ³ Enabled'
else St[23] := 'Internal Cache Memory                                ³ Disabled';

St[24] := Line3;

if (((Port2d and   2) shr 1) = 1) then
     St[25] := 'Fast Gate A20 Option                                 ³ Enabled'
else St[25] := 'Fast Gate A20 Option                                 ³ Disabled';

if ((Port2d and   1) = 1) then
     St[26] := 'Turbo Switch Function                                ³ Enabled'
else St[26] := 'Turbo Switch Function                                ³ Disabled';

if (((Port34 and  64) shr 6) = 1) then
     St[27] := 'Password Checking Option                             ³ Always'
else St[27] := 'Password Checking Option                             ³ Setup';

St[28] := Line3;

if (((Port35 and   4) shr 2) = 1) then
     St[29] :='Video   ROM Shadow C000, 32K                         ³ Enabled'
else St[29] :='Video   ROM Shadow C000, 32K                         ³ Disabled';

if (((Port34 and  32) shr 5) = 1) then
     St[30] := 'Adaptor ROM Shadow C800, 32K                         ³ Enabled'
else St[30] := 'Adaptor ROM Shadow C800, 32K                         ³ Disabled';

if (((Port34 and   8) shr 3) = 1) then
     St[31] := 'Adaptor ROM Shadow D000, 32K                         ³ Enabled'
else St[31] := 'Adaptor ROM Shadow D000, 32K                         ³ Disabled';

if (((Port34 and   2) shr 1) = 1) then
     St[32] :='Adaptor ROM Shadow D800, 32K                         ³ Enabled'
else St[32] :='Adaptor ROM Shadow D800, 32K                         ³ Disabled';

if (((Port35 and 128) shr 7) = 1) then
     St[33] :='Adaptor ROM Shadow E000, 32K                         ³ Enabled'
else St[33] :='Adaptor ROM Shadow E000, 32K                         ³ Disabled';

if (((Port35 and  32) shr 5) = 1) then
     St[34] :='Adaptor ROM Shadow E800, 32K                         ³ Enabled'
else St[34] :='Adaptor ROM Shadow E800, 32K                         ³ Disabled';

St[35] := Line3;

if (((Port34 and 128) shr 7) = 1) then
     St[36] := 'BootSector Virus Protection                          ³ Enabled'
else St[36] := 'BootSector Virus Protection                          ³ Disabled';

if (((Port33 and  16) shr 4) = 1) then
     St[37] :='AUTO Config Function                                 ³ Enabled'
else St[37] :='AUTO Config Function                                 ³ Disabled';

St[38] := Line3;

if (((Port36 and 192) shr 6) = 0) then
     St[39] :='DRAM Speed Option                                    ³ Slowest'
else if (((Port36 and 192) shr 6) = 1) then
     St[39] :='DRAM Speed Option                                    ³ Slower'
else if (((Port36 and 192) shr 6) = 2) then
     St[39] :='DRAM Speed Option                                    ³ Faster'
else if (((Port36 and 192) shr 6) = 3) then
     St[39] :='DRAM Speed Option                                    ³ Fastest';

if (((Port33 and  32) shr 5) = 1) then
     St[40] :='DRAM Write CAS Pulse                                 ³ 1 T'
else St[40] :='DRAM Write CAS Pulse                                 ³ 2 T';

if (((Port35 and  64) shr 6) = 1) then
     St[41] :='DRAM Write Cycle                                     ³ 0 W/S'
else St[41] :='DRAM Write Cycle                                     ³ 1 W/S';

if (((Port34 and   4) shr 2) = 1) then
     St[42] := 'DRAM Hidden Refresh                                  ³ Enabled'
else St[42] :='DRAM Hidden Refresh                                  ³ Disabled';

St[43] := Line3;

if (((Port36 and   8) shr 3) = 1) then
     St[44] :='Cache Write Back Option                              ³ W/THROUGH'
else St[44] :='Cache Write Back Option                              ³ W/BACK';

if (((Port36 and   4) shr 2) = 1) then
     St[45] :='Cache Write Cycle Option                             ³ 2 T'
else St[45] :='Cache Write Cycle Option                             ³ 3 T';

if (((Port36 and  32) shr 5) = 1) then
     St[46] :='Cache Burst Read Cycle                               ³ 2 T'
else St[46] :='Cache Burst Read Cycle                               ³ 1 T';

St[47] := Line3;

if ((Port36 and   7) = 0) then
     St[48] :='Bus Clock Frequency Select                           ³ 7.15 MHz'
else if ((Port36 and   7) = 1) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/10 CLK'
else if ((Port36 and   7) = 2) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/8 CLK'
else if ((Port36 and   7) = 3) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/6 CLK'
else if ((Port36 and   7) = 4) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/5 CLK'
else if ((Port36 and   7) = 5) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/4 CLK'
else if ((Port36 and   7) = 6) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/3 CLK'
else if ((Port36 and   7) = 7) then
     St[48] :='Bus Clock Frequency Select                           ³ 1/2 CLK';

if (((Port35 and   8) shr 3) = 1) then
     St[49] :='Video Cacheable Option                               ³ Enabled'
else St[49] :='Video Cacheable Option                               ³ Disabled';

if ((Port34 and   1) = 1) then
     St[50] :='BIOS Cacheable Option                                ³ Enabled'
else St[50] :='BIOS Cacheable Option                                ³ Disabled';

if (((Port34 and  16) shr 4) = 1) then
     St[51] := 'Latch Local Bus Device                               ³ ?'
else St[51] := 'Latch Local Bus Device                               ³ T3';

if (((Port33 and  64) shr 6) = 1) then
     St[52] :='Local Bus Ready                                      ³ ?'
else St[52] :='Local Bus Ready                                      ³ SYNC';

St[53] := Line3;

if (((Port11 and 128) shr 7) = 1) then
     St[54] := 'Mouse support Option                                 ³ Enabled'
else St[54] := 'Mouse support Option                                 ³ Disabled';

if (((Port35 and   2) shr 1) = 1) then
     St[55] :='Auto Cacheable Area                                  ³ Enabled'
else St[55] :='Auto Cacheable Area                                  ³ Disabled';



St[56] := Line1;
Str (HddType:21, St2);
St[57] := '³ First hard disk type                                 ³ '+St2+' ³';
Str (HddType2:21, St2);
St[58] := '³ Second hard disk type                                ³ '+St2+' ³';
St[59] := Line3;
Str (Cylindre:21, St2);
St[60] := '³ Cylinders number                                     ³ '+St2+' ³';
Str (WCylindre:21, St2);
St[61] := '³ Number of Write Precompensation cylinders            ³ '+St2+' ³';
Str (PzCylindre:21, St2);
St[62] := '³ Number of Parking Zone cylinders                     ³ '+St2+' ³';
Str (Head:21, St2);
St[63] := '³ Head number                                          ³ '+St2+' ³';
Str (Sectors:21, St2);
St[64] := '³ Sectors number                                       ³ '+St2+' ³';
St[65] := Line3;
Str (TailleHdd:21, St2);
St[66] := '³ First hard disk size (in MB)                         ³ '+St2+' ³';
St[67] := Line2;

St[68] := Line4;
St[69] := '³ The first array represent the Advanced CMOS Setup.   These values  are very  ³';
St[70] := '³ important for a correct use of your computer.                                ³';
St[71] := '³                                                                              ³';
St[72] := '³ Keep  this page near your  PC then, you could restore these  values if there ³';
St[73] := '³ are deleted by a defect software  (your PC should''nt run normally)           ³';
St[74] := Line5;
St[75] := '';
St[76] := Line4;
St[77] := '³ Le premier tableau  repr‚sente l''"Advanced CMOS Setup".    Ces valeurs sont  ³';
St[78] := '³ essentielles pour un fonctionnement correct de votre ordinateur.             ³';
St[79] := '³                                                                              ³';
St[80] := '³ Conservez toujours cette page prŠs de votre ordinateur pour  pouvoir, en cas ³';
St[81] := '³ de besoin, restorer ces donn‚es (avec des  donn‚es incorrectes, votre  PC ne ³';
St[82] := '³ fonctionnera plus correctement).                                             ³';
St[83] := Line5;
St[84] := '³ Conservez toujours cette page prŠs de votre ordinateur pour  pouvoir, en cas ³';
St[85] := '³ de besoin, restorer ces donn‚es (avec des  donn‚es incorrectes, votre  PC ne ³';
St[86] := '³ fonctionnera plus correctement).                                             ³';

St[87] := Line4;
St[88] := '³            This program is a distributed freely as a Cardware.               ³';
St[89] := '³        Please send-me a postcard from where you live.  Thank You!            ³';
St[90] := '³                                                                              ³';
St[91] := '³        Ce programme est distribu‚ gratuitement en tant que Cardware.         ³';
St[92] := '³     Veuillez, svp, m''envoyer une carte postale bien de chez vous. Merci!     ³';
St[93] := '³                                                                              ³';
St[94] := '³                                                                              ³';
St[95] := '³                                  AVC SOFTWARE                                ³';
St[96] := '³                              AVONTURE CHRISTOPHE                             ³';
St[97] := '³                                                                              ³';
St[98] := '³                         BOULEVARD EDMOND MACHTENS 157/53                     ³';
St[99] := '³                                B-1080 BRUXELLES                              ³';
St[100] :='³                                    BELGIQUE                                  ³';
St[101] := Line5;

End;

Var I, J, K  : Byte;
    F        : Text;
    Ch       : Char;

Begin

  Detect;

  ClrScr;
  TextAttr := 30;
  WriteLn('');
  WriteLn('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  WriteLn('³ CMOS : Create a Backup of your CMOS values   (c)  AVONTURE Christophe ³');
  WriteLn('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  WriteLn('');
  TextAttr := 14;
  WriteLn('');
  WriteLn('');
  WriteLn('  This program use Standard Printer Escape Code...');
  WriteLn('');
  WriteLn('  Check your printer...  Put it OnLine...  ');
  WriteLn('');
  WriteLn('');
  WriteLn('  Press a Key to start the printing...  Or Escape to abort...');
  WriteLn('');

  REPEAT
  UNTIL KeyPressed;

  Ch := ReadKey; IF Ch = #0 THEN Ch := ReadKey;

  IF Ch = #27 THEN
     Halt;


  WriteLn ('  Printing in progress ...');
  WriteLn ('');

  Write (Lst,PrnInit);

  Write (Lst,'                                                              CMOS '+
       '(c) AVC Software '+#1+' AVONTURE Christophe           October 96');

  Write (Lst,#13+#10);
  Write (Lst,#13+#10);
  Write (Lst,#13+#10);

  Write (Lst,Line1+#13+#10);

  For I := 1 To 55 Do Begin
      St2 := St[I];
      If (St2[1] <> 'Ã') then Begin
         K := 76-Length(St[I]);
         St2 := '';
         For J :=  1 to K Do St2 := St2 + ' ';
         If I in [3..18] then
            Write (Lst,'³ '+St[I]+St2+' ³'+'               '+St[(68-3)+I]+#13+#10)
         Else If I in [25..36] then
            Write (Lst,'³ '+St[I]+St2+' ³'+'               '+St[(56-25)+I]+#13+#10)
         Else If I in [42..55] then
            Write (Lst,'³ '+St[I]+St2+' ³'+'               '+St[(87-42)+I]+#13+#10)
         Else Write (Lst,'³ '+St[I]+St2+' ³'+#13+#10);
      End
      Else If I in [3..18] then
              Write (Lst,St[I]+'               '+St[(68-3)+I]+#13+#10)
           Else If I in [25..36] then
              Write (Lst,St[I]+'               '+St[(56-25)+I]+#13+#10)
           Else If I in [42..55] then
              Write (Lst,St[I]+'               '+St[(87-42)+I]+#13+#10)
           Else Write (Lst,St[I]+#13+#10);
  End;

  Write (Lst,Line2+'               '+St[101]+#13+#10);

  Write (Lst,PrnReset);

end.