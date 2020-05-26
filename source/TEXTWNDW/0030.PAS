{
                  =======================================

                         CRT-DEMO (c) AVC Software
                               Cardware

                   Souce in Pascal to  show how we can
                   manipulate  EGA/VGA  register   for
                   obtain  some  cool  effects in text
                   mode 80*25.


                  =======================================

   The purpose of this program is to show how we can make some cools effect
   in text mode by manipulating the EGA/VGA registers.

   I have writte almost all procedure in assembler for the quick effect and
   for the creation of OBJ file if you want.

   Some code cames from severall books.

   Sorry for the French comments.




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

{$G+}

Uses Crt;

Var I  : Byte;
   Ch  : Char;
   Delai : Byte;

Procedure Wait_Retrace; Assembler;

Asm

    Mov Dx, 3dah

  @Wait1:
    In   Al, Dx
    Test Al, 8h
    Jnz  @Wait1

   @Wait2:
    In   Al, Dx
    Test Al, 8h
    Jnz  @Wait2

End;

Procedure Wait_In_Retrace;

Begin

   Asm
           Mov Dx, 3dah
   @Wait2:
           In al, dx
           Test Al, 8h
           Jnz @Wait2
   End;

End;

Procedure Deplace_par_Pixel; Assembler;

Asm

 { Je m'adresse au contr“leur d'attributs (Attribute Controller : ATC)
   qui s'adresse via le port 3c0h.  Je lui envoi la valeur 110011b
   qui lui indique que je ne d‚sire pas que le CPU accŠde … la m‚moire
   de la palette et que le d‚placement doit se faire au pixel prŠs }

      Mov Dx, 3c0h
      Mov Al, 110011b
      Out Dx, Al

      Mov Al, 10100b
      Out Dx, Al

End;


Procedure Smooth_Scrolling (Sens : Byte);

{ Sens = 0 => d‚filement vers le bas
         1 => D‚filement vers le haut  (1 ou tout autre) }

Var Tempo : Word;

Begin

  If Sens = 0 then Tempo := 1 Else Tempo := 9;

  Repeat

     Asm
          Mov Al, 8
          Mov Dx, 3d4h
          Out Dx, Al
          Mov Dx, 3d5h
          In  Al, Dx
          Inc Al
          And Al, 15
          Out Dx, Al


     { Les bits 0 … 4 repr‚sente le Initial Row Adress : indiquent au CRTC
       la ligne de d‚clenchement du retour du balayage vertical, normalement
       0.  Si on augmente ce paramŠtre, le CRTC commence par une ligne situ‚e
       plus bas, ce qui d‚place le contenu de l'‚cran vers le haut.
       Ce registre fonctionne de la mˆme fa‡on en mode texte qu'en mode
       graphique, de sorte que grƒce … lui on peut r‚aliser un d‚filement
       continu vertical (qu'on appelle Smooth Scrolling).

       Si la ligne de d‚part est ‚gale … 15, cela signifie que je vais traiter
       le dernier pixel du caractŠre, et l'apparition de parasites se fera
       sentir.  Je r‚initalise donc … 0 grƒce … un AND 15. }

     End;

     Delay (Tempo);

  Until KeyPressed;

  Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

  Asm
      xor al, al
      mov dx, 3d5h
      out dx, al
  End;


  { R‚initialisation … sa valeur d'origine pour ‚viter les mauvaises surprises}

End;

Procedure EGA2VGA (OnOff : Byte); Assembler;

{ 0 pour que les caractŠres aient 9 pixels ou 1 pour qu'il en aient 8 }

Asm

          Mov Al, 1
          Mov Dx, 3c4h
          Out Dx, Al
          Mov Dx, 3c5h
          In  Al, Dx
          Or  Al, OnOff
          Out Dx, Al

End;


Procedure Minimize_Char;

Begin

    Repeat

       Asm

          Mov Al, 9
          Mov Dx, 3d4h
          Out Dx, Al
          Mov Dx, 3d5h
          In  Al, Dx
          Inc Al
          And Al, 14
          Or  Al, 1
          Out Dx, Al

       End;

       Delay (100);

    Until KeyPressed;

    Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

    Asm
           Mov Dx, 3d5h
           Mov Al, 15
           Out Dx, Al
    End;

End;

Procedure Mazimize_Char;

Begin

    Repeat

       Delay (100);

       Asm

            Mov Al, 9
            Mov Dx, 3d4h
            Out Dx, Al
            Mov Dx, 3d5h
            In  Al, Dx
            Inc Al
            Or  Al, 128
            Out Dx, Al

       End;

    Until KeyPressed;

    Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

    Asm Mov Al, 15; Out Dx, Al; End;

End;

Procedure Dedouble;

Begin

  Port[$3d4] := $09;              { Je m'adresse au registre 08h du CRTC }

  Port[$3d5] := (Port[$3d5] or 128) ;

  { Positionne … 1 le bit 7 qui divise le rythme d'horloe vertical (clock
    rate) par deux, ce qui a pour effet de d‚doubler l'affichage de chaque
    ligne.  Pr‚vu pour la g‚n‚ration des modes 200 lignes dans une r‚solution
    physique de 400 lignes. }

  Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

  Port[$3d5] := (Port[$3d5] and not 128) ;

  { Remet … 0 le bit 7 }

End;

Procedure Deplacement_Gauche;

{ Cette proc‚dure d‚cale tout l'‚cran vers la gauche pixel par pixel.

  Le d‚but de la ligne qui commence … disparaitre fait place au d‚but de la
  ligne suivante.  Par cons‚quent, la ligne nø 25 (non visible) doit contenir
  le mˆme texte que la ligne 24 pour une question d'esth‚tique. }

Var Nbr : Word;

Begin

   Nbr := 0;

   Repeat

      Nbr := (Nbr + 1) mod 80;

      Asm

          Mov Dx, 3d4h                { Je m'adresse au port du CRTC : 3d4h }
          Mov Al, 0ch

          { Registre 0ch : Linear Starting Address : d‚finit l'offset …
            l'int‚rieur de la m‚moire d'‚cran o— le CRTC commence … lire
            les donn‚es graphiques }

          Mov Ah, Byte Ptr Nbr + 1
          Out Dx, Ax

          { En manipulant cette adresse, on peut provoquer un d‚filement
            horizontal en incr‚mentant sans cesse cette valeur de une
            position sup‚rieure }

          Mov Al, 0dh
          Mov Ah, Byte Ptr Nbr
          Out Dx, Ax

      End;

      Delay (Delai);

  Until KeyPressed;

  Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

End;

Procedure Split (Row, Mouv : Byte); Assembler;

Asm

          Mov Bl, Row
          Xor Bh, Bh
          Shl Bx, 1

          Mov Cx, BX

          Mov Dx, 3d4h
          Mov Al, 07h
          Out Dx, Al

          Inc Dx
          In Al, Dx
          And Al, 11101111b

          Shr Cx, 4
          And Cl, 16
          Or Al, Cl
          Out Dx, Al

          Dec Dx
          Mov Al, 09h
          Out Dx, Al
          Inc Dx
          In Al, Dx
          And Al, 10111111b

          Shr Bl, 3
          And Bl, 64
          Or Al, Bl
          Out Dx, Al

          Dec Dx
          Mov Al, 18h
          Mov Ah, Row
          Shl Ah, 1
          Out Dx, Ax

          Cmp Mouv, 0
          Je @Fin

          Mov Al, 8
          Mov Dx, 3d4h
          Out Dx, Al
          Mov Dx, 3d5h
          In  Al, Dx
          Inc Al
          And Al, 15
          Out Dx, Al

@Fin:

End;

Procedure CopyPage (Source, Cible : Byte);

{ Copy le contenu de la page Source dans la page Cible.  Permet de sauver
  une page avant sa modification et de la restaurer le moment venu}

Type VRam = Array  [0..7,0..4095] of byte;
     Vptr = ^VRam;

Var RVideo   : Vptr;
    i        : Word;

Begin

     RVideo := ptr ($B800,$0000);

     Move (RVideo^[Source, 0],RVideo^[Cible, 0], 4096);

End;

Procedure Superpose (fond, active, buffer : byte);

{ Affiche en superposition la page ‚cran active sur la page ‚cran fond.
  La page ‚cran buffer servira de zone de stockage temporaire.

  Ces deux pages ‚cran doivent ˆtre pr‚par‚es … l'avance }

Begin

  CopyPage(Fond,   Buffer);
  CopyPage(Active, Fond);
  CopyPage(Buffer, Active);

  { Change the active page }

  Asm

    Mov Ah, 05h
    Mov Al, Active

    Int 10h

  End;

  Repeat

      For I := 200 downto 50 do Begin

        Wait_Retrace;
        Split(I,I Xor 1);
        Wait_Retrace;
        Delay (Delai);

        If KeyPressed then Delai := 0;

      End;

      For i := 50 to 200 do Begin

        Wait_Retrace;
        Split(I,I xor 1);
        Wait_Retrace;
        Delay (Delai);

        If KeyPressed then Delai := 0;

      End;

  Until KeyPressed;

  Ch := ReadKey; If Ch = #0 then Ch := ReadKey;

End;

var tempo, row : byte;

Begin

  Delai := 15;

  TextAttr:= 19;

  For I := 0 to 25 Do
     Writeln ('Wow!!!  What a cool effect!!!   Ha! Ha! Ha! Yes, it''s possible in text mode!!!  ');


  EGA2VGA(1);

  Smooth_Scrolling(0);
  Smooth_Scrolling(1);

  Dedouble;

  Minimize_Char;
  Mazimize_Char;

  Deplace_par_Pixel;

  Deplacement_Gauche;

  TextAttr := 45;

  For I := 0 to 24 Do
     Writeln ('Hello to you, Man.   This demo has been coded by AVONTURE Christophe');

  SuperPose (0,1,2);

  EGA2VGA(0);

  { Pour r‚initialiser correctement les paramŠtres du port 3d4h }

  Asm
     Mov Ax, 0003h
     Int 10h
  End;

  ClrScr;

  Writeln ('');
  Writeln ('Cette petite d‚mo n''a aucune pr‚tention si ce n''est celle de prouver');
  Writeln ('que le mode commun‚ment appel‚ texte n''est pas aussi idiot que cela.');
  Writeln ('');
  Writeln ('');
  Writeln ('Oui, on peut faire de jolies choses tout en restant dans le mode texte!!!');
  Writeln ('');


End.