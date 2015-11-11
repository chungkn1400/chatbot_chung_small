'chatbot_chung a program by NGUYEN.Chung (freeware 2014)
'compiled with freebasic v0.23
#Include Once "windows.bi"
#Include Once "gui_chung.bi"
#include Once "GL/gl.bi"
#include Once "GL/glu.bi"
#Include Once "gl_chung.bi"
#Include Once "chatbot_chung.bi"

#Inclib "TTS_chung_dll"
Declare Sub myTTSinit Cdecl Alias "myTTSinit" () 
Declare Sub myTTSclose Cdecl Alias"myTTSclose" () 
Declare Function myTTSspeak Cdecl Alias "myTTSspeak" (txt as ZString ptr,flags as Integer=0)As Integer 
Declare Function myTTSstatus Cdecl Alias "myTTSgetstatus" () As ZString Ptr

Enum SpeechVoiceSpeakFlags
      ' spvoice flags
      SVSFDefault          = &H0000
      SVSFlagsAsync        = &H0001
      SVSFPurgeBeforeSpeak = &H0002
      SVSFIsFilename       = &H0004 ' must be the whole path
      SVSFIsXML            = &H0008
      SVSFIsNotXML         = &H0010
      SVSFPersistXML       = &H0020
End Enum
Dim Shared As String objname
Dim Shared As string ilang 
Function myTTSspeak2(txt as ZString ptr,flags as Integer=0)As Integer 
Dim As String text
'<lang langid="409">
'   A U.S. English voice should speak this.
'</lang> 
ilang="409"
'409 English (United States)
'809 English (United Kingdom)
'40C French (Standard)
'407 German (Standard)
If InStr(objname,"\man")>0 Then
   'text="<VOICE Gender=""Male"">"+*txt+"</VOICE>"
   text="<VOICE Gender=""Male""><lang langid="""+Str(ilang)+""">"+*txt+"</lang></VOICE>"
Else    	
   'text="<VOICE Gender=""Female"">"+*txt+"</VOICE>"
   text="<VOICE Gender=""Female""><lang langid="""+Str(ilang)+""">"+*txt+"</lang></VOICE>"
EndIf
Return myTTSspeak(text,SVSFIsXML Or flags)
End Function

'Dim As ZString*1000 text,text2
Dim Shared As String status,phoneme,viseme,inword,status0,inword0
Dim Shared As Integer nphoneme=7,iphoneme,phonemes(nphoneme)
Dim Shared As Double tphoneme(nphoneme)
myTTSinit()

#Inclib "./loadobj_chung"
Declare Function loadobj Cdecl Alias "loadobj" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr) As Integer        
'call with autoresize desired size=integer  
Declare Function loadobjsize Cdecl Alias "loadobjsize" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr, ByVal size As uint) As Integer        
Declare Function loadobjsizesmooth Cdecl Alias "loadobjsizesmooth" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr, ByVal size As uint) As Integer        

#Inclib "./load3ds_chung"
Declare Function load3DS Cdecl Alias "load3DS" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr) As Integer        
'call with autoresize desired size=integer 
Declare Function load3DSsize Cdecl Alias "load3DSsize" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr, ByVal size As uint) As Integer        
Declare Function load3DSsizesmooth Cdecl Alias "load3DSsizesmooth" (Byval ficload As ZString Ptr,ByVal textlist As ZString Ptr,_ 
         Byval defauttext As ZString Ptr, ByVal size As uint) As Integer        
Type vertex_type
    As single x,y,z
End Type
'polygon (triangle), 3 numbers that aim 3 vertices
Type polygon_type
    As Integer a,b,c,flags
End Type 
'mapcoord type, 2 texture coordinates for each vertex
Type mapcoord_type
    As single u,v
End Type 
'myobject type
#Define max_obj 200
#Define max_vertices 64000
#Define max_polygons 64000
#Define max_textures 64000
Type  myobj_type
    As ZString*200 nameobj(max_obj-1)
    As Integer obj_poly(max_obj-1)

    As Integer vertices_qty
    As Integer polygons_qty
    As Integer textures_qty

    As vertex_type vertex(max_vertices-1)
    As polygon_type polygon(max_polygons-1)
    As mapcoord_type mapcoord(max_textures-1)
End Type
Declare Function load3DSsizeptr Cdecl Alias "load3DSsizeptr" (Byval ficload As ZString Ptr,ByVal myobjptr As myobj_type Ptr,size As Integer) As Integer          
Declare Function draw3DSptr Cdecl Alias "draw3DSptr" (ByVal myobjptr As myobj_type Ptr) As Integer          
Declare Function draw3DSptrsmooth Cdecl Alias "draw3DSptrsmooth" (ByVal myobjptr As myobj_type Ptr) As Integer          
Declare Function load3DSmap Cdecl Alias "load3DSmap" (Byval ficload As ZString Ptr,ByVal map As Integer Ptr) As Integer        

Declare Function loadobjsizeptr Cdecl Alias "loadobjsizeptr" (Byval ficload As ZString Ptr,ByVal myobjptr As myobj_type Ptr,size As Integer) As Integer          

Dim Shared As myobj_type myobj,myobj2,myobjeye,myobj0,myobj20,myobjmouth,myobjmoutho
Dim Shared As vertex_type Ptr myvertex,myvertex2
Dim Shared As Single dxeye(64000),dyeye(64000),dzeye(64000)
Dim Shared As Single dxeye0(64000),dyeye0(64000),dzeye0(64000)
Dim Shared As Single dxmouth(64000),dymouth(64000),dzmouth(64000)
Dim Shared As Single dxmouth0(64000),dymouth0(64000),dzmouth0(64000)
Dim Shared As Single dxmoutho(64000),dymoutho(64000),dzmoutho(64000)
Dim Shared As Single dxmoutho0(64000),dymoutho0(64000),dzmoutho0(64000)
Dim Shared As Single myobjsize 
Dim Shared As Single rr(64000),gg(64000),bb(64000),aa(64000)
Sub draw3dswire(ByVal obj As myobj_type Ptr)
Dim As Integer i,j,k,a,b,c
With *obj
glEnable GL_BLEND
glBlendFunc GL_src_alpha,gl_ONE_MINUS_SRC_ALPHA
glBegin GL_LINES
For i=0 To .polygons_qty-1
	a=.polygon(i).a
	b=.polygon(i).b
	c=.polygon(i).c
	j=a
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
	j=b
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
	j=b
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
	j=c
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
	j=c
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
	j=a
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	glvertex3f .vertex(j).x,.vertex(j).y,.vertex(j).z
Next
glend 
gldisable gl_blend
End With
End Sub
Sub draw3dsuv(ByVal obj As myobj_type Ptr)
Dim As Integer i,j,k,a,b,c
Dim As Single u,v
With *obj
glEnable GL_BLEND
glBlendFunc GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA
glBegin GL_LINES
Var z=1
For i=0 To .polygons_qty-1
	a=.polygon(i).a
	b=.polygon(i).b
	c=.polygon(i).c
	j=a
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
	j=b
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
	j=b
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
	j=c
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
	j=c
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
	j=a
	glcolor4f rr(j),gg(j),bb(j),aa(j)
	u=.mapcoord(j).u
	v=.mapcoord(j).v
	If abs(u)>0.1 Then u=(u+10)-Int(u+10)
	If abs(v)>0.1 Then v=(v+10)-Int(v+10)
	glvertex3f u,v,z
Next
glend 
gldisable gl_blend
End With
End Sub


Dim Shared As Integer itime,quit=0,restart=0,icombo=2,icomboaiml=1
Dim Shared As Integer initpersotext2=0,initobjeye2=0,ibright=100,idxbright=0,ibright0=100,ibright1=100
Dim Shared As Integer wx,wy,xmax,ymax,x,y,z,o1,o2,o3,ifunc
Dim Shared As Single x1,y1,sx1,sy1,sx2,sy2,sz2,y2,z2,so1,so2,so3,x3,y3,sx3,sy3
Dim Shared As Single zface=-30,szface=1,sxmouth=1,ymouth=70,symouth=1,szmouth=1
Dim Shared As Single yfront=100,syfront=1,sxfront=1,szfront=1,yphoto=69,syphoto=1
Dim Shared As Single sxphoto=1,yjaw=40,syjaw=1,sxjaw=1,szjaw=1
Dim Shared As ZString * 256 objfile,photofile,objfile2,objfileeye,objfilemouth
Dim Shared As ZString * 256 objfilemoutho
'Dim shared as double auxvar,auxvar2,auxvar3
Dim Shared As String curdir0
ChDir(ExePath)
curdir0=CurDir

Dim As String ficin
Dim As String ficini="chatbot_chung.ini"
file=FreeFile
Open ficini For Input As #file
x=0:y=0:z=0:o1=0:o2=0:o3=0
If Not Eof(file) Then Line Input #file,ficin:x=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:y=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:z=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:o1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:o2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:o3=Val(ficin)
objfile=""
If Not Eof(file) Then Line Input #file,ficin:objfile=Trim(ficin)
icombo=1
If Not Eof(file) Then Line Input #file,ficin:icombo=Val(ficin)
x1=0:y1=0:sx1=1:sy1=1
If Not Eof(file) Then Line Input #file,ficin:x1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:y1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sx1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy1=Val(ficin)
ifunc=2
If Not Eof(file) Then Line Input #file,ficin:ifunc=Val(ficin)
sx2=1:sy2=1:sz2=1
If Not Eof(file) Then Line Input #file,ficin:sx2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sz2=Val(ficin)
so1=0:so2=0:so3=0
If Not Eof(file) Then Line Input #file,ficin:so1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:so2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:so3=Val(ficin)
x3=0:y3=0:sx3=1:sy3=1
If Not Eof(file) Then Line Input #file,ficin:x3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:y3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sx3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy3=Val(ficin)
photofile=""
If Not Eof(file) Then Line Input #file,ficin:photofile=Trim(ficin)
zface=-30
If Not Eof(file) Then Line Input #file,ficin:zface=Val(ficin)
szface=1.0
If Not Eof(file) Then Line Input #file,ficin:szface=Val(ficin)
sxmouth=1.0
If Not Eof(file) Then Line Input #file,ficin:sxmouth=Val(ficin)
ymouth=70
If Not Eof(file) Then Line Input #file,ficin:ymouth=Val(ficin)
symouth=1.0
If Not Eof(file) Then Line Input #file,ficin:symouth=Val(ficin)
yfront=100
If Not Eof(file) Then Line Input #file,ficin:yfront=Val(ficin)
sxfront=1.0
If Not Eof(file) Then Line Input #file,ficin:sxfront=Val(ficin)
syfront=1.0
If Not Eof(file) Then Line Input #file,ficin:syfront=Val(ficin)
szfront=1.0
If Not Eof(file) Then Line Input #file,ficin:szfront=Val(ficin)
szmouth=1.0
If Not Eof(file) Then Line Input #file,ficin:szmouth=Val(ficin)
yphoto=69
If Not Eof(file) Then Line Input #file,ficin:yphoto=Val(ficin)
syphoto=1.0
If Not Eof(file) Then Line Input #file,ficin:syphoto=Val(ficin)
sxphoto=1.0
If Not Eof(file) Then Line Input #file,ficin:sxphoto=Val(ficin)
objfile2=""
If Not Eof(file) Then Line Input #file,ficin:objfile2=Trim(ficin)
yjaw=40
If Not Eof(file) Then Line Input #file,ficin:yjaw=Val(ficin)
sxjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:sxjaw=Val(ficin)
syjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:syjaw=Val(ficin)
szjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:szjaw=Val(ficin)
icomboaiml=1
If Not Eof(file) Then Line Input #file,ficin:icomboaiml=Val(ficin)
ibright=100
If Not Eof(file) Then Line Input #file,ficin:ibright=Val(ficin)
idxbright=0
If Not Eof(file) Then Line Input #file,ficin:idxbright=Val(ficin)
ibright0=100
If Not Eof(file) Then Line Input #file,ficin:ibright0=Val(ficin)
ibright1=100
If Not Eof(file) Then Line Input #file,ficin:ibright1=Val(ficin)
Close #file
Sub mysubquit
	quit=1
End Sub
Sub mysubreset
x=-144:y=52:z=-77:o1=9:o2=-90:o3=0
End Sub
Dim Shared As String objtype
Sub subbright
Dim As Integer i
	getcomboindex("win.bright",i)
	ibright=201-i
	initpersotext2=0
	'guisetfocus("win.text")
End Sub
Sub subcombo
	getcomboindex("win.combo",icombo)
	guisetfocus("win.text")
End Sub
Sub subaiml
	getcomboindex("win.aiml",icomboaiml)
	guisetfocus("win.text")
End Sub
Sub formatx(ByRef x As Single)
x=Int(x*10000+0.1)/10000
End Sub
Sub formatvars()
formatx x1
formatx y1
formatx sx1
formatx sy1
formatx sx2
formatx sy2
formatx sz2
formatx so1
formatx so2
formatx so3
formatx x3
formatx y3
formatx sx3
formatx sy3
formatx zface
formatx szface
formatx sxmouth
formatx ymouth
formatx symouth
formatx yfront
formatx sxfront
formatx syfront
formatx szfront
formatx szmouth
formatx yphoto
formatx syphoto
formatx sxphoto	
formatx yjaw
formatx sxjaw
formatx syjaw
formatx szjaw
End Sub
Sub load(ByRef fic As String)
Dim As Integer file,i,j,k
Dim As String ficin
file=FreeFile
Open fic For Input As #file
x1=0:y1=0:sx1=1:sy1=1
If Not Eof(file) Then Line Input #file,ficin:x1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:y1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sx1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy1=Val(ficin)
sx2=1:sy2=1:sz2=1
If Not Eof(file) Then Line Input #file,ficin:sx2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sz2=Val(ficin)
so1=0:so2=0:so3=0
If Not Eof(file) Then Line Input #file,ficin:so1=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:so2=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:so3=Val(ficin)
x3=0:y3=0:sx3=1:sy3=1
If Not Eof(file) Then Line Input #file,ficin:x3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:y3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sx3=Val(ficin)
If Not Eof(file) Then Line Input #file,ficin:sy3=Val(ficin)
Var photofile2=""
If Not Eof(file) Then Line Input #file,ficin:photofile2=Trim(ficin)
zface=-30
If Not Eof(file) Then Line Input #file,ficin:zface=Val(ficin)
szface=1.0
If Not Eof(file) Then Line Input #file,ficin:szface=Val(ficin)
sxmouth=1.0
If Not Eof(file) Then Line Input #file,ficin:sxmouth=Val(ficin)
ymouth=70
If Not Eof(file) Then Line Input #file,ficin:ymouth=Val(ficin)
symouth=1.0
If Not Eof(file) Then Line Input #file,ficin:symouth=Val(ficin)
yfront=100
If Not Eof(file) Then Line Input #file,ficin:yfront=Val(ficin)
sxfront=1.0
If Not Eof(file) Then Line Input #file,ficin:sxfront=Val(ficin)
syfront=1.0
If Not Eof(file) Then Line Input #file,ficin:syfront=Val(ficin)
szfront=1.0
If Not Eof(file) Then Line Input #file,ficin:szfront=Val(ficin)
szmouth=1.0
If Not Eof(file) Then Line Input #file,ficin:szmouth=Val(ficin)
yphoto=69
If Not Eof(file) Then Line Input #file,ficin:yphoto=Val(ficin)
syphoto=1.0
If Not Eof(file) Then Line Input #file,ficin:syphoto=Val(ficin)
sxphoto=1.0
If Not Eof(file) Then Line Input #file,ficin:sxphoto=Val(ficin)
objfile2=""
If Not Eof(file) Then Line Input #file,ficin:objfile2=Trim(ficin)
yjaw=40
If Not Eof(file) Then Line Input #file,ficin:yjaw=Val(ficin)
sxjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:sxjaw=Val(ficin)
syjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:syjaw=Val(ficin)
szjaw=1.0
If Not Eof(file) Then Line Input #file,ficin:szjaw=Val(ficin)
ibright=100
If Not Eof(file) Then Line Input #file,ficin:ibright=Val(ficin)
idxbright=0
If Not Eof(file) Then Line Input #file,ficin:idxbright=Val(ficin)
ibright0=100
If Not Eof(file) Then Line Input #file,ficin:ibright0=Val(ficin)
ibright1=100
If Not Eof(file) Then Line Input #file,ficin:ibright1=Val(ficin)
Close #file
'selectcomboindex("win.bright",41-ibright\5)
selectcomboindex("win.bright",201-ibright)
If FileExists(photofile2) Then
	photofile=photofile2
	If objfile2<>objfile And FileExists(objfile2) Then
		confirm "load new model "+objfile2+" ?","confirm",resp
		If resp="yes" Then objfile=objfile2
	EndIf
	restart=1:quit=1
EndIf
objfile2=Mid(objfile2,InStr(objfile2,"\")+1)
'confirm "convert sx2*sx1/sy1 ?","confirm",resp
'If resp="yes" Then sx2=(sx1/sy1)*sx2
End Sub
Sub subload
Dim As String fic,dir0,resp
Dim As Integer ret
dir0=CurDir  
ChDir(ExePath+"\save\")  
fic=filedialog("load","*.avatar","myavatar.avatar")
fic=Trim(fic)
ChDir(dir0)
If InStr(fic,".")=0 And fic<>"" Then fic=fic+".avatar"
If Right(fic,7)=".avatar" Then 
	'guiconfirm("load "+fic+" ?","confirm",resp)
	'If resp="yes" Then
		load(fic)
	'EndIf
EndIf
ret=ChDir(dir0)	
End Sub
Declare Sub myfuncscale()
Declare Sub myfuncscale2()
Declare Sub drawtexture2(opt As Integer=0)
Dim Shared As uint phototext,persotext,persotext2,whitetext
Dim Shared As Integer bmpx
Dim Shared As Integer mousex,mousey
Sub subleftmouse()
mousex=guimousex
mousey=guimousey
guisetfocus("win.graph")
End Sub
Dim Shared As String inputtext,inputtext0,myvoicemsg,minputtext,minputtext0
Sub mysubaiml()
Dim As String myinputtext
myinputtext=inputtext
	If myinputtext<>"" Then
		msg="> "+myinputtext
		If myinputtext="*" Then myinputtext=oldmsg'autochat
		myinputtext=formatinput(myinputtext)
		If myinputtext="" Then myinputtext="enough"
		processinput(myinputtext)
		If myinputtext="exit" Or myinputtext="/exit" Then quit=1
		inputtext=""
		msg0=""
	EndIf
	If msg0<>msg Then
	 'printgui("win.msg",msg)
	 msg0=msg
    If Left(msg,2)="> " Then'"> "
    	myvoicemsg=Mid(msg,InStr(msg,"> "))
    	myvoicemsg=Left(Mid(myvoicemsg,3),2800)
    	If quit=1 Then  
    		myTTSspeak2(myvoicemsg,SVSFPurgeBeforeSpeak)
    	Else 
      	'myTTSspeak2(myvoicemsg,SVSFlagsAsync+SVSFPurgeBeforeSpeak)
      	myTTSspeak2(outmsg,SVSFlagsAsync+SVSFPurgeBeforeSpeak)
    	EndIf 
    EndIf
	EndIf
End Sub 
Sub subtext2()
inputtext=guigettext("win.text")
'inputtext=Left(inputtext,Len(inputtext)-2)
replace(inputtext,Chr(13),"")
replace(inputtext,Chr(10),"")
inputtext=Trim(inputtext)
If inputtext="" Then inputtext=myvoicemsg 'repeat
'printgui("win.msg",inputtext)
mysubaiml()
printgui("win.text","")
End Sub
Sub subtext()
If icomboaiml=2 Then subtext2():Exit Sub 
inputtext=guigettext("win.text")
If Len(inputtext)<=2 Then inputtext=inputtext0
If Left(inputtext,1)="*" Then 
 inputtext=""
 inputtext+=chr(10)+"   The Search for the Crown of Alegare"
 inputtext+=chr(10)+"   Introduction"
 inputtext+=chr(10)+"   Deep Deadly Dungeons is a rogue-like game where you explore random dungeons"
 inputtext+=chr(10)+"   battling evil creatures and building up your character as you gain experience."
 inputtext+=chr(10)+"   Unlike some rogue-likes, there are a number of stones that must be found and "
 inputtext+=chr(10)+"   collected and on the last level, the crown which must be retrieved in order"
 inputtext+=chr(10)+"   to escape from the dungeon."
 inputtext+=chr(10)+"   "
 inputtext+=chr(10)+"   Objective"
 inputtext+=chr(10)+"   "
 inputtext+=chr(10)+"   You are the heir to the throne of Alegare. Before you can take back your throne"
 inputtext+=chr(10)+"   from the evil Wizard Morlach, you must enter the Deep Deadly Dungeons and retrieve"
 inputtext+=chr(10)+"   the crown of Alegare and the five stones of power. The stones are hidden within "
 inputtext+=chr(10)+"   the dungeon and it is rumored that the crown is in level 25. You must collect "
 inputtext+=chr(10)+"   the stones and crown to defeat Morlach and regain the crown."
EndIf
printgui("win.msg",inputtext)
myttsspeak2(inputtext,SVSFlagsAsync+SVSFPurgeBeforeSpeak)
inputtext0=inputtext
printgui("win.text","")
End Sub
Dim Shared As hwnd wintexth
Sub subfocus()
If ifunc=8 Or ifunc=9 Then
 guisetfocus("win.text")
 Var icar=Len(guigettexth(wintexth))
 SendMessage(wintexth, EM_SETSEL,icar,icar)	
EndIf 
End Sub 
Dim Shared As Double time0,time1,time2,time3,nframe,kfps=1,kfps2,kfps3,dtime2
Dim Shared As Double fps,maxfps=80,tfps
Sub setfps()
           	time3=time2
           	time2=Timer
           	dtime2=1.0/max(10.0,min(200.0,maxfps))-0.0015
           	'If time2<(time3+25) Then Sleep (time3+30-time2)'20'30
           	If time2<(time3+dtime2) Then
           		If time2<time3 Then time2=time3 'if midnight
           		Sleep Int((time3+dtime2+0.001-time2)*1000)'20'30
           	   time2=time3+dtime2+0.001
           	EndIf
           	tfps=0.85*tfps+0.15*min(1.0,(time2-time3))
           	fps=1.0/max(0.001,tfps)
           	kfps=min(10.0,30/fps)	
End Sub
Declare Sub initgl
Declare Sub initobjects
Declare Sub display
Declare Sub display2
Declare Sub subhelp
'
' Program start
guibackgroundcolor(0,240,240)
debut:
quit=0
ScreenInfo wx,wy
'wx=1200:wy=768
'wx=800:wy=600
winx=wx/2:winy=wy/2
'wx=min(wx,1024):wy=min(wy,600)
winx=winx-wx/2
winy=winy-wy/2
xmax=wx-30:ymax=wy-87'-30
button("win.button1","help",@subhelp,10,5,50,20)
button("win.button2","resetxyz",@mysubreset,70,5,70,20)
button("win.load","load perso",@subload,150,5,90,20)
button("win.quit","quit",@mysubquit,745,5,60,20)
button("win.loaddata","loaddata",@subloaddataas,810,5,80,20)
button("win.savedata","savedata",@subsavedata,895,5,80,20)
combobox("win.combo",@subcombo,500,5,100,200)
combobox("win.aiml",@subaiml,615,5,120,200)
combobox("win.bright",@subbright,395,5,90,400)
edittext("win.text","enter a text or *",@subtext,xmax/2-290,ymax-25,620,20,es_multiline+WS_VSCROLL+ES_LEFT)
edittext("win.msg","msg",@subtext,xmax/2+230*wx/1024,90,260*wx/1024,370*wy/600)
graphicbox("win.graph",10,19,xmax,ymax,"opengl")
openwindow("win","chatbot_chung",winx,winy,wx,wy-37)

For i=1 To 200
	addcombo("win.bright","bright"+Str(201-i))
Next
selectcomboindex("win.bright",201-ibright)

addcombo("win.combo","lighting")
addcombo("win.combo","lightsmooth")
addcombo("win.combo","no lighting")
addcombo("win.combo","wireframe")
addcombo("win.combo","initial")
selectcomboindex("win.combo",icombo)

addcombo("win.aiml","speak")
addcombo("win.aiml","Mychat dialog")
selectcomboindex("win.aiml",icomboaiml)

ifunc=8

wintexth=getguih("win.text")
If ifunc<>8 Then
	hidegui("win.text")
Else
	mysubreset
  	guisetfocus("win.text")
EndIf

trapclose("win",@mysubquit)
trapLeftmouse("win.graph",@subleftmouse)
Dim Shared As hwnd wingraph:wingraph=getguih("win.graph")

'notice Str(aimlgetsize())+" patterns loaded"

guistartOpenGL("win.graph")
initgl

whitetext=guiloadtexture(curdir0+"/objects/white.jpg")

loadSynonyms()
subloaddata2(0)

debut2:
initobjects
myttsspeak2("hello, how are you?",SVSFlagsAsync)
If ifunc=8 Then guisetfocus("win.text")


Dim As Integer tchanged0,tchanged,dxyz
While quit=0 And Not guitestKey(vk_escape)
	itime+=1:If itime>100000 Then itime=1
	dxyz=1
	If tchanged>=2 Then dxyz=max(1.1,1.1*kfps) 'Else Sleep 50
	tchanged0=tchanged
	If guitestkey(vk_f1) Then subhelp()
	If ifunc=0 Or (guitestkey(vk_shift)=0 And guitestkey(vk_control)=0) Then
	 If guitestkey(vk_left) Then o1+=dxyz:tchanged+=1
	 If guitestkey(vk_right) Then o1-=dxyz:tchanged+=1
	 If guitestkey(vk_up) Then o2+=dxyz:tchanged+=1
	 If guitestkey(vk_down) Then o2-=dxyz:tchanged+=1
	 If guitestkey(vk_prior) Then o3+=dxyz:tchanged+=1
	 If guitestkey(vk_next) Then o3-=dxyz:tchanged+=1
	 If tchanged0=tchanged Then
	 	tchanged0=0:tchanged=0
	 Else
	 	subfocus()
	 EndIf
	EndIf 
  If getfocus()=wingraph Then 	
	If guitestkey(vk_q) Then o1-=dxyz:tchanged+=1
	If guitestkey(vk_d) Then o1+=dxyz:tchanged+=1
	If guitestkey(vk_b) Then x+=dxyz:tchanged+=1
	If guitestkey(vk_n) Then x-=dxyz:tchanged+=1
	If guitestkey(vk_a) Then y+=dxyz:tchanged+=1
	If guitestkey(vk_e) Then y-=dxyz:tchanged+=1
	If guitestkey(vk_z) Then z+=dxyz:tchanged+=1
	If guitestkey(vk_s) Then z-=dxyz:tchanged+=1
	If tchanged0=tchanged Then tchanged0=0:tchanged=0
  EndIf 	
  'If guitestkey(vk_p) And guitestkey(vk_control) Then savedatapack()
  'If guitestkey(vk_u) And guitestkey(vk_control) Then savedataunpack()
  If guitestkey(vk_j) And guitestkey(vk_control) Then savedatajavascript()
  	
   If o1>360 Then o1-=360
   If o1<-360 Then o1+=360
   If o2>360 Then o2-=360
   If o2<-360 Then o2+=360
   If o3>360 Then o3-=360
   If o3<-360 Then o3+=360
   ifunc=8
	If ifunc=6 Or ifunc=7 Or ifunc=8 Then
		display2
	Else
		display
	EndIf
	If initobjeye2=1 Then guirefreshopenGL
	guiscan  'scan for input and continue
	'guiwait  'wait for msg
	'Sleep 70
	If (itime Mod 10)=0 Then 
	 minputtext0=minputtext
	 minputtext=guigettext("win.text")
	 If minputtext<>minputtext0 Then
	 	'findsyns(minputtext)
	 	'findwords(minputtext)
	 	'testparse(minputtext)
	 	testword(minputtext)
	 	'testrnd(minputtext)
	 EndIf
    'If icomboaiml=2 Then mysubaiml()
	EndIf 
	
	setfps()  
Wend
If restart=1 Then
	restart=0:itime=0:quit=0
	'notice("restart")
	'guibackgroundcolor(Rnd*255,Rnd*255,Rnd*255)
	guideletetexture(phototext)
	guideletetexture(persotext)
	guideletetexture(persotext2)
	GoTo debut2
	'guireset:Sleep 300:GoTo debut
EndIf

guicloseOpenGL

myTTSclose
'aimlclose()

guiclose'("msg")

ChDir(ExePath)
file=freefile
Open ficini For Output As #file
Print #file,x
Print #file,y
Print #file,z
Print #file,o1
Print #file,o2
Print #file,o3
Print #file,objfile
Print #file,icombo
Print #file,x1
Print #file,y1
Print #file,sx1
Print #file,sy1
Print #file,ifunc
Print #file,sx2
Print #file,sy2
Print #file,sz2
Print #file,so1
Print #file,so2
Print #file,so3
Print #file,x3
Print #file,y3
Print #file,sx3
Print #file,sy3
Print #file,photofile
Print #file,zface
Print #file,szface
Print #file,sxmouth
Print #file,ymouth
Print #file,symouth
Print #file,yfront
Print #file,sxfront
Print #file,syfront
Print #file,szfront
Print #file,szmouth
Print #file,yphoto
Print #file,syphoto
Print #file,sxphoto
Print #file,objfile2
Print #file,yjaw
Print #file,sxjaw
Print #file,syjaw
Print #file,szjaw
Print #file,icomboaiml
Print #file,ibright
Print #file,idxbright
Close #file	

guiquit
End

Dim Shared As uint tlight
Sub initgl
        /' init OpenGL '/        
	glMatrixMode GL_PROJECTION
	glLoadIdentity
	'              anglevue    xmax/ymax   mxmin,mxmax
	'gluPerspective   48.0,    640.0/480.0,  2.0, 13000.0
	'gldistmax=13000*10
	'gluPerspective   48.0,    xmax/ymax,  2.0, gldistmax*25
	gluPerspective   48.0,    xmax/ymax,  5.3, 100000'1700000
	'gluPerspective   89.0,    xmax/ymax,  3.3, 100000'1700000
	glMatrixMode GL_MODELVIEW
	glLoadIdentity
	
	glShadeModel GL_SMOOTH
	'glClearColor 0.50, 0.50, 1.0, 0.0
	glClearColor 0.25, 0.4, 1.0, 0.0
	glClearDepth 1.0
	glEnable GL_DEPTH_TEST
	glDepthFunc GL_LEQUAL
	
	'gldisable gl_cull_face
	glenable gl_lighting
	glenable gl_light0
	glenable gl_normalize
	'glnormals=1
   glEnable GL_COLOR_MATERIAL
   glColorMaterial GL_FRONT_and_back,GL_DIFFUSE
   'glcolormaterial GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE

	glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST    '' Really Nice Perspective Calculations
	'glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST    '' Really Nice Perspective Calculations
	
	'glenable gl_polygon_smooth
	'glhint gl_polygon_smooth_hint,gl_fastest
	
	'glenable GL_ARB_multitexture
		
	Dim LightAmbient(0 to 3) as single => {0.625, 0.625, 0.625, 1.0}   '' Ambient Light Values
	Dim LightAmbient2(0 to 3) as single => {0.7,0.7,0.7, 1.0}   '' Ambient Light Values
	Dim LightAmbient3(0 to 3) as single => {0.1,0.1,0.1, 1.0}   '' Ambient Light Values
	Dim LightDiffuse(0 to 3) as single => {1.0, 1.0, 1.0, 1.0}   '' Diffuse Light Values
	Dim LightPosition(0 to 3) as single => {0.0, 0.0, 2000.0, 1.0}  '' Light Position
   'gllightfv(gl_light0,GL_ambient,glparam4f(1,1,1,0)) 'GL_AMBIENT GL_DIFFUSE GL_SPECULAR GL_POSITION
	'glLightfv GL_LIGHT1, GL_AMBIENT, @LightAmbient(0)   '' Setup The Ambient Light
	'glLightfv GL_LIGHT2, GL_AMBIENT, @LightAmbient2(0)   '' Setup The Ambient Light
	'glLightfv GL_LIGHT3, GL_AMBIENT, @LightAmbient3(0)   '' Setup The Ambient Light
	'glLightfv GL_LIGHT0, GL_DIFFUSE, @LightDiffuse(0)   '' Setup The Diffuse Light
	'glLightfv GL_LIGHT0, GL_POSITION, @LightPosition(0) '' Position The Light
	'glEnable GL_LIGHT0                                  '' Enable Light One
 
End Sub
Sub initobjects()
If FileExists(objfile)=0 Then objfile="objects/chest.obj"
objname=Left(objfile,Len(objfile)-4)
objtype=Right(objfile,3)
'notice(objname+"/"+objtype)
If FileExists(photofile)=0 Then photofile="objects/elise2.jpg"
phototext=guiloadtexture(photofile,0,255)
persotext2=guiloadtexture(curdir0+"/objects/text512.jpg")
initpersotext2=0

If FileExists(objname+".bmp") Then 
 persotext=guiloadtexture(objname+".bmp")
ElseIf FileExists(objname+".jpg") Then 
 persotext=guiloadtexture(objname+".jpg")
Else 
 persotext=guiloadtexture(curdir0+"/objects/defaulttext.jpg")
EndIf 
'notice("text2="+Str(persotext))

'objlist=glgenlists(1)
'glnewlist objlist,GL_COMPILE 'GL_COMPILE_AND_EXECUTE'4865
If FileExists(objfile) Then
  /'If LCase(objtype)="3ds" Then
  	  If icombo=1 Then
  	  	  load3DSsize(@objfile,@"",@"",150)
  	  Else 	  
  	  	  load3DSsizesmooth(@objfile,@"",@"",150)
  	  EndIf
  EndIf '/
  If LCase(objtype)="3ds" Then
  	  load3DSsizeptr(@objfile,@myobj,150)
  	  'guinotice Str(myobj.vertices_qty)
  EndIf
  If LCase(objtype)="obj" Then
  	  /'If icombo=1 Then
  	  	  loadobjsize(@objfile,@"",@"",150)
  	  Else 	  
  	  	  loadobjsizesmooth(@objfile,@"",@"",150)
  	  EndIf '/
  	  loadobjsizeptr(@objfile,@myobj,150)
  EndIf
  If FileExists(objname+"eye.3ds") Then
  	  objfileeye=objname+"eye.3ds"
  	  load3DSsizeptr(@objfileeye,@myobjeye,150)
  ElseIf FileExists(objname+"eye.obj") Then
  	  objfileeye=objname+"eye.obj"
  	  loadobjsizeptr(@objfileeye,@myobjeye,150)
  Else
  	  myobjeye=myobj
  EndIf
  If FileExists(objname+"mouth.3ds") Then
  	  objfilemouth=objname+"mouth.3ds"
  	  load3DSsizeptr(@objfilemouth,@myobjmouth,150)
  ElseIf FileExists(objname+"mouth.obj") Then
  	  objfilemouth=objname+"mouth.obj"
  	  loadobjsizeptr(@objfilemouth,@myobjmouth,150)
  Else
  	  myobjmouth=myobj
  EndIf
  If FileExists(objname+"moutho.3ds") Then
  	  objfilemoutho=objname+"moutho.3ds"
  	  load3DSsizeptr(@objfilemoutho,@myobjmoutho,150)
  ElseIf FileExists(objname+"moutho.obj") Then
  	  objfilemoutho=objname+"moutho.obj"
  	  loadobjsizeptr(@objfilemoutho,@myobjmoutho,150)
  Else
  	  myobjmoutho=myobj
  EndIf
EndIf
'glendlist
myobj2=myobj
printgui("win","chatbot_chung        "+objfile+"      "+photofile+"  ["+objfile2+"]")
End Sub
Sub gldrawtext0(ByRef text As String,ByVal x As Single,ByVal y As Single,ByVal scale As Single=1.0)
   glLoadIdentity()
   gldisable(gl_texture_2d)
   'glTranslatef (22*(-1+2*x/xmax)*(xmax/ymax)*(520/700),17*(1-2*y/ymax),-38)
   glTranslatef ((-0.31+23.7*(-1+2*x/xmax)*(xmax/ymax)*(520/700)),-0.25+17.1*(1-2*y/ymax),-40)
   glscalef(scale,scale,scale)
   guigltext(text)
   glenable(gl_texture_2d)
End Sub 
Sub gldrawtext(ByRef text As String,ByVal x As Single,ByVal y As Single,ByVal scale As Single=1.0)
   glLoadIdentity()
   glenable(gl_texture_2d)
   glbindtexture(gl_texture_2d,myguifont256text)
   'glTranslatef (22*(-1+2*x/xmax)*(xmax/ymax)*(520/700),17*(1-2*y/ymax),-38)
   glTranslatef ((-0.31+23.7*(-1+2*x/xmax)*(xmax/ymax)*(520/700)),-0.25+17.1*(1-2*y/ymax),-40)
   glscalef(scale*1.1,scale,scale)
   'glscalef(scale,scale,scale)
   myguigltext(text)
End Sub
Sub myfuncscale
Dim As Integer i,j,k
Dim As single x,y,z,dx,dy,dz,xx,yy,zz
x=zface'-30
With myobj
For i=0 To .vertices_qty
	myobj2.vertex(i)=.vertex(i)
	y=.vertex(i).y
	z=.vertex(i).z
	If y<x Then
		dx=max(0.0,1-(x-y)/10.0)
		y=x+(y-x)*(dx+(1-dx)*szface)
		myobj2.vertex(i).y=y
		If z<ymouth Then 
		   dz=max(0.0,1-(1-dx)*(ymouth-z)/18.0)
		   xx=.vertex(i).x
		   myobj2.vertex(i).x=xx*(dz+(1-dz)*sxmouth)
		   yy=.vertex(i).y
		   myobj2.vertex(i).y=yy*(dz+(1-dz)*szmouth)
		EndIf
	EndIf 	
	If z<ymouth Then 
		   dy=max(0.0,1-(ymouth-z)/11.0)
		   zz=.vertex(i).z
		   myobj2.vertex(i).z=ymouth+(zz-ymouth)*(dy+(1-dy)*symouth)
	EndIf 
	If z>yfront Then 
		   dy=max(0.0,1-(z-yfront)/11.0)
		   xx=myobj2.vertex(i).x
		   myobj2.vertex(i).x=xx*(dy+(1-dy)*sxfront)
		   yy=myobj2.vertex(i).y
		   myobj2.vertex(i).y=yy*(dy+(1-dy)*szfront)
		   zz=myobj2.vertex(i).z
		   myobj2.vertex(i).z=yfront+(zz-yfront)*(dy+(1-dy)*syfront)
	EndIf 	
	If z<yjaw Then 
	  If y<x Then
		   dx=max(0.0,1-(x-y)/10.0)
		   dy=max(0.0,1-(1-dx)*(yjaw-z)/11.0)
		   xx=myobj2.vertex(i).x
		   myobj2.vertex(i).x=xx*(dy+(1-dy)*sxjaw)
		   yy=myobj2.vertex(i).y
		   myobj2.vertex(i).y=yy*(dy+(1-dy)*szjaw)
		   zz=myobj2.vertex(i).z
		   myobj2.vertex(i).z=yjaw+(zz-yjaw)*(dy+(1-dy)*syjaw)
	  EndIf 	   
	EndIf 	
Next
End With
End Sub
Sub myfuncscale2()
'glscalef(sx1/sy1,1,1)
'glscalef(sx2,sy2,sz2)
Dim As Integer i,j
Dim As Single x,y,z,kx
With myobj2
'kx=(sx1/sy1)*sx2
For i=0 To .vertices_qty
	.vertex(i).x*=sx2'kx
	.vertex(i).y*=sy2
	.vertex(i).z*=sz2
Next
End With 	
End Sub
Dim Shared As integer xpix1,ypix1
Dim Shared As Single umin,umax,vmin,vmax,kr1,kg1,kb1
Sub drawtext2(opt As Integer=0)
Dim As Integer i,j,k,a,b,c
Dim As Single xx,x,y,z,u,v,aa,kaa,kx,u0,v0,zz,dx,dz
xx=zface'-30
kaa=1/19'18
umin=1:umax=0:vmin=1:vmax=0
With myobj
	gldisable gl_lighting
	If opt=0 Then 
		glenable gl_blend
   	glblendfunc gl_src_alpha,gl_one_minus_src_alpha
	EndIf
	glrotatef(so1,0,0,1)
	gltranslatef(-0.5,-0.5,0)
	glbegin gl_triangles
	For i=0 To .polygons_qty-1
   	If .vertex(.polygon(i).a).y<xx Then
	   	If .vertex(.polygon(i).b).y<xx Then
        		If .vertex(.polygon(i).c).y<xx Then
        	     z=1
        	     a=.polygon(i).a
        	     kx=(xx-.vertex(a).y)*kaa
        	     aa=max(0.0,min(1.0,kx*kx))
        	     If opt=0 Then glcolor4f(kr1,kg1,kb1,aa)
        	     'u=(-.vertex(a).x*0.7-x1)*sx1/140+0.47
        	     'v=(-.vertex(a).z*0.7-y1)*sy1/140
        	     x=.vertex(a).x
        	     zz=.vertex(a).z
		        If zz<yphoto Then 
		           dz=max(0.0,1-(yphoto-zz)/18.0)
		           x=x*(dz+(1-dz)*sxphoto)
		           zz=yphoto+(zz-yphoto)*(dz+(1-dz)*syphoto)
        	     EndIf   
        	     u=(-x*0.7-x1)*sx1/140+0.47
        	     v=(-zz*0.7-y1)*sy1/140
		        glTexCoord2f u,v
     		  	  u0=.mapcoord(a).u
     		  	  v0=.mapcoord(a).v
     		  	  u0=(u0+10)-Int(u0+10)
     		  	  v0=(v0+10)-Int(v0+10)
	        	  glvertex3f u0,v0,z
        		  If Abs(v0-0.5)<0.05 Then 
        		  	   umin=min(umin,u0)
        		  	   umax=max(umax,u0)
        		  	   vmin=min(vmin,v0)
        		  	   vmax=max(vmax,v0)
        		  EndIf  
        	     
        	     a=.polygon(i).b
        	     kx=(xx-.vertex(a).y)*kaa
        	     aa=max(0.0,min(1.0,kx*kx))
        	     If opt=0 Then glcolor4f(kr1,kg1,kb1,aa)
        	     'u=(-.vertex(a).x*0.7-x1)*sx1/140+0.47
        	     'v=(-.vertex(a).z*0.7-y1)*sy1/140
        	     x=.vertex(a).x
        	     zz=.vertex(a).z
		        If zz<yphoto Then 
		           dz=max(0.0,1-(yphoto-zz)/18.0)
		           x=x*(dz+(1-dz)*sxphoto)
		           zz=yphoto+(zz-yphoto)*(dz+(1-dz)*syphoto)
        	     EndIf   
        	     u=(-x*0.7-x1)*sx1/140+0.47
        	     v=(-zz*0.7-y1)*sy1/140
		        glTexCoord2f u,v
     		  	  u0=.mapcoord(a).u
     		  	  v0=.mapcoord(a).v
     		  	  u0=(u0+10)-Int(u0+10)
     		  	  v0=(v0+10)-Int(v0+10)
	        	  glvertex3f u0,v0,z
        		  If Abs(v0-0.5)<0.05 Then 
        		  	   umin=min(umin,u0)
        		  	   umax=max(umax,u0)
        		  	   vmin=min(vmin,v0)
        		  	   vmax=max(vmax,v0)
        		  EndIf  

        	     a=.polygon(i).c
        	     kx=(xx-.vertex(a).y)*kaa
        	     aa=max(0.0,min(1.0,kx*kx))
        	     If opt=0 Then glcolor4f(kr1,kg1,kb1,aa)
        	     'u=(-.vertex(a).x*0.7-x1)*sx1/140+0.47
        	     'v=(-.vertex(a).z*0.7-y1)*sy1/140
        	     x=.vertex(a).x
        	     zz=.vertex(a).z
		        If zz<yphoto Then 
		           dz=max(0.0,1-(yphoto-zz)/18.0)
		           x=x*(dz+(1-dz)*sxphoto)
		           zz=yphoto+(zz-yphoto)*(dz+(1-dz)*syphoto)
        	     EndIf   
        	     u=(-x*0.7-x1)*sx1/140+0.47
        	     v=(-zz*0.7-y1)*sy1/140
		        glTexCoord2f u,v
     		  	  u0=.mapcoord(a).u
     		  	  v0=.mapcoord(a).v
     		  	  u0=(u0+10)-Int(u0+10)
     		  	  v0=(v0+10)-Int(v0+10)
	        	  glvertex3f u0,v0,z
        		  If Abs(v0-0.5)<0.05 Then 
        		  	   umin=min(umin,u0)
        		  	   umax=max(umax,u0)
        		  	   vmin=min(vmin,v0)
        		  	   vmax=max(vmax,v0)
        		  EndIf  

        		EndIf
	   	EndIf 
		EndIf
	Next
	glend
	gldisable gl_blend
End With
End Sub
Dim Shared As uint pix0(100),pix1(100),r0,g0,b0,r1,g1,b1
Dim Shared As Single kr,kg,kb
Dim Shared As Integer tkey
Sub drawtexture2(opt As Integer=0)
	glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
   glviewport(0,0,bmpx,bmpx)
   glEnable GL_TEXTURE_2D 
   glBindTexture GL_TEXTURE_2D,persotext 
		gldisable gl_lighting  
      glLoadIdentity
		glTranslatef 0,0,-2000
		glColor4f 1.0, 1.0, 1.0, 1
      gltexcarre(bmpx)
      gltranslatef(0,0,10.0)
      xpix1=bmpx*(umin+0.2*(umax-umin))+(idxbright)
      ypix1=bmpx*(1-(vmin+0.3*(vmax-vmin)))
      glReadPixels(xpix1,ypix1, 20,1, _   
                   GL_rgba, GL_UNSIGNED_BYTE, @pix0(0))
      'pix0=bmpbits(0)
      gltranslatef(0,0,10.0)
		glColor4f 1.0, 1.0, 1.0, 1
	   glbindtexture gl_texture_2d,phototext
      glscalef(bmpx*2,bmpx*2,0.5)
		kr1=1:kg1=1:kb1=1
      drawtext2(1)
      glReadPixels(xpix1,ypix1, 20,1, _   
                   GL_rgba, GL_UNSIGNED_BYTE, @pix1(0))
      'pix1=bmpbits(0)
      b0=0:g0=0:r0=0:
      b1=0:g1=0:r1=0
      For i=0 To 19
       b0+=(pix0(i) Shr 16)And 255
       g0+=(pix0(i) Shr 8)And 255
       r0+=(pix0(i)) And 255
       b1+=(pix1(i) Shr 16)And 255
       g1+=(pix1(i) Shr 8)And 255
       r1+=(pix1(i)) And 255
      Next
      If r0>r1 Then
      	kr=max2(1,r1)/max2(1,r0):kr1=1
      Else
      	kr=1:kr1=max2(1,r0)/max2(1,r1)
      EndIf
      If g0>g1 Then
      	kg=max2(1,g1)/max2(1,g0):kg1=1
      Else
      	kg=1:kg1=max2(1,g0)/max2(1,g1)
      EndIf
      If b0>b1 Then
      	kb=max2(1,b1)/max2(1,b0):kb1=1
      Else
      	kb=1:kb1=max2(1,b0)/max2(1,b1)
      EndIf
      
		glLoadIdentity
		If opt=1 Then glscalef(1,-1,1)
		glTranslatef 0,0,-1000
      glBindTexture GL_TEXTURE_2D,persotext 
		glColor4f kr,kg,kb, 1
      gltexcarre(bmpx)
      gltranslatef(0,0,10.0)
		glpushmatrix
      glscalef(bmpx*2,bmpx*2,0.5)
	   glbindtexture gl_texture_2d,phototext
		glcolor4f kr1,kg1,kb1,1
		drawtext2()
		glpopmatrix
      'drawtext3()
	   'glbindtexture gl_texture_2d,whitetext
      gldisable gl_texture_2d
      glEnable GL_BLEND
      glBlendFunc GL_src_alpha,gl_ONE_MINUS_SRC_ALPHA
      gltranslatef(0,0,10.0)
	   glbegin(gl_quads)
     	Var dx=bmpx,tx=0.9,br=1,bra=Abs(ibright-100)/250.0
     	If ibright<100 Then br=0
		glcolor4f br,br,br,bra
	   glvertex3f(-dx,-dx,0)
		glcolor4f br,br,br,bra
   	glvertex3f(dx,-dx,0)
		glcolor4f br,br,br,bra
	   glvertex3f(dx,dx,0)
		glcolor4f br,br,br,bra
	   glvertex3f(-dx,dx,0)
	   glend()
	   gldisable gl_blend
	   glenable gl_texture_2d 
End Sub
Sub display
Dim As Integer i,j,k,a,b,c
      
      'ifunc=3
      formatvars()
      
      myfuncscale()
      
   bmpx=512
	glMatrixMode GL_PROJECTION
	glLoadIdentity
   glortho(-bmpx,bmpx,-bmpx,bmpx,5,5000)
	'gluPerspective   45.0,    ymax/ymax,  5.0, 50000.0
	glMatrixMode GL_MODELVIEW

	If (itime Mod 30)=1 Or 1 Then 
      
      drawtexture2()
      
      glbindtexture(gl_texture_2d,persotext2)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_linear)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_linear)'NEAREST)'nomipmap
      'glcopyTexImage2D(GL_TEXTURE_2D, 0, gl_rgba,0,0,bmpx,bmpx, 0)   
      glcopyTexSubImage2D(GL_TEXTURE_2D, 0, 0,0, 0,0,bmpx,bmpx)
      gldisable gl_texture_2d   
      
      initpersotext2=1
	
	EndIf
	
		initobjeye2=0
End Sub 
Dim Shared As Double tkeye
Dim Shared As Single kmouth,kmoutho
Sub addphoneme(iphon As Integer)
iphoneme+=1:If iphoneme>nphoneme Then iphoneme=1
phonemes(iphoneme)=iphon
tphoneme(iphoneme)=Timer
End Sub
Sub drawphoneme(i As Integer)
Dim As Double ktime,dt,dtt,d1
ktime=4.5'2.80
dt=tphoneme(i)-Timer
If dt>999 Then tphoneme(i)=0
dtt=dt*ktime*0.75
If dtt>3.1416 Then Exit Sub 
d1=0.82
Select Case phonemes(i)
	Case 35 'o
   kmoutho+=(Sin(dtt)+d1)*0.64
   kmouth+=kmoutho*0.3
	Case 44 'u
   kmoutho+=(Sin(dtt)+d1)*0.64
   kmouth+=kmoutho*0.3
	Case 16 'i
   kmoutho+=(Sin(dtt)+d1)*0.24
   kmouth+=kmoutho*0.3
   kmouth+=(Sin(dtt)+0.7)*0.3
	Case 28 'e
   kmoutho+=(Sin(dtt)+d1)*0.24
   kmouth+=kmoutho*0.3
   kmouth+=(Sin(dtt)+0.7)*0.25
	Case 46 'w
   kmoutho+=(Sin(dtt)+d1)*0.2
   kmouth+=kmoutho*0.3
   kmouth+=(Sin(dtt)+0.7)*0.3
	Case 39,30 'x
   kmoutho+=(Sin(dtt)+d1)*0.15
   kmouth+=kmoutho*0.2
   kmouth+=(Sin(dtt)+0.7)*0.2
	Case 38 'r
   kmoutho+=(Sin(dtt)+d1)*0.18
   kmouth+=kmoutho*0.3
   kmouth+=(Sin(dtt)+0.7)*0.24
	Case 32 'm
   kmoutho+=(Sin(dtt)+d1)*0.18
   kmouth+=kmoutho*0.3
   kmouth+=(Sin(dtt)+0.7)*0.27
	Case 41 't
   kmoutho+=(Sin(dtt)+d1)*0.18
   kmouth+=kmoutho*0.2
   kmouth+=(Sin(dtt)+0.7)*0.27
	Case 18 'ch
   kmoutho+=(Sin(dtt)+d1)*0.18
   kmouth+=kmoutho*0.25
   kmouth+=(Sin(dtt)+0.7)*0.3
	
	Case Else 
   kmouth+=(Sin(dtt)+0.7)*0.4
		
End Select
End Sub
Sub drawphonemes()
Dim As Integer i,j,k
status=*(myTTSstatus)
If status<>status0 Then
	status0=status
 	j=InStr(status,"/")
 	k=InStr(status,"/inword")
 	phoneme=Left(status,j-1)
 	viseme=Mid(status,j+1,k-j-1)
 	inword=Mid(status,k+1)
 	If inword<>inword0 Then
 		inword0=inword
 		For i=1 To nphoneme
 			tphoneme(i)=0
 		Next
 	EndIf
 	If phoneme<>"phoneme0" Then
 		If phoneme<>"phoneme7" Then
 		   '?status+"   "+phoneme+"/"+viseme+"/"+inword
 		   addphoneme(Val(Mid(phoneme,8)))
 		Else'If viseme="viseme0" Then 
 		   For i=1 To nphoneme
 			    tphoneme(i)=0
 		   Next
      EndIf  			
 	EndIf
EndIf
For i=1 To nphoneme
	If Timer<(tphoneme(i)+1) Then
		drawphoneme(i)
	EndIf
Next
End Sub
Sub display2
Dim As Integer i,j,k,a,b,c
Dim As Single keye,do1
      
   If initpersotext2=0 Then
   	display():display()
   	For i=0 To myobj.vertices_qty-1
   		rr(i)=1:gg(i)=1:bb(i)=1:aa(i)=1
   	Next
   	Exit Sub
   EndIf
   If initobjeye2=0 And (ifunc=7 Or ifunc=8) Then
   	initobjeye2=1
   	myobj0=myobj:myobj20=myobj2
   	myobj=myobjeye
   	myfuncscale()
   	For i=0 To myobj.vertices_qty-1
   		dxeye(i)=myobj2.vertex(i).x-myobj20.vertex(i).x
   		dyeye(i)=myobj2.vertex(i).y-myobj20.vertex(i).y
   		dzeye(i)=myobj2.vertex(i).z-myobj20.vertex(i).z
   	Next
   	myobj=myobjmouth
   	myfuncscale()
   	For i=0 To myobj.vertices_qty-1
   		dxmouth(i)=myobj2.vertex(i).x-myobj20.vertex(i).x
   		dymouth(i)=myobj2.vertex(i).y-myobj20.vertex(i).y
   		dzmouth(i)=myobj2.vertex(i).z-myobj20.vertex(i).z
   	Next
   	myobj=myobjmoutho
   	myfuncscale()
   	For i=0 To myobj.vertices_qty-1
   		dxmoutho(i)=myobj2.vertex(i).x-myobj20.vertex(i).x
   		dymoutho(i)=myobj2.vertex(i).y-myobj20.vertex(i).y
   		dzmoutho(i)=myobj2.vertex(i).z-myobj20.vertex(i).z
   	Next
   	myobj=myobj0:myobj2=myobj20
   	For i=0 To myobj.vertices_qty-1
   		dxeye0(i)=myobjeye.vertex(i).x-myobj.vertex(i).x
   		dyeye0(i)=myobjeye.vertex(i).y-myobj.vertex(i).y
   		dzeye0(i)=myobjeye.vertex(i).z-myobj.vertex(i).z
   	Next
   	For i=0 To myobj.vertices_qty-1
   		dxmouth0(i)=myobjmouth.vertex(i).x-myobj.vertex(i).x
   		dymouth0(i)=myobjmouth.vertex(i).y-myobj.vertex(i).y
   		dzmouth0(i)=myobjmouth.vertex(i).z-myobj.vertex(i).z
   	Next
   	For i=0 To myobj.vertices_qty-1
   		dxmoutho0(i)=myobjmoutho.vertex(i).x-myobj.vertex(i).x
   		dymoutho0(i)=myobjmoutho.vertex(i).y-myobj.vertex(i).y
   		dzmoutho0(i)=myobjmoutho.vertex(i).z-myobj.vertex(i).z
   	Next
   EndIf
   
  If ifunc=7 Or ifunc=8 Then 
   Var ktime=1.5
   keye=(Sin(Timer*ktime-tkeye)+0.7)*0.32
   kmoutho=0'(Cos(Timer*ktime*0.75)+1)*0.64
   kmouth=(Cos(Timer*ktime*0.85)+0.7)*0.15+kmoutho*0.3
   If Rnd<0.03*kfps And keye>1.45*0.32 Then keye=0:tkeye=Timer*ktime
   If ifunc=8 Then
   	drawphonemes()
   EndIf
   If icombo=5 Then 
    For i=0 To myobj.vertices_qty-1
   	myvertex=@myobj0.vertex(i)
   	myvertex2=@myobj.vertex(i)
   	Var sc=0.89
   	myvertex->x=myvertex2->x+keye*dxeye0(i)+sc*(kmouth*dxmouth0(i)+kmoutho*dxmoutho0(i))
   	myvertex->y=myvertex2->y+keye*dyeye0(i)+sc*(kmouth*dymouth0(i)+kmoutho*dymoutho0(i))
   	myvertex->z=myvertex2->z+keye*dzeye0(i)+sc*(kmouth*dzmouth0(i)+kmoutho*dzmoutho0(i))
    Next
   Else
    For i=0 To myobj.vertices_qty-1
   	myvertex=@myobj20.vertex(i)
   	myvertex2=@myobj2.vertex(i)
   	myvertex->x=myvertex2->x+keye*dxeye(i)+kmouth*dxmouth(i)+kmoutho*dxmoutho(i)
   	myvertex->y=myvertex2->y+keye*dyeye(i)+kmouth*dymouth(i)+kmoutho*dymoutho(i)
   	myvertex->z=myvertex2->z+keye*dzeye(i)+kmouth*dzmouth(i)+kmoutho*dzmoutho(i)
    Next
   EndIf 	
   do1=Cos(Timer*0.6)*2.6
  EndIf 
	
	glClear GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

	glMatrixMode GL_PROJECTION
	glLoadIdentity
	gluPerspective   45.0,    xmax/ymax,  5.0, 50000.0
	glMatrixMode GL_MODELVIEW
	
   'gllightfv(gl_light0,GL_diffuse,glparam4f(1,1,1,1)) 'GL_AMBIENT GL_DIFFUSE GL_SPECULAR GL_POSITION
   'gllightfv(gl_light0,GL_ambient,glparam4f(0.1,0.1,0.1,1)) 'GL_AMBIENT GL_DIFFUSE GL_SPECULAR GL_POSITION

      glviewport(0,0,xmax,ymax)
      glEnable GL_TEXTURE_2D 
      glBindTexture GL_TEXTURE_2D,persotext2 
		glLoadIdentity
		glTranslatef 52-y, z, -373-x
		glRotatef o1-9+do1, 0, 1, 0
		glRotatef o2, 1, 0, 0
		glRotatef o3, 0, 0, 1
		glColor4f 1.0, 1.0, 1.0, 1
		'glenable gl_alpha_test
		'glalphafunc gl_lequal,10/256
		If icombo=1 Or icombo=2 Or icombo=4 Then tlight=1 Else tlight=0
      If tlight=1 Then glenable gl_lighting
      'gldisable gl_blend
      If icombo<>5 Then 
        'glscalef(sx1/sy1,1,1)
        glscalef(sx2,sy2,sz2)
      EndIf   
		glenable gl_cull_face
		glcullface gl_back
		'If objtype="3ds" Then
         If icombo=2 Then
            If ifunc=7 Or ifunc=8 Then
            	draw3dsptrsmooth(@myobj20)
            Else 
            	draw3dsptrsmooth(@myobj2)
            EndIf
         ElseIf icombo=1 Or icombo=3 Then    
         	If ifunc=7 Or ifunc=8 Then
         	 draw3dsptr(@myobj20)
         	Else
         	 draw3dsptr(@myobj2)
         	EndIf	
         ElseIf icombo=5 Then
         	glbindtexture(gl_texture_2d,persotext)
         	If ifunc=7 Or ifunc=8 Then
         		draw3dsptrsmooth(@myobj0)
         	Else 
         		draw3dsptrsmooth(@myobj)
         	EndIf
         Else
         	gldisable gl_texture_2d
         	gldisable gl_lighting
         	If ifunc=7 Or ifunc=8 Then 
         		draw3dswire(@myobj20)
         	Else 
         		draw3dswire(@myobj2)
         	EndIf
         EndIf
		'EndIf
		'If objtype="obj" Then glCallList objlist
		gldisable gl_cull_face
		
		x=int(x):y=int(y):z=int(z)
		o1=Int(o1):o2=Int(o2):o3=Int(o3)
		gldisable gl_lighting
		gldisable gl_texture_2d
		glcolor4f(1,1,0,1)
		glpushmatrix
		gldrawtext("fps "+Str(Int(fps)),50,30,1)
		glcolor4f(1,1,1,1)
		gldrawtext("x="+Str(Int(x)),50,50,1)
		gldrawtext("y="+Str(Int(y)),50,70,1)
		gldrawtext("z="+Str(Int(z)),50,90,1)
		gldrawtext("o1="+Str(Int(o1)),50,110,1)
		gldrawtext("o2="+Str(Int(o2)),50,130,1)
		gldrawtext("o3="+Str(Int(o3)),50,150,1)
		gldrawtext("poly "+Str(myobj.polygons_qty),50,180,1)
		If Abs(auxvar)>0.000001 Then gldrawtext("auxvar="+Str(auxvar),50,420,1)			
		If Abs(auxvar2)>0.000001 Then gldrawtext("auxvar2="+Str(auxvar2),50,440,1)			
		If Abs(auxvar3)>0.000001 Then gldrawtext("auxvar3="+Str(auxvar3),50,460,1)			
		If auxtext<>"" Then gldrawtext("auxtext="+Str(auxtext),50,400,1)			

      If Abs(auxvar)+Abs(auxvar2)+Abs(auxvar3)<0.000001 And auxtext="" Then
      	gldrawtext("keys :",50,400,1.1)
      	gldrawtext("B,N,Z,S,A,E ",50,420,1.1)
      	gldrawtext("arrows/",50,440,1.1)
      	gldrawtext("pageup/pagedown",50,460,1.1)
      EndIf
      'gldrawtext(status,xmax/2-270,ymax-105,1)'viseme
		glcolor3f(1,1,0)
      For i=1 To nmsg
      	gldrawtext(Left(lmsg(i),30),xmax/2-270,ymax-105-18*i,1)
      Next
		glcolor3f(1,1,0)
		gldrawtext(Left(msg,min2(100,InStr(msg,Chr(13))-1)),xmax/2-270,ymax-85,1)
		glcolor3f(0.6,1,1)
		gldrawtext(Left(Mid(msg,InStr(msg,"> ")),100),xmax/2-270,ymax-65,1)

End Sub
Sub subhelp()
Dim As String msg,cr
cr=Chr(13)
	msg="F1 => help"+cr
	msg+=cr+"If guitestkey(vk_left) Then o1+=dxyz"
	msg+=cr+"If guitestkey(vk_right) Then o1-=dxyz"
	msg+=cr+"If guitestkey(vk_up) Then o2+=dxyz"
	msg+=cr+"If guitestkey(vk_down) Then o2-=dxyz"
	msg+=cr+"If guitestkey(vk_prior) Then o3+=dxyz"
	msg+=cr+"If guitestkey(vk_next) Then o3-=dxyz"
	msg+=cr+"If guitestkey(vk_b) Then x+=dxyz"
	msg+=cr+"If guitestkey(vk_n) Then x-=dxyz"
	msg+=cr+"If guitestkey(vk_a) Then y+=dxyz"
	msg+=cr+"If guitestkey(vk_e) Then y-=dxyz"
	msg+=cr+"If guitestkey(vk_z) Then z+=dxyz"
	msg+=cr+"If guitestkey(vk_s) Then z-=dxyz"+cr
	'msg+=cr+"ctrl+P => savedatapack (pack data to one line)"
	'msg+=cr+"ctrl+U => savedataunpack (unpack packdata)"
	msg+=cr+"ctrl+J => save data to javascript"
	guinotice msg	
End Sub

