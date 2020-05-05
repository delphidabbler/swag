{

   Pointers functions: returns the segment and the offset in hexadecimal
   value (in a string variable)


               ษออออออออออออออออออออออออออออออออออออออออป
               บ                                        บฐ
               บ          AVONTURE CHRISTOPHE           บฐ
               บ              AVC SOFTWARE              บฐ
               บ     BOULEVARD EDMOND MACHTENS 157/53   บฐ
               บ           B-1080 BRUXELLES             บฐ
               บ              BELGIQUE                  บฐ
               บ                                        บฐ
               ศออออออออออออออออออออออออออออออออออออออออผฐ
               ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ

}

Function Segment (Chiffre : Pointer)  : String;

Type TWordRec = Record
       Lo, Hi : Word;
    End;

Begin

     Segment := Word2Hex(TWordRec(Chiffre).Hi);

End;

Function Offset (Chiffre : Pointer)  : String;

Type TWordRec = Record
       Lo, Hi : Word;
    End;

Begin

     Offset := Word2Hex(TWordRec(Chiffre).Lo);

End;

Var
   p : Pointer;

Begin

   p := Ptr($B800:$0000);

   Writeln (Segment(p),":",Offset(p));

End.