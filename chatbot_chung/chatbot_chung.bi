'chatbot_chung , keywords chatbot 
'a program by NGUYEN.Chung  (freeware 2014)
'.bi file

Dim Shared As Integer debug=3
Dim Shared As Integer File
Sub notice(ByRef msg As string,ByRef title As String ="notice")
	If debug>=3 Then guinotice(msg,title)
End Sub
Sub confirm(ByRef msg As string,ByRef title As string,ByRef resp As String)
   guiconfirm(msg,title,resp)
End Sub 

Dim Shared As Integer i,j,k,iaux,winx,winy,windx,windy
Dim Shared As Double  aux,auxvar,auxvar2,auxvar3
Dim Shared As String resp,msg,msg0,outmsg,oldmsg,thatmsg,auxtext
Dim Shared As Double timer0,timer1,timer2



'Dim Shared As ZString*20000000 text
Dim Shared As ZString Ptr ptext
Dim Shared As Integer ltext,ltext0,itext,erreur,countsyns,botsize,botchanged
'Dim Shared As String fic
'fic="aiml\alice.aiml"


Const As Integer naiml=150000,nword=80,nstar=40,nlevel=20,nthat=40,nallword=30000
Const As Integer nvar=10000,nli=400,ninput=40,nsyns=200000,nsyns2=30
Dim Shared As String  patterns(naiml),templates(naiml),starpatt(naiml)
Dim Shared As String  starpatt2(naiml),startemp(naiml),topics(naiml),thats(naiml)
'ReDim Shared As String pattwords(naiml,nword)
ReDim Shared As String inputs(ninput,nword)
ReDim Shared As String synonyms(nsyns,nsyns2),lsynonyms(nsyns,nsyns2)
ReDim Shared As String allwords(nallword),allwordspatt(nallword)
ReDim Shared As Integer isynonyms(nsyns),ipatterns(naiml),iwords(nallword)
ReDim Shared As Single  testpattern(naiml)
ReDim Shared As Integer testnword(naiml),testiword(naiml)
Dim Shared As Integer isyns,iaiml,iallword,istar,itopic
Dim Shared As ZString*20000 mytext,myword,template,texts(nlevel)
Dim Shared As ZString*20000 mytexts(nlevel),textlearn,text,text2
Dim Shared As uchar   ktext,ktext0,mychar(256),mychar2(256)
Const As String Crlf=Chr(13)+Chr(10)
Const As uchar   top=254,star=253,star_=16,lf=10,vk_cr=13,that_=17,temp_=18
Dim Shared As Single xweight(1000),tweight(naiml)
For i=0 To 1000
	xweight(i)=Sqr(i)
Next
For i=0 To naiml
	tweight(i)=1
Next
Function weight(i As Integer)As Single
	Return xweight(Int(max2(0,min2(1000,i))))
End Function
For i=0 To 256
	If (InStr(" ,;:!?./$&�""'([-�_��@)]=+*_<>{}",Chr(i))<1) and _
	   (Not(i>=Asc("a") And i<=Asc("z"))) And _ 
	   (Not(i>=Asc("A") And i<=Asc("Z"))) And _ 
	   (InStr("1234567890",Chr(i))<1) Then 
	   	mychar(i)=Asc(" ")
	   	mychar2(i)=Asc(" ")
	Else
	      If InStr(",;:?",Chr(i))<1 Then 
	      	mychar(i)=Asc(LCase(Chr(i)))
	      Else
	      	mychar(i)=Asc(" ")
	      EndIf 	
	      mychar2(i)=Asc(Chr(i))   	
	EndIf    	
Next i
mychar(Asc("*"))=star
mychar(Asc("_"))=star_
mychar(lf)=Asc(" ") '32 'line feed
mychar(vk_cr)=Asc(" ")

Dim Shared As Integer nparse=20000,iparse,iparse2
Dim Shared As String textparse(nparse)
Sub parse(ByRef text0 As String,ByRef str1 As String,maxlen As Integer=999)
Dim As Integer i,j,k,l
Dim As String text
text=text0
l=Len(str1)
iparse=0:k=1
For i=1 To nparse
  j=InStr(text,str1)
  If j<=0 Then
  	 If text<>"" Then
  	 	iparse+=1
   	textparse(iparse)=text
  	 EndIf
  	 Exit For
  EndIf
  If j>1 Then 
    iparse+=1
    textparse(iparse)=Left(text,j-1)
  EndIf   
  'text=Mid(text,j+l)
  k+=j+l-1
  text=Mid(text0,k,maxlen)
Next
End Sub
Sub parsei2(ByRef text0 As String,ByRef str1 As String,maxlen As Integer=999)
Dim As Integer i,j,k,l
Dim As String text
text=text0
l=Len(str1)
iparse2=0:k=1
For i=1 To nparse
  j=InStr(text,str1)
  If j<=0 Then
  	 If text<>"" Then
  	 	iparse2+=1
  	 EndIf
  	 Exit For
  EndIf
  If j>1 Then 
    iparse2+=1
  EndIf   
  'text=Mid(text,j+l)
  k+=j+l-1
  text=Mid(text0,k,maxlen)
Next
End Sub
Sub replace(ByRef text As String,ByRef str1 As String, _  
	              ByRef str2 As String)
Dim As Integer i,j,k,l
Dim As String text2
text2=""
j=1:l=Len(str1)
If l<1 Then Exit Sub  
For i=1 To 2000
	k=InStr(j,text,str1)
	If k<1 Then Exit For 
	text2+=Mid(text,j,k-j)+str2
	j=k+l
Next
text2+=Right(text,Len(text)-j+1)
text=text2
End Sub
Sub swaptext(ByRef text As String,ByRef str1 As String, _  
	          ByRef str2 As String)
If str1="" Or str2="" Then Exit Sub 
replace(text,str1,"$$myswapstring_")
replace(text,str2,str1)
replace(text,"$$myswapstring_",str2)
End Sub 
Sub replace2(ByRef text As String,ByRef str1 As String, _  'by words
	           ByRef str2 As String)
Dim As String text2,key,key1,lcasetext,lcasestr1
Dim As Integer i,len1,len2,len0
If str1="" Or str2="" Or text="" Then Exit Sub 
len1=Len(str1):len2=Len(str2):len0=Len(text)
i=0:text2=""
key=" "
lcasetext=LCase(text):lcasestr1=LCase(str1)
While i<=len0
	If InStr(" ,;?.:!<>/&""'([-_)]+=",key)>0 Then
		If Mid(lcasetext,i+1,len1)=lcasestr1 Then
			key1=Mid(text,i+1+len1,1)
			If InStr(" ,;?.:!<>/&""'([-_)]+=",key1)>0 Or (i+1+len1)>len0 Then
				text2+=str2
				i+=len1
			Else
				text2+=str1
				i+=len1
			EndIf  
		EndIf
	EndIf
	i+=1
	key=Mid(text,i,1)
	text2+=key
Wend 
text=text2
End Sub 
Sub swaptext2(ByRef text As String,ByRef str1 As String, _  
	           ByRef str2 As String)
Dim As String text2,key,key1,lcasetext,lcasestr1,lcasestr2
Dim As Integer i,len1,len2,len0
If str1="" Or str2="" Or text="" Then Exit Sub 
len1=Len(str1):len2=Len(str2):len0=Len(text)
i=0:text2=""
key=" "
lcasetext=LCase(text):lcasestr1=LCase(str1):lcasestr2=LCase(str2)
While i<=Len0
	If InStr(" ,;?.:!<>/&""'([-_)]+=",key)>0 Then
		If Mid(lcasetext,i+1,len1)=lcasestr1 Then
			key1=Mid(text,i+1+len1,1)
			If InStr(" ,;?.:!<>/&""'([-_)]+=",key1)>0 Or (i+1+len1)>len0 Then
				text2+=str2
				i+=len1
			Else
				text2+=str1
				i+=len1
			EndIf  
		ElseIf Mid(lcasetext,i+1,len2)=lcasestr2 Then
			key1=Mid(text,i+1+len2,1)
			If InStr(" ,;?.:!<>/&""'([-_)]+=",key1)>0 Or (i+1+len2)>len0 Then
				text2+=str1
				i+=len2
			Else
				text2+=str2
				i+=len2
			EndIf 	
		EndIf
	EndIf
	i+=1
	key=Mid(text,i,1)
	text2+=key
Wend 
text=text2
End Sub 
Function ismono(ByRef text As String) As Integer
	If Right(text,1)<>"s" Then Return 1
	Return 0
End Function
Function ispoly(ByRef text As String) As Integer
	If Right(text,1)="s" Then Return 1
	Return 0
End Function
Function lmono(ByRef text0 As String) As String
Dim As Integer i,j
Dim As String text,text2
Dim As String txt
text2=LCase(Right(text0,1))
If InStr("abcdefghijklmnopqrsuvwxyz0123456789",text2)>0 Then
   text2="":text=text0
Else
	text=Left(text0,Len(text0)-1)
EndIf
If Right(text,1)<>"s" Then Return text+text2
If Right(text,2)="ss" Then Return text+text2
If Right(text,2)<>"es" Then Return Left(text,Len(text)-1)+text2
txt=Mid(text,Len(text)-2,1)
If InStr("sx",txt)>0 Then Return Left(text,Len(text)-2)+text2
Return Left(text,Len(text)-1)+text2
End Function
Function lpoly(ByRef text0 As String) As String
Dim As Integer i,j
Dim As String text,text2
Dim As String txt
text2=LCase(Right(text0,1))
If InStr("abcdefghijklmnopqrsuvwxyz0123456789",text2)>0 Then
   text2="":text=text0
Else
	text=Left(text0,Len(text0)-1)
