{

   Read the character visible on the screen


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


Procedure ReadCar (X, Y : Word; Var Attr : Byte; Var Carac : Char);

Var
   Car      : ^char;
   Attribut : ^Byte;
   AdressP  : Word Absolute $0040:$004E; { Address of the screen page }

Begin

   New (car);  { Allocate memory for the character }

   { Get the character from the screen video memory -for the active video
     page- }

   Car := Ptr($B800,(Y*160 + X Shl 1 + AdressP Shl 12));

   Carac := car^;

   New (attribut); { Allocate memory for the character color attribute }

   { Get the color attribute of the character -for the active video page- }

   Attribut := Ptr($B800,(Y*160 + X Shl 1 + 1 + AdressP Shl 12));

   Attr := attribut^;

End;
