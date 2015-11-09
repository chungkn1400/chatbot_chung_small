var voicemsg="",auxvoicetext="",voiceoutmsg="",voiceoutmsg0="",voiceoutmsg00="",voiceoutmsg1="",voiceoutmsg01="";
var recoinput="",irecoinput=0,trecoinput=0;
function printvoicemsg(txt){
   //document.getElementById("msg").value=txt;
   }
function printvoicemsg0(txt){
   //document.getElementById("msg").value=txt;
   }
function printvoicemsginfo(txt){
   if(recoinput!=""){document.getElementById("msg").value=txt;}
   }
var langvoice="en";
function subvoicecombo(){
langvoice="en";
//icombo=document.getElementById('combo').selectedIndex;
//langvoice=document.getElementById('combo')[icombo].id;
recognition.lang=langvoice;
recognition.stop();setTimeout('recognition.start();',100);
}
var recognizing=false;
var voicequit=0;var voicewords=[];
var voicetime0=0,voicetime1=0,voicetime00=0,testvoiceloop=0,dt8000=6000;
function dvoicetime(){return parseInt((voicetime1-voicetime00)/1000);}
function recostart(){
voicetime0=voicetimer();voicetime00=voicetimer();
recognition.start();
printvoicemsg0("recovoice..."+recognition);
voicequit=0;
if(testvoiceloop==0){testvoiceloop=1;setTimeout("voiceloop();",1000);}
}
function voicestop(){voicequit=1;voicereset();testvoiceloop=0;}
var ivoicesay=0;
function voiceloop(){
voicetime1=voicetimer();
if(voicequit==1){return;}
if(voiceoutmsg1==""){voiceoutmsg0="";}
if(voiceoutmsg1!=voiceoutmsg00){voiceoutmsg00=voiceoutmsg1;trecoinput=voicetime1;}
else if(voicetime1>trecoinput+1000){
  if(voiceoutmsg1!=voiceoutmsg0 && voiceoutmsg1!=""){
   voiceoutmsg+="$";printvoicemsg(getvoiceoutmsg());voiceoutmsg0=voiceoutmsg1;voiceoutmsg00="///";
   trecoinput=voicetime1;
   recoinput=voiceoutmsg1;//.substr(irecoinput,99);irecoinput=voiceoutmsg1.length;
   printvoicemsg0("'"+recoinput+"' !!");//ivoicesay+=1;recoinput+="("+ivoicesay+")";
   mykeypressvoice();
   voicetime0=-9999;
   }
}   
if(voicetime1>voicetime0+dt8000){
   recognition.stop();
   printvoicemsg0("stop..."+recognition);
   voicetime0=voicetimer();
   setTimeout("voiceloop2();",20);
}else{setTimeout("voiceloop();",100);}
}
function getvoiceoutmsg(){
voiceoutmsg1="";//+"//";
for(var i=0;i<voicewords.length;i++){if(voicewords[i]){voiceoutmsg1+=""+voicewords[i].trim()+" ";}}
voiceoutmsg1=voiceoutmsg1.trim();
var voiceoutmsg10="";
for(var i=0;i<voicewords.length;i++){if(voicewords[i]){voiceoutmsg10+="("+voicewords[i].trim()+")";}}
return voiceoutmsg+"//"+voiceoutmsg10;
}
function voiceloop2(){
voicetime1=voicetimer();
printvoicemsg0(dvoicetime()+"'"+recoinput+"'");
printvoicemsg(getvoiceoutmsg());
if(voicequit==1){return;}
if(recognizing==false){
   for(var i=0;i<voicewords.length;i++){if(voicewords[i]){voiceoutmsg+="("+voicewords[i].trim()+")";}}
   voicewords=[];
   voiceoutmsg1="";voiceoutmsg0="";
   recognition.start();
   printvoicemsg(getvoiceoutmsg());
   setTimeout("voiceloop();",20);
}else{setTimeout("voiceloop2();",20);}
}
function voicereset(){
recognition.stop();
recognizing=false;
printvoicemsg("stop..."+recognition);
}
function subclear(){
voiceoutmsg="";
printvoicemsg("voiceoutmsg");}
function say(txt){
var su = new SpeechSynthesisUtterance();
su.lang = langvoice;//"en";//"-GB";
su.voicetext = txt;//"Hello World";
speechSynthesis.speak(su);
}
function voicetimer(){return Date.now();}
var recognition;
function initvoicereco(){if(recognition){return;}
  recognition = new webkitSpeechRecognition();
  recognition.continuous = true;
  recognition.interimResults = true;
  recognition.lang = langvoice;//"en";
  
  recognition.onstart = function() {
    recognizing = true;
  };

  recognition.onerror = function(event) {
      printvoicemsginfo("error="+event.error);
  };

  recognition.onend = function() {
    recognizing = false;
  };

  recognition.onresult = function(event) {
    if (typeof(event.results) == 'undefined') {
      recognition.onend = null;
      recognition.stop();
	  voiceoutmsg="error ";
       return;
    }
    //for (var i = event.resultIndex; i < event.results.length; ++i) {
    var n=event.resultIndex;
	for (var i=0;i<event.results.length;i++) {
      if (event.results[i].isFinal) {
        trecoinput=voicetimer();
		var l=voicewords.length;
		if(l>1){
		  var w=voicewords[l-1],w2=voicewords[l-2];
		  if(w.length<=w2.length){
		    if(w==w2.substr(w2.length-w.length,99)){voicewords[l-1]=".";}}}
		//if(l>1){if(voicewords[l-1].trim()==lastword(voicewords[l-2])){voicewords[l-1]=".";}}
		//voicewords[n+i]= event.results[i][0].transcript;
      } else {
        voicewords[n+i]=event.results[i][0].transcript.trim();
        trecoinput=voicetimer();
		var l=voicewords.length;
		if(l>1){
		  var w=voicewords[l-1],w2=voicewords[l-2];
		  if(w.length<=w2.length){
		    if(w==w2.substr(w2.length-w.length,99)){voicewords[l-1]=".";}}}
      }
    }
	var voiceoutmsg2=getvoiceoutmsg();
	if(voiceoutmsg2.length>14*30){
	      voiceoutmsg=voiceoutmsg2.substr(voiceoutmsg2.length-10,12);
		  voiceoutmsg2=voiceoutmsg;
		  //voicewords=[];
		  }
    voicetime1=voicetimer();voicetime0=Math.max(voicetime0,voicetime1-dt8000+2000);
	printvoicemsg0(dvoicetime()+"'"+recoinput+"'");
	printvoicemsg(voiceoutmsg2);
	};
}
voicequit=1;
function subrecopause(){voiceinput="";voicetime0=-9999;}
function subrecolang(lan){recognition.lang=lan;}
function subreco(){
 if(voicequit==1){
	 if(confirm("start voice reco ? (chrome only)")){
        voicequit=0;try{initvoicereco();recostart();}catch(e){alert(e);}}
}else if(confirm("stop voice reco ?")){
	 try{voicestop();voicequit=1}catch(e){alert(e)};}
}
printvoicemsg("ok");
