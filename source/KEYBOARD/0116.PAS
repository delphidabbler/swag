{

   Flush the keyboard: removes all characters present in the buffer


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

Procedure FlushKeyboard;

Begin

   Inline ($Fa);
   MemW[$40:$1A] := MemW [$40:$1C];
   Inline ($Fb);

End;

{ Another solution is  While KeyPressed Do ReadKey; }
