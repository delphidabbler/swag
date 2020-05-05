{
Here you have an encriptation program based in Xor encription by
bits manipulation

XOR        1101  1001   the origin file
           0101  0011   Password      Encription
         _____________                ^^
           1000  1010


XOR        1000  1010   the destination file
           0101  0011   Password       decryption
        --------------                 ^^
           1101  1001


I recommend you to read the book "Advanced Turbo Pascal: Programming and
Techniques"  of Herbert Schildt (1987)
(The book i read)
}


      PROGRAM Clave;
      {    Por: JAVIER PEREZ-VIGO FDEZ  6/01/1994          }
      {    Codifica y descodifica ficheros mediante un XOR }
      USES CRT;
      VAR
         Fuente,Destino:     FILE;
         Ma,Mo:              CHAR;
         Buffer:             ARRAY[1..2048] of byte;
         Leidos,f,a,b,c,d,Largo1,Largo2,Largo3:   INTEGER;
         ch:char;
         Par1,Par2,Par3:     STRING;

      FUNCTION EXISTE_ARCH(Nombre:STRING):BOOLEAN;
         VAR
           F:FILE;
           OK:BOOLEAN;
         BEGIN            { Existe_Arch }
           Assign (f,Nombre);
           {$I-}                              {Exists file?}
           Reset(f);
           {$I+}
           OK:=IOresult=0;
           If Not OK then
              Existe_Arch:=False
            else
              begin
                close(f);
                existe_Arch:=True;
              end;        { else }
         END;             { Existe_Arch }

      PROCEDURE MENU;
        BEGIN             { Menu }
         Clrscr;
         TextColor(white);
         GotoXY( 1, 1);Write('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
         GotoXY( 1, 2);Write('บ       ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป    บ');
         GotoXY( 1, 3);Write('บ       บ           UTILIDAD DE ENCRIPACION / DESENCRIPTACION             บ    บ');
         GotoXY( 1, 4);Write('บ       บ Por: Javier Prez-Vigo 1993                                     บ    บ');
         GotoXY( 1, 5);Write('บ       ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ    บ');
         GotoXY( 1, 6);Write('บ                                                                              บ');
         GotoXY( 1, 7);Write('บ       ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป    บ');
         GotoXY( 1, 8);Write('บ       บ ๙Nombre del archivo a des/encriptar :                           บ    บ');
                                  {Name of the file to de/encript}

         GotoXY(60,8);TextColor(red);Write('? ');
         GotoXY(60,8);TextColor(red);Write(Paramstr(1));
         TextColor(white);
         GotoXY( 1, 9);Write('บ       บ                                                                 บ    บ');
         GotoXY( 1,10);Write('บ       บ ๙Nombre del archivo des/encriptado  :                           บ    บ');

                                  {Name of the to de/encripted file}

         GotoXY(60,10);TextColor(red);Write('? ');
         GotoXY(60,10);TextColor(red);Write(paramstr(2));
         TextColor(white);
         GotoXY( 1,11);Write('บ       บ                                                                 บ    บ');
         GotoXY( 1,12);Write('บ       บ ๙Clave de encriptaciขn:                                         บ    บ');
                                    {Password}

         GotoXY(60,12);TextColor(red);Write('? ');
         GotoXY(60,12);TextColor(red);Write(paramstr(3));
         TextColor(white);
         GotoXY( 1,13);Write('บ       บ                                                                 บ    บ');
         GotoXY( 1,14);Write('บ       ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน    บ');
         GotoXY( 1,15);Write('บ       บ                                                                 บ    บ');
         GotoXY( 1,16);Write('บ       ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ    บ');
         GotoXY( 1,17);Write('บ                                                                              บ');
         GotoXY( 1,18);Write('บ                                                                              บ');
         GotoXY( 1,19);Write('บ                                                                              บ');
         GotoXY( 1,20);Write('บ                                                                              บ');
         GotoXY( 1,21);Write('บ                                                                              บ');
         GotoXY( 1,22);Write('ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
END;
     PROCEDURE FIN;
       BEGIN
         MENU;
         TextColor(YELLOW);           {Clave [origin] [destination] [password number] }
         GotoXY( 6,17);
         WriteLn ('                    Clave  [origen]    [destino]   [nง clave]');
         TextColor(RED);
         GotoXY( 6,18);
         WriteLn('=======================================');
         TextColor(YELLOW);
         GotoXY( 6,19);
         WriteLn ('     ENCRIPTAR:     Clave  texto.doc   secret.doc  12345');
         GotoXY( 6,20);
         WriteLn ('     DESENCRIPTAR:  Clave  secret.doc  texto.txt   12345');
       END;


    BEGIN  { Programa Principal }   {Main}
        Clrscr;
        Largo1:=LENGTH(Paramstr(1));
        Largo2:=LENGTH(Paramstr(2));
        Largo3:=LENGTH(Paramstr(3));
        If (Largo1 =0) OR (Largo2=0) OR (Largo3=0) then
           Begin
             Clrscr;
             FIN;
             Par1:='';Par2:='';Par3:='';
             if largo1=0 then Par1:=' ORIGEN,';
             if largo2=0 then Par2:=' DESTINO,';
             if largo3=0 then Par3:=' CLAVE';
             GotoXY(10,15);
             TextColor(red);
             Write(' ญ Introduzca los par metros ญ :   ',PAR1,PAR2,PAR3);

                                        {introduce the parameters}

             TextColor(WHITE);
             GotoXY(1,24);
             Halt(0);
           End;
        If Paramstr(1)=Paramstr(2) Then
           begin;
              Fin;
              GotoXY(10,15);
              TextColor(RED);
              Write(' ญ Introduzca distintos ficheros ORIGEN y DESTINO ! ');
              TextColor(WHITE);

               {origin and destination are the same file}

              GotoXY(1,24);
              Halt(1);
           end;

       ASSIGN (FUENTE,PARAMSTR(1));
       if existe_arch (paramstr(1)) then
         RESET (FUENTE,1)
       else
         BEGIN
           Clrscr;
           FIN;
           GotoXY(10,15);
           TextColor(RED);
           Write(' ญ No existe el fichero ORIGEN ! ');

           {The origin file don't exist}

           TextColor(WHITE);
           GotoXY(1,24);
           Halt(2);
         END;
       ASSIGN (DESTINO,PARAMSTR(2));
       if existe_arch (paramstr(2)) then
           BEGIN
             Clrscr;
             MENU;
             GotoXY(9,18);
             TextColor(LightGreen);
             Write('El archivo destino  < ');
             TextColor(LightRed);

             {if destination file exist}

             Write(PARAMSTR(2));
             TextColor(LightGreen);
             Write(' > existe');
             GotoXY(9,20);
             Write('จ Quiere SOBREESCRIBIRLO ? ');

             {rewrite it?}

             TextColor(LightRed);
             write(' (S/N) ');
             TextColor(White);
             Ch := ReadKey;
             TextColor(White);
             if Upcase(Ch) <> 'S'  then
               begin
                 Close(fuente);
                 Clrscr;
                 FIN;
                 GotoXY(10,15);
                 TextColor(Red);
                 Write(' ญ Escriba un nuevo nombre de fichero DESTINO !');
                 TextColor(White);

                 {write a new name for destination file}

                 GotoXY(1,24);
                 Halt(3);
               end;
          END;

        ReWrite(DESTINO,1);
        VAL(Paramstr(3),RANDSEED,F);
        Clrscr;
        MENU;
        GotoXY(10,15);
        TextColor(Blue);
        Write('==>');
        a:=1;
        TextColor(Red);
        REPEAT
          BlockRead(FUENTE,BUFFER,SIZEOF(BUFFER),LEIDOS);
          FOR F:=1 TO LEIDOS DO
             Buffer[F] := Buffer[F] XOR RANDOM(255);
             TextColor((a div 60)+1);
             Write('Þ');
             a:=a+1;
             if  (a mod 60 =0)  then GotoXY(13,15);
          BlockWrite(DESTINO,BUFFER,LEIDOS);
        UNTIL (LEIDOS=0);
        CLOSE (FUENTE);
        CLOSE (DESTINO);
        TextColor(White);
        WriteLn;
        WriteLn;
        WriteLn;
        GotoXY(1,24);
        Halt(4)
      END.
