{ Have NO IDEA what the message say ..  they are in Russian ! GDAVIS}
{$IFDEF VIRTUALPASCAL}
Какие в OS/2 вообще мог
т быть овеpлеи ? Вы в своем
ме ? :)
{$ENDIF}
{$IFDEF DPMI}
Какие в DPMI вообще мог
т быть овеpлеи ? Вы в своем
ме ? :)
{$ENDIF}
{$IFDEF OS2}
Какие в OS/2 вообще мог
т быть овеpлеи ? Вы в своем
ме ? :)
{$ENDIF}

Unit MainOvr;
Interface

Uses Overlay,Dos;

Implementation

{.$DEFINE BUILDEXE}

Var
   Ovr_Name : PathStr;
          D : DirStr;
          N : NameStr;
          E : ExtStr;

Begin
  FSplit(ParamStr(0),D,N,E);
{$IFDEF BUILDEXE}
  Ovr_Name:=D+N+'.EXE';
{$ELSE}
  Ovr_Name:=D+N+'.OVR';
{$ENDIF}
  Repeat
    OvrInit(ovr_name);
    If OvrResult=OvrNotFound
      Then
        Begin
          WriteLn('Оверлейный файл не найден : ',ovr_name);
          Write  ('Введите правильное имя :');
          ReadLn(Ovr_Name);
        End;
  Until OvrResult<>OvrNotFound;
  If OvrResult<>OvrOk
    Then
      Begin
        WriteLn('Ошибка администратора овeрлеев ',OvrResult);
{$IFDEF STONYBROOK}
        Halt(1);
{$ELSE}
        RunError;
{$ENDIF}
      End;
  OvrInitEMS;
  If OvrResult<>OvrOk
    Then
      Begin
        Case OvrResult Of
          OvrNoEMSDriver : Write('Драйвер EMS нестановлен');
          OvrNoEMSMemory : Write('Мало свободной EMS памяти');
          OvrIOError     : Write('Ошибка чтения файла');
        End;
        Write(' - EMS память не использется.');
      End;
  OvrSetRetry(OvrGetBuf div 3);
end.
