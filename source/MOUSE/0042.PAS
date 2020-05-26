
{ AUTEUR            : AVONTURE Christophe
  BUT DE L'UNITE    : FOURNIR LES FONCTIONS DE GESTION DE LA SOURIS

  DATE DE REDACTION : 8 MARS 1996
  DERNIERE MODIF.   : 8 MARS 1996 }

UNIT uMouse;

INTERFACE

TYPE

   cgCoord = (cgPixel, cgCharacter);

CONST

   { Nombre de Handle actuellement associ‚ au Handler de la souris }

   cgCurrentProc : Byte = 0;

   { Autorise l'appel aux diff‚rentes proc‚dures cr‚‚es par les Handler ou
     interdit leur appel. }

   cgEnableMouseProc : Boolean = True;

   { D‚finit si les coordonn‚es sont … consid‚rer comme ‚tant relatifs … des
     pixels ou bien relatifs … des caractŠres }

   cgCoordonnees : cgCoord = cgPixel;

TYPE

   { Constantes Boutons enfonc‚s }

   cgMouse_Key = (cgMouse_None, cgMouse_Left, cgMouse_Right, cgMouse_Both);

   { Structure permettant d'associer une proc‚dure lorsque le clic de la
     souris se fait dans le rectangle d‚limit‚ par
           (XMin, YMin) -------------- (XMax, YMin)
                :                            :
                :                            :
           (XMin, YMax) -------------- (XMax, YMax) }

   TProcedure = PROCEDURE;

   TMouseHandle = RECORD
      XMin, XMax, YMin, YMax : Word;
      Adress_Proc            : TProcedure;
   END;

   { Lorsque l'utilisateur clic en un certain endroit, si cet endroit est
     compris dans le rectangle sp‚cifi‚ ci-dessus, alors il faudra ex‚cuter
     une certaine proc‚dure.

     On va pouvoir sp‚cifier autant de surfaces diff‚rentes. La seule
     restriction sera la m‚moire disponible.

     Ainsi, on pourra dessiner un bouton OK, un bouton CLOSE, ... et leur
     associer un ‚vŠnement qui leur est propre.

     Cela sera obtenu par la gestion d'un liste chaŒn‚e vers le haut. }

   TpListMouseHandle = ^TListMouseHandle;
   TListMouseHandle  = RECORD
      Next : TpListMouseHandle;
      Item     : TMouseHandle;
   END;

VAR

   { Liste chaŒn‚e des diff‚rents handles associ‚s au handler de la souris }

   MouseProc      : TpListMouseHandle;  { Zone de travail }
   MouseProcFirst : TpListMouseHandle;  { Tout premier ‚vŠnement }
   MouseProcOld   : TpListMouseHandle;  { Sauvegarde de l'ancien ‚vŠnement }

   { True si un gestionnaire de souris est pr‚sent }

   bMouse_Exist : Boolean;

   { Coordonn‚es du pointeur de la souris }

   cgMouse_X    : Word;
   cgMouse_Y    : Word;

   { Correspondant du LastKey.  Contient la valeur du dernier bouton
     enfonc‚ }

   cgMouse_LastButton : cgMouse_Key;

   { Lorsque le clic ne se fait pas dans une des surfaces couvertes par les
     diff‚rents handlers (voir AddMouseHandler); on peut ex‚cuter une
     certaine proc‚dure. }

   hClicNotInArea     : Pointer;

PROCEDURE Mouse_Show;
PROCEDURE Mouse_Hide;
PROCEDURE Mouse_GoToXy (X, Y : Word);
PROCEDURE Mouse_Window (XMin, XMax, YMin, YMax : Word);
PROCEDURE Mouse_AddHandler (XMin, XMax, YMin, YMax : Word; Adress : TProcedure);
PROCEDURE Mouse_RemoveHandler;
PROCEDURE Mouse_Handle;
PROCEDURE Mouse_Flush;

FUNCTION  Mouse_Init    : Boolean;
FUNCTION  Mouse_Pressed : cgMouse_Key;
FUNCTION  Mouse_InArea (XMin, XMax, YMin, YMax : Word) : Boolean;
FUNCTION  Mouse_ReleaseButton (Button : cgMouse_Key) : Boolean;

{ ------------------------------------------------------------------------ }

IMPLEMENTATION

{ Teste si un gestionnaire de souris est pr‚sent }

FUNCTION Mouse_Init : Boolean;

BEGIN

   ASM

      Xor  Ax, Ax
      Int  33h

      Mov  Byte Ptr bMouse_Exist, Ah

   END;

END;

{ Cache le pointeur de la souris }

PROCEDURE Mouse_Hide; ASSEMBLER;

ASM

    Mov  Ax, 02h
    Int  33h

END;

{ Montre le pointeur de la souris }

PROCEDURE Mouse_Show; ASSEMBLER;

ASM

    Mov  Ax, 01h
    Int  33h

END;

{ Retourne une des constantes ‚quivalents aux boutons enfonc‚s.  Retourne 0
  si aucun bouton n'a ‚t‚ enfonc‚ }

FUNCTION Mouse_Pressed : cgMouse_Key;  ASSEMBLER;

ASM

    Mov  Ax, 03h
    Int  33h

    { Bx contiendra 0 si aucun bouton n'a ‚t‚ enfonc‚
                    1          bouton de gauche
                    2          bouton de droite
                    3          bouton de gauche et bouton de droite
                    4          bouton du milieu }

    Mov  Ax, Bx
    Mov  cgMouse_X, Cx
    Mov  cgMouse_Y, Dx
    Mov  cgMouse_LastButton, Al

END;

{ Positionne le curseur de la souris }

PROCEDURE Mouse_GoToXy (X, Y : Word); ASSEMBLER;

ASM

    Mov  Ax, 04h
    Mov  Cx, X
    Mov  Dx, Y
    Int  33h

END;

{ D‚finit la fenˆtre dans laquelle le curseur de la souris peut ‚voluer }

PROCEDURE Mouse_Window (XMin, XMax, YMin, YMax : Word); ASSEMBLER;

ASM

    Mov  Ax, 07h
    Mov  Cx, XMin
    Mov  Dx, XMax
    Int  33h

    Mov  Ax, 08h
    Mov  Cx, YMin
    Mov  Dx, YMax
    Int  33h

END;

{ Teste si le curseur de la souris se trouve dans une certaine surface }

FUNCTION  Mouse_InArea (XMin, XMax, YMin, YMax : Word) : Boolean;

BEGIN

    IF NOT bMouse_Exist THEN 
       Mouse_InArea := False
    ELSE
       BEGIN

          { Les coordonn‚es sont-elles … consid‚rer comme pixels ou comme
            caractŠres }

          IF cgCoordonnees = cgPixel THEN
             BEGIN

                IF NOT (cgMouse_X < XMin) AND NOT (cgMouse_X > XMax) AND
                   NOT (cgMouse_Y < YMin) AND NOT (cgmouse_y > YMax) THEN
                    Mouse_InArea := True
                ELSE
                    Mouse_InArea := False

             END
          ELSE
             BEGIN

                { Il s'agit de caractŠres.  Or un caractŠre fait 8 pixels de long.
                  Donc, lorsque l'on programme (0,1,0,1, xxx), il s'agit du
                  caractŠre se trouvant en (0,0) qui se trouve en r‚alit‚ en
                  0..7,0..15 puisqu'il fait 8 pixels de long sur 16 de haut. }

                IF NOT (cgMouse_X Shr 3 < XMin ) AND
                   NOT (cgMouse_X Shr 3 > XMax ) AND
                   NOT (cgMouse_Y Shr 3 < YMin ) AND
                   NOT (cgmouse_y Shr 3 > YMax ) THEN
                     Mouse_InArea := True
                  ELSE
                     Mouse_InArea := False;
               END;
       END;

END;

{ Ajoute un ‚vŠnement. }

PROCEDURE Mouse_AddHandler (XMin, XMax, YMin, YMax : Word; Adress : TProcedure);

BEGIN

    IF bMouse_Exist THEN
       BEGIN

          { On peut ajouter un ‚vŠnement pour autant qu'il reste de la m‚moire
            disponible pour le stockage du pointeur sur la proc‚dure et de la
            sauvegarde des coordonn‚es de la surface d‚limit‚e pour son action. }

          IF MemAvail > SizeOf(TListMouseHandle) THEN
             BEGIN

                Inc (cgCurrentProc);

                IF cgCurrentProc = 1 THEN
                   BEGIN

                      { C'est le tout premier ‚vŠnement.  Sauvegarde du pointeur
                        pour pouvoir ensuite fabriquer la liste. }

                      New (MouseProc);
                      MouseProcFirst := MouseProc;

                      { Sauvegarde du pointeur courant pour pouvoir fabriquer la
                        liste. }

                      MouseProcOld   := MouseProc;

                      { Etant donn‚ que le liste se rempli de bas en haut -le
                        premier introduit est le moins prioritaire, ...-; seul le
                        premier aura un pointeur vers NIL.  Cette m‚thode permettra
                        … un ‚vŠnement de recouvrir une surface d‚j… d‚limit‚e par
                        un autre objet. }

                      MouseProc^.Next := NIL;
                   END
                ELSE
                   BEGIN

                      { Ce n'est pas le premier.  Il faut que je cr‚e le lien avec
                        le pointeur NEXT de l'‚vŠnement pr‚c‚dent. }

                      MouseProcOld := MouseProc;
                      New (MouseProc);
                      MouseProc^.Next := MouseProcOld;
                      MouseProcFirst := MouseProc;
                   END;

                { Les liens cr‚‚s, je peux en toute s‚curit‚ sauvegarder les
                  donn‚es. }

                MouseProc^.Item.XMin    := XMin;
                MouseProc^.Item.XMax    := XMax;
                MouseProc^.Item.YMin    := YMin;
                MouseProc^.Item.YMax    := YMax;
                MouseProc^.Item.Adress_Proc := Adress;

             END;
       END;
END;

{ Cette proc‚dure retire le tout dernier ‚vŠnement introduit tout en
  conservant la coh‚rence de la liste. }

PROCEDURE Mouse_RemoveHandler;

BEGIN

    IF bMouse_Exist THEN
       BEGIN

          IF NOT (MouseProc^.Next = NIL) THEN
             BEGIN

               MouseProcFirst := MouseProc^.Next;
               Dispose (MouseProc);
               MouseProc := MouseProcFirst;
               Dec (cgCurrentProc);

             END;
       END;

END;


{ Examine si le clic s'est fait dans une surface d‚limit‚e par un ‚vŠnement.

  Si c'est le cas, alors appel de l'‚vŠnement en question. }

PROCEDURE Mouse_Handle;

VAR
   bFin : Boolean;
   bNotFound : Boolean;

BEGIN

    IF bMouse_Exist THEN
       BEGIN

          { Il doit y avoir un process uniquement si on a associ‚ des ‚l‚ments au
            handler de la souris.  ET SEULEMENT SI LES APPELS AUX DIFFERENTES
            PROCEDURES SONT AUTORISES OU NON. }

          IF cgEnableMouseProc AND (cgCurrentProc > 0) THEN
             BEGIN

                bFin := False;

                { bNotFound sera mis sur True lorsque le clic s'est fait dans une
                  surface non couverte par un handler. }

                bNotFound := False;

                { Pointe sur le tout premier ‚vŠnement }

                MouseProcOld := MouseProcFirst;

                REPEAT

                   IF Mouse_InArea (MouseProcOld^.Item.XMin, MouseProcOld^.Item.XMax,
                      MouseProcOld^.Item.YMin, MouseProcOld^.Item.YMax) THEN
                      BEGIN

                         { Le clic s'est fait dans une surface … surveiller.  Appel
                           de l'‚vŠnement ad'hoc. }

                         MouseProcOld^.Item.Adress_Proc;
                         bFin := True;
                      END
                   ELSE
                      IF (MouseProcOld^.Next = NIL) THEN
                         BEGIN
                            bNotFound := True;
                            bFin := True
                         END
                      ELSE
                         MouseProcOld := MouseProcOld^.Next;

                UNTIL bFin;

       {         IF bNotFound THEN
                   ASM
                      Call hClicNotInArea;
                   END;}

             END;
       END;
END;

{ Retourne TRUE lorsque l'utilisateur maintien le bouton xxx enfonc‚ et
  renvoi FALSE lorsque ce bouton est relƒch‚. }

FUNCTION Mouse_ReleaseButton (Button : cgMouse_Key) : Boolean; ASSEMBLER;

ASM
   Mov  Ax, 06h
   Mov  Bx, 01h
   Int  33h
END;

{ Cette proc‚dure va attendre jusqu'… ce que le dernier bouton enfonc‚ ne
  le soit plus; autrement dit jusqu'… ce que l'utilisateur relƒche ce mˆme
  bouton.  Ce qui aura pour effet de vider le buffer de la souris. }

PROCEDURE Mouse_Flush;

BEGIN


    IF bMouse_Exist THEN
       REPEAT
       UNTIL NOT (Mouse_ReleaseButton(cgMouse_LastButton));

END;

{ Initialisation }

BEGIN

   { Initialise le boolean d'existence d'un gestionnaire de souris }

   Mouse_Init;

   { Positionne le curseur de la souris en (0,0) }

   Mouse_GotoXy (0,0);

END.
