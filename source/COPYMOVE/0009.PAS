{³o³ I want to make my buffer For the BlockRead command as       ³oº
³o³ large as possible. When I make it above 11k, I get an       ³oº
³o³ error telling me "too many Variables."                      ³oº
Use dynamic memory, as in thanks a heap.
}


if memavail > maxint  { up to 65520 }
then bufsize := maxint
else bufsize := memavail;
if i<128
then Exitmsg('No memory')
else getmem(buf,bufsize);


