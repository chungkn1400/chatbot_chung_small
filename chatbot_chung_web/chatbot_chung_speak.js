// chatbot_chung_speak a program by NGUYEN.Chung (freeware 2015)
var paudio=[],iaudio=0;
var Timer=-1;
function speak(){
if(textspeakall.length>99){
   var i=99;
   for(var j=0;j<40;j++){
       if(textspeakall.substr(i-j,1)==" "){break;};}	   
   i=i-j;
   textspeak=textspeakall.substr(0,i);
   textspeakall=textspeakall.substr(i,textspeakall.length-i);
}else{textspeak=textspeakall;textspeakall="";}
textspeak=textspeak.toLowerCase();
//auxvar=(window.speechSynthesis)+"/tsay="+tsay;
if (('speechSynthesis' in window)&&(tsay==1)){
   speakhtml();if(tsay==1){return;};
}
tsay=0;
var ttslang=lang;
//alert(textspeak);
//audiosrc ='http://translate.google.com/translate_tts?ie=utf-8&tl=en&q='+encodeURIComponent(textspeak);
//audiosrc ='http://translate.google.com/translate_tts?&tl=en&q='+encodeURIComponent(textspeak);
audiosrc ="http://translate.google.com/translate_tts?&tl="+ttslang+"&q="+encodeURIComponent(textspeak);
audiosrc='http://translate.google.com/translate_tts?tl='+ttslang+'&q='+encodeURIComponent(textspeak)+'&ie=UTF-8&total=1&idx=0&client=t';
//audiosrc ='http://translate.google.com/translate_tts?&tl=es&q='+encodeURIComponent(textspeak);
//audiosrc ='http://translate.google.com/translate_tts?&tl=fr&q='+encodeURIComponent(textspeak);
//audiosrc ='http://translate.google.com/translate_tts?&tl=de&q='+encodeURIComponent(textspeak);
//audiosrc ='http://translate.google.com/translate_tts?&tl=it&q='+encodeURIComponent(textspeak);
//text=encodeURIComponent(textspeak);
//audiosrc='http://translate.google.com/translate_tts?ie=UTF-8&q='+text+'&tl=en&total=1&idx=0&textlen='+text.length+'&prev=input';
var msg=textspeak;
textspeak=textspeak+" ";

getmyresponsivevoice(ttslang);
if(myresponsivevoice!=""){responsivespeak(msg);return;}
if(ttslang='en'){myresponsivevoice="";responsivespeak(msg);return;}


if(iaudio>0){paudio[iaudio].src=null;}
iaudio+=1;
paudio[iaudio]=new Audio();
audio=paudio[iaudio];
 
audio.type="audio/mp3";//"x-wav";
audio.src=audiosrc;
Timer=-1;
//audio.addEventListener('loadedmetadata',function(){
audio.addEventListener('canplay',function(){
 tsay=0;
 if(Timer<0){ Timer=gettimer()/1000.0;
 audiotime0=Timer;
 audiotime1=Timer+audio.duration;
 if(textspeakall.length>1){audiotime1-=0.05;}//0.5
 //alert(audiotime1-audiotime0);
 //audio.playbackRate=0.7;
 audio.play();
 };
});
//audio.addEventListener('ended',function(){audio.src="";});
tsay=1;audiotime1=8+gettimer()/1000.0;
audio.load();
//audio.play();//load();
//alert("say0="+textspeak);
//alert("$"+vars['_y']);
//alert("$ "+vars['_x']+eval("if(vars['_x']){alert(vars['_x']);};"));eval("vars['_x']='ok1'");
document.getElementById('intext').value="";
document.getElementById('intext').focus();
document.getElementById('ntest').innerHTML=" "+ntest0;
}
/*var myjs=document.createElement("script");
myjs.type = "text/javascript";
myjs.src = 'https://code.responsivevoice.org/responsivevoice.js';
myjs.async=false;
myjs.onload = function(){alert("ok");}
document.getElementsByTagName('head')[0].appendChild(myjs);
*/
var responserate=0.060,responsivemsg="",myresponsivevoice="";
function responsivespeak(msg){
Timer=-1;
responsivemsg=msg;
tsay=1;audiotime1=8+gettimer()/1000.0;
var voicename="UK English Female";
if(myresponsivevoice!=""){voicename=myresponsivevoice;}
//responsiveVoice.speak(msg,voicename);
responsiveVoice.speak(msg,voicename,{onstart:startresponse,onend:endresponse});
document.getElementById('intext').value="";
document.getElementById('intext').focus();
document.getElementById('ntest').innerHTML=" "+ntest0;
}
function startresponse(){
 tsay=0;
 if(Timer<0){ Timer=gettimer()/1000.0;
 audiotime0=Timer;
 audiotime1=Timer+responserate*responsivemsg.length;//textspeakall.length;
 //if(textspeakall.length>1){audiotime1-=0.05;}//0.5
 //alert(audiotime1-audiotime0);
}}
function endresponse(){
audiotime1=gettimer()/1000.0;
var rate=(audiotime1-audiotime0)/(1+responsivemsg.length);
responserate+=(rate-responserate)*0.4;
}
function getmyresponsivevoice(ttslang){
myresponsivevoice="";
var voices=responsiveVoice.responsivevoices;
//alert(voices[0].name);
//alert(listlang[0]+" "+listlangname[0]);
var langname="";
for(var i=0;i<listlang.length;i++){
	if(ttslang.toLowerCase()==listlang[i].toLowerCase()){
		langname=listlangname[i];break;}
}
if(langname==""){return;}
langname=langname.substr(0,4).toLowerCase();
//alert(langname);
for(var i=0;i<voices.length;i++){
	if(voices[i].name.toLowerCase().indexOf(langname)==0){
		myresponsivevoice=voices[i].name;break;
	}
	if(voices[i].name.toLowerCase().indexOf(" "+langname)>=0){
		myresponsivevoice=voices[i].name;break;
	}
}
//alert(myresponsivevoice);
if(myresponsivevoice!=""){return;}
for(var i=0;i<voices.length;i++){
	if(voices[i].name.toLowerCase().indexOf(ttslang.toLowerCase())==0){
		myresponsivevoice=voices[i].name;break;
	}
}
//alert(myresponsivevoice);
}
/*
        self.responsivevoices = [
            {name: 'UK English Female', voiceIDs: [3, 5, 1, 6, 7, 171, 8]},
            {name: 'UK English Male', voiceIDs: [0, 4, 2, 6, 7, 75, 159]},
            {name: 'US English Female', voiceIDs: [39, 40, 41, 42, 43, 173, 44]},
            {name: 'Arabic Male', voiceIDs: [96,95,97,98]},
            {name: 'Armenian Male', voiceIDs: [99]},
            {name: 'Australian Female', voiceIDs: [87,86,5,88]},
            {name: 'Brazilian Portuguese Female', voiceIDs: [124,123,125,186,126]},
            {name: 'Chinese Female', voiceIDs: [58, 59, 60, 155, 191, 61]},
            {name: 'Czech Female', voiceIDs: [101,100,102,103]},
            {name: 'Danish Female', voiceIDs: [105,104,106,107]},
            {name: 'Deutsch Female', voiceIDs: [27, 28, 29, 30, 31, 78, 170, 32]},
            {name: 'Dutch Female', voiceIDs: [84, 157, 158, 184, 45]},
            {name: 'Finnish Female', voiceIDs: [90,89,91,92]},
            {name: 'French Female', voiceIDs: [21, 22, 23, 77, 178, 26]},
            {name: 'Greek Female', voiceIDs: [62, 63, 80, 64]},
            {name: 'Hatian Creole Female', voiceIDs: [109]},
            {name: 'Hindi Female', voiceIDs: [66, 154, 179, 67]},
            {name: 'Hungarian Female', voiceIDs: [9, 10, 81, 11]},
            {name: 'Indonesian Female', voiceIDs: [111,112,180,113]},
            {name: 'Italian Female', voiceIDs: [33, 34, 35, 36, 37, 79, 181, 38]},
            {name: 'Japanese Female', voiceIDs: [50, 51, 52, 153, 182, 53]},
            {name: 'Korean Female', voiceIDs: [54, 55, 56, 156, 183, 57]},
            {name: 'Latin Female', voiceIDs: [114]},
            {name: 'Norwegian Female', voiceIDs: [72, 73, 74]},
            {name: 'Polish Female', voiceIDs: [120,119,121,185,122]},
            {name: 'Portuguese Female', voiceIDs: [128,127,129,187,130]},
            {name: 'Romanian Male', voiceIDs: [151, 150, 152, 46]},
            {name: 'Russian Female', voiceIDs: [47,48,83,188,49]},
            {name: 'Slovak Female', voiceIDs: [133,132,134,135]},
            {name: 'Spanish Female', voiceIDs: [19, 16, 17, 18, 20, 76, 174, 15]},
            {name: 'Spanish Latin American Female', voiceIDs: [137,136,138,175,139]},
            {name: 'Swedish Female', voiceIDs: [85, 148, 149, 65]},
            {name: 'Tamil Male', voiceIDs: [141]},
            {name: 'Thai Female', voiceIDs: [143,142,144,189,145]},
            {name: 'Turkish Female', voiceIDs: [69, 70, 82, 190, 71]},
            {name: 'Afrikaans Male', voiceIDs: [93]},
            {name: 'Albanian Male', voiceIDs: [94]},
            {name: 'Bosnian Male', voiceIDs: [14]},
            {name: 'Catalan Male', voiceIDs: [68]},
            {name: 'Croatian Male', voiceIDs: [13]},
            {name: 'Czech Male', voiceIDs: [161]},	
            {name: 'Danish Male', voiceIDs: [162]},	
            {name: 'Esperanto Male', voiceIDs: [108]},
            {name: 'Finnish Male', voiceIDs: [160]},	
            {name: 'Greek Male', voiceIDs: [163]},	
            {name: 'Hungarian Male', voiceIDs: [164]},	
            {name: 'Icelandic Male', voiceIDs: [110]},
            {name: 'Latin Male', voiceIDs: [165]},	
            {name: 'Latvian Male', voiceIDs: [115]},
            {name: 'Macedonian Male', voiceIDs: [116]},
            {name: 'Moldavian Male', voiceIDs: [117]},
            {name: 'Montenegrin Male', voiceIDs: [118]},
            {name: 'Norwegian Male', voiceIDs: [166]},	
            {name: 'Serbian Male', voiceIDs: [12]},
            {name: 'Serbo-Croatian Male', voiceIDs: [131]},
            {name: 'Slovak Male', voiceIDs: [167]},	
            {name: 'Swahili Male', voiceIDs: [140]},
            {name: 'Swedish Male', voiceIDs: [168]},
            {name: 'Vietnamese Male', voiceIDs: [146]},
            {name: 'Welsh Male', voiceIDs: [147]},
            {name: 'US English Male', voiceIDs: [169]},
            {name: 'Fallback UK Female', voiceIDs: [8]}
*/