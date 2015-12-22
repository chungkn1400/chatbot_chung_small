#Include once "httppost.bi"

Dim Shared hostname as string
dim Shared path as string

Dim Shared As String wikikeysearch:wikikeysearch="lennon"
Dim Shared As Integer wikilimit=10
hostname="en.wikipedia.org"
'path="/w/api.php?action=opensearch&search="+wikikeysearch+"&limit=5&namespace=0&format=json&redirects=resolve&callback=mywikicallback";
path="/w/api.php?action=opensearch&search="+wikikeysearch+"&limit="+Str(wikilimit)+"&namespace=0&format=json&redirects=resolve"


Dim Shared As String wtext(20),wline,wword
Dim Shared As Integer windex,nwtext
Function formattext(text As String)As String
	Dim As String c,text2=""
	Dim As Integer i
	For i=1 To Len(text)
		c=Mid(text,i,1)
		If InStr("abcdefghijklmnopqrstuvwxyz1234567890&й'и_завкофы,;:!*щ$?.{[(/)]}\+-="" ",LCase(c))>0 Then text2+=c
	Next
	Return Trim(text2)
End Function
Sub nextword(c As String)
	windex=InStr(wline,c)
	If windex>0 Then
		wword=formattext(Left(wline,windex-1))
		wline=Mid(wline,windex+Len(c))
	Else
		wword=""
	EndIf
End Sub
Function formatwebtext(text0 As String)As String
	Dim As Integer i,j,k
	Dim As String c
	wline=text0
	nextword("["):nextword("["):nextword("[")
	j=0:wword=""
	For i=1 To 9999
		c=Mid(wline,i,1)
		If c="[" Then j+=1
		If c="]" Then j-=1
		If j>=0 Then wword+=c
		If j<0 Then Exit For 
	Next
	wline=wword
	nwtext=0
	For i=1 To wikilimit
		nextword(""""):If windex<=0 Then Exit For
		nextword(""""):If windex<=0 Then Exit For
		If InStr(wword,"refer to:")>0 Then wword=""
		If Len(wword)>5 Then
			nwtext+=1:wtext(nwtext)=wword
		EndIf
	Next
	var text2=""
	If nwtext>0 Then text2=wtext(Int(1+Rnd*nwtext*0.99))
	replace(text2,"\u2013","-")
	Var text=""
	j=0:k=0
	For i=1 To Len(text2)
		c=Mid(text2,i,1)
		If c="\" And Mid(text2,i+1,1)="u" Then
			c="-":i+=5
		EndIf
		If c="(" Or c="[" Or c="{" Then j+=1
		If c="/" Then
			'If k=0 Then k=1 Else k=0 EndIf 
		EndIf
		if j=0 and k=0 And InStr("abcdefghijklmnopqrstuvwxyz1234567890&й'и_завкофы,;:!*щ$?.+-= ",LCase(c))>0 Then text+=c
		If c=")" Or c="]" Or c="}" Then j-=1
	Next
	Return Trim(text)
End Function
   
Sub testwiki()
   randomize 
   Var webtext=httppost(hostname,path)
   print
   Print "webtext="+webtext
   Print
   Print "result="+formatwebtext(webtext)
	Sleep
End Sub
Sub printwebmsg(intext As String,msgprocess As String)
	var msgmsg=intext
	outmsg=msgprocess
	msgmsg=msgmsg+crlf+"> "+msgprocess
printgui("win.msg",msgmsg)
End Sub 
Dim Shared As Single randomwiki=1
Dim Shared As Integer twiki=1,wikinword=1
Sub processinput22(intext22 As String)
If twiki=0 Then
	processinput(intext22):Exit sub
EndIf
auxvar=0
randomwiki=max(0.03,min(1,randomwiki+0.03))
If Rnd<(0.25*randomwiki) Then 
 parse(Trim(intext22)," ")
 wikinword=iparse
 If iparse>=1 and iparse<=3 Then 
   wikikeysearch=Trim(intext22)
   replace(wikikeysearch,"  "," ")
   replace(wikikeysearch," ","_")
   wikilimit=Int(2+Rnd*10)
   hostname="en.wikipedia.org"
   path="/w/api.php?action=opensearch&search="+wikikeysearch+"&limit="+Str(wikilimit)+"&namespace=0&format=json&redirects=resolve"
   Var webtext=httppost(hostname,path)
   webtext=formatwebtext(webtext)
   If webtext<>"" Then
      randomwiki-=1/(1+wikinword)
      webtext=formatrndsyn(webtext)
   	printwebmsg(intext22,webtext):Exit Sub 
   EndIf
   processinput(intext22)
   exit sub 
 EndIf 
EndIf 
processinput(intext22)
If testnoresponse=0 Or wikinword<1 Then Exit Sub
   wikikeysearch=Trim(Left(intext22,99))
   replace(wikikeysearch,"  "," ")
   replace(wikikeysearch," ","_")
   wikilimit=Int(1+Rnd*10)
   hostname="en.wikipedia.org"
   path="/w/api.php?action=opensearch&search="+wikikeysearch+"&limit="+Str(wikilimit)+"&namespace=0&format=json&redirects=resolve"
   Var webtext=httppost(hostname,path)
   webtext=formatwebtext(webtext)
   If webtext<>"" Then
      randomwiki-=1/(1+wikinword)
      webtext=formatrndsyn(webtext)
   	printwebmsg(intext22,webtext)
   EndIf
End Sub     
Sub subwiki()
	If twiki=0 Then
		twiki=1
		printgui("win.wiki","nowiki")
	Else
		twiki=0
		printgui("win.wiki","wiki")
	EndIf
	If twiki=0 Then
		printgui("win.wiki","wiki off")
	Else
		printgui("win.wiki","wiki on")
	EndIf
End Sub


