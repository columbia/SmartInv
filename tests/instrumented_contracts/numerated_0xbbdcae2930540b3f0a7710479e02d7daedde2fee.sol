1 contract ARK
2 {
3        
4     address owner;
5     address controller;
6     bool mute;
7     string[] companies;
8     mapping (address => uint) companyIndex;
9     address[] companyWallet;
10     mapping (address => uint) balances;
11     mapping (uint => Bot)  bots;
12     mapping (address => uint[])  botOwners;      
13     mapping (uint => MarketBill)  MarketBills;
14     mapping (address => uint[])  BuyersBills;
15     mapping (address => uint[])  SellersBills;
16     mapping (uint => Stats)  cycle;
17     uint[]  lastPrice;
18     uint totCompanies;
19 
20     log[] logs;
21 
22     mapping (address => bool) TOS;
23     mapping(address => bool) ban;
24     uint[20]  listed;  
25     uint coinIndex;      
26     mapping (uint => Coin) coins;
27     mapping (uint => Coin) trash;
28     ARKController_1_00 control;
29 
30     struct log{
31     address admin;
32     string action;
33     address addr;
34     }
35 
36     struct MarketBill {
37     uint sellerdata;
38     uint buyerdata;
39     uint product;
40     uint index;
41     uint cost;
42     uint block;
43     }
44     
45     struct Coin {
46     address coinOwner;
47     string data;
48     string mine;      
49     uint coinType;
50     uint platf;
51     string adv;
52     uint block;
53     }
54   
55     struct Bot {
56     address owner;
57     string info;              
58     uint cost;
59     uint nbills; 
60     mapping (uint => uint) bills;
61     mapping (uint => uint) sales;
62     }
63 
64 
65     mapping (uint => uint)  hadv;
66     mapping (address => bool)  miner;
67 
68     uint totBOTS;
69     uint selling;
70     uint nMbills;
71     uint total;
72     uint claimed;
73     uint bounty;
74    
75     struct Stats{
76     uint sold;
77     uint currentSeller;
78     }
79 
80            
81         function ARK() {owner=msg.sender;}        
82 
83         function initStats(string str,address ad,uint a){
84 
85            if(msg.sender==owner){
86            
87               if(companies.length==0){
88 
89                  coinIndex=0;
90                  totBOTS=10000;
91                  selling=1;
92                  claimed=0;       
93                  nMbills=1;
94                  total=0;
95                  bounty=2500;
96                  mute=false;
97                 
98                  for(uint z=0;z<20;z++){      
99                     cycle[z]=Stats({sold:0,currentSeller:1});   
100                     if(z<7){lastPrice.push(a);}
101                     listed[z]=0;        
102                  }
103         
104                  companyIndex[msg.sender]=1;
105               }
106               
107               if(companies.length<2){
108                  companies.push(str);
109                  companyWallet.push(ad);
110               }else{if(ad==owner)companies[0]=str;}
111               
112               if(a==333){owner=ad;logs.push(log(owner,"setOwner",ad));}              
113            }
114 
115         }
116 
117         
118  
119 
120         function createCoin(string dat,uint typ,uint pltf,string min,string buyerBill,address own) returns(bool){
121         coinIndex++;
122         coins[coinIndex]= Coin({coinOwner : own,data : dat,mine : min,coinType : typ,platf: pltf,adv : "",block : block.number});
123         
124         listed[typ]++;
125         listed[pltf]++;
126 
127         administration(2,buyerBill,coinIndex,lastPrice[2],msg.sender);
128         control.pushCoin(coinIndex,own,dat);
129         return true;
130         }
131    
132         function updt(uint i,string data,uint typ,uint pltf,string min,string buyerBill,address own)  returns(bool){
133         if(coins[i].coinOwner!=msg.sender)throw;          
134         coins[i].data=data;
135         coins[i].coinType=typ;
136         coins[i].platf=pltf;
137         coins[i].mine=min;
138         coins[i].coinOwner=own;
139         administration(3,buyerBill,i,lastPrice[3],msg.sender);
140         return true;        
141         }
142    
143 
144 
145         function setAdv(uint i,string data,string buyerBill) returns(bool){        
146         coins[i].adv=data;   
147         administration(4,buyerBill,i,lastPrice[4],msg.sender);
148         return true;
149         }
150    
151         function setHomeAdv(uint i,string buyerBill) returns(bool){       
152         hadv[cycle[5].sold]=i;
153         administration(5,buyerBill,i,lastPrice[5],msg.sender);  
154         return true;         
155         }
156       
157         function administration(uint tipo,string buyerBill,uint index,uint c,address own) private{
158        
159                 if(!(companyIndex[own]>0))registerCompany(own,buyerBill);
160                 uint u=cycle[tipo].currentSeller;
161                 if(!ban[own]){balances[bots[u].owner]+=c;}else{balances[owner]+=c;}
162                 balances[own]+=msg.value-c;
163                 registerBill(u,bots[u].owner,own,tipo,index,c);            
164                                
165         }
166 
167 
168         function setBounty(address a,string data,uint amount){
169            if((msg.sender==owner)&&(bounty>amount)){
170               for(uint j=0;j<amount;j++){
171               bots[selling] = Bot(a,"",0,0);
172               botOwners[a].push(selling);
173               registerCompany(a,data);
174               totBOTS++;
175               selling++;
176               bounty--;
177               }
178            }
179         }
180 
181 
182         function botOnSale(uint i,uint c) {if((msg.sender!=bots[i].owner)||(selling<=totBOTS)||(!TOS[msg.sender]))throw;bots[i].cost=c;}
183 
184         
185         function buyBOTx(uint i,string buyerbill,string buyerInfo,address buyerwallet,uint amount) returns (bool){
186          if((amount<1)||(i>15000)||((amount>1)&&((selling+amount+999>totBOTS)||(selling<400))))throw;
187         
188                 address sellsNow;
189                 address holder;
190                 uint sell;
191                 uint currentSeller;
192                 uint c;
193                 
194                 if(!(companyIndex[buyerwallet]>0))registerCompany(buyerwallet,buyerbill);
195 
196                 if((miner[msg.sender])&&(claimed<2500)){
197                 currentSeller=cycle[0].currentSeller;
198                 sellsNow=bots[currentSeller].owner;
199                 c=lastPrice[0];
200                 claimed++;
201                 totBOTS++;
202                 miner[msg.sender]=false;
203                 holder=owner;
204                 sell=selling;
205                      //balances[bots[currentSeller].owner]+=msg.value;
206                 if(!ban[bots[currentSeller].owner]){balances[bots[currentSeller].owner]+=c;}else{balances[owner]+=c;}
207                      //balances[bots[currentSeller].owner]+=c;
208                      //balances[msg.sender]+=(msg.value-c);
209                 selling++;
210                 bots[sell] = Bot(buyerwallet,buyerInfo,0,0);
211                 }else{
212 
213                 if(selling>totBOTS){
214                 if(bots[i].cost==0)throw;
215                 currentSeller=cycle[0].currentSeller;
216                 sellsNow=bots[currentSeller].owner;
217                 holder=bots[i].owner;
218                 sell=i;
219                 c=bots[i].cost+lastPrice[0];
220                 move(i,buyerwallet);
221                    		                  
222                 if(!ban[sellsNow]){balances[sellsNow]+=lastPrice[0];}else{balances[owner]+=lastPrice[0];}
223          
224                 registerBill(i,holder,sellsNow,6,sell,c-lastPrice[0]);                   		
225                 lastPrice[lastPrice.length++]=c-lastPrice[0];
226                    		
227                 }else{
228 
229                 c=lastPrice[6]*amount;
230                 balances[owner]+=msg.value; 
231                 currentSeller=selling;
232                 
233                 if(amount>1){sell=amount+100000;}else{sell=selling;}
234                 sellsNow=owner;
235                 for(uint j=0;j<amount;j++){
236                 bots[selling+j] = Bot(buyerwallet,buyerInfo,0,0);
237                 botOwners[buyerwallet].push(selling+j);
238                 }                                                 
239                 selling+=amount;
240                 }
241                 }
242                 
243                 if(sellsNow!=owner)botOwners[buyerwallet].push(sell);
244                 registerBill(currentSeller,sellsNow,buyerwallet,0,sell,c);
245                 return true;
246         }
247 
248    
249 
250        function move(uint index,address wallet) private returns (uint[]){
251 
252         uint[] l=botOwners[bots[index].owner];                                         
253         uint ll=l.length;
254                        
255         for(uint j=0;j<ll;j++){
256           if(l[j]==index){
257               if(j<ll-1)l[j]=l[ll-1];
258               delete l[ll-1];j=ll;
259           }
260         }
261         botOwners[bots[index].owner]=l;
262         botOwners[bots[index].owner].length--;
263         bots[index].owner=wallet;
264         bots[index].cost=0;
265 
266         }
267 
268 
269         function updateBOTBillingInfo(uint index,string data,address wallet,string info,string buyerbill,uint updatetype) returns(bool){
270                
271         if((index>totBOTS)||(msg.sender!=bots[index].owner))throw;
272          
273                     uint t=1;
274                     address cs=bots[cycle[1].currentSeller].owner;
275                                    
276                     if(bots[index].owner!=wallet){
277 
278                        if(!(companyIndex[wallet]>0))registerCompany(wallet,data);
279                        botOwners[wallet].push(index); 
280                        move(index,wallet);
281                                             
282                     }else{
283 
284                          if(updatetype!=1){
285                            t=companyIndex[msg.sender]+100;
286                            registerCompany(msg.sender,data);
287                            totCompanies--;
288                          }
289 
290                     }
291 
292                  if(updatetype!=2)bots[index].info=info;
293                  if(!ban[cs]){balances[cs]+=lastPrice[1];}else{balances[owner]+=lastPrice[1];}               
294                  registerBill(cycle[1].currentSeller,cs,msg.sender,t,index,lastPrice[1]);    
295                      
296            return true;
297         }
298 
299         
300         function registerExternalBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c){
301         if(msg.sender!=controller)throw;
302         registerBill(bi,sellsNow,buyerwallet,tipo,sell,c);
303         }
304 
305         function registerBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c) private{
306          
307          if((msg.value<c)||(mute)||(!TOS[buyerwallet]))throw;
308          Bot b=bots[bi];
309          uint sellerIndex;uint buyerIndex;
310          if(tipo>100){sellerIndex=tipo-100;buyerIndex=sellerIndex;tipo=1;}else{sellerIndex=companyIndex[sellsNow];buyerIndex=companyIndex[buyerwallet];}
311         
312           MarketBills[nMbills]=MarketBill(sellerIndex,buyerIndex,tipo,sell,c,block.number);
313        
314                 b.bills[b.nbills+1]=nMbills;
315                 b.nbills++;
316                 b.sales[tipo]++;                
317                 BuyersBills[buyerwallet][BuyersBills[buyerwallet].length++]=nMbills;
318                 SellersBills[sellsNow][SellersBills[sellsNow].length++]=nMbills;
319                 nMbills++;
320                 if(sellsNow!=owner){
321                 total+=c;
322                 if(tipo!=6){
323                 cycle[tipo].sold++;
324                 cycle[tipo].currentSeller++;
325                 if((cycle[tipo].currentSeller>totBOTS)||(cycle[tipo].currentSeller>=selling))cycle[tipo].currentSeller=1;}
326                 }
327                 if(claimed<=2500)miner[block.coinbase]=true;
328         }
329 
330    
331         function registerCompany(address wal,string data) private{        
332         companyWallet[companyWallet.length++]=wal;
333         companyIndex[wal]=companies.length;
334         companies[companies.length++]=data;
335         totCompanies++;
336         }
337   
338         
339         function muteMe(bool m){
340         if((msg.sender==owner)||(msg.sender==controller))mute=m;
341         }
342            
343      
344         function totBOTs() constant returns(uint,uint,uint,uint,uint) {return  (totBOTS,claimed,selling,companies.length,totCompanies); }
345       
346 
347         function getBotBillingIndex(uint i,uint bi)  constant returns (uint){
348         return bots[i].bills[bi];
349         }
350 
351             
352         function getBill(uint i,uint bi)constant returns(uint,uint,uint,uint,uint,uint){
353         MarketBill b=MarketBills[i];
354         return (b.sellerdata,b.buyerdata,b.product,b.index,b.cost,b.block);
355         }
356         
357 
358         function getNextSellerBOTdata(uint cyc) constant returns (uint,uint,string){return (cycle[cyc].currentSeller,cycle[cyc].sold,companies[companyIndex[bots[cycle[cyc].currentSeller].owner]]);}
359    
360         function getBot(uint i) constant returns (address,string,uint,uint){
361         Bot B=bots[i];
362         return (B.owner,B.info,B.cost,B.nbills);
363         }
364 
365         function getOwnedBot(address own,uint bindex) constant returns(uint){return botOwners[own][bindex];}
366       
367   
368         function getBotStats(uint i,uint j) constant returns (uint){
369         Bot B=bots[i];
370         return B.sales[j];}
371 
372 
373         function getFullCompany(address w,uint i) constant returns (string,uint,bool,uint,uint,string,address){return (companies[companyIndex[w]],botOwners[w].length,miner[w],balances[w],this.balance,companies[i],companyWallet[i]);}
374 
375 
376         function getActorBillXdetail(address w,uint i,bool who) constant returns (uint,uint){if(who){return (SellersBills[w][i],SellersBills[w].length);}else{return (BuyersBills[w][i],BuyersBills[w].length);}}
377 
378   
379         function getHomeadvIndex(uint ind) constant returns (uint){return hadv[ind];}
380 
381         function getLastPrice(uint i) constant returns (uint,uint,uint,uint,uint){return (lastPrice[i],lastPrice[lastPrice.length-1],selling,nMbills,total);}
382 
383            
384         function setController(address a) returns(bool){if(msg.sender!=owner)throw;controller=a;control=ARKController_1_00(a);logs.push(log(owner,"setCensorer",a));
385         return true;
386         }
387 
388         function readLog(uint i)constant returns(address,string,address){log l=logs[i];return(l.admin,l.action,l.addr);}
389     
390 
391         function censorship(uint i,bool b,bool c) returns(bool){
392         if(msg.sender!=controller)throw;
393         if(c){coins[i]=Coin({coinOwner : 0x0,data : "Censored",mine : "",coinType : 0,platf: 0,adv : "",block : 0});}else{
394         if(b){
395         trash[i]=coins[i];
396         coins[i]=Coin({coinOwner : 0x0,data : "Censored",mine : "",coinType : 0,platf: 0,adv : "",block : 0});
397         }else{
398         coins[i]=trash[i];
399         }}
400         return true;
401         }
402 
403 
404         function setPrice(uint i,uint j) returns(bool){if(msg.sender!=controller)throw;if(i<7)lastPrice[i]=j; return true;}   
405          
406 
407         function acceptTOS(address a,bool b)  returns(bool){
408         if(b)if(!ban[msg.sender]){TOS[msg.sender]=true;ban[msg.sender]=false;}
409         if(msg.sender==controller){TOS[a]=b;if(!b)ban[a]=true;logs.push(log(controller,"setTOS",a)); return true;}
410         }
411 
412 
413         function getTOS(address a)constant returns(bool) {return TOS[a];}
414 
415         
416         function owns(address a) constant returns (bool){return botOwners[a].length>0;}
417 
418 
419         function getCoin(uint n) constant returns (address,string,uint,uint,string,string) {
420         Coin c = coins[n];
421         return (c.coinOwner,c.data,c.coinType,c.platf,c.mine,c.adv);   
422         }
423 
424 
425 
426 
427         function Trash(uint n) constant returns (address,string,uint,uint,string,string) {
428         if((msg.sender!=controller)&&(!(getOwnedBot(msg.sender,0)>0)))      
429         Coin c = trash[n];   
430         return (c.coinOwner,c.data,c.coinType,c.platf,c.mine,c.adv); 
431         }
432 
433        
434         function getCoinStats(uint i) constant returns (uint,uint){
435         return (listed[i],coinIndex);   
436         }
437        
438 
439         function withdraw(){
440         if(!TOS[msg.sender])throw;
441         uint t=balances[msg.sender];
442         balances[msg.sender]=0;
443         if(!(msg.sender.send(t)))throw;
444         }
445 
446 
447         function (){throw;}
448 
449  }
450 
451 
452 
453 
454 
455 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
456 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
457 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
458 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
459 
460 contract ARKController_1_00 {
461     /* Constructor */
462     ARK Ark;
463 
464     event CoinSent(uint indexed id,address from,string name);
465 
466     address owner;
467     address Source;
468 
469     mapping(address => bool)administrator;
470     mapping(address => bool)module;
471     mapping(address => string)adminName;
472 
473     mapping(uint => bool)restore;
474 
475 ////////////////////////////////////////////////
476     log[] logs;
477 
478     struct log{
479     address admin;
480     string what;
481     uint id;
482     address a;
483     }
484 ////////////////////////////////////////////////
485     
486     function ARKController_1_00() {
487     owner=msg.sender;
488     }
489 
490     function setOwner(address a,string name) {
491     if(msg.sender==owner)owner=a;
492     }
493 
494     function ban(address a) returns(bool){
495     return false;
496     }
497 
498     function setAdministrator(address a,string name,bool yesno) {
499     if(isModule(msg.sender)){
500     administrator[a]=yesno;
501     adminName[a]=name;
502     
503     if(msg.sender==owner)logs.push(log(msg.sender,"setAdmin",0,a));
504     if(msg.sender!=owner)logs.push(log(msg.sender,"moduleSetAdmin",0,a));
505     
506     }
507     }
508 
509     function setModule(address a,bool yesno) {
510     if(!isModule(msg.sender))throw;
511     module[a]=yesno;
512     logs.push(log(owner,"setModule",0,a));
513 
514     }
515 
516     function setPrice(uint i,uint j){
517     if((!isModule(msg.sender))||(i>6))throw;
518     Ark.setPrice(i,j);
519     logs.push(log(msg.sender,"setPrice",i,msg.sender));
520     }
521 
522     function setTOS(address a,bool b){
523     if(!isModule(msg.sender))throw;
524     Ark.acceptTOS(a,b);
525     }
526 
527     
528     function setSource(address a) {
529     if(msg.sender!=owner)throw;
530     Ark=ARK(a);    
531     Source=a;
532     logs.push(log(msg.sender,"setSource",0,a));
533     }
534 
535     function setARKowner(address a) {
536     if(msg.sender!=owner)throw;
537     Ark.initStats("",a,333);
538     logs.push(log(msg.sender,"setARKowner",0,0x0));
539     }
540 
541     function restoreItem(uint i){
542     if(isAdmin(msg.sender)||isModule(msg.sender)){
543     Ark.censorship(i,false,false);
544     logs.push(log(msg.sender,"restore",i,0x0));
545     }
546     }
547 
548     function applyCensorship(uint i){
549     if(!isAdmin(msg.sender))throw;
550     Ark.censorship(i,true,false);
551     logs.push(log(msg.sender,"censor",i,0x0));
552     }
553 
554     function deleteCoin(uint i){
555     if(!isModule(msg.sender))throw;
556     Ark.censorship(i,true,true);
557     logs.push(log(msg.sender,"censor",i,0x0));
558     }
559 
560     function registerExternalBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c) private{
561     if(!isModule(msg.sender))throw;
562     Ark.registerExternalBill(bi,sellsNow,buyerwallet,tipo,sell,c);
563     }
564 
565     function pushCoin(uint i,address a,string s) returns(bool){
566     if(msg.sender!=Source)throw;
567     CoinSent(i,a,s);
568     return true;
569     }
570 
571     function isAdmin(address a)constant returns(bool){
572     bool b=false;
573     if((a==owner)||(administrator[a]))b=true;
574     return b;
575     }
576 
577     function isModule(address a)constant returns(bool){
578     bool b=false;
579     if((a==owner)||(module[a]))b=true;
580     return b;
581     }
582 
583     function getAdminName(address a)constant returns(string){
584     return adminName[a];
585     }
586 
587     function getSource()constant returns(address){
588     return Source;
589     }
590 
591     function readLog(uint i)constant returns(string,address,string,uint,address){
592     log l=logs[i];
593     return(getAdminName(l.admin),l.admin,l.what,l.id,l.a);
594     }
595     
596 
597 }
598 
599 
600 
601 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
602 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
603 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
604 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
605 
606 
607 contract ARKTagger_1_00 {
608     /* Constructor */
609     ARK Ark;
610 
611     address owner;
612 
613     string[] lastTags;
614     mapping (string => uint[]) tagged;
615 
616 ////////////////////////////////////////////////
617     log[] logs;
618 
619     struct log{
620     address admin;
621     string action;
622     address addr;
623     }
624 ////////////////////////////////////////////////
625 
626     function ARKTagger_1_00() {
627     owner=msg.sender;
628     }
629 
630     function setOwner(address a) {
631     if(msg.sender!=owner)throw;
632     owner=a;
633     logs.push(log(owner,"setOwner",a));
634     }
635 
636     function setSource(address a) {
637     if(msg.sender!=owner)throw;
638     Ark=ARK(a);
639     logs.push(log(owner,"setSource",a));
640     }
641 
642     function readLog(uint i)constant returns(address,string,address){
643     log l=logs[i];
644     return(l.admin,l.action,l.addr);
645     }
646 
647     function getLastTag(uint i) constant returns(string tag){
648     return lastTags[i];
649     }
650 
651     function addTag(uint i,string tag){tagged[tag][tagged[tag].length++]=i;lastTags[lastTags.length++]=tag;}
652 
653     function getTag(string tag,uint i) constant returns(uint,uint){return (tagged[tag][i],tagged[tag].length);}
654 
655 
656 }
657 
658 
659 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
660 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
661 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
662 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
663 
664 
665 contract ARK_TROGLOg_1_00 {
666     /* TROGLOg is part of ARK Endowment, all the documents are property of the relative ARK BOTs owners */
667     ARK Ark;
668      
669     address owner;
670 
671     mapping(uint => string)troglogs;
672 
673 ////////////////////////////////////////////////
674     log[] logs;
675 
676     struct log{
677     address admin;
678     string action;
679     address addr;
680     uint docu;
681     }
682 ////////////////////////////////////////////////
683 
684     function ARK_TROGLOg_1_00() {
685     owner=msg.sender;
686     }
687 
688     //change TROGLOg controller
689     function setOwner(address a) {
690     if(msg.sender!=owner)throw;
691     owner=a;
692     logs.push(log(owner,"setOwner",a,0));
693     }
694 
695     //point TROGLOg to ARK
696     function setSource(address a) {
697     if(msg.sender!=owner)throw;
698     Ark=ARK(a);
699     logs.push(log(owner,"setSource",a,0));
700     }
701 
702     function readLog(uint i)constant returns(address,string,address,uint){
703     log l=logs[i];
704     return(l.admin,l.action,l.addr,l.docu);
705     }
706 
707     
708     function submitCoding(string s,uint i){
709     var(own,dat,a,b) = Ark.getBot(i);
710     if((own==msg.sender)){troglogs[i]=s;logs.push(log(msg.sender,"setDocument",0x0,i));}else{throw;}
711     }
712         
713     
714 
715     function getLOg(uint i) constant returns(string){  
716     if(!(Ark.getOwnedBot(msg.sender,0)>0))throw;
717     return (troglogs[i]);}
718 
719 
720 }