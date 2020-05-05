{

   Set the LED (NumLock, CapsLock, ...) on or off


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

Procedure SetEtatLED (Interrupteur, Flag : Byte);

{ Modify the LED byte attribut

  Interrupteur = 0     Turn Off
                 1     Turn On
  Flag         = LED constant : one of the following
                 ScrollLock = 16
                 NumLock    = 32
                 CapsLock   = 64
                 Insert     = 128
}

Var Led : Byte Absolute $40:$17;

Begin

     If (Interrupteur = 1) Then
        Led := Led Or Flag
     Else
        Led := Led And Not (Flag);

     { Force BIOS to read the LED }

     Asm

       Mov Ah, 1h
       Int 16h

     End;

End;
