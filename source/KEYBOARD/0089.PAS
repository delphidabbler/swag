{ > how do I get the f11 and f12 keys? }

Program ReadF11F12Keys;
{ Written by Andrew Eigus of 2:5100/33@fidonet.org }
{ SWAG donation... }

const
  F11 = #$85;
  F12 = #$86;

Function ReadKey : char; assembler;
Asm
  mov ah,08h
  int 21h
End; { ReadKey }

var
  Ch : char;
  Extended : boolean;

Begin
  Write('Press F11 or F12 to quit... ');
  repeat
    Ch := ReadKey;
    if Ch = #0 then
    begin
      Extended := True;
      Ch := ReadKey
    end else Extended := False;
  until (Ch in [F11,F12]) and Extended;
  WriteLn('Done.')
End.
{
> ALSO!  What is bit 8 in that address?

Two bytes at address 0:0417 and 0:0418 identify the status of the keyboard
shift keys and keyboard toggles.  INT 16H returns the first byte in AL.

ึฤ7ยฤ6ยฤ5ยฤ4ยฤ3ยฤ2ยฤ1ยฤ0ท     Perform INT 16H Fn 02H
บI ณC ณN ณS ณa ณc ณsLณsRบ     or fetch AL=byte at 0:0417
ำฤามฤามฤามฤามฤามฤามฤามฤาฝ bit
  บ  บ  บ  บ  บ  บ  บ  ศอ 0: alpha-shift (right side) DOWN (AL & 01H)
  บ  บ  บ  บ  บ  บ  ศออออ 1: alpha-shift (left side) DOWN  (AL & 02H)
  บ  บ  บ  บ  บ  ศอออออออ 2: Ctrl-shift (either side) DOWN (AL & 04H)
  บ  บ  บ  บ  ศออออออออออ 3: Alt-shift  (either side) DOWN (AL & 08H)
  บ  บ  บ  ศอออออออออออออ 4: ScrollLock state              (AL & 10H)
  บ  บ  ศออออออออออออออออ 5: NumLock state                 (AL & 20H)
  บ  ศอออออออออออออออออออ 6: CapsLock state                (AL & 40H)
  ศออออออออออออออออออออออ 7: Insert state                  (AL & 80H)

ึฤ7ยฤ6ยฤ5ยฤ4ยฤ3ยฤ2ยฤ1ยฤ0ท
บi ณc ณn ณs ณ  ณsyณaLณcLบ    fetch AL=byte at 0:0418
ำฤามฤามฤามฤามฤามฤามฤามฤาฝ bit
  บ  บ  บ  บ  บ  บ  บ  ศอ 0: Ctrl-shift (left side) DOWN (AL & 01H)
  บ  บ  บ  บ  บ  บ  ศออออ 1: Alt-shift (left side) DOWN  (AL & 02H)
  บ  บ  บ  บ  บ  ศอออออออ 2: SysReq DOWN                 (AL & 04H)
  บ  บ  บ  บ  ศออออออออออ 3: hold/pause state            (AL & 08H)
  บ  บ  บ  ศอออออออออออออ 4: ScrollLock DOWN             (AL & 10H)
  บ  บ  ศออออออออออออออออ 5: NumLock DOWN                (AL & 20H)
  บ  ศอออออออออออออออออออ 6: CapsLock DOWN               (AL & 40H)
  ศออออออออออออออออออออออ 7: Insert DOWN                 (AL & 80H)

Notes: Bits 0-2 of 0:0418 are defined only for the 101-key enhanced keyboard.

       The 101-key BIOS INT 16H Fn 12H returns AL as with Fn 02, but AH is
       returned with the following bit-flag layout:

       ึฤ7ยฤ6ยฤ5ยฤ4ยฤ3ยฤ2ยฤ1ยฤ0ท
       บsyณc ณn ณs ณaRณcRณaLณcLบ    Perform INT 16H Fn 12H (101-key BIOS only)
       ำฤามฤามฤามฤามฤามฤามฤามฤาฝ bit
         บ  บ  บ  บ  บ  บ  บ  ศอ 0: Ctrl-shift (left side) DOWN  (AH & 01H)
         บ  บ  บ  บ  บ  บ  ศออออ 1: Alt-shift (left side) DOWN   (AH & 02H)
         บ  บ  บ  บ  บ  ศอออออออ 2: Ctrl-shift (right side) DOWN (AH & 04H)
         บ  บ  บ  บ  ศออออออออออ 3: Alt-shift (right side) DOWN  (AH & 08H)
         บ  บ  บ  ศอออออออออออออ 4: ScrollLock DOWN              (AH & 10H)
         บ  บ  ศออออออออออออออออ 5: NumLock DOWN                 (AH & 20H)
         บ  ศอออออออออออออออออออ 6: CapsLock DOWN                (AH & 40H)
         ศออออออออออออออออออออออ 7: SysReq DOWN                  (AH & 80H)

       Some older programs change the values of NumLock and CapsLock state
       bits (at 0:0417) to force a known status.  This is unwise because
       modern keyboards have indicator lights which will get out of sync with
       the status. See AT Keyboard for more information on the lock-key LEDs.

       PCjr status bytes at 0:0488 are omitted for lack of interest [mineฤDR].
}
