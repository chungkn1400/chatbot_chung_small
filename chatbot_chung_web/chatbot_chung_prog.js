// chatbot_chung_prog.js a program by NGUYEN.Chung (freeware(2015))
var canvasmsg=document.getElementById('cvmsg');
var contextmsg;if(canvasmsg){contextmsg=canvasmsg.getContext('2d');}
var msgcanvas="";
//alert(contextmsg);
function printcanvasmsg(msg,msg2){if(!contextmsg){return;}
contextmsg.clearRect (0,0,canvasmsg.width,canvasmsg.height);
contextmsg.font = "10pt Arial";
contextmsg.fillStyle = '#00BB00';
//contextmsg.fillStyle = '#88AA00';
contextmsg.fillText(msg,10,11);
//contextmsg.fillText(msg2,10,23);
}
	var crlf="\r\n";
	var v=[];//vars
	var patterns=[],templates=[],allwords=[],allwordspatt=[];
	patterns=mypatterns.split("\n");//alert(patterns.length);
	templates=mytemplates.split("\n");//alert(templates.length);
	allwords=mywords.split("\n");//alert(allwords.length);
	allwordspatt=mywordspatt.split("\n");//alert(allwordspatt.length);
	var iaiml=patterns.length-1;
	//alert(iaiml+"/"+patterns[iaiml-1]);
	var iallword=allwords.length-1;
	//alert(allwords[iallword-1]);
	var starpatt=[],starpatt2=[],startemp=[];
	starpatt=mystarpatt.split("\n");//alert(starpatt.length);
	starpatt2=mystarpatt2.split("\n");//alert(starpatt2.length);
	startemp=mystartemp.split("\n");//alert(startemp.length);
	var istar=starpatt.length-1;
	var thats=[];
	thats=mythats.split("\n");//alert(thats.length);
	var topics=[],startopics=[];
	for(var i=0;i<=iaiml;i++){topics[i]="";}
	for(var i=0;i<=istar;i++){startopics[i]="";}
	try{if(mytopics){topics=mytopics.split("\n");}}catch(e){};//alert(topics.length);
	if(topics.length>iaiml+1){for(var i=0;i<topics.length-iaiml-1;i++){startopics[i]=topics[i+iaiml+1];}}
function getiallword(text){ 
var i,j,k,l;
i=1;j=iallword;
while((j-i)>=2){
 k=parseInt(i+(j-i)/1.99);
 if(text>=allwords[k-1]){
	i=k;
 }else{
	j=k;
 }
}
if(text==allwords[i-1]){
	return i;
}
if(text==allwords[j-1]){
	return j;
}
l=text.length;
if(text==allwords[i-1].substr(0,l)){
	return -i;
}
if(text==allwords[j-1].substr(0,l)){
	return -j;
}
return 0;
} 
//alert(allwords[getiallword("ok")-1]); 
function weight(x){return Math.sqrt(Math.abs(x));}
function replaceall(text0,str1,str2){
    var text=text0;
	for(var p=0;p<100;p++){
	   if(text.indexOf(str1)<0){break;}
	   text=text.replace(str1,str2);
	   }
	return text;   
}
function formatinput(text0){
var text=text0.toLowerCase();
text=replaceall(text,"'"," ");
text=replaceall(text,","," ");
text=replaceall(text,";"," ");
text=replaceall(text,":"," ");
text=replaceall(text,"."," ");
text=replaceall(text,"!"," ");
text=replaceall(text,"("," ");
text=replaceall(text,")"," ");
text=replaceall(text,"?"," ");
text=replaceall(text,"  "," ");
text=replaceall(text,"é","e");
text=replaceall(text,"è","e");
text=replaceall(text,"ê","e");
text=replaceall(text,"î","i");
text=replaceall(text,"ô","o");
text=replaceall(text,"ù","u");
text=replaceall(text,"û","u");
text=replaceall(text,"à","a");
text=replaceall(text,"â","a");
text=replaceall(text,"ç","c");
return text.trim();
}
function formatoutput(text0){
var text=text0.toLowerCase();
//text=replaceall(text,"é","e");
//text=replaceall(text,"è","e");
//text=replaceall(text,"ê","e");
text=replaceall(text,"î","i");
text=replaceall(text,"ô","o");
text=replaceall(text,"ù","u");
text=replaceall(text,"û","u");
text=replaceall(text,"à","a");
text=replaceall(text,"â","a");
text=replaceall(text,"ç","c");
return text.trim();
}
var botsize=iaiml;
var testpattern=new Array(iaiml+1);
var testiword=new Array(iaiml+1);
var testnword=new Array(iaiml+1);
var tweight=new Array(iaiml+1);
for(var i=0;i<=iaiml;i++){tweight[i]=1;testpattern[i]=1;
    testnword[i]=0;testiword[i]=0;}
