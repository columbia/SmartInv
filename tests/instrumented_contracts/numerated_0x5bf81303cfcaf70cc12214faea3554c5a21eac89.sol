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
721 
722 
723 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
724 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
725 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
726 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
727 
728 contract ARK_VOTER_1_00{
729 
730   ARK Ark;
731   ARKController_1_00 controller;
732   address owner;
733   mapping(uint => uint)thresold;
734   Vote[] votes;
735   uint max;
736   uint min;
737   Vote[] tv;
738   uint[] lastblock;
739   uint vmin=30;
740   uint vmax=700;
741   uint qmin=30;
742   uint qmax=700;
743 
744         struct Vote {
745         uint up;
746         uint down;
747 
748         mapping (address => bool) voters;
749         }
750 
751 ////////////////////////////////////////////////
752     log[] logs;
753 
754     struct log{
755     address admin;
756     string action;
757     address addr;
758     uint i;
759     }
760 ////////////////////////////////////////////////
761 
762    function ARK_VOTER_1_00(uint a,uint b,uint c,uint d,uint e,uint f){
763 
764    owner=msg.sender;
765    //tv.push();
766    thresold[0]=a; //blackflag quorum
767    thresold[1]=b; //censor quorum
768    thresold[2]=c; //price vote quorum
769    thresold[3]=d; //quorum voting quorum
770    thresold[4]=e;
771    thresold[5]=f;
772 
773    for(uint z=0;z<9;z++){ votes.push(Vote({up:0,down:0})); lastblock.push(1);}
774    min=50000000000000000;
775    max=2000000000000000000;
776    vmin=30;
777    vmax=700;
778    qmin=30;
779    qmax=700;
780    }
781 
782   
783 
784     function setOwner(address a) {
785     if(msg.sender!=owner)throw;
786     owner=a;
787     logs.push(log(owner,"setOwner",a,0));
788     }
789 
790 
791     function setSource(address a) {
792     if(msg.sender!=owner)throw;
793     Ark=ARK(a);
794     logs.push(log(owner,"setSource",a,0));
795     }
796 
797     function setController(address a) {
798     if(msg.sender!=owner)throw;
799     controller=ARKController_1_00(a);
800     logs.push(log(owner,"setController",a,0));
801     }
802 
803     function readLog(uint i)constant returns(address,string,address){
804     log l=logs[i];
805     return(l.admin,l.action,l.addr);
806     }
807 
808     function setThresold(uint i,uint j){
809     if(msg.sender!=owner)throw;
810     thresold[i]=j;
811 
812     if(i==0)logs.push(log(owner,"setThresold0",0x0,j));
813     if(i==1)logs.push(log(owner,"setThresold1",0x0,j));
814     if(i==2)logs.push(log(owner,"setThresold2",0x0,j));
815     if(i==3)logs.push(log(owner,"setThresold3",0x0,j));
816     if(i==4)logs.push(log(owner,"setThresold4",0x0,j));
817     if(i==5)logs.push(log(owner,"setThresold5",0x0,j));
818 
819     }
820 
821     function setMin(uint i,uint w) {
822     if(msg.sender!=owner)throw;
823     if(w==0){min=i; logs.push(log(owner,"setMin",0x0,i));}
824     if(w==1){vmin=i; logs.push(log(owner,"setVMin",0x0,i));}
825     if(w==2){qmin=i; logs.push(log(owner,"setQMin",0x0,i));}
826     }
827 
828     function setMax(uint i,uint w) {
829     if(msg.sender!=owner)throw;
830     if(w==0){max=i; logs.push(log(owner,"setMax",0x0,i));}
831     if(w==1){vmax=i; logs.push(log(owner,"setVMax",0x0,i));}
832     if(w==2){qmax=i; logs.push(log(owner,"setQMax",0x0,i));}
833     }
834 
835     function setPrice(uint i,uint j) {
836     if(msg.sender!=owner)throw;
837 
838     if(i==0)logs.push(log(owner,"setPrice0",0x0,j));
839     if(i==1)logs.push(log(owner,"setPrice1",0x0,j));
840     if(i==2)logs.push(log(owner,"setPrice2",0x0,j));
841     if(i==3)logs.push(log(owner,"setPrice3",0x0,j));
842     if(i==4)logs.push(log(owner,"setPrice4",0x0,j));
843     if(i==5)logs.push(log(owner,"setPrice5",0x0,j));
844     controller.setPrice(i,j);
845 
846     }
847     
848     function check(uint i)constant returns(bool){
849         if((Ark.getOwnedBot(msg.sender,0)>0)&&(block.number-lastblock[i]>1000)){return true;}else{return false;}   
850     }
851     
852       
853     function votePrice(uint x,bool v){
854        
855 
856         Vote V=votes[x];
857         var(a,b,c,d,e) = Ark.getLastPrice(x);
858 
859         if(check(x)&&(!(V.voters[msg.sender]))&&(x<=5)&&(a<=max)&&(a>=min)){
860 
861         V.voters[msg.sender]=true;
862 
863             
864         
865            
866             if(v){V.up++;
867                   if(V.up>thresold[2]){
868                       
869                             uint u=a+(a/10);
870                             controller.setPrice(x,u);
871                             lastblock[x]=block.number;
872                             votes[x]=Vote({up:0,down:0});
873                   }
874             }else{
875                   V.down++;
876                   if(V.down>thresold[2]){
877                        
878                             uint z=a-(a/10);
879                             controller.setPrice(x,z);
880                             lastblock[x]=block.number;
881                             votes[x]=Vote({up:0,down:0});
882                       
883                   }
884             }
885            
886         
887         }else{throw;}
888         }
889 
890 
891         function voteQuorum(uint x,bool v){
892 
893         Vote V=votes[x];
894 
895         if((check(x))&&(!(V.voters[msg.sender]))&&(x>5)&&(x<9)&&(thresold[x-6]<vmax)&&(thresold[x-6]>vmin)){
896 
897         V.voters[msg.sender]=true;
898            
899             if(v){V.up++;
900                   if(V.up>thresold[3]){                       
901                        thresold[x-6]+=thresold[x-6]/10;
902                        lastblock[x]=block.number;
903                        votes[x]=Vote({up:0,down:0});
904                   }
905             }else{
906                   V.down++;
907                   if(V.down>thresold[3]){
908                     thresold[x-6]-=thresold[x-6]/10;
909                     lastblock[x]=block.number;
910                     votes[x]=Vote({up:0,down:0});
911                   }
912             }
913             
914         
915         }else{throw;}
916         }
917 
918 
919 
920         function voteSuperQuorum(uint x,bool v){
921      
922         Vote V=votes[x];
923 
924         if((check(x))&&(!(V.voters[msg.sender]))&&(x>8)&&(thresold[3]<qmax)&&(thresold[3]>qmin)){
925 
926         V.voters[msg.sender]=true;
927            
928             if(v){V.up++;
929                   if(V.up>thresold[3]){                       
930                   thresold[3]+=thresold[3]/10;
931                   lastblock[x]=block.number;
932                   votes[x]=Vote({up:0,down:0});   
933                   }
934             }else{
935                   V.down++;
936                   if(V.down>thresold[3]){
937                   thresold[3]-=thresold[3]/10;
938                   lastblock[x]=block.number;
939                   votes[x]=Vote({up:0,down:0});  
940                   }
941             }
942             
943         
944         }else{throw;}
945         }
946 
947 
948         function getVotes(uint x) constant returns(uint,uint,bool){
949         Vote V=votes[x];
950         return (V.up,V.down,V.voters[msg.sender]);
951         }
952 
953         function getThresold(uint i)constant returns(uint){return thresold[i];}
954 
955         function getMinMax()constant returns(uint,uint,uint,uint,uint,uint){return (min,max,vmin,vmax,qmin,qmax);}
956 }
957 
958 
959 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
960 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
961 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
962 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
963 
964 contract ARK_FLAGGER_1_00{
965 
966   ARK Ark;
967   ARKController_1_00 ARKcontroller;
968   address owner;
969   ARK_VOTER_1_00 ARKvoter;
970 
971   struct BlackFlag{
972   uint blackflagrequest;
973   uint blackflags;
974   }
975 
976     mapping(uint => BlackFlag) blackflags;
977 
978 
979     mapping(uint => Censorship)censoring;
980     struct Censorship{mapping(address => bool) censor;}
981 
982    uint[] thresold;
983 
984     
985   
986 ////////////////////////////////////////////////
987     log[] logs;
988 
989     struct log{
990     address admin;
991     string action;
992     address addr;
993     uint i;
994     }
995 ////////////////////////////////////////////////
996 
997    function ARK_FLAGGER_1_00(){
998 
999    owner=msg.sender;
1000    
1001    thresold.push(3);
1002    thresold.push(3);
1003    thresold.push(3);
1004    thresold.push(3);
1005    thresold.push(3);
1006    thresold.push(3);
1007    }
1008 
1009   
1010 
1011     function setOwner(address a) {
1012     if(msg.sender!=owner)throw;
1013     owner=a;
1014     logs.push(log(owner,"setOwner",a,0));
1015     }
1016 
1017     function setController(address a) {
1018     if(msg.sender!=owner)throw;
1019     ARKcontroller=ARKController_1_00(a);
1020     logs.push(log(owner,"setController",a,0));
1021     }
1022 
1023     function setVoter(address a) {
1024     if(msg.sender!=owner)throw;
1025     ARKvoter=ARK_VOTER_1_00(a);
1026     logs.push(log(owner,"setVoter",a,0));
1027     }
1028 
1029 
1030     function setSource(address a) {
1031     if(msg.sender!=owner)throw;
1032     Ark=ARK(a);
1033     logs.push(log(owner,"setSource",a,0));
1034     }
1035 
1036     function readLog(uint i)constant returns(address,string,address,uint){
1037     log l=logs[i];
1038     return(l.admin,l.action,l.addr,l.i);
1039     }
1040 
1041     function check()constant returns(bool){
1042         var b=false;
1043         if(Ark.getOwnedBot(msg.sender,0)>0)b=true;
1044         return b;
1045        
1046     }
1047 
1048         function setBlackflag(uint i,bool b){if(msg.sender!=owner)throw;if(b){blackflags[i].blackflags++;}else{blackflags[i].blackflags--;}}
1049 
1050 
1051 
1052 
1053         function setBlackFlagRequest(uint index,uint typ){
1054  
1055         var (x,y) = Ark.getCoinStats(0);
1056         BlackFlag c = blackflags[index];
1057         
1058         if((index<=y)&&(check())&&((typ==1)||(typ==1001)||(typ==10001))&&(!censoring[index].censor[msg.sender])){
1059         if(c.blackflagrequest==0){censoring[index]=Censorship(); c.blackflagrequest=typ;}
1060         logs.push(log(msg.sender,"requestBlackFlag",0x0,index));
1061         censoring[index].censor[msg.sender]=true;      
1062         }else{throw;}
1063         }
1064 
1065 
1066 
1067 
1068        function getBlackflag(uint index,address a) constant returns(bool,uint,uint){
1069         BlackFlag c = blackflags[index];
1070         return (censoring[index].censor[a],c.blackflagrequest,c.blackflags);
1071         }
1072 
1073         function confirmBlackFlag(uint index,bool confirm){
1074         BlackFlag c = blackflags[index];
1075         uint t=c.blackflagrequest;
1076 
1077         
1078         if((check())&&(t>=1)&&(!censoring[index].censor[msg.sender])){
1079             if(confirm){
1080         
1081                if((t<(1+thresold[0]))||((1000<t)&&(t<(1001+thresold[0])))||((t>10000)&&(t<(10000+thresold[1])))){
1082                   c.blackflagrequest++;
1083                   //censoring[index].blackflagasker=msg.sender;
1084                   censoring[index].censor[msg.sender]=true;
1085                }else{   
1086                    if(t>=10000+thresold[1]){
1087                     ARKcontroller.applyCensorship(index);
1088                     censoring[index]=Censorship();
1089                    }else{                      
1090                     c.blackflags++;     
1091                    } 
1092                    c.blackflagrequest=0;
1093                }      
1094             }else{if(t>10000){c.blackflagrequest=0;logs.push(log(msg.sender,"nullCensorshipRequest",0x0,index));}else{c.blackflagrequest--;}}
1095         }else{throw;}
1096         }
1097 
1098 
1099         function setThresold(uint i,uint j){
1100         if(msg.sender!=owner)throw;
1101         thresold[i]=j;
1102  
1103         if(i==0)logs.push(log(owner,"setThresold0",0x0,j));
1104         if(i==1)logs.push(log(owner,"setThresold1",0x0,j));
1105         if(i==2)logs.push(log(owner,"setThresold2",0x0,j));
1106         if(i==3)logs.push(log(owner,"setThresold3",0x0,j));
1107         if(i==4)logs.push(log(owner,"setThresold4",0x0,j));
1108         if(i==5)logs.push(log(owner,"setThresold5",0x0,j));
1109         }
1110 
1111         function updateThresold(uint i){
1112         thresold[i]=ARKvoter.getThresold(i);
1113         //uint u=ARKvoter.getThresold(i);
1114         if(i==0)logs.push(log(owner,"updateThresold0",0x0,i));
1115         if(i==1)logs.push(log(owner,"updateThresold1",0x0,i));
1116         if(i==2)logs.push(log(owner,"updateThresold2",0x0,i));
1117         if(i==3)logs.push(log(owner,"updateThresold3",0x0,i));
1118         if(i==4)logs.push(log(owner,"updateThresold4",0x0,i));
1119         if(i==5)logs.push(log(owner,"updateThresold5",0x0,i));
1120         }
1121 
1122         function getThresold()constant returns(uint,uint,uint,uint,uint,uint){
1123         return (thresold[0],thresold[1],thresold[2],thresold[3],thresold[4],thresold[5]);
1124         }
1125 
1126 
1127 }