EndIf
If Right(text,1)="s" Then Return text+text2
txt=Right(text,1)
If InStr("sx",txt)>0 Then Return text+"es"+text2
Return text+"s"+text2
End Function
Sub loadSynonyms(ByRef ficsave As String="data\AIMLsynonyms.txt")
Dim As Integer i,j,k,k0,imytext
Dim As String syn1,syn2,syn0,lsyn
printgui("win.msg","loading synonyms...")
guiscan
ReDim isynonyms(nsyns),synonyms(nsyns,nsyns2),lsynonyms(nsyns,nsyns2)
msg=""
file=FreeFile
Open ficsave For Binary Access Read As #file
ltext0=Lof(file)
ptext=Allocate(ltext0+4)
If Not Eof(file) Then (*ptext)=Input(ltext0,file)
Close #file
ltext=Len((*ptext))
isyns=0
itext=0:erreur=0
mytext="":imytext=0
countsyns=0
While itext<ltext And erreur=0
	ktext=(*ptext)[itext]
	If ktext=vk_cr Then
		itext+=1 'skip lf
		mytext[imytext]=0
		If isyns<nsyns Then
			isyns+=1
			k=InStr(mytext,"/")
			isynonyms(isyns)=max2(0,min2(nsyns2,Val(Left(mytext,k-1))))
			For j=1 To isynonyms(isyns)
				countsyns+=1
				k0=k
		      k=InStr(k+1,mytext,"/")
		      If k>=1 Then
		      	synonyms(isyns,j)=mid(mytext,k0+1,k-k0-1)
		      else
		         synonyms(isyns,j)=Mid(mytext,k0+1)
		      EndIf
		      lsyn=LCase(Trim(synonyms(isyns,j)))
		      replace(lsyn," ","-")
		      replace(lsyn,"'","")
		      replace(lsyn,"""","")
		      replace(lsyn,"_","-")
		      replace(lsyn,".","")
		      replace(lsyn,",","")
		      lsynonyms(isyns,j)=lsyn
		      If isyns<22 Then msg+="/"+lsynonyms(isyns,j)
			Next j   
			msg+=crlf
		   imytext=0
		Else
			erreur+=1
			Exit While
		EndIf 	
	Else
		'mytext+=Chr(ktext)
		mytext[imytext]=ktext
		If imytext<10000 Then imytext+=1 Else erreur+=1
	EndIf
	itext+=1
Wend 
DeAllocate(ptext)
'guinotice "isyns="+Str(isyns)+"/"+synonyms(1,1)+"/"+synonyms(1,2)
msg=Str(countsyns)+"/"+Str(isyns)+" synonyms loaded"+crlf+msg
printgui("win.msg",msg)
msg0=""
End Sub
Dim Shared As Integer nsynprolog=300000
ReDim Shared As Integer ksynprolog(1),psynprolog(1)
ReDim Shared As String synprolog(1)
Sub loadSynonymsprolog(ByRef ficsave As String="data\prologsyn.txt")
Dim As Integer i,j,k,k0,imytext,iprolog,kprolog,l,n,p
Dim As String syn1,syn2,syn0,lsyn,li
printgui("win.msg","loading synonymsprolog...")
guiscan
ReDim isynonyms(nsyns),synonyms(nsyns,nsyns2),lsynonyms(nsyns,nsyns2)
ReDim ksynprolog(nsynprolog),synprolog(nsynprolog),psynprolog(nsynprolog)
msg=""
file=FreeFile
Open ficsave For Binary Access Read As #file
ltext0=Lof(file)
ptext=Allocate(ltext0+4)
If Not Eof(file) Then (*ptext)=Input(ltext0,file)
Close #file
ltext=Len((*ptext))-1
isyns=0
itext=0:erreur=0
mytext="":imytext=0
countsyns=0
iprolog=0:kprolog=0
While itext<ltext And erreur=0
	ktext=(*ptext)[itext]
	If ktext=vk_cr Then
		itext+=1 'skip lf
		mytext[imytext]=0
		li=Left(mytext,imytext)
		If iprolog<nsynprolog Then
			iprolog+=1
			k=InStr(li,"(")
			li=Mid(li,k+1)
			k=InStr(li,",")
			ksynprolog(iprolog)=Val(Left(li,k-1))
			k=InStr(li,"'")
			li=Mid(li,k+1)
			k=InStr(li,"'")
			synprolog(iprolog)=Left(li,k-1)
			If InStr(synprolog(iprolog)," ")>0 Then
				iprolog-=1
			Else
				Dim As Integer test=0,key=ksynprolog(iprolog)
				For l=1 To iprolog-1
					If key=ksynprolog(l) Then
						test=1
						psynprolog(iprolog)=psynprolog(l)
						Exit For
					EndIf
				Next
				auxvar=key
				If test=0 Then
					isyns+=1:If isyns>=nsyns Then erreur+=1
					psynprolog(iprolog)=isyns
				EndIf
			EndIf
		Else
			erreur+=1
			Exit While
		EndIf
		imytext=0
	Else
		'mytext+=Chr(ktext)
		mytext[imytext]=ktext
		If imytext<1000 Then imytext+=1 Else erreur+=1
	EndIf
	itext+=1
	If (itext Mod 100000)=10 Then printgui("win.msg",Str(itext)+"/"+Str(ltext)):guiscan  
Wend
For i=1 To iprolog
	j=psynprolog(i)
	If j<nsyns Then
		k=isynonyms(j)+1
		If k<=nsyns2 Then
			isynonyms(j)=k
			synonyms(j,k)=synprolog(i)
		   lsyn=LCase(Trim(synonyms(j,k)))
		   replace(lsyn," ","-")
		   replace(lsyn,"'","")
		   replace(lsyn,"""","")
		   replace(lsyn,"_","-")
		   replace(lsyn,".","")
		   replace(lsyn,",","")
		   lsynonyms(j,k)=lsyn
		EndIf
	EndIf
Next
n=0
For i=1 To isyns
	If isynonyms(i)>1 Then
		n+=1
		isynonyms(n)=isynonyms(i)
		For j=1 To isynonyms(i)
			synonyms(n,j)=synonyms(i,j)
			countsyns+=1
		Next
	EndIf
Next
isyns=n
guinotice "isyns="+Str(isyns)
DeAllocate(ptext)
'guinotice "isyns="+Str(isyns)+"/"+synonyms(1,1)+"/"+synonyms(1,2)
msg=Str(countsyns)+"/"+Str(isyns)+" synonymsprolog loaded"+crlf+msg
printgui("win.msg",msg)
msg0=""
End Sub
Declare Function getiallword(ByRef text As String)As Integer 
Function isynonym(ByRef text0 As String) As Integer 
Dim As Integer i,j,k,l
Dim As String text
text=LCase(text0)
l=Len(text)
If l<2 Then Return 0
For i=1 To isyns
	For j=1 To isynonyms(i)
		If text=lsynonyms(i,j) Then
	      Return i		
		EndIf
	Next
Next
Return 0
End Function
Function getsynonym1(ByRef text0 As string) As String
Return text0
Dim As Integer i,j,k,l,n,p
Dim As String text2
text=LCase(text0)
l=Len(text)
If l<2 Then Return text0
i=isynonym(text)
If i>0 Then
	j=getiallword(lsynonyms(i,1))
	If j>0 Then
		Return synonyms(i,1)
		'text2=allwords(iwords(j))
		'Return UCase(Left(text2,1))+Mid(text2,2)
	EndIf
EndIf
If ismono(text) Then
 text=lpoly(text)
 i=isynonym(text)
 If i>0 Then
	j=getiallword(lsynonyms(i,1))
	If j>0 Then
		Return lmono(synonyms(i,1))
		'text2=lmono(allwords(iwords(j)))
		'Return UCase(Left(text2,1))+Mid(text2,2)
	EndIf
 EndIf
Else
 text=lmono(text)
 i=isynonym(text)
 If i>0 Then
	j=getiallword(lsynonyms(i,1))
	If j>0 Then
		Return lpoly(synonyms(i,1))
		'text2=lpoly(allwords(iwords(j)))
		'Return UCase(Left(text2,1))+Mid(text2,2)
	EndIf
 EndIf
EndIf
Return text0
End Function 
Function getsynonym(ByRef text As string) As String
Return text
Dim As Integer i,j,k,l,n,p
l=Len(text)
If l<2 Then Return text
i=isynonym(text)
If i>0 Then
	If getiallword(lsynonyms(i,1))<>0 Then Return synonyms(i,1)
EndIf
For i=1 To isyns
	For j=1 To isynonyms(i)
		If text=Left(lsynonyms(i,j),l) Then
			p=getiallword(lsynonyms(i,1))
			If p<>0 Then
				Return synonyms(i,1)		
			Else
				Exit For
			EndIf
		EndIf
	Next
Next
Return text
End Function
Dim Shared As String rndsynonym(100)
Function getrndsynonym(ByRef text0 As string) As String
Dim As Integer i,j,k,l,n,p
text=text0
l=Len(text)
If l<2 Then Return text
text=lmono(text)
i=isynonym(text)
If i>0 And Rnd<0.5 Then
	j=0
	For k=1 To isynonyms(i)
		If getiallword(lsynonyms(i,k))<>0 Then
			j+=1:rndsynonym(j)=synonyms(i,k)
			If j>=100 Then Exit for
		EndIf
	Next
	If j>0 Then
		If ismono(text0) Then
			Return rndsynonym(Int(1+Rnd*j))
		Else
			Return lpoly(rndsynonym(Int(1+Rnd*j)))
		EndIf
	EndIf
EndIf
Return text0
End Function
Function formatrndsyn(text0 As String)As String
Dim As Integer i,j,k
Dim As String text=""
'Return text0
parse(text0," ")
For i=1 To iparse
	text+=getrndsynonym(textparse(i))+" "
Next
Return Trim(text)
End Function
Dim Shared As Integer nmsg=18,nbwords(nword)
Dim Shared As String lmsg(nmsg),inputword(nword)
Sub testparse(ByRef text0 As string)
Dim As Integer i,j,k,l,p,n
parse(text0," ")
For i=1 To nmsg
	lmsg(i)=""
Next 
j=0
For i=1 To nmsg 
	j+=1
	If i<=iparse Then
		lmsg(i)=textparse(j)
		If j>=iparse Then Exit for
	EndIf
Next
End Sub
Function formatinput(text0 As String) As String 
Dim As String text
text=LCase(text0)
replace(text,"_","-")
replace(text,""""," ")
replace(text,"'"," ")
replace(text,","," ")
replace(text,";"," ")
replace(text,":"," ")
replace(text,"!"," ")
replace(text,"?"," ")
replace(text,"."," ")
replace(text,"("," ")
replace(text,")"," ")
replace(text,"  "," ")
Return Trim(text) 
End Function
Dim Shared As Integer nouttemplate=30000,iouttemplate(nouttemplate)
Dim Shared As Integer testproc=0,teststar=0,testsrai=0,testnoresponse=0
Dim Shared As String msgprocess,msgmsg,topicprev,topicnext
Dim Shared As single ktopic=0
Declare Function formatcondition(ByRef text0 As String)As String
Sub processinputstar(ByRef text0 As string)
Dim As Integer i,j,k,l,p,n,nbword,test,kk
Dim As String msg,msg2,patt,patt2,temp,text,startext
text=text0
kk=0
For i=1 To istar
   k=Len(starpatt(i)):test=1
   If k>0 Then test=(Left(text,k)=starpatt(i))
   If test Then
      l=Len(starpatt2(i)):test=1
   	If l>0 Then test=(Right(text,l)=starpatt2(i))
   	If test Then
   			n=Len(text)-l-k
   			startext=Mid(text,k+1,n)
   			If startext<>"" Then
   				testproc=1
   				kk+=1:If kk>nouttemplate Then Exit For
			      iouttemplate(kk)=i
			      if rnd<0.6 then Exit for
   			EndIf
   	EndIf
   EndIf
Next
If testproc=1 Then 
	i=iouttemplate(1+Int(Rnd*kk*0.999))
	msg=startemp(i)
	replace(msg,"/*/",startext)
	'outmsg=msg
	'auxtext=starpatt(i)+"*"+starpatt2(i)+"/"+Right(startemp(i),55)
	For j=1 To 30
	 If InStr(msg,"/rnd/")>0 Then
	 	k=InStr(msg,"/rnd/")
	 	l=InStr(msg,"/rnd2/")
	 	If l<1 Then l=Len(msg)
	 	Var msg1=Mid(msg,k,l-k)
	 	Var msg2=Mid(msg,l+6)
		replace(msg1,"/rnd/","")
		replace(msg1,"  /li/","/li/")
		replace(msg1," /li/","/li/")
		replace(msg1,"/li2/  ","/li2/")
		replace(msg1,"/li2/ ","/li2/")
		replace(msg1,"/li2/","")
		parse(Trim(msg1),"/li/")
		msg1=textparse(Int(Rnd*iparse*0.999)+1)
		'msg+="/"+Str(iparse)+"/"
		msg=Left(msg,k-1)+Trim(msg1)+msg2
	 Else
		Exit For
	 EndIf
	Next j
	If testsrai=1 Then msg=formatcondition(msg)
	outmsg=msg
	replace(outmsg,"/br/",crlf)
	'msg+=outmsg
	patt=starpatt(i)+startext+starpatt2(i)
	replace(patt,"<bot/>","Helen")
	If Len(outmsg)<0.65*Len(patt) Then
		outmsg=patt+" "+outmsg 
	EndIf
   thatmsg=patt:'auxtext+="/thatmsg="+thatmsg

   oldmsg=msg
	'printgui("win.msg",patt+crlf+"> "+msg)
	msgprocess=msg
	msgmsg=patt
	''printgui("win.msg",patterns(j)+"/"+msg2)
EndIf
End Sub
Declare Sub setvar(ByRef varname As String,ByRef varvalue As String)
Sub formatconst(ByRef msg As String)
	replace(msg,"/botname/","Helen")
	replace(msg,"/botmaster/","Chung")
	replace(msg,"/date/",Date)
	replace(msg,"/size/",Str(botsize))		
End Sub
Sub setformatconst()
	setvar("botname","Helen")
	setvar("botmaster","Chung")
	setvar("date",Date)
	setvar("size",Str(botsize))	
	setvar("vocabulary",Str(iallword))	
End Sub
Dim Shared As Single starrandom=1,starrandom2=1
Dim Shared As Single kj(nallword)
Dim Shared As Integer ntest,ntest0,ntestsrai,nteststar
Sub processinput0(ByRef text0 As string)
Dim As Integer i,j,k,l,p,n,nbword,q,r
Dim As String msg,msg2,allpatt,inword,inword2,patt
testproc=0
teststar=0
If Rnd<0.5*starrandom Then
	teststar=1
	processinputstar(text0)
	nteststar+=1
	If testproc=1 Then
		starrandom2=max(0.12,starrandom/1.4)
		Exit Sub 
	EndIf
Else
	starrandom2=min(1.75,starrandom+0.1)
EndIf
parse(text0," ",99)
If iparse=0 Then Exit Sub 
j=0:k=0
For i=1 To min2(iparse,nword) 
	inword=textparse(i)
	j=getiallword(inword)
	If j=0 Then 
	  inword=LCase(getsynonym(inword))
	EndIf  
	k+=1:If k<=nword Then inputword(k)=inword:nbwords(k)=1
	If i<iparse Then
		inword=LCase(textparse(i)+"-"+textparse(i+1))
	   j=getiallword(inword)
	   If j=0 Then 
	      inword2=LCase(getsynonym(inword))
	      If inword2<>inword Then
         	k+=1:If k<=nword Then inputword(k)=inword2:nbwords(k)=2 	
	      EndIf
      Else 
       	k+=1:If k<=nword Then inputword(k)=inword:nbwords(k)=2
	   EndIf  
	EndIf
Next
For i=1 To iaiml
	testpattern(i)=0
	testiword(i)=0
	testnword(i)=0
Next
k=min2(k,nword)'iparse,nword)
nbword=min2(iparse,nword)
For i=1 To k
   j=getiallword(inputword(i))
	If j<>0 Then
		allpatt=""'allwordspatt(iwords(Abs(j)))
		p=Abs(j)
		l=Len(inputword(i))
		iparse=0
		For n=1 To 100
		 If p<=iallword Then
			If inputword(i)=Left(allwords(iwords(p)),l) Then
				Var iparse00=iparse
				allpatt+=allwordspatt(iwords(p))
				parsei2(allwordspatt(iwords(p)),"/",20)
				iparse+=iparse2
				'allpatt+=allwordspatt(iwords(p))
				'parsei2(allpatt,"/",20)
				'iparse=iparse2
				r=max2(1,Len(allwords(iwords(p))))
	         If l=r Then
	         	r=2
	         Else
	           	r=(4+l)/(4+r)
	         EndIf 
	         For q=iparse00+1 To iparse
				  kj(q)=r
				Next  
			   p+=1
			Else
				Exit For 
			EndIf
		 Else
		 	Exit For
		 EndIf
		Next n 
		parse(allpatt,"/",20)
		'msg2=allwords(iwords(Abs(j)))+"/"+allpatt'allwordspatt(iwords(Abs(j)))
	Else
		iparse=0
	EndIf
	If iparse>0 Then
		For p=1 To iparse
		  n=max2(1,min2(iaiml,Int(Val(textparse(p))+0.1)))
		  If testiword(n)<i Then 
			 testiword(n)=i
			 testnword(n)+=1
			 If kj(p)>0.87 Then
				testpattern(n)+=kj(p)*weight(4*nbwords(i)+Len(inputword(i)))*(1+Rnd*0.3)*Sqr(0.507+15/(40+Len(patterns(n))))
			 Else
				testpattern(n)+=kj(p)*0.65*weight(4*nbwords(i)+Len(inputword(i)))*(1+Rnd*0.3)*sqr(0.507+15/(40+Len(patterns(n))))
			 EndIf
			 If testnword(n)=1 Then 
			  If Abs(Len(patterns(n))-Len(text0))<1+0.1*Len(text0) Then testpattern(n)+=1
			  If Abs(Len(patterns(n))-Len(text0))<1 Then 
              testpattern(n)+=1
			    If thatmsg<>"" Then
			 	   If thats(n)=thatmsg Then
			 	      testpattern(n)+=1.2:'auxtext+="!!"+thatmsg
			 	   EndIf
			    EndIf 		 	
			  EndIf
			  If patterns(n)=text0 Then
             testpattern(n)+=1.2
			  EndIf
			  If thats(n)<>"" And thats(n)<>thatmsg Then testpattern(n)-=1.2
			  If topicprev<>"" Then
			  	 If topics(n)=topicprev Then testpattern(n)+=ktopic*0.12
			  EndIf
			 EndIf
		  EndIf 	
		Next
	EndIf
Next
For i=1 To iaiml
	testpattern(i)*=tweight(i)
	'tweight(i)=min(2.0,tweight(i)*1.1)
	tweight(i)=min(3.0,tweight(i)+0.05*(3.0-tweight(i)))
	If testnword(i)=nbword Then
        testpattern(i)*=1.2
	EndIf
Next
Var xtest=0.01
j=0:ntest=0
For i=1 To iaiml
  If testpattern(i)>0.01 Then
  	ntest+=1
	If testpattern(i)>xtest Then
		xtest=testpattern(i)
		j=i
	EndIf
  EndIf 	
Next
If j>0 Then
 parse(patterns(j),"")
 If iparse>nbword Then  
	k=0
	Var dx=xtest*0.3
	For i=1 To iaiml
		If Abs(testpattern(i)-xtest)<dx Then
			'If topicprev="" Or topics(i)=topicprev Then 
			  k+=1:If k>nouttemplate Then Exit For
			  iouttemplate(k)=i
			'EndIf  
		EndIf
	Next
	j=iouttemplate(1+Int(Rnd*k*0.999))
 endif 	
EndIf
If j>0 Then
	'auxtext+="/thats="+thats(j)
	'auxtext=topicprev+"/"+topics(j)
	If topicprev<>"" And topics(j)=topicprev Then
		tweight(j)=max(0.3*40/(40+Len(patterns(j))),tweight(j)/1.1)
		topicnext=topicprev
	Else 
		tweight(j)=max(0.3*40/(40+Len(patterns(j))),tweight(j)/1.4)
	EndIf
	msg=templates(j)
	/'replace(msg,"/botname/","Helen")
	replace(msg,"/botmaster/","Chung")
	replace(msg,"/date/",Date)
	replace(msg,"/size/",Str(botsize))'/
	'outmsg=msg
	For p=1 To 30
	 If InStr(msg,"/rnd/")>0 Then
	 	k=InStr(msg,"/rnd/")
	 	l=InStr(msg,"/rnd2/")
	 	If l<1 Then l=Len(msg)
	 	Var msg1=Mid(msg,k,l-k)
	 	Var msg2=Mid(msg,l+6)
		replace(msg1,"/rnd/","")
		replace(msg1,"  /li/","/li/")
		replace(msg1," /li/","/li/")
		replace(msg1,"/li2/  ","/li2/")
		replace(msg1,"/li2/ ","/li2/")
		replace(msg1,"/li2/","")
		parse(Trim(msg1),"/li/")
		msg1=textparse(Int(Rnd*iparse*0.999)+1)
		'msg+="/"+Str(iparse)+"/"
		msg=Left(msg,k-1)+Trim(msg1)+msg2
	 Else
		Exit For
	 EndIf
	Next p
	If testsrai=1 Then msg=formatcondition(msg)
	outmsg=msg
	replace(outmsg,"/br/",crlf)
	'msg+=outmsg
	/'parse(outmsg," ")
	outmsg=""
	For i=1 To iparse
		If Rnd<01.5 Then
			outmsg+=getsynonym1(textparse(i))+" "
		Else
			outmsg+=textparse(i)+" "
		EndIf
	Next
	msg+="/"+outmsg '/
	If Len(outmsg)<0.65*Len(patterns(j)) Then
		outmsg=patterns(j)+" "+outmsg 
	   replace(outmsg,"<bot/>","Helen")
	EndIf
EndIf
If j<=0 Then
	If teststar=0 Then
		teststar=1
		testproc=0
		processinputstar(text0)
		If testproc=1 Then Exit Sub 
	EndIf
EndIf
oldmsg=msg
If j>0 Then
	patt=patterns(j)
	replace(patt,"<bot/>","Helen")
	msgprocess=msg
	msgmsg=patt
	'printgui("win.msg",patt+crlf+"> "+msg)
	'printgui("win.msg",patterns(j)+"/"+msg2)
   thatmsg=patt:'auxtext+="/thatmsg="+thatmsg
Else
   If rnd<0.35 Then
   	msg="i don't see what you mean"
   ElseIf Rnd<0.5 Then 
   	msg="that's too complicated for me"
   Else
   	msg="can you be more explicit"
   EndIf
   testnoresponse=1
   oldmsg=msg
   outmsg=msg
	'printgui("win.msg","> "+msg)
	msgprocess=msg
	msgmsg=""
EndIf
End Sub
Declare Function formatoutput(ByRef text0 As string)As String
Declare Sub formatget(ByRef text As String)
Declare Sub resetvars()
Dim Shared As Integer optset=0,optthink=0
Sub processinput(ByRef text0 As string)
Dim As Integer i,j,k,n,j1,nmax=4
Dim As String text,mymsg,msgprocess0,msgprocess2
If text0="reset vars" Then
	confirm("reset aiml vars ?","confirm",resp)
	If resp="yes" Then
		resetvars()
	EndIf
EndIf
If topicprev<>topicnext Or topicprev="" Then
	ktopic=max(0.1,ktopic-0.1)
	If ktopic<0.11 Then topicprev=""
	topicnext=""
Else
	ktopic=min(1.0,ktopic+0.01)
	topicnext=""
EndIf
testnoresponse=0
mymsg=">>"+text0
ntest0=0
ntestsrai=0
nteststar=0
starrandom=starrandom2
optset=1
optthink=0
testsrai=0
auxtext=""
For n=1 To nmax 
	testsrai=0
	processinput0(text0)
	ntest0+=ntest
	msgprocess=formatoutput(msgprocess)
	'If msgmsg<>"" then mymsg+=crlf+msgmsg
	ntestsrai=(n-1)*1000
   For i=1 To 90	
	   j=InStr(msgprocess,"/srai/")
	   j1=InStr(msgprocess,"/cond0/")
	   If j>0 And (j<j1 Or j1<=0) Then
	   	ntestsrai+=1
	   	testsrai=1
	   	If Len(msgprocess)>2000 Then n=nmax+3:Exit For
	   	msgprocess0=Left(msgprocess,j-1)
	   	text=Mid(msgprocess,j+6)
	   	k=InStr(text,"/srai2/")
	   	If k>0 Then
	   		msgprocess2=Mid(text,k+7)
	   		text=Left(text,k-1)
	   		text=formatinput(text)
	   		'auxtext=""'msgprocess
	   		processinput0(text)
	   		ntest0+=ntest+1
	   	   formatget(msgprocess0)
	   	   formatconst(msgprocess0)
	   		msgprocess=formatoutput(msgprocess)
	   		msgprocess=msgprocess0+msgprocess+msgprocess2
	   		'If msgmsg<>"" Then mymsg+=crlf+msgmsg
	   	EndIf
	   ElseIf j1>0 And (j1<j Or j<=0)  Then
	   	j=j1
	   	If Len(msgprocess)>20000 Then n=nmax+3:Exit For
	   	msgprocess0=Left(msgprocess,j-1)
	   	text=Mid(msgprocess,j)
	   	k=InStr(text,"/cond2/")
	   	If k>0 Then
	   		msgprocess2=Mid(text,k+7)
	   		text=Left(text,k+6)
	   		text=formatinput(text)
	   		'auxtext=""'msgprocess
	   		text=formatcondition(text)
	   	   formatget(msgprocess0)
	   	   formatconst(msgprocess0)
	   		msgprocess=formatoutput(text)
	   		msgprocess=msgprocess0+msgprocess+msgprocess2
	   	Else
	   		n=nmax+3:Exit For 
	   	EndIf
	   Else
	   	n=n+99:Exit For',For 
	   EndIf
   Next i
   If n>99 Then
   	n-=99:If Rnd<0.35 Then Exit For
   EndIf
	j=InStr(msgprocess,"/srai/")
   If j<=0 And msgprocess<>"" And msgmsg<>"" Then Exit For  
Next n
optset=0
optthink=1
formatget(msgprocess)
formatconst(msgprocess)
formatget(msgmsg)
formatconst(msgmsg)
If n>nmax+2 Then
	outmsg="thats too much than i can say"
	outmsg=formatrndsyn(outmsg)
	msgmsg="> "+outmsg
	testnoresponse=1
ElseIf n>nmax Then
	outmsg="i dont know what to say"
	outmsg=formatrndsyn(outmsg)
	msgmsg="> "+outmsg
	testnoresponse=1
ElseIf msgmsg="" Then
	msgprocess=formatoutput(msgprocess)
	If msgprocess="" Then msgprocess="i am thinking..."
	outmsg=msgprocess
	outmsg=formatrndsyn(outmsg)
	msgmsg="> "+outmsg
ElseIf i>1 Or n>1 Then
	msgprocess=formatoutput(msgprocess)
	If msgprocess="" Then msgprocess="i am thinking..."
	msgmsg=formatoutput(msgmsg)
	msgprocess=formatrndsyn(msgprocess)
	outmsg=msgmsg+" "+msgprocess
	msgmsg=">"+msgmsg+crlf+"> "+msgprocess
Else 	
	msgprocess=formatoutput(msgprocess)
	If msgprocess="" Then msgprocess="i am thinking..."
	msgmsg=formatoutput(msgmsg)
	msgprocess=formatrndsyn(msgprocess)
	outmsg=msgmsg+" "+msgprocess
	msgmsg=msgmsg+crlf+"> "+msgprocess
EndIf
printgui("win.msg",msgmsg)
End Sub
Dim Shared As Integer nvars=2000
Dim Shared As Integer vark(nvars)
Dim Shared As String varnames(nvars),varvalues(nvars)
For i=0 To nvars
	vark(i)=i
	varnames(i)="":varvalues(i)=""
Next
Sub setvar(ByRef varname As String,ByRef varvalue As String)
Dim As Integer i,j,k,p
If varname="topic" Then
	If varvalue="" Then
		ktopic=0
	Else
		ktopic=1
	EndIf
	topicprev=LCase(Trim(varvalue))
	topicnext=topicprev
EndIf
k=-1
For i=0 To nvars
	If varnames(i)=varname Then
		k=vark(i)
		For j=0 To nvars
			If vark(j)<k Then vark(j)+=1
		Next
		vark(i)=0
		varvalues(i)=varvalue
		Exit Sub
	EndIf 
Next
p=-1
For j=0 To nvars
	vark(j)+=1
	If vark(j)>p Then
		p=vark(j)
		k=j
	EndIf
Next
If k<0 Then k=0
vark(k)=0
varnames(k)=varname
varvalues(k)=varvalue	
End Sub
Function getvar(ByRef varname As String)As String
Dim As Integer i,j,k
k=-1
For i=0 To nvars
	If varnames(i)=varname Then
		k=vark(i)
		For j=0 To nvars
			If vark(j)<k Then vark(j)+=1
		Next
		vark(i)=0
		Return varvalues(i)
	EndIf 
Next
Return varname
End Function 
Function formatcondition(ByRef text0 As String)As String
Dim As Integer i,j,k,n,p,i2
	Var text=text0,text2="",text1=""
	For p=1 To 90
	  i=InStr(text,"/cond0/")
	  If i<=0 Then text2+=text:Exit For
		 text2+=Left(text,i-1)
		 text=Mid(text,i+7)
		 i=InStr(text,"/cond2/")
		 If i<=0 Then Exit For
		 text1=Left(text,i-1)
		 text=Mid(text,i+7)
		 i=InStr(text1,"/cond1/")
		 If i<=0 Then Exit For
		 Var varname=Trim(Left(text1,i-1))
		 Var varvalue=getvar(varname)
  	 	 'auxtext+="/"+varname+":"+varvalue
		 text1=Mid(text1,i+7)
		 For n=1 To 90
		 	i=InStr(text1,"/li0/")
		 	If i<=0 Then Exit For
		 	text1=Mid(text1,i+5)
		 	i=InStr(text1,"/li1/")
		 	If i<=0 Then Exit For
		 	Var varvalue2=Left(text1,i-1)
  	 	   'auxtext+="?="+varvalue2	
		 	text1=Mid(text1,i+5)
		 	If LCase(varvalue)=varvalue2 Then
		      i=InStr(text1,"/li2/")
		      If i<=0 Then Exit For
		      text1=Left(text1,i-1)
		      text2+=text1
		      'auxtext+="="+text1
		      Exit For 		 		
		 	EndIf
		 Next
	Next
Return text2
End Function 
Dim Shared As Integer ipushvar=0,pushvarindex(90)
Dim Shared As String pushvarname(90)
Sub formatget(ByRef text As String)
Dim As Integer i,p
Dim As String text2=""
	For p=1 To 90
	  i=InStr(text,"/get0/")
	  If i<=0 Then text2+=text:Exit For
		 text2+=Left(text,i-1)
		 text=Mid(text,i+6)
		 i=InStr(text,"/get1/")
		 If i<=0 Then Exit For
		 Var varname=Trim(Left(text,i-1))
	    text=Mid(text,i+6)
		 text2+=getvar(varname)
  	 	 'auxtext+="/"+varname+":"+getvar(varname)
	Next
	text=text2
End Sub
Function formatoutput(ByRef text0 As String)As String
Dim As Integer i,j,k,n,p,i2
	Var text=text0,text2="",text1="",text3=""
	replace(text,"/br/",crlf)
	ipushvar=0
	For p=1 To 90
	  i=InStr(text,"/set0/")
	  i2=InStr(text,"/set2/")
	  If i<=0 And i2<=0 Then text2+=text:text3+=text:Exit For
	  If i<i2 And i>0 Then
		 text2+=Left(text,i-1)
		 text3+=Left(text,i-1)
		 text=Mid(text,i+6)
		 i=InStr(text,"/set1/")
		 If i<=0 Then Exit For
		 Var varname=Trim(Left(text,i-1))
		 text=Mid(text,i+6)
		 ipushvar+=1
		 pushvarname(ipushvar)=varname
		 pushvarindex(ipushvar)=Len(text2)
	  Else
	  	 i=i2
	  	 text2+=Left(text,i-1)
		 text3+=Left(text,i-1)
		 text=Mid(text,i+6)
	  	 If ipushvar>0 Then
	  	 	Var varname=pushvarname(ipushvar)
	  	 	j=pushvarindex(ipushvar)
		   formatget(text3)
	  	 	ipushvar-=1
	  	 	Var varvalue=Mid(text2,j+1)
	  	 	formatget(varvalue)
	  	 	If optset=1 Then setvar(varname,varvalue)
	  	 	'If optset=1 Then auxtext+="/"+varname+"="+getvar(varname)
	  	 EndIf
	  EndIf
	Next
	text2=text3
	replace(text2,"/set2/","")
	If optthink=1 Then 
	 text=text2:text2="":text1=text
	 n=0
	 For p=1 To 900
		i=InStr(text,"/think0/")
		j=InStr(text,"/think2/")
		If i<=0 And n<=0 Then text2+=text:Exit For 
		If n=0 Then text2+=Left(text,i-1)
      If i<j And i>0 Then
      	n+=1
      	text=Mid(text,i+8)
      EndIf
		If i>j Or i<=0 Then
         n-=1
		   text=Mid(text,j+8)
		EndIf 
	 Next
	EndIf
	text2=Trim(text2)
	Return text2
End Function
/'Dim Shared As String tagtext2,tagtext,tag,tagname,tagvalue,tagtext1,msgout
Dim Shared As String pushtag(30),pushli(30,90),pushtagname(30),pushtext(30),pushtext2(30)
Dim Shared As Integer ipushtag=0,pushnli(30),tagnli=0,otagnli=0,pushindex(30),tagindex=0
Dim Shared As String otagtext2,otagtext,otag,otagname,otagvalue,otagtext1
Dim Shared As Integer tthink=0
Sub subpushtag()
Dim As Integer i,j
	If ipushtag>=30-1 Then Exit Sub
	i=ipushtag
	pushtag(i)=tag
	pushtext(i)=tagtext
	pushtext2(i)=tagtext2
	pushtagname(i)=tagname
	pushnli(i)=tagnli
	pushindex(i)=Len(tagtext2)
	If i>0 Then 
     For j=0 To tagnli
       pushli(i,j)=pushli(i-1,j)
     Next
   EndIf   
	ipushtag+=1
End Sub
Sub subpoptag()
Dim As Integer i,j
	If ipushtag<1 Then Exit Sub
	ipushtag-=1
	i=ipushtag
	otag=pushtag(i)
	otagtext=pushtext(i)
	otagtext2=pushtext2(i)
	otagname=pushtagname(i)
	otagnli=pushnli(i)
	tagindex=pushindex(i)
End Sub
Sub nexttag()
Dim As Integer i,j,k
Dim As String tag2,text,tag1
tag="":tagname="":tagvalue=""
tagtext1=""
text=tagtext
i=Len(text)+1
tag2="/get0/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/get1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/set0/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/set1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/set2/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/think0/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/think2/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/rnd/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/rnd2/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/li/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/li0/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/li1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j
tag2="/li2/"
j=InStr(text,tag2)
If j<i And j>0 Then tag=tag2:i=j

If tag="" Then tagtext1=text:tagtext="":Exit Sub 
tagtext1=Left(text,i-1)
tagtext=Mid(text,i+Len(tag))
If InStr(tag,"0")<1 Then Exit Sub
If tag="/think0/" Then Exit Sub 

text=tagtext 
i=Len(tagtext)+1
tag1=""
tag2="/get1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag1=tag2:i=j
tag2="/set1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag1=tag2:i=j
tag2="/li1/"
j=InStr(text,tag2)
If j<i And j>0 Then tag1=tag2:i=j
If tag1="" then exit Sub
tagname=Trim(Left(text,i-1))
tagtext=Mid(text,i+Len(tag1))
End Sub 
Function parseoutput(ByRef text0 As string)As String
Dim As Integer i,j,k,n,p
tagtext=text0:tagtext2="":tagtext1=""
ipushtag=0
tthink=0
msgout=""
For i=1 To 200
  nexttag()
  If tag="" Then
	  If tthink=0 Then msgout+=tagtext1
     Exit For   	
  EndIf 
  If tag="/think0/" Then
	  If tthink=0 Then msgout+=tagtext1
	  tagtext2+=tagtext1
  	  tthink=1
  ElseIf tag="/think2/" Then
	  If tthink=0 Then msgout+=tagtext1
	  tagtext2+=tagtext1
  	  tthink=0
  ElseIf tag="/get0/" Then
	  If tthink=0 Then msgout+=tagtext1
	  tagtext2+=tagtext1
  	  tagtext1=getvar(tagname)
	  If tthink=0 Then msgout+=tagtext1
  	  tagtext2+=tagtext1
	  auxtext+="/"+tagname+":"+getvar(tagname)
  ElseIf tag="/set0/" Then
	  If tthink=0 Then msgout+=tagtext1
	  tagtext2+=tagtext1
	  subpushtag()
  ElseIf tag="/set2/" Then
  	  subpoptag()
	  If tthink=0 Then msgout+=tagtext1
  	  tagtext2+=tagtext1
  	  Var varvalue=Mid(tagtext2,tagindex+1)
  	  If optset=1 Then setvar(otagname,varvalue)
	  auxtext+="/"+otagname+"="+getvar(otagname)
  Else 
	  If tthink=0 Then msgout+=tagtext1
  	  tagtext2+=tagtext1
  EndIf
Next i
auxvar=1000+ipushtag
Return msgout
End Function '/
Sub findsyns(ByRef text0 As string)
Dim As Integer i,j,k,l,n,p
Dim As String lsyn
For i=1 To nmsg
	lmsg(i)=""
Next
text=Mid(text0,InStrRev(text0," ")+1)
l=Len(text)
If l<2 Then Exit Sub 
k=0
i=isynonym(text)
If i>0 Then
	For j=1 To isynonyms(i)		
      k+=1:If k>nmsg Then k=nmsg:Exit Sub 
      lmsg(k)="syn:"+lsynonyms(i,j)+"("+lsynonyms(i,1)	
	   p=getiallword(lsynonyms(i,1))
	   If p<>0 Then
	   	lmsg(k)+="/"+allwords(iwords(Abs(p)))+")"		
	   Else
	   	lmsg(k)+=")"
	   EndIf
	Next
EndIf
For i=1 To isyns
	For j=1 To isynonyms(i)
		If text=Left(lsynonyms(i,j),l) Then
	      k+=1:If k>nmsg Then k=nmsg:Exit Sub 
	      lmsg(k)=lsynonyms(i,j)
	      p=getiallword(lsynonyms(i,1))
	      If p<>0 Then lmsg(k)+="("+allwords(iwords(Abs(p)))+")"		
	      If ismono(lsynonyms(i,j)) Then
	      	'lmsg(k)+=" "+lpoly(lsynonyms(i,1))		
	      Else 
	      	'lmsg(k)+=" "+lmono(lsynonyms(i,1))		
	      EndIf
		EndIf
	Next
Next 	
End Sub
Sub findwords(ByRef text0 As string)
Dim As Integer i,j,k,l,p,test,ii,jj
Dim As String lword,text
text=Mid(text0,InStrRev(text0," ")+1)
For i=1 To nmsg
	lmsg(i)=""
Next
l=Len(text)
If l<2 Then Exit Sub 
k=0
ii=isynonym(text)
If ii>0 Then
	For jj=1 To isynonyms(ii)		
   text=lsynonyms(ii,jj)
   
l=Len(text)
If l>=2 Then  
For i=1 To iallword 
		lword=allwords(i) 
		If lword="" Then Exit For
		If text=Left(lword,l) Then
	      k+=1:If k>nmsg Then k=nmsg:Exit For,For
	      test=0
	      lword="syn:"+lword
	      For p=1 To k-1
	      	If lword=lmsg(p) Then test=1:Exit For
	      Next
	      If test=0 Then
	      	lmsg(k)=lword
	      	'If k=1 Then printgui("win.msg",templates(i))
	      Else
	      	k-=1			
	      EndIf
		EndIf
Next
EndIf 
      	
	Next
EndIf

text=Mid(text0,InStrRev(text0," ")+1)
l=Len(text)
If l<2 Then Exit Sub 
For i=1 To iallword
		lword=allwords(i)
		If lword="" Then Exit For
		If text=Left(lword,l) Then
	      k+=1:If k>nmsg Then k=nmsg:Exit For
	      test=0
	      For p=1 To k-1
	      	'If lword=lmsg(p) Then test=1:Exit For
	      Next
	      If test=0 Then
	      	lmsg(k)=lword
	      	'If k=1 Then printgui("win.msg",templates(i))
	      Else
	      	k-=1			
	      EndIf
		EndIf
Next 	
End Sub
Sub testword(ByRef text0 As string)
Dim As Integer i,j,k,l,p,test,ii,jj
Dim As String lword,text
text=Mid(text0,InStrRev(text0," ")+1)
For i=1 To nmsg
	lmsg(i)=""
Next
l=Len(text)
If l<2 Then Exit Sub 
k=0
ii=Abs(getiallword(text))
If ii>0 Then
	For jj=ii To min2(iallword,ii+20)
		 k+=1:If k>nmsg Then Exit Sub 
		 lmsg(k)=allwords(iwords(jj))
	Next
EndIf    
For i=1 To isyns
	For j=1 To isynonyms(i)
		If text=Left(lsynonyms(i,j),l) Then
		  If getiallword(lsynonyms(i,1))<>0 Then 	
	       k+=1:If k>nmsg Then k=nmsg:Exit Sub 
	       lmsg(k)="syn:"+lsynonyms(i,j)+"("+lsynonyms(i,1)+")"
	     EndIf   		
		EndIf
	Next
Next 	
End Sub 
Sub testrnd(ByRef text0 As string)
Dim As Integer i,j,k,l,p,n,test,ii,jj
Dim As String lword,text
text=Mid(text0,InStrRev(text0," ")+1)
For i=1 To nmsg
	lmsg(i)=""
Next
l=Len(text)
If l<2 Then Exit Sub 
k=0
i=0
For j=1 To 8
 While i<iaiml
  i+=1
  If InStr(templates(i),"/rnd/")>0 Then Exit While
 Wend    
 If i>=iaiml Then Exit Sub 
 k+=1:If k>nmsg Then Exit Sub
 lmsg(k)=Str(i)+"/"+patterns(i)
 k+=1:If k>nmsg Then Exit Sub 
 lmsg(k)=templates(i)
Next   
End Sub 
Sub saveSynonyms(ByRef ficsave As String="data\AIMLsynonyms.txt")
Dim As String mytext,topic0
Dim As Integer i,j,k,countsyns
msg=""
printgui("win.msg","saving...")
guiscan
countsyns=0
file=freefile
Open ficsave For Output As #file
For i=1 To isyns
   mytext=Str(isynonyms(i))
   countsyns+=isynonyms(i)
	For j=1 To isynonyms(i)
		mytext+="/"+synonyms(i,j)
	Next
	Print #file,mytext
Next
Close #file	
msg=Str(countsyns)+"/"+Str(isyns)+" synonyms saved as "+ficsave
msg0=""
End Sub
Sub subloadsyns()
confirm("loadSynonyms ?","confirm",resp)
If resp<>"yes" Then Exit Sub 
loadSynonyms()
End Sub
Sub subsavesyns()
confirm("saveSynonyms ?","confirm",resp)
If resp<>"yes" Then Exit Sub 
saveSynonyms()
End Sub
Sub savevars(ByRef ficsave As String="data\savevars.txt")
Dim As String mytext
Dim As Integer i,j,k
file=freefile
Open ficsave For Output As #file
For i=0 To nvars
   mytext=varnames(i)+"="+varvalues(i)+"//"+Str(vark(i))
	Print #file,mytext
Next
Close #file	
End Sub
Sub loadvars(ByRef ficsave As String="data\savevars.txt")
Dim As Integer i,j,k
Dim As String ficin
If FileExists(ficsave) Then
   file=FreeFile 
   Open ficsave For Input As #file
   For i=0 To nvars
     varnames(i)=""
     varvalues(i)=""
     vark(i)=i
     If Not Eof(file) Then
        Line Input #file,ficin
        j=InStr(ficin,"=")
        k=InStr(ficin,"//")
        If j>0 And k>j Then
        	  varnames(i)=Left(ficin,j-1)
        	  varvalues(i)=Mid(ficin,j+1,k-j-1)
        	  vark(i)=Val(Mid(ficin,k+2))
        EndIf 	  
     EndIf
   Next
   Close #file
EndIf
End Sub
Sub resetvars()
Dim As Integer i 
   For i=0 To nvars
     varnames(i)=""
     varvalues(i)=""
     vark(i)=i
   Next 	
End Sub
Declare Sub addallword()
Dim Shared As String kstar:kstar=Chr(star)
Dim Shared As ZString*1000 mypattern 
Dim Shared As Integer tstar,iword
Sub setwords()
Dim As Integer i,imyword
tstar=0:iword=0:myword="":imyword=0
For i=0 To Len(mypattern)-1
			ktext=mypattern[i]
			If ktext=32 Then
				If tstar=0 Then
				 tstar=1
				 If imyword>=2 Then
				 	myword[imyword]=0
				  	'pattwords(iaiml,iword)=LCase(myword)
				   iword+=1
				   If iword>nword Then
				   	iword-=1:erreur+=1
				   Else
				   	If imyword>=2 Then addallword()
				   EndIf
				 EndIf
				 'pattwords(iaiml,iword)=""
				 imyword=0
				EndIf 
			Else
				'myword+=Chr(ktext)
				myword[imyword]=ktext
				If imyword<1000 Then imyword+=1 Else erreur+=1
				tstar=0
			EndIf
Next i
		   If imyword<>0 Then
		   	myword[imyword]=0
		   	'pattwords(iaiml,iword)=LCase(myword)
			   iword+=1
			   If iword>nword Then
			   	iword-=1:erreur+=1
			   Else
			   	If imyword>=2 Then addallword()
			   EndIf
		   EndIf
			'pattwords(iaiml,iword)=""
End Sub 
Sub formattemp(ByRef temp0 As String)
Dim As Integer n,p,q,r,i,j,k
Dim As String temp,temp2,temp1
temp=temp0
		   		replace(temp,"<random>","/rnd/")
		   		replace(temp,"<li>","/li/")
		   		replace(temp,"<li ","/li0/")
		   		replace(temp,"</li>","/li2/")
		   		replace(temp,"</random>","/rnd2/")
		   		temp2=temp
		   		For q=1 To 30
		   			n=InStr(temp2,"/rnd/")
		   			If n>0 Then
		   				temp2=Mid(temp2,n+5)
		   			   n=InStr(temp2,"/rnd/")
		   				p=InStr(temp2,"/rnd2/")
		   				If n<p And n>0 Then
		   					temp="<<notok>>":Exit For
		   				EndIf
		   			EndIf
		   		Next
		   		temp2=temp
		   		For q=1 To 30
		   			n=InStr(temp2,"/rnd/")
		   			If n>0 Then
		   				temp2=Mid(temp2,n+5)
		   			   n=InStr(temp2,"<condition ")
		   				p=InStr(temp2,"/rnd2/")
		   				If n<p And n>0 Then
		   					temp="<<notok>>":Exit For
		   				EndIf
		   			EndIf
		   		Next
		   		replace(temp,"<br/>","/br/")
		   		'replace(temp,"<bot name=","<get name=")
		   		replace(temp,"<bot/>","/botname/")
		   		replace(temp,"<date/>","/date/")
		   		replace(temp,"<size/>","/size/")
		   		replace(temp,"<br />","/br/")
		   		replace(temp,"<botmaster/>","/botmaster/")
		   		'replace(temp,"<star/>","/*/")
		   		'replace(temp,"<star index=""1""/>","/*/")
		   		For q=1 To 30
		   		 n=InStr(temp,"<!--")
		   		 If n>0 Then
		   			p=InStr(Mid(temp,n+4),"-->")
		   			If p>0 Then
	   					temp=Left(temp,n-1)+Mid(temp,p+3+n+3)
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q 
		   		'If InStr(temp,"<condition")>0 Then auxvar+=1
		   		temp2=""
		   		For q=1 To 30
		   		 n=InStr(temp,"<condition ")
		   		 If n<1 Then Exit For 
		   			p=InStr(mid(temp,n+11),"name=""")
		   			If p>0 Then
		   			   Var pp=InStr(Mid(temp,n+11+p+5),"""")
		   			   If pp>1 Then
		   			   	Var pname=Mid(temp,n+11+p+5,pp-1)
		   			   	Var ppp=InStr(Mid(temp,n+11+p+5+pp),">")
		   			   	If ppp>0 Then
		   			   		temp2+=Left(temp,n-1)+"/cond0/"+pname+"/cond1/"
		   			   		temp1=Mid(temp,n+11+p+5+pp+ppp)
		   			   		i=InStr(temp1,"</condition>")
		   			   		if i<1 Then Exit For
		   			   		temp=Mid(temp1,i+12)
                           temp1=Left(temp1,i-1) 
		   			   		For r=1 To 90
		   			   		    i=InStr(temp1,"/li0/")'"<li "
		   			   		    If i<1 Then Exit For
		   			   		    temp1=Mid(temp1,i+5)
		   			   		    i=InStr(temp1,"value=""")
		   			   		    If i<1 Then Exit For
		   			   		    temp1=Mid(temp1,i+7)
		   			   		    i=InStr(temp1,"""")
		   			   		    If i<1 Then Exit For 
		   			   		    Var pvalue=Left(temp1,i-1)
		   			   		    temp1=Mid(temp1,i+1)
		   			   		    i=InStr(temp1,">")
		   			   		    If i<1 Then Exit For
		   			   		    temp1=Mid(temp1,i+1)
		   			   		    i=InStr(temp1,"/li2/")'"</li>")
		   			   		    If i<1 Then Exit For
		   			   		    Var pli=Left(temp1,i-1)
		   			   		    temp2+="/li0/"+pvalue+"/li1/"+pli+"/li2/"
		   			   		    temp1=Mid(temp1,i+5)
		   			   		Next
		   			   		temp2+="/cond2/"
		   			   	Else
		   			   		Exit For 
		   			   	EndIf 	
		   			   Else
		   			   	Exit For
		   			   EndIf 	 
		   			Else
		   				Exit For  
		   			EndIf
		   		Next q 
		   		temp=temp2+temp 	
		   		/'replace(temp,"</set>","")
		   		For q=1 To 90
		   		 n=InStr(temp,"<set ")
		   		 If n>0 Then
		   			p=InStr(mid(temp,n+5),">")
		   			If p>0 Then
	   					temp=Left(temp,n-1)+Mid(temp,p+1+n+4)
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q'/ 
		   		replace(temp,"</set>","/set2/")
		   		For q=1 To 90
		   		 n=InStr(temp,"<set ")
		   		 If n>0 Then
		   			p=InStr(mid(temp,n+5),"name=""")
		   			If p>0 Then
		   			   Var pp=InStr(Mid(temp,n+5+p+5),"""")
		   			   If pp>1 Then
		   			   	Var pname=Mid(temp,n+5+p+5,pp-1)
		   			   	Var ppp=InStr(Mid(temp,n+5+p+5+pp),">")
		   			   	If ppp>0 Then
		   			   		temp=Left(temp,n-1)+"/set0/"+pname+"/set1/"+Mid(temp,n+5+p+5+pp+ppp)
		   			   	Else
		   			   		Exit For 
		   			   	EndIf
		   			   Else
		   			   	Exit For 
		   			   EndIf
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q 
		   		For q=1 To 90
		   		 n=InStr(temp,"<get ")
		   		 If n>0 Then
		   			p=InStr(mid(temp,n+5),"name=""")
		   			If p>0 Then
		   			   Var pp=InStr(Mid(temp,n+5+p+5),"""")
		   			   If pp>1 Then
		   			   	Var pname=Mid(temp,n+5+p+5,pp-1)
		   			   	Var ppp=InStr(Mid(temp,n+5+p+5+pp),">")
		   			   	If ppp>0 Then
		   			   		temp=Left(temp,n-1)+"/get0/"+pname+"/get1/"+Mid(temp,n+5+p+5+pp+ppp)
		   			   	EndIf
		   			   EndIf
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q 
		   		For q=1 To 90
		   		 n=InStr(temp,"<bot ")
		   		 If n>0 Then
		   			p=InStr(mid(temp,n+5),"name=""")
		   			If p>0 Then
		   			   Var pp=InStr(Mid(temp,n+5+p+5),"""")
		   			   If pp>1 Then
		   			   	Var pname=Mid(temp,n+5+p+5,pp-1)
		   			   	Var ppp=InStr(Mid(temp,n+5+p+5+pp),">")
		   			   	If ppp>0 Then
		   			   		temp=Left(temp,n-1)+"/get0/bot"+pname+"/get1/"+Mid(temp,n+5+p+5+pp+ppp)
		   			   	EndIf
		   			   EndIf
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q 
		   		replace(temp,"<think>","/think0/")
		   		replace(temp,"</think>","/think2/")
		   		/'For q=1 To 30
		   		 n=InStr(temp,"<think>")
		   		 If n>0 Then
		   			p=InStr(Mid(temp,n+7),"</think>")
		   			If p>0 Then
	   					temp=Left(temp,n-1)+Mid(temp,p+8+n+6)
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q'/ 
		   		For q=1 To 30
		   		 n=InStr(temp,"<srai>")
		   		 If n>0 Then
		   			p=InStr(Mid(temp,n+6),"</srai>")
		   			If p>0 Then
	   					temp=Left(temp,n-1)+"/srai/"+Mid(temp,n+6,p-1)+"/srai2/"+Mid(temp,p+7+n+5)
		   			   'Exit For 
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q 
		   		replace(temp,"  "," ")
		   		temp0=Trim(temp)	
End Sub
Sub formattempstar(ByRef temp0 As String)
Dim As Integer n,p,q	
Dim As String temp
   temp=temp0
	formattemp(temp)
		   		replace(temp,"<star/>","/*/")
		   		replace(temp,"<star />","/*/")
		   		replace(temp,"<star index=""1""/>","/*/")
		   		/'replace(temp,"</set>","")
		   		For q=1 To 90
		   		 n=InStr(temp,"<set ")
		   		 If n>0 Then
		   			p=InStr(Mid(temp,n+5),">")
		   			If p>0 Then
	   					temp=Left(temp,n-1)+Mid(temp,p+1+n+4)
		   			Else
		   				Exit For  
		   			EndIf
		   		 Else
		   		 	Exit For  
		   		 EndIf 	
		   		Next q'/  
		   		replace(temp,"  "," ")
		   		temp0=Trim(temp)
End Sub
Dim Shared As Integer tloadallword=1,tloadaiml=1
Sub loaddata(ByRef ficsave As String="data\AIMLdata.data")
Dim As Integer i,j,k,l,iaiml0,imytext,kk,n,p,q,j0,ltext00,imsg
Dim As String patt,temp,temp2,ficword,ficin,ficstar,fictopic
ficword="":ltext00=0
If ficsave="data\CHATBOTdata.data" Then
	ficword="data\CHATBOTword.txt"
	ficstar="data\CHATBOTstar.txt"
	fictopic="data\CHATBOTtopic.txt"
   If FileExists(ficword) And tloadaiml=0 Then
     file=FreeFile 
     Open ficword For Input As #file
     If Not Eof(file) Then Line Input #file,ficin
     ltext00=Val(ficin)
     Close #file
   EndIf   
EndIf
printgui("win.msg","loading...")
guiscan
erase patterns,templates 'fixed lenghts only
erase starpatt,starpatt2,startemp,topics,thats 'fixed lenghts only
'erase patterns,thats,templates,topics 'fixed lenghts only
'ReDim pattwords(naiml,nword)
ReDim allwords(nallword)
ReDim allwordspatt(nallword)
'msg=""
'ficsave="data\pattern.txt"
'text=""
tloadallword=1
file=FreeFile
Open ficsave For Binary Access Read As #file
ltext0=Lof(file)
ptext=Allocate(ltext0+4)
If Not Eof(file) Then (*ptext)=Input(ltext0,file)
Close #file
If ltext00=ltext0 And tloadaiml=0 And ltext00>0 Then tloadallword=0
ltext=Len((*ptext))
iaiml=0
itext=0
iallword=0:istar=0
mytext="":imytext=0
While itext<ltext
	ktext=(*ptext)[itext]
	If ktext=vk_cr Then
		itext+=1 'skip lf
		mytext[imytext]=0
		If iaiml>=imsg+10000 Then
			imsg=iaiml:printgui("win.msg","loading... "+Str(iaiml)):guiscan
		EndIf 	
		If iaiml<naiml Then
		   iaiml+=1
		   ipatterns(iaiml)=iaiml
		   If tloadaiml=1 Then 
		     i=InStr(mytext,Chr(top))
		     j=InStr(mytext,Chr(that_))
		     k=InStr(mytext,Chr(temp_))
		     If k<=0 Then
		   	  k=InStr(mytext,"//"):kk=1
		     Else
		   	  kk=0
		     EndIf 	
		     If j<=0 Then j=k
		     If i<=0 Then i=0
		   Else
		     k=InStr(mytext,"//"):kk=1
		     i=0
		     j=InStr(mytext,"/that/")
		     If j<=0 Then j=k
		     EndIf   	
		   l=Len(mytext)
		   'patterns(iaiml)=Left(mytext,k-1)
		   'If i>1 Then
		   '	topics(iaiml)=LCase(Left(mytext,i-1))
		   '	itopic+=1
		   'Else
		   '	topics(iaiml)=""
		   'EndIf
		   'If k>(j+7) Then '<that>
		   '	thats(iaiml)=LCase(Mid(mytext,j+7,k-j-7))
		   'Else 	
		   '	thats(iaiml)=""
		   'EndIf
		   'If l>k Then
		   '	templates(iaiml)=Trim(Mid(mytext,k+1,l-k))
		   'Else
		   '	templates(iaiml)=""
		   'EndIf
'Const As uchar   top=254,star=253,star_=16,lf=10,vk_cr=13,that_=17,temp_=18
		   If (j-i-1)>1 And (l-k-kk)>0 Then
		      If i>1 Then
		      	topics(iaiml)=LCase(Left(mytext,i-1))
		      	itopic+=1
		      Else
		      	topics(iaiml)=""
		      EndIf
		   	patterns(iaiml)=Trim(Mid(mytext,i+1,j-i-1))
		   	If tloadaiml=1 Then 
		       If k>(j+7) Then
		         thats(iaiml)=Trim(LCase(Mid(mytext,j+7,k-j-7)))
		       Else 	
		      	thats(iaiml)=""
		       EndIf
		   	 If (InStr(patterns(iaiml),Chr(star))<=0 And _
		   	   InStr(patterns(iaiml),Chr(star_))<=0) And _  
		   	   Len(patterns(iaiml))>4 Then
		   		temp=Trim(Mid(mytext,k+1+kk,l-k-kk))
		   		formattemp(temp)
		   		If InStr(temp,"<")>0 Or temp="" Then
		   			iaiml-=1
		   		Else		   			
		            templates(iaiml)=temp
		            mypattern=LCase(patterns(iaiml))
		            setwords()
		   		EndIf 	
		   	 Else
               Var iaux=InStr(patterns(iaiml),Chr(star))
               Var iaux2=InStr(patterns(iaiml),Chr(star_))
               If iaux<0 Then iaux=0
               If iaux2<0 Then iaux2=0
               If iaux>0 And iaux2=0 Then 
		   	      If iaux=InStrRev(patterns(iaiml),Chr(star)) Then
		   	         'auxvar+=1 
		   	      Else
		   	      	iaux=-iaux
		   	      EndIf 	
               Else
            	   iaux=-iaux
               EndIf 	
               If iaux2>0 And iaux=0 Then 
		   	      If iaux2=InStrRev(patterns(iaiml),Chr(star_)) Then   
   		   	      'auxvar2+=1
		   	      Else
		   	      	iaux2=-iaux2
		   	      EndIf 	
               Else
            	   iaux2=-iaux2 
		   	   EndIf   	
		   		If iaux>0 Or iaux2>0 Then
		   		   temp=Trim(Mid(mytext,k+1+kk,l-k-kk))
		   		   formattempstar(temp)
		   		   If InStr(temp,"<")>0 Or temp="" Then
		   		   ElseIf istar<naiml Then 
		   		   	istar+=1
		   		   	If iaux>0 Then
		   		   		starpatt(istar)=Left(patterns(iaiml),iaux-1)

		   		   		starpatt2(istar)=Mid(patterns(iaiml),iaux+1)
		   		   	Else
		   		   		starpatt(istar)=Left(patterns(iaiml),iaux2-1)
		   		   		starpatt2(istar)=Mid(patterns(iaiml),iaux2+1)
		   		   	EndIf 	
		   		   	startemp(istar)=temp
		   		   EndIf 	
		   		EndIf 	
		   		iaiml-=1
		   	 EndIf
		     Else
		         If k>(j+6) Then
		           thats(iaiml)=Trim(LCase(Mid(mytext,j+6,k-j-6)))
		         Else 	
		      	  thats(iaiml)=""
		         EndIf
		   		templates(iaiml)=Trim(Mid(mytext,k+1+kk,l-k-kk))
		         If tloadallword=1 Then 
		           mypattern=LCase(patterns(iaiml))
		           setwords()
		         EndIf   		       
		     EndIf 
		   Else
		   	iaiml-=1
		   EndIf
		   'mypattern=Trim(LCase(Mid(mytext,i+1,j-i-1)))
		   'setwords()
		   imytext=0
		Else
			erreur+=1
			Exit While
		EndIf 	
	Else
		'mytext+=Chr(ktext)
		mytext[imytext]=ktext
		If imytext<10000 Then imytext+=1 Else erreur+=1
	EndIf
	itext+=1
Wend 
DeAllocate(ptext)
If FileExists(ficword) And tloadaiml=0 Then
   file=FreeFile 
   Open ficword For Input As #file
   If Not Eof(file) Then Line Input #file,ficin
   'ltext00=Val(ficin)
   iallword=0
   For i=1 To nallword
      If Not Eof(file) Then Line Input #file,ficin Else Exit For
      j=InStr(ficin,"�")
      If j<=1 Then
      	erreur+=1
      Else
         iallword+=1
         iwords(iallword)=iallword
      	allwords(iallword)=Left(ficin,j-1)
      	allwordspatt(iallword)=Mid(ficin,j+1)
      EndIf
   Next
   Close #file
EndIf   
If FileExists(ficstar) And tloadaiml=0 Then
   file=FreeFile 
   Open ficstar For Input As #file
   istar=0
   For i=1 To naiml
      If Not Eof(file) Then Line Input #file,ficin Else Exit For
      j=InStr(ficin,"*")
      If j<1 Then
      	erreur+=1
      Else
      	k=InStr(ficin,"//")
      	If k<j+1 Then
      		erreur+=1
      	Else
            istar+=1
            starpatt(istar)=Left(ficin,j-1)
            starpatt2(istar)=Mid(ficin,j+1,k-j-1)
      	   startemp(istar)=Mid(ficin,k+2)
         EndIf 	   
      EndIf
   Next
   Close #file
EndIf   
If FileExists(fictopic) And tloadaiml=0 Then
   file=FreeFile 
   Open fictopic For Input As #file
   itopic=0
   For i=1 To naiml
      If Not Eof(file) Then Line Input #file,ficin Else Exit For
      topics(i)=ficin
      If ficin<>"" Then itopic+=1 
   Next
   Close #file
EndIf   
botsize=iaiml
msg="loaded patterns :"+Str(botsize)+"  topics :"+Str(itopic)+crlf
msg+="allwords :"+Str(iallword)+" err="+Str(erreur)+crlf'+msg
msg+=Str(countsyns)+"/"+Str(isyns)+" synonyms loaded"+crlf
msg+=Str(istar)+" stars loaded"+crlf
msg+=crlf+crlf+"enter => repeat"+crlf
msg+="star* => autochat"+crlf
j=0
For i=0 To iaiml
	If InStr(templates(i),"/rnd/")>0 Then
		'msg+=str(i)+templates(i)+crlf
		j=i:Exit For
	EndIf
Next
For i=30 To 30+5
	'msg+=patterns(i)+crlf'+"/"+templates(i)+crlf
	'msg+=templates(i)
	'msg+=allwords(i)+allwordspatt(i)+crlf
	'For j=0 To 7
		'msg+='pattwords(i,j)+" "
	'Next
	'msg+=crlf
Next
printgui("win.msg",msg)
msg="loaded patterns :"+Str(botsize)+crlf
guisetfocus("win.text")
'setallwords()
End Sub
Sub subloaddata2(ByVal tconfirm As Integer=1)
Dim As String ficsave="",ficsave2=""
tloadallword=1:tloadaiml=1
If FileExists("data\CHATBOTdata.data") Then
	ficsave="data\CHATBOTdata.data"
	tloadaiml=0
EndIf
If tconfirm=1 Then
	confirm("loadDATA ? "+ficsave,"confirm",resp)
   If resp<>"yes" Then Exit Sub
EndIf
If ficsave="" Then
	loaddata()
Else
	loaddata(ficsave)
EndIf
End Sub
Sub subloaddata()
	subloaddata2(1)
End Sub
Sub subloaddataas()
Dim As Integer i=0 
Dim As String fic,dir0
Dim As Integer ret 
dir0=CurDir
ret=ChDir(ExePath+"\data\")  
fic=filedialog("loadDATAas","*.data")
fic=LCase(Trim(fic))
ret=ChDir(dir0)
If fic="" Then Exit Sub 
If InStr(fic,".")<1 Then fic+=".data"
If Right(fic,5)<>".data" Then Exit Sub 
If Not FileExists(fic) Then Exit Sub  
confirm("loadDATAas "+fic+" ?","confirm",resp)
If resp<>"yes" Then Exit Sub
tloadaiml=1 
loaddata(fic)
End Sub
Sub savedata(ByRef ficsave As String="data\CHATBOTdata.data")
Dim As String ficword,ficstar,fictopic
Dim As Integer i,ltext0
ficword="data\CHATBOTword.txt"
ficstar="data\CHATBOTstar.txt"
fictopic="data\CHATBOTtopic.txt"
msg=""
printgui("win.msg","saving...")
guiscan
'ficsave="data\pattern.txt"
file=FreeFile
Open ficsave For Output As #file
For i=1 To iaiml
	If thats(ipatterns(i))<>"" Then
	  Print #file,patterns(ipatterns(i))+"/that/"+thats(ipatterns(i))+"//"+templates(ipatterns(i))
	Else 	
	  'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	  Print #file,patterns(ipatterns(i))+"//"+templates(ipatterns(i))
   EndIf 	 
Next
Close #file	
file=FreeFile
Open ficsave For Binary Access Read As #file
ltext0=Lof(file)
Close #file
file=freefile
Open ficword For Output As #file
Print #file,Str(ltext0)
For i=1 To iallword
	Print #file,allwords(iwords(i))+"�"+allwordspatt(iwords(i))
Next
Close #file	
file=freefile
Open ficstar For Output As #file
For i=1 To istar
	Print #file,starpatt(i)+"*"+starpatt2(i)+"//"+startemp(i)
Next
Close #file	
file=freefile
Open fictopic For Output As #file
For i=1 To iaiml
	Print #file,topics(ipatterns(i))
Next
Close #file	
printgui("win.msg","saved in "+ficsave+crlf+" "+ficword+crlf+" "+ficstar+crlf+" "+fictopic)
guisetfocus("win.text")
/'
ficsave="data\template.txt"
file=freefile
Open ficsave For Output As #file
For i=1 To iaiml
	Print #file,templates(ipatterns(i))
Next
Close #file	
'/
End Sub
Sub savedatapack(ByRef ficsave As String="data\CHATBOTdatapack.txt")
'Dim As String ficsave
Dim As Integer i
Dim As String outline
confirm("pack data to one line in "+ficsave+" ?","pack",resp)
If resp<>"yes" Then Exit Sub 
msg=""
printgui("win.msg","saving...")
guiscan
'ficsave="data\pattern.txt"
file=freefile
Open ficsave For Binary Access write As #file
For i=1 To iaiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	Print #file,patterns(ipatterns(i))+"//"+templates(ipatterns(i))+"/cr/";
Next
Close #file	
printgui("win.msg","saved in "+ficsave)
guisetfocus("win.text")
End Sub
Sub savedataunpack(ByRef ficsave As String="data\CHATBOTdataunpack.txt")
Dim As String ficload
Dim As Integer i,j,k,l
Dim As String outline,inline,text
ficload="data\CHATBOTdatapack.txt"
If FileExists(ficload)=0 Then guinotice(ficload+" not found !"):Exit Sub  
confirm("unpack "+ficload+" to "+crlf+ficsave+" ?","unpack",resp)
If resp<>"yes" Then Exit Sub
msg=""
printgui("win.msg","unpacking...")
guiscan
file=FreeFile
Open ficload For Input As #file
If Not Eof(file) Then Line Input #file,inline
Close #file
If Len(inline)<1 Then Exit Sub 
file=freefile
Open ficsave For Output As #file
j=1:k=0:l=Len(inline)
For i=1 To naiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
   While k<l
   	k+=1
   	If Mid(inline,k,4)="/cr/" Then
   		Exit While
   	EndIf
   Wend
   If k>=l Then Exit For 
   text=Trim(Mid(inline,j,k-j))
   replace(text,"�","e")
   replace(text,"�","e")
   replace(text,"�","e")
   replace(text,"�","a")
   replace(text,"�","u")
   replace(text,"�","u")
   replace(text,"�","i")
   replace(text,"�","o")
  	Print #file,text 
   k+=4
   j=k
   If k>=l Then Exit For 
Next
Close #file	
printgui("win.msg","unpacked in "+ficsave)
guisetfocus("win.text")
End Sub
Sub savedatajavascript()
Dim As String ficsave,msg
Dim As Integer i
Dim As String outline,text
confirm("save data to javascript ?","export",resp)
If resp<>"yes" Then Exit Sub 
msg=""
printgui("win.msg","saving to javascript...")
guiscan
ficsave="data\mypatterns.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mypatterns=""";
For i=1 To iaiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=patterns(ipatterns(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mythats.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mythats=""";
For i=1 To iaiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=thats(ipatterns(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mytemplates.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mytemplates=""";
For i=1 To iaiml
	text=templates(ipatterns(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mywords.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mywords=""";
For i=1 To iallword
	text=allwords(iwords(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mywordspatt.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mywordspatt=""";
For i=1 To iallword 
	text=allwordspatt(iwords(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mystarpatt.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mystarpatt=""";
For i=1 To istar
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=starpatt(i)+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mystarpatt2.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mystarpatt2=""";
For i=1 To istar
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=starpatt2(i)+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mystartemp.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mystartemp=""";
For i=1 To istar
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=startemp(i)+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

ficsave="data\mytopics.js"
file=FreeFile
Open ficsave For Binary Access write As #file
Print #file,"mytopics=""";
For i=1 To iaiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	text=topics(ipatterns(i))+"\n"
	replace(text,"""","'")
	Print #file,text;
Next
Print #file,"""; "+crlf;
Close #file	
msg+="saved in "+ficsave+crlf

printgui("win.msg",msg)
guisetfocus("win.text")
End Sub
Sub subsavedata()
confirm("saveDATA ? data\CHATBOTdata.data","confirm",resp)
If resp<>"yes" Then Exit Sub
savedata()
botchanged=0
End Sub
Sub addallword()'myword,iaiml
If tloadallword=0 Then Exit Sub 
Dim As Integer i,j,k,p
Dim As String kiaiml
If iallword>=nallword Then erreur+=1:Exit Sub 
iallword+=1
allwords(iallword)=LCase(myword)
kiaiml="/"+Str(iaiml)

If iallword=1 Then
	iwords(iallword)=iallword:allwordspatt(iallword)=kiaiml:Exit Sub
EndIf
If allwords(iallword)>allwords(iwords(iallword-1)) Then
	iwords(iallword)=iallword:allwordspatt(iallword)=kiaiml:Exit Sub
EndIf
If allwords(iallword)=allwords(iwords(iallword-1)) Then
	j=iwords(iallword-1)
	If InStr(allwordspatt(j)+"/",kiaiml+"/")<=0 Then allwordspatt(j)+=kiaiml
	iallword-=1
	Exit Sub
EndIf
If allwords(iallword)<allwords(iwords(1)) Then
	For p=iallword To 2 Step -1
		iwords(p)=iwords(p-1)
	Next
	iwords(1)=iallword:allwordspatt(iallword)=kiaiml:Exit Sub 
EndIf
i=1:j=iallword-1
While (j-i)>=2
 k=i+(j-i)/1.99
 If allwords(iallword)>=allwords(iwords(k)) Then
	i=k
 Else
	j=k
 EndIf
Wend
If allwords(iallword)=allwords(iwords(i)) Then
	j=iwords(i)
	If InStr(allwordspatt(j)+"/",kiaiml+"/")<=0 Then allwordspatt(j)+=kiaiml
	iallword-=1
	Exit Sub
EndIf
For p=iallword To j+1 Step -1
	iwords(p)=iwords(p-1)
Next
iwords(j)=iallword:allwordspatt(iallword)=kiaiml
End Sub
Function getiallword(ByRef text As String)As Integer 
Dim As Integer i,j,k,l
i=1:j=iallword
While (j-i)>=2
 k=i+(j-i)/1.99
 If text>=allwords(iwords(k)) Then
	i=k
 Else
	j=k
 EndIf
Wend
If text=allwords(iwords(i)) Then
	Return i
EndIf
If text=allwords(iwords(j)) Then
	Return j
EndIf
l=Len(text)
If text=Left(allwords(iwords(i)),l) Then
	Return -i
EndIf
If text=Left(allwords(iwords(j)),l) Then
	Return -j
EndIf
Return 0
End Function  



