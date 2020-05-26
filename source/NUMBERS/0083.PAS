{

   Convert a byte into his binary representation


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

Function Byte2Bin (Chiffre : Byte) : String;

Var I, Temp : Byte;
    St      : String;

Begin

   St := '';

   For I := 7 Downto 0 do Begin
       Temp := (Chiffre and (1 shl I));
       If (Temp = 0) then St := St + '0' Else St := St + '1';
   End;

   Byte2Bin := St;

End;
