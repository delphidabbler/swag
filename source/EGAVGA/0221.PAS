{
Well, I finally managed to get my hands on this book describing an algorithm
for phong shading using only two additions. I'll use ù for the dot-product (I
assume you know how to calculate a dot-product :-)

Here goes:

For the intensity at a certain point in a triangle with normals N1, N2 and N3
at the vertices, and with a vector L pointing to the light-source:

                       ax+by+c
  I(x,y) = ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
           û(d*xı + e*x*y + f*yı + gx + hy + i)

where:
         a = Lu  ù N1
         b = Lu  ù N2
         c = Lu  ù N3
         d = N1  ù N1
         e = 2N1 ù N2
         f = N2  ù N2
         g = 2N1 ù N3
         h = 2N2 ù N3
         i = N3  ù N3
              L
        Lu = ÄÄÄ
             ³L³

I hope the extended characters come thru :-).

This can be simplified (?) to:

  I(x,y) = ê5*xı + ê4*x*y + ê3*yı + ê2*x + ê1*y + ê0 

with:       c 
      ê0 = ÄÄÄ
           ûi

           2*b*i - c*h
      ê1 = ÄÄÄÄÄÄÄÄÄÄÄ
             2*i*ûi

           2*a*i - c*g
      ê2 = ÄÄÄÄÄÄÄÄÄÄÄ
             2*i*ûi

           3*c*hı - 4*c*f*i - 4*b*h*i
      ê3 = ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                   8*iı*ûi 

           3*c*g*h - 2*c*e*i - 2*b*g*i - 2*a*h*i
      ê4 = ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                         4*iı*ûi

           3*i*gı - 4*c*d*i - 4*a*g*i
      ê5 = ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                   8*iı*ûi


Which can be rewritten as:

  I(x,y) = ê5*xı + x(ê4*y + ê2) + ê3*yı + ê1*y + ê0

Thus needing only 2 additions per pixel.
}