var textparse=[],iparse=0,inputword=[];
var nouttemplate=300,iouttemplate=new Array(nouttemplate);
var oldmsg="",msgprocess="",msgmsg="",thatmsg="";
var testproc=0,teststar=0,starrandom=1,ntest=0,ntest0=0,starrandom2=1;
function processinputstar(text0){
var i=0,j=0,k=0,l=0,p=0,n=0,nbword=0,test=0;
var msg="",outmsg="",patt="",patt2="",temp="",text="",startext="";	
text=text0;
var kk=0;
for(i=0;i<istar;i++){
   k=starpatt[i].length;test=1;
   if(k>0){if(text.substr(0,k)!=starpatt[i]){test=0;};}
   if(test==1){
      l=starpatt2[i].length;test=1;p=text.length;
   	if(l>0){if(text.substr(p-l,l)!=starpatt2[i]){test=0;};}
   	if(test==1){
   			n=p-l-k;
   			startext=text.substr(k,n);
   			if(startext!=""){
   				testproc=1;
  				kk+=1;if(kk>nouttemplate){break;}
		        iouttemplate[kk]=i;
				if(topicprev!="" && topicprev==startopics[i]){
  				  kk+=1;if(kk>nouttemplate){break;}
		          iouttemplate[kk]=i;
  				  kk+=1;if(kk>nouttemplate){break;}
		          iouttemplate[kk]=i;
  				  kk+=1;if(kk>nouttemplate){break;}
		          iouttemplate[kk]=i;
				  topicnext=topicprev;	
				}
			    if(topicprev=="" && Math.random()<0.6){break;}
   			}
   	}
   }
}
if(testproc==1){ 
	i=iouttemplate[1+parseInt(Math.random()*kk*0.999)]
	msg=startemp[i];
	/*msg=replaceall(msg,"/botname/","Helen");
	msg=replaceall(msg,"/botmaster/","Chung")
	msg=replaceall(msg,"/date/",new Date().toDateString());
	msg=replaceall(msg,"/size/",botsize);*/
	msg=replaceall(msg,"/*/",startext);
	//outmsg=msg;
	for(var p=1;p<30;p++){
	 if(msg.indexOf("/rnd/")>=0){
        k=msg.indexOf("/rnd/");
        l=msg.indexOf("/rnd2/");
		if(l<0){l=msg.length;}
	 	var msg1=msg.substr(k,l-k);
	 	var msg2=msg.substr(l+6,msg.length);
		msg1=replaceall(msg1,"/rnd/","");
		msg1=replaceall(msg1,"  /li/","/li/");
		msg1=replaceall(msg1," /li/","/li/");
		msg1=replaceall(msg1,"/li2/  ","/li2/");
		msg1=replaceall(msg1,"/li2/ ","/li2/");
		msg1=replaceall(msg1,"/li2/","");
		textparse=[];
		textparse=(msg1.trim()).split("/li/");
		iparse=textparse.length-1;
		msg1=textparse[parseInt(Math.random()*iparse*0.999)+1];
		//'msg+="/"+Str(iparse)+"/"
		//msg=templates[j-1];
		msg=msg.substr(0,k)+msg1.trim()+msg2;
	 }else{
		break;
	}}
	if(testsrai==1){msg=formatcondition(msg);}
	outmsg=msg;
	//msg+=outmsg;
	patt=starpatt[i]+startext+starpatt2[i];
	patt=replaceall(patt,"<bot/>","Helen");
	if(outmsg.length<0.65*patt.length){
		outmsg=patt+" "+outmsg; 
	}
    thatmsg=patt;//auxtext+="/thatmsg="+thatmsg;

    oldmsg=msg;
	msgprocess=msg;
	msgmsg=patt;
	//printmsg(patt+crlf+"> "+msg);
	msg=(patt+crlf+"> "+msg);
}
return msg;//outmsg;
}
var forcestar=0;
function processinput0(text0){
var j=0,k=0,l=0,p=0,n=0,nbword=0,kj=[],q=0,r=0;
var outmsg="",msg="",msg2="",allpatt="",inword="",patt="";
testproc=0;
teststar=0;
var krandom=0;if(randomize==0){krandom=4;}
if(Math.random()<0.5*starrandom || forcestar==1){
	teststar=1;
	starrandom2=Math.max(0.12,starrandom/1.4);
	outmsg=processinputstar(text0);
	if(testproc==1){return outmsg;} 
}else{
	starrandom2=Math.min(1.75,starrandom+0.1);
}
textparse=[];
textparse=text0.split(" ");
iparse=textparse.length;
if(iparse<=0){return "???";} 
j=0;
for(var i=0;i<iparse;i++){ 
	inword=textparse[i];
	//j=getiallword(inword);
	//if(j=0){ 
	  //inword=LCase(getsynonym(inword))
	//}  
	inputword[i]=inword;
}
for(var i=1;i<=iaiml;i++){
	testpattern[i]=0;
	testiword[i]=-1;
	testnword[i]=0;
}
var iparse0=iparse;
nbword=iparse;
for(var i=0;i<iparse0;i++){
   j=getiallword(inputword[i]);
	if(j!=0){
		var allpatt="";//allwordspatt[Math.abs(j)-1];
		p=Math.abs(j);
		l=inputword[i].length;
		iparse=0;
		for(n=1;n<100;n++){
		 if(p<=iallword){
			if(inputword[i]==allwords[p-1].substr(0,l)){
				var iparse00=iparse;
				allpatt+=allwordspatt[p-1];
				textparse=[];
				textparse=allpatt.split("/");
				iparse=textparse.length;
				r=Math.max(1,allwords[p-1].length);
				if(r==l){r=2;}else{r=(4+l)/(4+r);}
	            for(q=iparse00;q<iparse;q++){
				  kj[q]=r;
				}  
     			p+=1;
			}else{
				break; 
			}
		 }else{
		 	break;
		 }
		} 
		textparse=[];
		textparse=allpatt.split("/");
		iparse=textparse.length;
		//'msg2=allwords(iwords(Abs(j)))+"/"+allpatt'allwordspatt(iwords(Abs(j)))
	}else{
		iparse=0;
	}
	if(iparse>0){
		for(p=0;p<iparse;p++){
		   n=Math.max(1,Math.min(iaiml,parseInt(textparse[p])));
		   if(testiword[n]<i){
             testiword[n]=i;		   
			 testnword[n]+=1;
			 var k03=0.3;if(randomize==0){k03=0.001;}
			 if(kj[p]>0.87){
				testpattern[n]+=kj[p]*weight(4+(inputword[i].length))*(1+Math.random()*k03)*Math.sqrt(0.507+15/(40+patterns[n-1].length));
			 }else{
				testpattern[n]+=kj[p]*0.65*weight(4+(inputword[i].length))*(1+Math.random()*k03)*Math.sqrt(0.507+15/(40+patterns[n-1].length));
			 }
			 if(testnword[n]==1){
			  var len=Math.abs(patterns[n-1].length-text0.length);
			  var len0=text0.length+25;
		      if(len<1+0.1*text0.length){testpattern[n]+=1;}
		      if(len<1){
				  testpattern[n]+=1+krandom;
				  if(thats[n-1]==thatmsg){testpattern[n]+=1.2+krandom;}//auxtext+="!!"+thatmsg;}
				  }
		      if(patterns[n-1]==text0){testpattern[n]+=1.2+krandom*8;}
			  if(thats[n-1]!=thatmsg && thats[n-1]!=""){testpattern[n]-=1.2;}
			  if(topicprev!=""){
			   if(topics[n-1]==topicprev){testpattern[n]+=ktopic*0.2+krandom;}
			  }
			  testpattern[n]*=(len0)/(len0+len);	
		     }
		   }	 
		}
	}
}
for(var i=1;i<=iaiml;i++){
	if(randomize==0){tweight[i]=3.0;}
	testpattern[i]*=tweight[i];
	//tweight[i]=Math.min(2.0,tweight[i]*1.1);
	tweight[i]=Math.min(3.0,tweight[i]+0.05*(3.0-tweight[i]));//*1.1);
	if(testnword[i]==nbword){testpattern[i]*=1.2;}
}
var xtest=0.01;
j=0;ntest=0;
for(var i=1;i<=iaiml;i++){
   if(testpattern[i]>0.01){ntest+=1;
	if(testpattern[i]>xtest){
		xtest=testpattern[i];
		j=i;
   }}
}
if(j>0){
 textparse=[];
 textparse=patterns[j].split(" ");
 if(textparse.length>nbword){
	k=0;
	var dx=xtest*0.3;if(randomize==0){dx*=0.01;}
	for(var i=1;i<=iaiml;i++){
		if(Math.abs(testpattern[i]-xtest)<dx){
			k+=1;if(k>=nouttemplate){break;}
			iouttemplate[k]=i;
		}
	}
	j=iouttemplate[1+parseInt(Math.random()*k*0.999)];
 }
}
if(j>0){
	if(topicprev!="" && topics[j-1]==topicprev){
          if(randomize==1){tweight[j]=Math.max(0.3*40/(40+patterns[j-1].length),tweight[j]/1.1);}
     	  topicnext=topicprev;
	}else if(randomize==1){tweight[j]=Math.max(0.3*40/(40+patterns[j-1].length),tweight[j]/1.4);}
	msg=templates[j-1];
	//outmsg=msg;
	for(var p=1;p<30;p++){
	 if(msg.indexOf("/rnd/")>=0){
        k=msg.indexOf("/rnd/");
        l=msg.indexOf("/rnd2/");
	 	var msg1=msg.substr(k,l-k);
	 	var msg2=msg.substr(l+6,msg.length);
		msg1=replaceall(msg1,"/rnd/","");
		msg1=replaceall(msg1,"  /li/","/li/");
		msg1=replaceall(msg1," /li/","/li/");
		msg1=replaceall(msg1,"/li2/  ","/li2/");
		msg1=replaceall(msg1,"/li2/ ","/li2/");
		msg1=replaceall(msg1,"/li2/","");
		textparse=[];
		textparse=(msg1.trim()).split("/li/");
		iparse=textparse.length-1;
		msg1=textparse[parseInt(Math.random()*iparse*0.999)+1];
		//'msg+="/"+Str(iparse)+"/"
		//msg=templates[j-1];
		msg=msg.substr(0,k)+msg1.trim()+msg2;
	 }else{
		break;
	}}
	if(testsrai==1){msg=formatcondition(msg);}
	outmsg=msg;
	//msg+=outmsg;
	/* /'parse(outmsg," ")
	outmsg=""
	For i=1 To iparse
		If Rnd<01.5 Then
			outmsg+=getsynonym1(textparse(i))+" "
		Else
			outmsg+=textparse(i)+" "
		EndIf
	Next
	msg+="/"+outmsg '/*/
	patt=patterns[j-1];
	patt=replaceall(patt,"<bot/>","Helen");
	if(outmsg.length<0.65*patt.length){
		outmsg=patt+" "+outmsg; 
	}
}
if(j<=0){
	if(teststar==0){
		teststar=1;
		testproc=0;
		outmsg=processinputstar(text0);
		if(testproc==1){return outmsg;} 
	}
}
oldmsg=msg;
if(j>0){
	msgprocess=msg;
	msgmsg=patt;
	//printmsg(patt+crlf+"> "+msg);
	msg=(patt+crlf+"> "+msg);
    thatmsg=patt;//auxtext+="/thatmsg="+thatmsg;
}else{
    if(Math.random()<0.35){msg="i don't see what you mean";}
	else if(Math.random()<0.5){msg="that's too complicated for me";}
	else{msg="can you be more explicit";}
	if(Math.random()<0.7 || randomize==0){testsay222=1;}
	oldmsg=msg;
	outmsg=msg;
	msgprocess=msg;
	msgmsg="";
	//printmsg("> "+msg);
	msg=("> "+msg);
}
return msg;//outmsg;
}
function formatconst(msg0){
	var msg=msg0;
	msg=replaceall(msg,"/botname/","Helen");
	msg=replaceall(msg,"/botmaster/","Chung");
	msg=replaceall(msg,"/date/",new Date().toDateString());
	msg=replaceall(msg,"/size/",botsize);
	return msg;
}
function setformatconst(){
	setvar("botname","Helen");
	setvar("botmaster","Chung");
	setvar("date",new Date().toDateString());
	setvar("size",botsize);
	setvar("vocabulary",iallword);
}
function subhelp(){
	var msg="say 'help' => help"+crlf+crlf;
	msg+="return => repeat"+crlf;
	msg+="star*  => autochat"+crlf;
	msg+="'vars'   => display aimlvars"+crlf;
	msg+="'resetvars' => reset aimlvars"+crlf;
	msg+="'randomize' => randomize"+crlf;
	msg+="'wiki +keywords' => wiki search"+crlf;
	alert(msg);
}
function subvars(){
	var msg="aiml vars :"+crlf;
	var j=0;
	for(var i=0;i<nvars;i++){
	    if(varnames[i]!=""){msg+=varnames[i]+"="+varvalues[i]+crlf;j+=1;if(j>200){break;}}
	}
	alert(msg);
}
var randomize=-1;
function subrandomize(){
	if(randomize==0){if(confirm("set randomize on ?")){randomize=1;setvar("myaimlrandomize",1);savevars();}}
	else{if(confirm("set randomize off ?")){randomize=0;setvar("myaimlrandomize",0);savevars();}}
}
var optset=0,optthink=0,testsrai=0;
var topicprev="",topicnext="",ktopic=0;
var text00="";
function processinput(text0){
msgcanvas=text0;
if(text0==text00){forcestar=parseInt(Math.random()*1.99);}else{forcestar=0;}
text00=text0;
if(text0=="reset vars" || text0=="resetvars"){
  if(confirm("reset aiml vars ?")){resetaimlvars();
     document.getElementById('intext').value="";}}
if(text0=="help"){subhelp();
     document.getElementById('intext').value="";}
if(text0=="vars"){subvars();
     document.getElementById('intext').value="";}
if(randomize<0){if(getvar("myaimlrandomize")=="myaimlrandomize"){randomize=1;setvar("myaimlrandomize",1);}
                else{randomize=parseInt(getvar("myaimlrandomize"));}
				}
if(text0=="randomize"){subrandomize();
     document.getElementById('intext').value="";}
var i,j,k,n,j1,nmax=4;
var text="",mymsg="",txt="",msgprocess0="",msgprocess2="";
if(topicprev!=topicnext || topicprev==""){
	ktopic=Math.max(0.1,ktopic-0.1);
	if(ktopic<0.11){topicprev="";}
	topicnext="";
}else{
	ktopic=Math.min(1.0,ktopic+0.1);
	topicnext="";
}
//mymsg=">>"+text0;
ntest0=0;
starrandom=starrandom2;
optset=1;optthink=0;
testsrai=0;
auxtext="";
for(n=1;n<=nmax;n++){ 
   txt=processinput0(text0);
   ntest0+=ntest;
   msgprocess=formatoutput2(msgprocess);
   //if(msgmsg!=""){mymsg+=crlf+msgmsg+msgprocess;}
   for(var i=1;i<=30;i++){	
	   j=msgprocess.indexOf("/srai/");
	   j1=msgprocess.indexOf("/cond0/");
	   if(j>=0 && (j<j1 || j1<0)){
	    if(msgprocess.length>2000){n=nmax+3;break;}
		testsrai=1;
		msgprocess0=msgprocess.substr(0,j);
	   	text=msgprocess.substr(j+6,msgprocess.length);
	   	k=text.indexOf("/srai2/");
	   	if(k>=0){
		    msgprocess2=text.substr(k+7,text.length)
	   		text=text.substr(0,k);
	   		text=formatinput(text);
	   		txt=processinput0(text);
            ntest0+=ntest;
			msgprocess0=formatget(msgprocess0);
		    msgprocess0=formatconst(msgprocess0);
            msgprocess=formatoutput2(msgprocess);
			msgprocess=msgprocess0+msgprocess+msgprocess2;
	   		//if(msgmsg!=""){mymsg+=crlf+msgmsg;}
	   	}
	   }else if(j1>=0 && (j1<j || j<0)){
	   	j=j1;
	    if(msgprocess.length>20000){n=nmax+3;break;}
		msgprocess0=msgprocess.substr(0,j);
	   	text=msgprocess.substr(j,msgprocess.length);
	   	k=text.indexOf("/cond2/");
	   	if(k>=0){
		    msgprocess2=text.substr(k+7,text.length)
	   		text=text.substr(0,k+7);
	   		text=formatinput(text);
	   		text=formatcondition(text);
	   	    msgprocess0=formatget(msgprocess0);
			msgprocess0=formatconst(msgprocess0);
	   		msgprocess=formatoutput2(text);
	   		msgprocess=msgprocess0+msgprocess+msgprocess2;
		}else{
		n=nmax+3;break;}
	   }else{
	   	 n=n+99;break; 
	   }
   }
   if(n>99){n-=99;if(Math.random()<0.35){break;};}
   j=msgprocess.indexOf("/srai/");
   if(j<0 && msgprocess!="" && msgmsg!=""){break;}  
}
optset=0;optthink=1;
msgprocess=formatget(msgprocess);
msgprocess=formatconst(msgprocess);
msgmsg=formatget(msgmsg);
msgmsg=formatconst(msgmsg);
if(n>nmax+2){
	msgprocess="that's more than i can say";
	msgmsg="> "+msgprocess;
	txt=msgmsg;
	if(Math.random()<0.7){testsay222=1;}
}else if(n>nmax){
	msgprocess="i dont know what to say";
	msgmsg="> "+msgprocess;
	txt=msgmsg;
	if(Math.random()<0.7){testsay222=1;}
}else if(msgmsg=""){
    msgprocess=formatoutput2(msgprocess);
	msgmsg="> "+msgprocess;
}else if(i>1 || n>1){
    msgprocess=formatoutput2(msgprocess);
    msgmsg=formatoutput2(msgmsg);
	msgmsg+=crlf+"> "+msgprocess;
	txt="."+txt;
}else{	
    msgprocess=formatoutput2(msgprocess);
    msgmsg=formatoutput2(msgmsg);
	msgmsg+=crlf+"> "+msgprocess;
}
oldmsg=formatget(oldmsg);
oldmsg=formatoutput2(oldmsg);
printcanvasmsg(msgcanvas,msgprocess);
txt=formatget(txt);
txt=formatoutput2(txt);
txt=formatget(txt);
i=txt.indexOf(crlf+">");
txt=txt.substr(0,i)+crlf+"> "+msgprocess;
return txt+mymsg;
}
var nvars=2000;
var vark=[],varnames=[],varvalues=[];
for(var i=0;i<nvars;i++){
	vark[i]=i;
	varnames[i]="";varvalues[i]="";
}
function setvar(varname,varvalue){
var i,j,k,p;
if(varname=="topic"){
	if(varvalue==""){ktopic=0;}else{ktopic=1;}
	topicprev=varvalue.trim().toLowerCase();
	topicnext=topicprev;
}
k=-1;
for(var i=0;i<nvars;i++){
	if(varnames[i]==varname){
		k=vark[i];
		for(j=0;j<nvars;j++){
			if(vark[j]<k){vark[j]+=1;}
		}
		vark[i]=0;
		varvalues[i]=varvalue;
		return;
	}
}
p=-1;
for(var j=0;j<nvars;j++){
	vark[j]+=1;
	if(vark[j]>p){
		p=vark[j];
		k=j;
	}
}
if(k<0){k=0;}
vark[k]=0;
varnames[k]=varname;
varvalues[k]=varvalue;	
}
function getvar(varname){
var i,j,k;
k=-1;
for(var i=0;i<nvars;i++){
	if(varnames[i]==varname){
		k=vark[i];
	    for(j=0;j<nvars;j++){
			if(vark[j]<k){vark[j]+=1;}
		}
		vark[i]=0;
		return varvalues[i];
	}
}
return varname;
} 
function formatcondition(text0){
var i,j,k,n,p,i2;
	var text=text0,text2="",text1="";
	for(var p=1;p<90;p++){
	  i=text.indexOf("/cond0/");
	  if(i<0){text2+=text;break;}
	     //auxtext+="/cond0/";
		 text2+=text.substr(0,i);
		 text=text.substr(i+7,text.length);
		 i=text.indexOf("/cond2/");
		 if(i<0){break;}
		 text1=text.substr(0,i);
		 text=text.substr(i+7,text.length);
		 i=text1.indexOf("/cond1/");
		 if(i<0){break;}
		 var varname=text1.substr(0,i).trim();
		 var varvalue=getvar(varname);
  	 	 //auxtext+="/"+varname+":"+varvalue;
		 text1=text1.substr(i+7,text1.length);
		 for(var n=1;n<90;n++){
		 	i=text1.indexOf("/li0/");
		 	if(i<0){break;}
		 	text1=text1.substr(i+5,text1.length);
		 	i=text1.indexOf("/li1/");
		 	if(i<0){break;}
		 	var varvalue2=text1.substr(0,i);
  	 	    //auxtext+="?="+varvalue2;
		 	text1=text1.substr(i+5,text1.length);
		 	if(varvalue.toLowerCase()==varvalue2){
		      i=text1.indexOf("/li2/");
		      if(i<0){break;}
		      text1=text1.substr(0,i);
		      text2+=text1;
		      //auxtext+="="+text1;
		      break;	
		 	}
		 }
	}
return text2;
}
function formatget(text0){
var i,p;
var text=text0,text2="";
	for(p=1;p<90;p++){
	  i=text.indexOf("/get0/");
	  if(i<0){text2+=text;break;}
		 text2+=text.substr(0,i);
		 text=text.substr(i+6,text.length);
		 i=text.indexOf("/get1/");
		 if(i<0){break;};
		 var varname=text.substr(0,i).trim();
	     text=text.substr(i+6,text.length);
		 text2+=getvar(varname);
  	 	 //auxtext+="/"+varname+":"+getvar(varname);
	}
return text2;
}
var ipushvar=0,pushvarindex=[];
var pushvarname=[];
function formatoutput2(text0){
var i,j,k,n,p,i2;
	var text=text0,text2="",text3="";
	text=replaceall(text,"/br/",crlf);
	ipushvar=0;
	for(var p=1;p<90;p++){
	  i=text.indexOf("/set0/");
	  i2=text.indexOf("/set2/");
	  if(i<0 && i2<0){text2+=text;text3+=text;break;}
	  if(i<i2 && i>=0){		 
		 text2+=text.substr(0,i);
		 text3+=text.substr(0,i);
		 text=text.substr(i+6,text.length);
		 i=text.indexOf("/set1/");
		 if(i<0){break;}
		 var varname=text.substr(0,i).trim();
		 text=text.substr(i+6,text.length);
		 ipushvar+=1;
		 pushvarname[ipushvar]=varname;
		 pushvarindex[ipushvar]=text2.length;
	  }else{
	  	 i=i2;
		 text2+=text.substr(0,i);
		 text3+=text.substr(0,i);
		 text=text.substr(i+6,text.length);
	  	 if(ipushvar>0){
	  	 	var varname=pushvarname[ipushvar];
	  	 	j=pushvarindex[ipushvar];
			text3=formatget(text3);
	  	 	ipushvar-=1;
	  	 	var varvalue=text2.substr(j,text2.length);
			varvalue=formatget(varvalue);
	  	 	if(optset==1){setvar(varname,varvalue);}
	  	 	//auxtext+="/"+varname+"="+getvar(varname);
	  	 }
	 } 	
	}
	text2=text3;
	text2=replaceall(text2,"/set2/","");
	if(optthink==1){
	 text=text2;text2="";
	 n=0;
	 for(p=1;p<900;p++){
		i=text.indexOf("/think0/");
		j=text.indexOf("/think2/");
		if(i<0 && n<=0){text2+=text;break;}
		if(n==0){text2+=text.substr(0,i);}
        if(i<j && i>=0){
      	  n+=1;
      	  text=text.substr(i+8,text.length);
        }
		if(i>j || i<0){
          n-=1;
		  text=text.substr(j+8,text.length);
		}
	 }
	}
	text2=text2.trim();
	return text2;
}
function resetaimlvars(){
  for(var i=0;i<nvars;i++){
      vark[i]=i;
	  varnames[i]="";
	  varvalues[i]="";
}}
function savevars(){
var text="";
for(var i=0;i<nvars;i++){
    text+=varnames[i]+"="+varvalues[i]+"//"+vark[i]+"§§";}
if(localStorage){localStorage.setItem("chatbot_chung_small_savevars",text);}
}
function loadvars(){
var text="";
if(localStorage){text=localStorage.getItem("chatbot_chung_small_savevars");}
if(text!=null && text!=""){
  var textline=[];
  textline=text.split("§§");
  for(var i=0;i<nvars;i++){
      vark[i]=i;
	  varnames[i]="";
	  varvalues[i]="";
	  if(textline[i]){
	     var j=textline[i].indexOf("=");   
	     var k=textline[i].indexOf("//");   
	     varnames[i]=textline[i].substr(0,j);   
	     varvalues[i]=textline[i].substr(j+1,k-j-1);   
	     try{vark[i]=eval(textline[i].substr(k+2,9));}catch(e){vark[i]=i;}
      }}
}
}
function close(){
	  savevars();
	  audio.pause();audio.src="";
}	
loadvars();
setformatconst();
//alert(vark[nvars-1]+"/"+varnames[nvars-1]+"="+varvalues[nvars-1]);
//alert(vark[nvars-2]+"/"+varnames[nvars-2]+"="+varvalues[nvars-2]);
var mywikitext="";
function formatwiki(text0){
 var i,j,k,c,text="",text2="";
 var words=text0.split(".,");//alert(words.length);
 for(var n=0;n<5;n++){
   text=words[parseInt(Math.random()*words.length*0.99)];
   if(text.toLowerCase().indexOf("refer to:")<0){break;}}
 if(text.toLowerCase().indexOf("refer to:")>=0){return "";}
 randomwiki-=1/(1+words.length);
 j=0;k=0;
 for(var i=0;i<text.length;i++){
  c=text.substr(i,1);
  if(c=="(" || c=="[" || c=="{"){j+=1;}
  //if(c=="/"){if(k==0){k=1;}else{k=0;}}
  if(j==0 && k==0){text2+=c;}
  if(c==")" || c=="]" || c=="}"){j-=1;}
 }
text=text2;
/*text=replaceall(text,"é","e");
text=replaceall(text,"è","e");
text=replaceall(text,"ê","e");
text=replaceall(text,"î","i");
text=replaceall(text,"ô","o");
text=replaceall(text,"ù","u");
text=replaceall(text,"û","u");
text=replaceall(text,"à","a");
text=replaceall(text,"â","a");
text=replaceall(text,"ç","c");
text=replaceall(text,"ã","a");
text=replaceall(text,"õ","o");
text=replaceall(text,"Â","A");
text=replaceall(text,"Ê","E");
text=replaceall(text,"Î","I");
text=replaceall(text,"Ô","O");
text=replaceall(text,"Û","U");
text=replaceall(text,"'"," ");
*/
return text; 
}
var intext22="",testsay222=0;
function mywikicallback(r){mywikitext="";//alert(r);
mywikitext=formatwiki(""+r[2]);
document.getElementsByTagName('head')[0].removeChild(myjson);
if(mywikitext!=""){intext22=mywikitext;}//randomwiki/=2}
if(testsay222==0){say22();}
else{testsay222=0;say222()}
}
var wikikeysearch="lennon";
wikikeysearch="john lennon";
var myjson;
function subwiki(){
var nlimit=1+parseInt(Math.random()*10);
var wikiurl = 'http://en.wikipedia.org/w/api.php?action=opensearch&search=marcel prou&format=json&callback=mywikicallback&limit=1';
wikiurl="https://en.wikipedia.org/w/api.php?action=opensearch&search="+wikikeysearch+"&limit="+nlimit+"&namespace=0&format=json&redirects=resolve&callback=mywikicallback&utf8=1";
myjson = document.createElement ('script');
myjson.setAttribute ('src', wikiurl);
myjson.setAttribute ('type','text/javascript');
myjson.setAttribute ('async','false');
document.getElementsByTagName('head')[0].appendChild(myjson);
}
var randomwiki=1;
function saytest22(){
randomwiki=Math.max(0.03,Math.min(1,randomwiki+0.03));
var forcewiki=0;if(intext22.substr(0,5).toLowerCase()=="wiki "){forcewiki=1;intext22=intext22.substr(5,99);}
if(Math.random()<0.065*randomwiki+forcewiki){//0.2*
 var word22=intext22.trim().split(" "); 
 if(mywikitext!="searching..." && (word22.length>=1 && word22.length<=3)){
   mywikitext="searching...";wikikeysearch=intext22;subwiki();
   return;}}
say22();
}
function saytest222(){
 var word22=intext22.trim().split(" "); 
 if(mywikitext!="searching..." && (word22.length>=1 && word22.length<=3)){
   mywikitext="searching...";wikikeysearch=intext22;testsay222=1;subwiki();
   return;}
say222();
}


