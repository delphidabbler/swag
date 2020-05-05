{      Many will recall a series of messages that I posted a few weeks
      ago regarding the Implementation of XLAT in BAsm.

      I have revisited it With the idea of using it not For filtering
      but just For up- and low-casing Pascal Strings. I came With a
      pure Assembler Function With a loop of only 4 instructions (TXlat
      in Unit TXLATU.PAS). The acCompanying Program TXLATE1.PAS shows
      examples on how to use TXlat both For up- or low-casing a String.

      The intriguing finding was that when I bench-marked it against
      other Assembler Upcasing routines posted in this echo or against
      the one in Hax 144 in PC-Techniques (Vol.3, No.6, Feb 1993, p.40)
      TXlat got to be 20-30% faster! if anyone is interested I could
      upload the benchmarking routines.

      So, here is my question: could this possibly be the fastest
      routine For String conversion in Turbo Pascal?

      Please note that XLAT has special requirements respect to the
      location of the source and destination buffers as well as the
      translation table. Turbo Pascal memory model places global
      Variables in the data segment wh    local Variables are located in
      the stack segment. The code in TXlat requires that both the table
      and the source buffer be located in the data segment.

      Another point of interest is that a Pascal String Variabe (Table) is
      used as the 256-Byte long table required by XLAT.

      -Jose- (1:163/513.3)

   ============================================================================

}
    Unit TXLATU;

   {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
   {³Unit TXlatU.PAS by Jos‚ Campione, Feb.1993.³}
   {³This Unit implements Function TXlat and    ³}
   {³declares Variables in the data segment.    ³}
   {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

   Interface

   Var
     Source, Table : String;   {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
                               {³This Forces these Variables to be  ³}
                               {³in the data segment. Both Variables³}
                               {³passed to TXlat must be created in ³}
                               {³this segment.                      ³}
                               {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

   Function TXlat(Var Source: String; Var Table: String):String;

   Implementation

   {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
   {³This Function translates or filters a String as per the Byte values³}
   {³in the Table buffer. It implements the Assembler XLAT instruction. ³}
   {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}
   Function TXlat(Var Source: String; Var Table: String):String; Assembler;
   Asm
              push ds           {preserve data segment}
              lds  bx,table     {load ds:bx With table address}
              lds  si,source    {load ds:si With source address}
                                {both are in datasegment...}
              les  di,@result   {load es:di With result}
              cld               {si will increment}
              lodsb             {load al With length of source}
              stosb             {store al in es:di}
              mov  cx,ax        {assign length of source to counter}
              or   cx,cx        {if counter = 0}
              jz   @end         {jump to end}
     @filter: lodsb             {load Byte in ax}
              xlat              {tans-xlat-e...}
              stosb             {store it in destination Array}
              loop @filter      {loop back}
        @end: pop ds            {restore data segment}
   end;

   end.
{
   ---------------------------------------------------------------------
}
   Program TXLATE1;

   {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
   {³Program TXlate1.PAS by Jos‚ Campione, Feb.1993.³}
   {³Test Program For Function TXlat in Unit TXlatU ³}
   {³It shows how the same Function can be used For ³}
   {³up-casing of low-casing a String.              ³}
   {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

   Uses TXLATU, HAX144U;

   Var
     UpSource, LowTable,          {These must be global Variables}
     LowSource, UpTable : String; {created in the data segment   }
     i : Byte;

   begin

     {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
     {³Set Table For upper Case translation by XLAT³}
     {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}
     For i:= 0 to 255 do
       if i in [$61..$7A] then UpTable[i]:= Char(i - $20)
         else UpTable[i]:= Char(i);

     {ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿}
     {³Set Table For lower Case translation by XLAT³}
     {ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}
     For i:= 0 to 255 do
       if i in [$41..$5A] then LowTable[i]:= Char(i + $20)
         else LowTable[i]:= Char(i);

     LowSource:= 'this is a low-Case String to be up-Cased';
     UpSource:= 'THIS IS AN UP-Case String to BE LOW-CaseD';

     Writeln(TXlat(LowSource,UpTable));
     Writeln(TXlat(UpSource,LowTable));

     ReadLn;

   end.
