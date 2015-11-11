load3DS_chung.dll  'a dll by Nguyen.Chung (free)(2009)


open "load3DS_chung.dll" for dll as #load3ds
calldll #load3ds,"testload3DS",ficload$ as ptr,r as long 'displays objects names, vertex and faces numbers
close #load3ds



textlist$=""
for i=1 to texturemax:textlist$=textlist$+text$(i)+" "+gentex(i)+" ":next i
textlist$=textlist$+chr$(0):ficload$=ficload$+chr$(0):defauttex$="herbe"+chr$(0)

open "load3DS_chung.dll" for dll as #load3ds
calldll #load3ds,"load3DS",ficload$ as ptr,textlist$ as ptr,defauttex$ as ptr,r as long
close #load3ds

open "load3DS_chung.dll" for dll as #load3ds
calldll #load3ds,"load3DSsize",ficload$ as ptr,textlist$ as ptr,defauttex$ as ptr,size as long,r as long
close #load3ds


textlist$ : string containing main program's textures infos (list of all "nametext$" numberID ) 
defauttext$ : name of a defaut texture for objects with no texture.



'call without loading textures 
calldll #load3ds,"load3DS",ficload$ as ptr,"" as ptr,"" as ptr,r as long
calldll #load3ds,"load3DSsize",ficload$ as ptr,"" as ptr,"" as ptr,size as long,r as long
calldll #load3ds,"load3DSsizesmooth",ficload$ as ptr,"" as ptr,"" as ptr,size as long,r as long

"load3DSsizesmooth" => smooth normals per vertex , for smooth lighting



it loads multi objects , with textures (to be set by the calling program).


note: ficload$ last name (the 3ds file name) must not contain blanks.
      textures file name must be "object$".jpg where object$ is the name of an object.
      textures names assumed to be prefix$+object$ where prefix$=filename  if ficload$="c:\...path...\"filename.3ds