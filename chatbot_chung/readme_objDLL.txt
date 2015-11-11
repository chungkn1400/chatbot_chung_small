loadobj_chung.dll  'a dll by Nguyen.Chung (free)(2010)


open "loadobj_chung.dll" for dll as #loadobj
calldll #loadobj,"testloadobj",ficload$ as ptr,r as long 'displays vertex , maptexture and faces numbers
close #loadobj



textlist$=""
for i=1 to texturemax:textlist$=textlist$+text$(i)+" "+gentex(i)+" ":next i
textlist$=textlist$+chr$(0):ficload$=ficload$+chr$(0):defauttex$="herbe"+chr$(0)

open "loadobj_chung.dll" for dll as #loadobj
calldll #loadobj,"loadobj",ficload$ as ptr,textlist$ as ptr,defauttex$ as ptr,r as long
close #loadobj

'call with autoresize desired size=integer 
calldll #loadobj,"loadobjsize",ficload$ as ptr,textlist$ as ptr,defauttex$ as ptr,size as long,r as long
calldll #loadobj,"loadobjsizesmooth",ficload$ as ptr,textlist$ as ptr,defauttex$ as ptr,size as long,r as long


'call without loading textures 
calldll #loadobj,"loadobj",ficload$ as ptr,"" as ptr,"" as ptr,r as long

calldll #loadobj,"loadobjsize",ficload$ as ptr,"" as ptr,"" as ptr,size as long,r as long

calldll #loadobj,"loadobjsizesmooth",ficload$ as ptr,"" as ptr,"" as ptr,size as long,r as long




textlist$ : string containing main program's textures infos (list of all "nametext$" numberID ) 
defauttext$ : name of a defaut texture for objects with no texture.

it loads one object with textures (to be set by the calling program).


note: ficload$ last name (the obj file name) must not contain blanks.
      textures file name must be "usemtl$".jpg where usemtl$ is the name of a mtllib in the .obj file.
      textures names assumed to be prefix$+usemtl$ where prefix$=filename  if ficload$="c:\...path...\"filename.obj      
      if called with defautext$="",defauttex$ will be set to prefix$+prefix$ (ex: arrosoirarrosoir arrosoir.jpg with arrosoir.obj)
 



(24/05/2010) normals added