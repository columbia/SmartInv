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
170               registerCompany(a,data);
171               for(uint j=0;j<amount;j++){
172               bots[selling] = Bot(a,"",0,0);
173               botOwners[a].push(selling);
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
186          if((amount<1)||(amount>20)||(i>15000)||((amount>1)&&((selling+amount+999>totBOTS)||(selling<400))))throw;
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
205 
206                 if(!ban[bots[currentSeller].owner]){balances[bots[currentSeller].owner]+=c;}else{balances[owner]+=c;}
207 
208                 selling++;
209                 bots[sell] = Bot(buyerwallet,buyerInfo,0,0);
210                 }else{
211 
212                 if(selling>totBOTS){
213                 if(bots[i].cost==0)throw;
214                 currentSeller=cycle[0].currentSeller;
215                 sellsNow=bots[currentSeller].owner;
216                 holder=bots[i].owner;
217                 sell=i;
218                 c=bots[i].cost+lastPrice[0];
219                 move(i,buyerwallet);
220                    		                  
221                 if(!ban[sellsNow]){balances[sellsNow]+=lastPrice[0];}else{balances[owner]+=lastPrice[0];}
222          
223                 registerBill(i,holder,sellsNow,6,sell,c-lastPrice[0]);                   		
224                 lastPrice[lastPrice.length++]=c-lastPrice[0];
225                    		
226                 }else{
227 
228                 c=lastPrice[6]*amount;
229                 balances[owner]+=msg.value; 
230                 currentSeller=selling;
231                 
232                 if(amount>1){sell=amount+100000;}else{sell=selling;}
233                 sellsNow=owner;
234                 for(uint j=0;j<amount;j++){
235                 bots[selling+j] = Bot(buyerwallet,buyerInfo,0,0);
236                 botOwners[buyerwallet].push(selling+j);
237                 }                                                 
238                 selling+=amount;
239                 }
240                 }
241                 
242                 if(sellsNow!=owner)botOwners[buyerwallet].push(sell);
243                 registerBill(currentSeller,sellsNow,buyerwallet,0,sell,c);
244                 return true;
245         }
246 
247    
248 
249        function move(uint index,address wallet) private returns (uint[]){
250 
251         uint[] l=botOwners[bots[index].owner];                                         
252         uint ll=l.length;
253                        
254         for(uint j=0;j<ll;j++){
255           if(l[j]==index){
256               if(j<ll-1)l[j]=l[ll-1];
257               delete l[ll-1];j=ll;
258           }
259         }
260         botOwners[bots[index].owner]=l;
261         botOwners[bots[index].owner].length--;
262         bots[index].owner=wallet;
263         bots[index].cost=0;
264 
265         }
266 
267 
268         function updateBOTBillingInfo(uint index,string data,address wallet,string info,string buyerbill,uint updatetype) returns(bool){
269                
270         if((index>totBOTS)||(msg.sender!=bots[index].owner))throw;
271          
272                     uint t=1;
273                     address cs=bots[cycle[1].currentSeller].owner;
274                                    
275                     if(bots[index].owner!=wallet){
276 
277                        if(!(companyIndex[wallet]>0))registerCompany(wallet,data);
278                        botOwners[wallet].push(index); 
279                        move(index,wallet);
280                                             
281                     }else{
282 
283                          if(updatetype!=1){
284                            t=companyIndex[msg.sender]+100;
285                            registerCompany(msg.sender,data);
286                            totCompanies--;
287                          }
288 
289                     }
290 
291                  if(updatetype!=2)bots[index].info=info;
292                  if(!ban[cs]){balances[cs]+=lastPrice[1];}else{balances[owner]+=lastPrice[1];}               
293                  registerBill(cycle[1].currentSeller,cs,msg.sender,t,index,lastPrice[1]);    
294                      
295            return true;
296         }
297 
298         
299         function registerExternalBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c){
300         if(msg.sender!=controller)throw;
301         registerBill(bi,sellsNow,buyerwallet,tipo,sell,c);
302         }
303 
304         function registerBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c) private{
305          
306          if((msg.value<c)||(mute)||(!TOS[buyerwallet]))throw;
307          Bot b=bots[bi];
308          uint sellerIndex;uint buyerIndex;
309          if(tipo>100){sellerIndex=tipo-100;buyerIndex=sellerIndex;tipo=1;}else{sellerIndex=companyIndex[sellsNow];buyerIndex=companyIndex[buyerwallet];}
310         
311           MarketBills[nMbills]=MarketBill(sellerIndex,buyerIndex,tipo,sell,c,block.number);
312        
313                 b.bills[b.nbills+1]=nMbills;
314                 b.nbills++;
315                 b.sales[tipo]++;                
316                 BuyersBills[buyerwallet][BuyersBills[buyerwallet].length++]=nMbills;
317                 SellersBills[sellsNow][SellersBills[sellsNow].length++]=nMbills;
318                 nMbills++;
319                 if(sellsNow!=owner){
320                 total+=c;
321                 if(tipo!=6){
322                 cycle[tipo].sold++;
323                 cycle[tipo].currentSeller++;
324                 if((cycle[tipo].currentSeller>totBOTS)||(cycle[tipo].currentSeller>=selling))cycle[tipo].currentSeller=1;}
325                 }
326                 if(claimed<=2500)miner[block.coinbase]=true;
327         }
328 
329    
330         function registerCompany(address wal,string data) private{        
331         companyWallet[companyWallet.length++]=wal;
332         companyIndex[wal]=companies.length;
333         companies[companies.length++]=data;
334         totCompanies++;
335         }
336   
337         
338         function muteMe(bool m){
339         if((msg.sender==owner)||(msg.sender==controller))mute=m;
340         }
341            
342 
343         function setController(address a) returns(bool){if(msg.sender!=owner)throw;controller=a;control=ARKController_1_00(a);logs.push(log(owner,"setCensorer",a));
344         return true;
345         }
346 
347 
348         function censorship(uint i,bool b,bool c) returns(bool){
349         if(msg.sender!=controller)throw;
350         if(c){coins[i]=Coin({coinOwner : 0x0,data : "Censored",mine : "",coinType : 0,platf: 0,adv : "",block : 0});}else{
351         if(b){
352         trash[i]=coins[i];
353         coins[i]=Coin({coinOwner : 0x0,data : "Censored",mine : "",coinType : 0,platf: 0,adv : "",block : 0});
354         }else{
355         coins[i]=trash[i];
356         }}
357         return true;
358         }
359 
360 
361         function setPrice(uint i,uint j) returns(bool){if(msg.sender!=controller)throw;lastPrice[i]=j; return true;}   
362          
363 
364         function acceptTOS(address a,bool b)  returns(bool){
365         if(b)if(!ban[msg.sender]){TOS[msg.sender]=true;ban[msg.sender]=false;}
366         if(msg.sender==controller){TOS[a]=b;ban[a]=!b;logs.push(log(controller,"setTOS",a));}
367         return true;
368         }
369      
370         function totBOTs() constant returns(uint,uint,uint,uint,uint) {return  (totBOTS,claimed,selling,companies.length,totCompanies); }
371       
372 
373         function getBotBillingIndex(uint i,uint bi)  constant returns (uint){
374         return bots[i].bills[bi];
375         }
376 
377             
378         function getBill(uint i,uint bi)constant returns(uint,uint,uint,uint,uint,uint){
379         MarketBill b=MarketBills[i];
380         return (b.sellerdata,b.buyerdata,b.product,b.index,b.cost,b.block);
381         }
382         
383 
384         function getNextSellerBOTdata(uint cyc) constant returns (uint,uint,string){return (cycle[cyc].currentSeller,cycle[cyc].sold,companies[companyIndex[bots[cycle[cyc].currentSeller].owner]]);}
385    
386         function getBot(uint i) constant returns (address,string,uint,uint){
387         Bot B=bots[i];
388         return (B.owner,B.info,B.cost,B.nbills);
389         }
390 
391         function getOwnedBot(address own,uint bindex) constant returns(uint){return botOwners[own][bindex];}
392       
393   
394         function getBotStats(uint i,uint j) constant returns (uint){
395         Bot B=bots[i];
396         return B.sales[j];}
397 
398 
399         function getFullCompany(address w,uint i) constant returns (string,uint,bool,uint,uint,string,address){return (companies[companyIndex[w]],botOwners[w].length,miner[w],balances[w],this.balance,companies[i],companyWallet[i]);}
400 
401 
402         function getActorBillXdetail(address w,uint i,bool who) constant returns (uint,uint){if(who){return (SellersBills[w][i],SellersBills[w].length);}else{return (BuyersBills[w][i],BuyersBills[w].length);}}
403 
404   
405         function getHomeadvIndex(uint ind) constant returns (uint){return hadv[ind];}
406 
407         function getLastPrice(uint i) constant returns (uint,uint,uint,uint,uint){return (lastPrice[i],lastPrice[lastPrice.length-1],selling,nMbills,total);}
408 
409 
410         function readLog(uint i)constant returns(address,string,address){log l=logs[i];return(l.admin,l.action,l.addr);}
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
425         function Trash(uint n) constant returns (address,string,uint,uint,string,string) {
426         if((msg.sender==controller)||(getOwnedBot(msg.sender,0)>0))      
427         Coin c = trash[n];   
428         return (c.coinOwner,c.data,c.coinType,c.platf,c.mine,c.adv); 
429         }
430 
431        
432         function getCoinStats(uint i) constant returns (uint,uint){
433         return (listed[i],coinIndex);   
434         }
435        
436 
437         function withdraw(){
438         if(!TOS[msg.sender])throw;
439         uint t=balances[msg.sender];
440         balances[msg.sender]=0;
441         if(!(msg.sender.send(t)))throw;
442         }
443 
444 
445         function (){throw;}
446 
447  }
448 
449 
450 
451 
452 
453 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
454 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
455 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
456 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
457 
458 contract ARKController_1_00 {
459     /* Constructor */
460     ARK Ark;
461 
462     event CoinSent(uint indexed id,address from,string name);
463 
464     address owner;
465     address Source;
466 
467     mapping(address => bool)administrator;
468     mapping(address => bool)module;
469     mapping(address => string)adminName;
470 
471     mapping(uint => bool)restore;
472 
473 ////////////////////////////////////////////////
474     log[] logs;
475 
476     struct log{
477     address admin;
478     string what;
479     uint id;
480     address a;
481     }
482 ////////////////////////////////////////////////
483     
484     function ARKController_1_00() {
485     owner=msg.sender;
486     }
487 
488     function setOwner(address a,string name) {
489     if(msg.sender==owner)owner=a;
490     }
491 
492     function ban(address a) returns(bool){
493     return false;
494     }
495 
496     function setAdministrator(address a,string name,bool yesno) {
497     if(isModule(msg.sender)){
498     administrator[a]=yesno;
499     adminName[a]=name;
500     
501     if(msg.sender==owner)logs.push(log(msg.sender,"setAdmin",0,a));
502     if(msg.sender!=owner)logs.push(log(msg.sender,"moduleSetAdmin",0,a));
503     
504     }
505     }
506 
507     function setModule(address a,bool yesno) {
508     if(!isModule(msg.sender))throw;
509     module[a]=yesno;
510     logs.push(log(owner,"setModule",0,a));
511 
512     }
513 
514     function setPrice(uint i,uint j){
515     if((!isModule(msg.sender))||(i>6))throw;
516     Ark.setPrice(i,j);
517     logs.push(log(msg.sender,"setPrice",i,msg.sender));
518     }
519 
520     function setTOS(address a,bool b){
521     if(!isModule(msg.sender))throw;
522     Ark.acceptTOS(a,b);
523     }
524 
525     
526     function setSource(address a) {
527     if(msg.sender!=owner)throw;
528     Ark=ARK(a);    
529     Source=a;
530     logs.push(log(msg.sender,"setSource",0,a));
531     }
532 
533     function setARKowner(address a) {
534     if(msg.sender!=owner)throw;
535     Ark.initStats("",a,333);
536     logs.push(log(msg.sender,"setARKowner",0,0x0));
537     }
538 
539     function restoreItem(uint i){
540     if(isAdmin(msg.sender)||isModule(msg.sender)){
541     Ark.censorship(i,false,false);
542     logs.push(log(msg.sender,"restore",i,0x0));
543     }
544     }
545 
546     function applyCensorship(uint i){
547     if(!isAdmin(msg.sender))throw;
548     Ark.censorship(i,true,false);
549     logs.push(log(msg.sender,"censor",i,0x0));
550     }
551 
552     function deleteCoin(uint i){
553     if(!isModule(msg.sender))throw;
554     Ark.censorship(i,true,true);
555     logs.push(log(msg.sender,"censor",i,0x0));
556     }
557 
558     function registerExternalBill(uint bi,address sellsNow,address buyerwallet,uint tipo,uint sell,uint c) private{
559     if(!isModule(msg.sender))throw;
560     Ark.registerExternalBill(bi,sellsNow,buyerwallet,tipo,sell,c);
561     }
562 
563     function pushCoin(uint i,address a,string s) returns(bool){
564     if(msg.sender!=Source)throw;
565     CoinSent(i,a,s);
566     return true;
567     }
568 
569     function isAdmin(address a)constant returns(bool){
570     bool b=false;
571     if((a==owner)||(administrator[a]))b=true;
572     return b;
573     }
574 
575     function isModule(address a)constant returns(bool){
576     bool b=false;
577     if((a==owner)||(module[a]))b=true;
578     return b;
579     }
580 
581     function getAdminName(address a)constant returns(string){
582     return adminName[a];
583     }
584 
585     function getSource()constant returns(address){
586     return Source;
587     }
588 
589     function readLog(uint i)constant returns(string,address,string,uint,address){
590     log l=logs[i];
591     return(getAdminName(l.admin),l.admin,l.what,l.id,l.a);
592     }
593     
594 
595 }