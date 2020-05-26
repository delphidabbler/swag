Unit BitOper;
{$F+,O+}
Interface

Function GetBit(a,n: byte):byte;              { Возвращает значение n-ого бита
}
Function SetBitZero(a,n:byte):byte;                      { Сбрасывает n-ый бит
}
Function SetBitOne(a,n:byte):byte;                    { Устанавливает n-ый бит
}

Implementation

Function GetBit(a,n: byte):byte;              { Возвращает значение n-ого бита
}
Begin
    GetBit:=1 and (a shr n);
End;

Function SetBitZero(a,n:byte):byte;                      { Сбрасывает n-ый бит
}
Begin
    SetBitZero:=a and (not(1 shl n));
End;

Function SetBitOne(a,n:byte):byte;                    { Устанавливает n-ый бит
}
Begin
    SetBitOne:=a or (1 shl n);
End;

End.
