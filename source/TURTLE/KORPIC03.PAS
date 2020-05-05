(* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ Programated by Vladimir Zahoransky                        ³
   ³                Vladko software                            ³
   ³ Contact      : zahoran@cezap.ii.fmph.uniba.sk             ³
   ³ Program tema : The anomals for spirales                   ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ *)

{ Wha is it ? This is modification of korpic02.pas. This program draw
  two spirals useing anomals. Short program, but easy to undestand if
  you know korpic02.pas.
}

Uses Okor;
Var M:Kor;
    i:integer;
Begin

With m do Begin
               Init(0,0,0);
               For i:=1 to 700 do Begin
                                  Vlavo(i);
                                  Dopredu(20);
                                  End;
               CakajKlaves;
               Koniec;
               End;

End.
