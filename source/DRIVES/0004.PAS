{³o³  How do I detect active drives in Pascal?  My Program would ³oº
³o³  crash if you Typed in a non-existent drive as either       ³oº
³o³  source or destination.                                     ³oº
}
Uses Dos;
Var sr : SearchRec;
begin
  findfirst('k:\*.*',AnyFile,sr);
  if Doserror=0
  then Writeln('It is there all right!')
  else Writeln('Sorry, could not find it.');
end.

