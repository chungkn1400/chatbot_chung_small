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
Dim Shared As String resp,msg,msg0,outmsg
Dim Shared As Double timer0,timer1,timer2



'Dim Shared As ZString*20000000 text
Dim Shared As ZString Ptr ptext
Dim Shared As Integer ltext,ltext0,itext,erreur,countsyns,botsize,botchanged
'Dim Shared As String fic
'fic="aiml\alice.aiml"


Const As Integer naiml=250000,nword=80,nstar=40,nlevel=20,nthat=40,nallword=30000
Const As Integer nvar=10000,nli=400,ninput=40,nsyns=20000,nsyns2=50
Dim Shared As String  patterns(naiml),templates(naiml)
ReDim Shared As String pattwords(naiml,nword)
ReDim Shared As String inputs(ninput,nword)
ReDim Shared As String synonyms(nsyns,nsyns2),lsynonyms(nsyns,nsyns2)
ReDim Shared As String allwords(nallword),allwordspatt(nallword)
ReDim Shared As Integer isynonyms(nsyns),ipatterns(naiml),iwords(nallword)
ReDim Shared As Single  testpattern(naiml)
Dim Shared As Integer isyns,iaiml,iallword
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
	If (InStr(" ,;:!?./$&й""'([-и_за@)]=+*_<>{}",Chr(i))<1) and _
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

