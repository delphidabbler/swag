{
 ฺฤฤ GEORGE VAISEY ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 ณ GVฏ I've read throught the book and even looked it up in the two   ณ
 ณ GVฏ pascal books I've got and can't seem to get any help.I'm       ณ
 ณ GVฏ trying (without luck) to get this this command:                ณ
 ณ GVฏ trying (without luck) to get this this PROMPT $mTYPE "EXIT" TO ณ
 ณ GVฏ RETURN to be sent as a command before it shells. This is so    ณ
 ณ GVฏ that the individual that shells out will always know that he   ณ
 ณ GVฏ needs to type EXIT to return.  If you can help or know of a    ณ
 ณ GVฏ better way PLEASE let me know.  Here is what I use to shell to ณ
 ณ GVฏ OS:                                                            ณ
 ณ                                                                    ณ
 ณ GVฏ Begin                                                          ณ
 ณ GVฏ   ClrScr;                                                      ณ
 ณ GVฏ   TextColor(Yellow+Blink);                                     ณ
 ณ GVฏ   Writeln ('Type EXIT To Return To Program');                  ณ
 ณ GVฏ   SwapVectors;                                                 ณ
 ณ GVฏ   Exec(GetEnv('Comspec'), '');                                 ณ
 ณ GVฏ   SwapVectors;                                                 ณ
 ณ GVฏ   NormVideo;                                                   ณ
 ณ GVฏ End.                                                           ณ
 ณ GVฏ I want it to be                                                ณ
 ณ GVฏ TYPE "EXIT" TO RETURN                                          ณ
 ณ GVฏ then the prompt command.  Thanks again for your help.          ณ
 ณ GVฏ     George Vaisey                                              ณ
 ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

George,

  You should get either Object Professional or Turbo Professional from
  Turbo Power software (800) 333-4160 and use the xxDOS unit.  It has
  routines in it to change environment variables on the fly.  These
  routines work really well.

  In the mean time you can use the technique shown in the code below.
  Beware however, that you MUST have enough environment space to deal
  with the extra space required and that there will actually be two
  copies of COMMAND.COM running in addition to the master copy.

  The technique shown in SHELLTODOS is not exactly what you asked for, but
  it does show you how to do what you want.  SHELLTODOS1 is the code used
  if you have either Object Pro or Turbo Pro.

  P.S.  Long lines of code may get truncated by my "QWK" mailer.  Inspect
        the SHELLMESSAGE procedure as it appears it may get truncated.  Also
        change all the WRITE commands in SHELLMESSAGE to WRITELN's.

[-------------------------------CUT HERE-----------------------------------]
}

{$M 4096, 0, 655360 }
Program DosShell;
uses
 OpDos,                                      { Needed only by SHELLTODOS1 }
 Memory,
 Dos,
 CRT;


Procedure ShellMessage ( ProgName : String );
  Function Extend ( AStr : String; ML : byte ) : String;
  begin
    while ord ( AStr[0] ) < ML do
      AStr := AStr + ' ';
    Extend := AStr;
  end;
begin
 clrscr;
 Change the following 6 lines to WRITELN's then delete this line entirely.
 write(' ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
 write(' บ þ While in the DOS SHELL, do not execute any TSR programs like  บ');
 write(' บ   SideKick or DOS''s PRINT command.                              บ')
 write(' บ þ Type EXIT and press ENTER to quit the SHELL and return to the บ');
 write(Extend ( ' บ   ' + ProgName  + ' program.', 67 ), 'บ' );
 write(' ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
end;


Procedure ShellToDos ( ProgName : string );
var
 T : text;
 D : string;
begin
 (* Save current directory                                    *)
 GetDir ( 0, D );

 (* Create a DOS batch file with a PROMPT command             *)
 assign  ( T, 'DOSSHELL.BAT' );
 rewrite ( T );
 writeln ( T, '@echo off' );
 writeln ( T, 'Prompt [EXIT] $p$g' );
 writeln ( T, GetEnv ( 'COMSPEC' ) );
 close   ( T );

 (* Execute the batch file which in turn executes COMMAND.COM *)
 ShellMessage ( ProgName );
 DoneDosMem;
 swapvectors;
 exec ( GetEnv ( 'COMSPEC' ), '/c DOSSHELL.BAT' );
 swapvectors;
 InitDosMem;

 (* Erase the batch file and restore the working directory    *)
 erase ( T );
 chdir ( D );
end;


Procedure ShellToDos1 ( ProgName : string );
var
 NewPrompt : String;
 D : string;
begin
 getdir ( 0, D );
 ShellMessage ( ProgName );
 NewPrompt := 'Type "EXIT" and press ENTER to return to DOSSHELL'^M^J+
              '[' + ProgName + '] ' + GetEnvironmentString ('PROMPT');
 ShellWithPrompt ( NewPrompt, NoExecDosProc );
 chdir ( D );
end;


begin
 InitMemory;
 ShellToDos  ( 'DosShell' );
 ShellToDos1 ( 'DosShell' );
 DoneMemory;
end.