Dim Shared As Integer nparse=20000,iparse
Dim Shared As String textparse(nparse)
Sub parse(ByRef text0 As String,ByRef str1 As String)
Dim As Integer i,j,k,l
Dim As String text
text=text0
l=Len(str1)
iparse=0
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
  text=Mid(text,j+l)
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
Function lmono(ByRef text As String) As String
Dim As Integer i,j
Dim As String txt
If Right(text,1)<>"s" Then Return text
If Right(text,2)="ss" Then Return text
If Right(text,2)<>"es" Then Return Left(text,Len(text)-1)
txt=Mid(text,Len(text)-2,1)
If InStr("sx",txt)>0 Then Return Left(text,Len(text)-2)
Return Left(text,Len(text)-1)
End Function
Function lpoly(ByRef text As String) As String
Dim As Integer i,j
Dim As String txt
If Right(text,1)="s" Then Return text
txt=Right(text,1)
If InStr("sx",txt)>0 Then Return text+"es"
Return text+"s"
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
		      replace(lsyn," ","_")
		      replace(lsyn,"'","")
		      replace(lsyn,"""","")
		      replace(lsyn,"-","")
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
Function getsynonym(ByRef text As string) As String
Dim As Integer i,j,k
i=isynonym(text)
If i=0 Then Return text
Return synonyms(i,1)
End Function
Declare Function getiallword(ByRef text As String)As Integer 
Dim Shared As Integer nmsg=18
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
Dim Shared As Integer nouttemplate=30000,iouttemplate(nouttemplate)
Sub processinput(ByRef text0 As string)
Dim As Integer i,j,k,l,p,n
Dim As String msg,msg2,allpatt,inword
parse(text0," ")
If iparse=0 Then Exit Sub 
j=0
For i=1 To min2(iparse,nword) 
	inword=textparse(i)
	j=getiallword(inword)
	If j=0 Then 
	  inword=getsynonym(inword):auxvar+=1
	  lmsg(10)=inword
	EndIf  
	inputword(i)=inword
Next
For i=1 To iaiml
	testpattern(i)=0
Next
k=min2(iparse,nword)
For i=1 To k
   j=getiallword(inputword(i))
	If j<>0 Then
		allpatt=allwordspatt(iwords(Abs(j)))
		p=Abs(j)
		l=Len(inputword(i))
		For n=1 To 100
		 If p<iallword Then
			p+=1
			If inputword(i)=Left(allwords(iwords(p)),l) Then
				allpatt+=allwordspatt(iwords(p))
			Else
				Exit For 
			EndIf
		 Else
		 	Exit For
		 EndIf
		Next n 
		parse(allpatt,"/")
		'msg2=allwords(iwords(Abs(j)))+"/"+allpatt'allwordspatt(iwords(Abs(j)))
	Else
		iparse=0
	EndIf
	If iparse>0 Then
		For p=1 To iparse
			n=max2(1,min2(iaiml,Int(Val(textparse(p))+0.1)))
			If j>0 Then
				testpattern(n)+=weight(4+Len(inputword(i)))*(1+Rnd*0.3)
			Else
				testpattern(n)+=0.65*weight(4+Len(inputword(i)))*(1+Rnd*0.3)
			EndIf
		Next
	EndIf
Next
For i=1 To naiml
	testpattern(i)*=tweight(i)
	tweight(i)=min(2.0,tweight(i)*1.1)
Next
Var xtest=0.01
j=0
For i=1 To iaiml
	If testpattern(i)>xtest Then
		xtest=testpattern(i)
		j=i
	EndIf
Next
If j>0 Then
	k=0
	Var dx=xtest*0.3
	For i=1 To iaiml
		If Abs(testpattern(i)-xtest)<dx Then
			k+=1:If k>nouttemplate Then Exit For
			iouttemplate(k)=i
		EndIf
	Next
	j=iouttemplate(1+Int(Rnd*k*0.999))
EndIf
If j>0 Then
	tweight(j)=max(0.5,tweight(j)/1.2)
	msg=templates(j)
	outmsg=msg
	If InStr(msg,"/rnd/")>0 Then
		replace(msg,"/rnd/","")
		parse(Trim(msg),"/li/")
		outmsg=textparse(Int(Rnd*iparse*0.999)+1)
		msg+="/"+Str(iparse)+"/"
	Else
		msg=""
	EndIf
	/'msg+=outmsg+"/syn:"
	parse(outmsg," ")
	outmsg=""
	For i=1 To iparse
		If Rnd<0.85 Then
			outmsg+=getsynonym(textparse(i))+" "
		Else
			outmsg+=textparse(i)+" "
		EndIf
	Next'/
	msg+=outmsg
	If Len(outmsg)<0.65*Len(patterns(j)) Then
		outmsg=patterns(j)+" "+outmsg 
	EndIf
EndIf
If j>0 Then
	printgui("win.msg",patterns(j)+crlf+"> "+msg)
	'printgui("win.msg",patterns(j)+"/"+msg2)
Else
	printgui("win.msg","???")
EndIf
End Sub
Sub findsyns(ByRef text0 As string)
Dim As Integer i,j,k,l
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
      lmsg(k)="syn:"+lsynonyms(i,j)		
	Next
EndIf
For i=1 To isyns
	For j=1 To isynonyms(i)
		If text=Left(lsynonyms(i,j),l) Then
	      k+=1:If k>nmsg Then k=nmsg:Exit Sub 
	      lmsg(k)=lsynonyms(i,j)		
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
For i=1 To iaiml
	For j=1 To nword 
		lword=pattwords(i,j)
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
Next
EndIf 
      	
	Next
EndIf

text=Mid(text0,InStrRev(text0," ")+1)
l=Len(text)
If l<2 Then Exit Sub 
For i=1 To iaiml
	For j=1 To nword 
		lword=pattwords(i,j)
		If lword="" Then Exit For
		If text=Left(lword,l) Then
	      k+=1:If k>nmsg Then k=nmsg:Exit For,For
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
				  	pattwords(iaiml,iword)=LCase(myword)
				   iword+=1
				   If iword>nword Then
				   	iword-=1:erreur+=1
				   Else
				   	If imyword>2 Then addallword()
				   EndIf
				 EndIf
				 pattwords(iaiml,iword)=""
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
		   	pattwords(iaiml,iword)=LCase(myword)
			   iword+=1
			   If iword>nword Then
			   	iword-=1:erreur+=1
			   Else
			   	If imyword>2 Then addallword()
			   EndIf
		   EndIf
			pattwords(iaiml,iword)=""
End Sub 
Dim Shared As Integer tloadallword=0,tloadaiml=1
Sub loaddata(ByRef ficsave As String="data\AIMLdata.data")
Dim As Integer i,j,k,l,iaiml0,imytext,kk
Dim As String patt,temp
printgui("win.msg","loading...")
guiscan
erase patterns,templates 'fixed lenghts only
'erase patterns,thats,templates,topics 'fixed lenghts only
ReDim pattwords(naiml,nword)
ReDim allwords(nallword)
ReDim allwordspatt(nallword)
'msg=""
'ficsave="data\pattern.txt"
'text=""
file=FreeFile
Open ficsave For Binary Access Read As #file
ltext0=Lof(file)
ptext=Allocate(ltext0+4)
If Not Eof(file) Then (*ptext)=Input(ltext0,file)
Close #file
ltext=Len((*ptext))
iaiml=0
itext=0
iallword=0
mytext="":imytext=0
While itext<ltext
	ktext=(*ptext)[itext]
	If ktext=vk_cr Then
		itext+=1 'skip lf
		mytext[imytext]=0
		If iaiml<naiml Then
		   iaiml+=1
		   ipatterns(iaiml)=iaiml
		   If tloadaiml=1 Then 
		     i=InStr(mytext,Chr(top))
		     j=InStr(mytext,Chr(that_))
		   Else
		     i=0:j=0
		   EndIf   	
		   k=InStr(mytext,Chr(temp_))
		   If k<=0 Then
		   	k=InStr(mytext,"//"):kk=1
		   Else
		   	kk=0
		   EndIf 	
		   l=Len(mytext)
		   If j<=0 Then j=k
		   If i<=0 Then i=0
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
		   If (j-i-1)>4 And (l-k-kk)>4 Then
		   	patterns(iaiml)=Trim(Mid(mytext,i+1,j-i-1))
		   	If tloadaiml=1 Then 
		   	 If InStr(patterns(iaiml),Chr(star))<=0 And _
		   	   InStr(patterns(iaiml),Chr(star_))<=0 And _  
		   	   Len(patterns(iaiml))>4 Then
		   		temp=Trim(Mid(mytext,k+1+kk,l-k-kk))
		   		replace(temp,"<random>","/rnd/")
		   		replace(temp,"<li>","/li/")
		   		replace(temp,"</li>","")
		   		replace(temp,"</random>","")
		   		If InStr(temp,"<")>0 Then
		   			iaiml-=1
		   		Else		   			
		            templates(iaiml)=temp
		            mypattern=LCase(patterns(iaiml))
		            setwords()
		   		EndIf 	
		   	 Else
		   		iaiml-=1
		   	 EndIf
		     Else
		   		templates(iaiml)=Trim(Mid(mytext,k+1+kk,l-k-kk))
		         mypattern=LCase(patterns(iaiml))
		         setwords()		       
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
botsize=iaiml
msg="loaded patterns :"+Str(botsize)+crlf
msg+="allwords :"+Str(iallword)+" err="+Str(erreur)+crlf'+msg
msg+=Str(countsyns)+"/"+Str(isyns)+" synonyms loaded"+crlf
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
		'msg+=pattwords(i,j)+" "
	'Next
	'msg+=crlf
Next
printgui("win.msg",msg)
guisetfocus("win.text")
'setallwords()
End Sub
Sub subloaddata2(ByVal tconfirm As Integer=1)
Dim As String ficsave="",ficsave2=""
tloadallword=1:tloadaiml=1
If FileExists("data\CHATBOTdata.data") Then
	ficsave="data\CHATBOTdata.data"
	'tloadaiml=0
   If FileExists("data\CHATBOTwords.data") Then
 	   ficsave2="data\CHATBOTwords.data"
 	   tloadallword=0
   EndIf
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
Sub savedata(ByRef ficsave As String="data\CHATBOTdata.data")
'Dim As String ficsave
Dim As Integer i
msg=""
printgui("win.msg","saving...")
guiscan
'ficsave="data\pattern.txt"
file=freefile
Open ficsave For Output As #file
For i=1 To iaiml
	'Print #file,patterns(ipatterns(i))+Chr(temp_)+templates(ipatterns(i))
	Print #file,patterns(ipatterns(i))+"//"+templates(ipatterns(i))
Next
Close #file	
printgui("win.msg","saved in "+ficsave)
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


