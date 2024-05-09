1 pragma solidity ^0.4.24;
2 
3 
4 contract Game{
5   using ShareCalc for uint256;
6   using SafeMath for *;
7   uint256 constant private weight0 = 1;
8   uint256 constant private weight1 = 1;  
9   uint256 constant private refcodeFee = 1e16;
10   uint256 constant private phasePerStage = 4;
11   uint256 constant private maxStage = 10;
12   Entrepreneur.Company public gameState;  
13   mapping (bytes32 => address) public refcode2Addr;
14 
15   mapping (address => Entrepreneur.Player) public players;    
16   address foundationAddr = 0x52E9e51e2519e9D8e5D68D992958e7D1bD4e5899;
17   uint256 constant private phaseLen  = 11 hours;
18   uint256 constant private growthTarget    = 110; 
19   uint256 constant private lockup = 2 ;
20   uint256 constant private sweepDelay = 30 days;
21   Entrepreneur.Allocation rate = Entrepreneur.Allocation(50,9,3,2,6,30);
22   mapping (uint256 => Entrepreneur.Phase) public phases;
23   mapping (uint256 => mapping (address => uint256)) public phase_player_origShare; 
24   mapping (uint256 =>mapping (uint256 => mapping (address => uint256))) public stage_prod_player_origShare;
25   mapping (uint256 =>mapping (uint256 => mapping (address => uint256))) public stage_prod_player_cdps;
26   mapping (uint256 =>mapping (uint256 => mapping (address => uint256))) public stage_prod_player_cbps;
27   mapping (uint256 =>mapping (uint256 =>  uint256)) public phase_prod_Share;
28   mapping (uint256 =>mapping (uint256 =>  uint256)) public stage_prod_currShare;
29   mapping (uint256 =>mapping (uint256 =>  uint256)) public stage_prod_origShare;
30   mapping (uint256 =>mapping (uint256 =>  uint256)) public stage_prod_cdps;
31   mapping (uint256 =>mapping (uint256 =>  uint256)) public stage_prod_cbps;
32   mapping (address =>mapping (uint256=>  bytes32)) public player_id_refCode;
33   modifier isHuman() { 
34     require(msg.sender == tx.origin, "Humans only");
35     _;
36   }
37   modifier ethLimit(uint256 _eth) { 
38     require(_eth >= 1e16, "0.01ETH min");
39     require(_eth <= 1e20, "100ETH max");
40     _;    
41   }
42   constructor () public {
43     gameState.stage=1;
44     gameState.phase=1;
45     phases[gameState.phase].ethGoal=10*1e18;
46     phases[gameState.phase].shareGoal=(gameState.eth).sharesRec(phases[gameState.phase].ethGoal);            
47     phases[gameState.phase].stage=1;    
48   }
49   string public gameName = "Entrepreneur";
50   function checkRefcode(address playerAddr,uint256 id)
51     public 
52     view
53     returns(bytes32)
54   {
55     return player_id_refCode[playerAddr][id];
56   }
57   function accruedDiv (address playerAddr)
58     public 
59     view 
60     returns (uint256)
61   {
62     uint256 div=0;
63     for(uint i=1;i<=gameState.stage;i++){
64       for(uint j=0;j<2;j++){
65         div=(stage_prod_cdps[i][j].sub(stage_prod_player_cdps[i][j][playerAddr]).mul(stage_prod_player_origShare[i][j][playerAddr])/1e18).add(div);        
66       }
67     }
68     return div;
69   }
70   function accruedBuyout (address playerAddr)
71     public
72     view 
73     returns (uint256)
74   {
75     if(gameState.stage<=lockup)
76       return 0;
77     uint256 buyoutEth=0;
78       for(uint i=1;i<=gameState.stage.sub(lockup);i++){
79         buyoutEth=buyoutEth.add((stage_prod_cbps[i][0].sub(stage_prod_player_cbps[i][0][playerAddr])).mul(stage_prod_player_origShare[i][0][playerAddr])/1e18);        
80       }
81     return buyoutEth;
82   }
83   function potShare(address playerAddr)
84     private
85     view
86     returns (uint256)
87   {
88     uint256 weightedShare=phase_player_origShare[gameState.phase][playerAddr].mul(weight0);
89     if(gameState.phase>1){
90       weightedShare=weightedShare.add(phase_player_origShare[gameState.phase-1][playerAddr].mul(weight1));                  
91     }
92     return weightedShare;        
93   }
94   function accruedLiq(address playerAddr) 
95     private 
96     view 
97     returns (uint256)
98   {
99     if(gameState.ended>0 && !players[playerAddr].redeemed )
100     {                                          
101       return (gameState.lps).mul(potShare(playerAddr))/1e18;      
102     }      
103     return 0;
104   }
105   function currShares(address playerAddr)
106     private
107     view
108     returns(uint256)
109   {
110     uint256 _shares;
111     for(uint i=1;i<=gameState.stage;i++){
112       for(uint j=0;j<2;j++){
113         if(stage_prod_origShare[i][j]>0)
114           _shares=_shares.add(stage_prod_player_origShare[i][j][playerAddr].mul(stage_prod_currShare[i][j])/stage_prod_origShare[i][j]);        
115       }
116     }
117     return _shares;
118   }
119   function getState() 
120     public 
121     view 
122     returns (
123       uint256,
124       uint256,
125       uint256,
126       uint256,
127       uint256,
128       uint256,
129       uint256,
130       uint256,
131       uint256,
132       uint256
133     )
134   {
135     uint256 phase=gameState.phase;
136     uint256 end;
137     uint256 ethGoal;
138     uint256 eth;  
139     uint256 stage=gameState.stage;
140     if(phases[phase].end!=0 && now > phases[phase].end && phases[phase].shares>=phases[phase].shareGoal && gameState.ended==0){
141       end=phases[phase].end.add(phaseLen);      
142       ethGoal=phases[phase].eth.mul(growthTarget)/100;
143       phase++;
144       stage=(phase-1)/phasePerStage+1;                  
145     }else{
146       end=phases[phase].end;
147       ethGoal=phases[phase].ethGoal;
148       eth=phases[phase].eth;
149     }
150     return (
151       gameState.pot, 
152       gameState.origShares,
153       gameState.plyrCount,
154       phase,
155       end,
156       ethGoal,
157       eth,
158       stage,
159       gameState.eth,
160       gameState.currShares
161       );    
162   }
163   // function getState2() 
164   //   public 
165   //   view 
166   //   returns (
167   //     uint256 pot,
168   //     uint256 origShares,
169   //     uint256 plyrCount,
170   //     uint256 phase,
171   //     uint256 end,
172   //     uint256 phaseEthGoal,
173   //     uint256 phaseEth,
174   //     uint256 stage,
175   //     uint256 totalEth,
176   //     uint256 totalCurrShares
177   //   )
178   // {
179   //   phase=gameState.phase;            
180   //   stage=gameState.stage;
181   //   if(phases[phase].end!=0 && now > phases[phase].end && phases[phase].shares>=phases[phase].shareGoal && gameState.ended==0){
182   //     end=phases[phase].end.add(phaseLen);      
183   //     phaseEthGoal=phases[phase].eth.mul(growthTarget)/100;
184   //     phase++;
185   //     stage=(phase-1)/phasePerStage+1;                  
186   //   }else{
187   //     end=phases[phase].end;
188   //     phaseEthGoal=phases[phase].ethGoal;
189   //     phaseEth=phases[phase].eth;
190   //   }
191   //   pot=gameState.pot;
192   //   origShares=gameState.origShares;
193   //   plyrCount=gameState.plyrCount;
194   //   totalEth=gameState.eth;
195   //   totalCurrShares=gameState.currShares;
196   //   return (
197   //     pot, 
198   //     origShares,
199   //     plyrCount,
200   //     phase,
201   //     end,
202   //     phaseEthGoal,
203   //     phaseEth,
204   //     stage,
205   //     totalEth,
206   //     totalCurrShares
207   //     );    
208   // }
209   function phaseAddtlInfo(uint256 phase)
210     public 
211     view
212     returns(      
213       uint256,
214       uint256,
215       uint256,
216       uint256
217     )
218   { 
219     uint256 growth;
220     if(phase==1)
221       growth=0;
222     else
223       growth=phases[phase].eth.mul(10000)/phases[phase.sub(1)].eth;
224     uint256 stage;    
225     uint256 ethGoal;          
226     if(phase == gameState.phase + 1 && phases[gameState.phase].end!=0 && phases[gameState.phase].shares>=phases[gameState.phase].shareGoal && now > phases[gameState.phase].end){
227       stage=(phase-1)/phasePerStage+1;            
228       ethGoal=phases[gameState.phase].eth.mul(growthTarget)/100;
229     }else{
230       stage=phases[phase].stage;      
231       ethGoal=phases[phase].ethGoal;
232     }
233     return(
234       stage,      
235       phases[phase].eth,
236       ethGoal,      
237       growth
238     );
239   }
240   function getPlayerIncome(address playerAddr) 
241     public 
242     view 
243     returns (      
244       uint256,
245       uint256,
246       uint256,
247       uint256
248       )
249   {     
250     return (     
251       players[playerAddr].redeemedDiv.add(accruedDiv(playerAddr)),      
252       players[playerAddr].redeemedRef,
253       players[playerAddr].redeemedBuyout.add(accruedBuyout(playerAddr)),
254       players[playerAddr].redeemedLiq.add(accruedLiq(playerAddr)));
255   }
256   
257   function getPlayerVault(address playerAddr) 
258     public 
259     view 
260     returns (            
261       uint256,
262       uint256,
263       uint256,
264       uint256
265       )
266   { 
267     uint256 shares=currShares(playerAddr);
268     return (            
269       totalBal(playerAddr),
270       shares,
271       potShare(playerAddr),
272       (gameState.origShares).ethRec(shares));
273   }
274   function totalBal(address playerAddr)
275     public 
276     view 
277     returns(uint256)
278   {
279     uint256 div = accruedDiv(playerAddr);  
280     uint256 liq = accruedLiq(playerAddr);
281     uint256 buyout=accruedBuyout(playerAddr);
282     return players[playerAddr].bal.add(div).add(liq).add(buyout);
283   }
284 
285   function _register(address playerAddr,address ref) 
286     private
287   {
288     if(players[playerAddr].id>0)
289       return;
290     if(players[ref].id==0 || ref==playerAddr)
291       ref=address(0);
292     players[playerAddr].id=++gameState.plyrCount;
293     players[playerAddr].ref=ref;
294     players[ref].apprentice1++;
295     address ref2=players[ref].ref;
296     if(ref2 != address(0)){
297       players[ref2].apprentice2++;
298       address ref3=players[ref2].ref;
299       if(ref3 != address(0)){
300         players[ref3].apprentice3++;
301       }
302     }    
303   }
304   function _register2(address playerAddr,bytes32 refcode)
305     private
306   {
307     _register(playerAddr,refcode2Addr[refcode]);
308   }
309 
310   function endGame() 
311     private 
312     returns (uint256)
313   {
314     if(gameState.ended>0){
315       return gameState.ended;
316     }      
317     if(now > phases[gameState.phase].end){
318       if(phases[gameState.phase].shares>=phases[gameState.phase].shareGoal)
319       {
320         uint256 nextPhase=gameState.phase+1;
321         if(gameState.phase % phasePerStage == 0){          
322           if(gameState.stage+1>maxStage){
323             gameState.ended=2;            
324           }else{
325             gameState.stage++;            
326           }
327         }     
328         if(gameState.ended==0){
329           phases[nextPhase].stage=gameState.stage;
330           phases[nextPhase].end=phases[gameState.phase].end.add(phaseLen);      
331           phases[nextPhase].ethGoal=phases[gameState.phase].eth.mul(growthTarget)/100;
332           phases[nextPhase].shareGoal=(gameState.eth).sharesRec(phases[nextPhase].ethGoal);
333           gameState.phase=nextPhase;        
334           if(now > phases[gameState.phase].end){
335             gameState.ended=1;
336           }                
337         }        
338       }else{
339         gameState.ended=1;                
340       }      
341     }
342     if(gameState.ended>0){
343       uint256 weightedShare=phases[gameState.phase].shares.mul(weight0);
344       if(gameState.phase>1){
345         weightedShare=weightedShare.add(phases[gameState.phase-1].shares.mul(weight1));                        
346       }        
347       gameState.lps=(gameState.pot).mul(1e18)/weightedShare;
348       gameState.pot=0;
349     }
350     return gameState.ended;      
351   }
352   function calcBuyout(uint256 shares) 
353     public
354     view
355     returns(uint256)
356   { 
357     if(gameState.stage<=lockup)
358       return 0;
359     uint256 buyoutShares;
360 
361     if(phases[gameState.phase].shares.add(shares)>phases[gameState.phase].shareGoal){
362       buyoutShares=phases[gameState.phase].shares.add(shares).sub(phases[gameState.phase].shareGoal);
363     }
364     if(buyoutShares>shares){
365       buyoutShares=shares;
366     }
367     if(buyoutShares > stage_prod_currShare[gameState.stage.sub(lockup)][0]){
368       buyoutShares= stage_prod_currShare[gameState.stage.sub(lockup)][0];
369     }
370     return buyoutShares;
371   }
372   function minRedeem(address playerAddr,uint256 stage,uint256 prodId)
373     public
374   {     
375     uint256 div= (stage_prod_cdps[stage][prodId].sub(stage_prod_player_cdps[stage][prodId][playerAddr])).mul(stage_prod_player_origShare[stage][prodId][playerAddr])/1e18;      
376     stage_prod_player_cdps[stage][prodId][playerAddr]=stage_prod_cdps[stage][prodId];
377     players[playerAddr].bal=div.add(players[playerAddr].bal);
378     players[playerAddr].redeemedDiv=div.add(players[playerAddr].redeemedDiv);    
379   }
380   function redeem(address playerAddr) 
381     public
382   {
383     uint256 liq=0;
384     if(gameState.ended>0 && !players[playerAddr].redeemed){
385       liq=accruedLiq(playerAddr);      
386       players[playerAddr].redeemed=true;
387     }
388 
389     uint256 div=0;
390     for(uint i=1;i<=gameState.stage;i++){
391       for(uint j=0;j<2;j++){
392         div=div.add((stage_prod_cdps[i][j].sub(stage_prod_player_cdps[i][j][playerAddr])).mul(stage_prod_player_origShare[i][j][playerAddr])/1e18);
393         stage_prod_player_cdps[i][j][playerAddr]=stage_prod_cdps[i][j];
394       }
395     }      
396     
397     uint256 buyoutEth=0;
398     if(gameState.stage>lockup){
399       for(i=1;i<=gameState.stage.sub(lockup);i++){
400         buyoutEth=buyoutEth.add((stage_prod_cbps[i][0].sub(stage_prod_player_cbps[i][0][playerAddr])).mul(stage_prod_player_origShare[i][0][playerAddr])/1e18);
401         stage_prod_player_cbps[i][0][playerAddr]=stage_prod_cbps[i][0];
402       }
403     }    
404     players[playerAddr].bal=liq.add(div).add(buyoutEth).add(players[playerAddr].bal);
405     players[playerAddr].redeemedLiq=players[playerAddr].redeemedLiq.add(liq);
406     players[playerAddr].redeemedDiv=players[playerAddr].redeemedDiv.add(div);
407     players[playerAddr].redeemedBuyout=players[playerAddr].redeemedBuyout.add(buyoutEth);
408   }    
409   
410   function payRef(address playerAddr,uint256 eth) 
411     private
412   {
413     uint256 foundationAmt=eth.mul(rate.foundation)/100;
414     uint256 ref1Amt=eth.mul(rate.ref1)/100;
415     uint256 ref2Amt=eth.mul(rate.ref2)/100;
416     uint256 ref3Amt=eth.mul(rate.ref3)/100;
417     address ref1= players[playerAddr].ref;
418     if(ref1 != address(0)){
419       players[ref1].bal=ref1Amt.add(players[ref1].bal);
420       players[ref1].redeemedRef=ref1Amt.add(players[ref1].redeemedRef);
421       address ref2=players[ref1].ref;
422       if(ref2 != address(0)){
423         players[ref2].bal=ref2Amt.add(players[ref2].bal);
424         players[ref2].redeemedRef=ref2Amt.add(players[ref2].redeemedRef);
425         address ref3=players[ref2].ref;
426         if(ref3 != address(0)){
427           players[ref3].bal=ref3Amt.add(players[ref3].bal);
428           players[ref3].redeemedRef=ref3Amt.add(players[ref3].redeemedRef);
429         }else{
430           foundationAmt=foundationAmt.add(ref3Amt);    
431         }        
432       }else{
433         foundationAmt=foundationAmt.add(ref3Amt).add(ref2Amt);    
434       }        
435     }else{
436       foundationAmt=foundationAmt.add(ref3Amt).add(ref2Amt).add(ref1Amt);    
437     }            
438     foundationAddr.transfer(foundationAmt);  
439   }
440   function updateDps(uint256 div) 
441     private
442   {
443     uint256 dps=div.mul(1e18)/gameState.currShares;  
444     for(uint i = 1; i <= gameState.stage; i++){
445       for(uint j=0;j<=1;j++){
446         if(stage_prod_origShare[i][j]>0){
447           stage_prod_cdps[i][j]=(dps.mul(stage_prod_currShare[i][j])/stage_prod_origShare[i][j]).add(stage_prod_cdps[i][j]);     
448         }        
449       }
450     }    
451   }  
452   function _buy(address playerAddr, uint256 eth, uint256 prodId) 
453     ethLimit(eth)
454     private      
455   {
456     if(prodId>1)
457       prodId=1;
458     if(players[playerAddr].id==0)
459       _register(playerAddr,address(0));      
460     minRedeem(playerAddr,gameState.stage,prodId);
461     require(players[playerAddr].bal >= eth,"insufficient fund");        
462     if(eth>0 && phases[gameState.phase].end==0)
463       phases[gameState.phase].end=now.add(phaseLen);
464     if(endGame()>0)
465       return;
466     uint256 stage=gameState.stage;
467     uint256 phase=gameState.phase;
468     players[playerAddr].bal=(players[playerAddr].bal).sub(eth);    
469     uint256 shares=(gameState.eth).sharesRec(eth);
470     uint256 buyout = calcBuyout(shares);            
471     uint256 newShare=shares.sub(buyout);    
472     uint256 newShareEth=(gameState.origShares).ethRec(newShare);
473     uint256 buyoutEth=eth.sub(newShareEth);    
474     if(buyout>0){
475       uint256 buyoutStage=stage.sub(lockup);
476       stage_prod_currShare[buyoutStage][0]=stage_prod_currShare[buyoutStage][0].sub(buyout);                  
477       stage_prod_cbps[buyoutStage][0]=(stage_prod_cbps[buyoutStage][0]).add(buyoutEth.mul(rate.pot).mul(1e18)/100/stage_prod_origShare[buyoutStage][0]);
478     }    
479         
480     gameState.origShares = shares.add(gameState.origShares);
481     gameState.currShares=newShare.add(gameState.currShares);
482     gameState.eth = eth.add(gameState.eth);
483     phases[phase].shares=shares.add(phases[phase].shares);    
484     phases[phase].eth=eth.add(phases[phase].eth);    
485     stage_prod_origShare[stage][prodId]=shares.add(stage_prod_origShare[stage][prodId]);
486     stage_prod_currShare[stage][prodId]=stage_prod_origShare[stage][prodId];
487     
488     players[playerAddr].origShares=shares.add(players[playerAddr].origShares);
489     stage_prod_player_origShare[stage][prodId][playerAddr]=shares.add(stage_prod_player_origShare[stage][prodId][playerAddr]);
490     phase_player_origShare[phase][playerAddr]=shares.add(phase_player_origShare[phase][playerAddr]);
491     
492     updateDps(eth.mul(rate.div)/100);            
493     payRef(playerAddr,eth);    
494     gameState.pot=gameState.pot.add(newShareEth.mul(rate.pot)/100);        
495   }
496   function sweep()
497     public
498   {
499     if(gameState.ended>0 && now > sweepDelay + phases[gameState.phase].end)
500       foundationAddr.transfer(address(this).balance);
501   }
502 
503   function register(address ref)
504     isHuman()
505     public
506   {
507     _register(msg.sender,ref);
508   }
509 
510   function recharge()    
511     public 
512     payable
513   {
514     players[msg.sender].bal=(players[msg.sender].bal).add(msg.value);
515   }
516 
517   function withdraw() 
518     isHuman()
519     public 
520   {
521     redeem(msg.sender);
522     uint256 _bal = players[msg.sender].bal;            
523     players[msg.sender].bal=0;    
524     msg.sender.transfer(_bal);
525   }
526   function buyFromWallet(uint256 prodId,bytes32 refCode) 
527     isHuman()    
528     public 
529     payable
530   {
531     _register2(msg.sender, refCode);
532     players[msg.sender].bal=(players[msg.sender].bal).add(msg.value);        
533     _buy(msg.sender,msg.value,prodId);
534   }
535 
536   function regRefcode(bytes32 refcode)
537     public 
538     payable
539     returns (bool)
540   {
541     _register2(msg.sender, "");
542     if(msg.value<refcodeFee || refcode2Addr[refcode]!=address(0)){
543       msg.sender.transfer(msg.value);
544       return false;
545     }
546     refcode2Addr[refcode]=msg.sender;
547     
548     players[msg.sender].numRefcodes=players[msg.sender].numRefcodes.add(1);
549     player_id_refCode[msg.sender][players[msg.sender].numRefcodes]=refcode;
550     return true;  
551   }
552 
553   function buyFromBal(uint256 eth,uint256 prodId,bytes32 refCode)    
554     isHuman()
555     public
556   {
557     _register2(msg.sender, refCode);
558     redeem(msg.sender);
559     _buy(msg.sender,eth,prodId);
560   }
561 
562   function getEthNeeded(uint256 keysCount) public view returns(uint256) {
563     uint256 ethCount=(gameState.origShares).ethRec(keysCount);
564 
565     return ethCount;
566   }
567 }
568 
569 library Entrepreneur {
570   struct Player {    
571     uint256 origShares;       
572     uint256 bal;    
573     bool redeemed;
574     uint256 id;
575     address ref;
576     uint256 redeemedDiv;    
577     uint256 redeemedRef;
578     uint256 redeemedBuyout;
579     uint256 redeemedLiq;
580     uint256 apprentice1;
581     uint256 apprentice2;
582     uint256 apprentice3;
583     uint256 numRefcodes;
584   }
585     
586   struct Company {    
587     uint256 eth;    
588     uint256 pot;    
589     uint256 origShares;
590     uint256 currShares;
591     uint256 lps;
592     uint256 ended;
593     uint256 plyrCount;
594     uint256 phase;
595     uint256 stage;  
596   }  
597 
598   struct Phase{ 
599     uint256 stage;
600     uint256 end; 
601     uint256 shareGoal; 
602     uint256 shares; 
603     uint256 eth;
604     uint256 ethGoal;    
605   }
606 
607   struct Allocation {
608     uint256 div;  
609     uint256 ref1;
610     uint256 ref2;
611     uint256 ref3;
612     uint256 foundation;   
613     uint256 pot;    
614   }  
615 }
616 
617 library ShareCalc {
618   using SafeMath for *;
619   /**
620     * @dev calculates number of share received given X eth 
621     * @param _curEth current amount of eth in contract 
622     * @param _newEth eth being spent
623     * @return amount of Share purchased
624     */
625   function sharesRec(uint256 _curEth, uint256 _newEth)
626       internal
627       pure
628       returns (uint256)
629   {
630     return(shares((_curEth).add(_newEth)).sub(shares(_curEth)));
631   }
632   
633   /**
634     * @dev calculates amount of eth received if you sold X share 
635     * @param _curShares current amount of shares that exist 
636     * @param _sellShares amount of shares you wish to sell
637     * @return amount of eth received
638     */
639   function ethRec(uint256 _curShares, uint256 _sellShares)
640       internal
641       pure
642       returns (uint256)
643   {
644     return(eth(_curShares.add(_sellShares)).sub(eth(_curShares)));
645   }
646 
647   /**
648     * @dev calculates how many shares would exist with given an amount of eth
649     * @param _eth eth "in contract"
650     * @return number of shares that would exist
651     */
652   function shares(uint256 _eth) 
653       internal
654       pure
655       returns(uint256)
656   {
657     // old
658     // return ((((((_eth).mul(1000000000000000000)).mul(46675600000000000000000000)).add(49018761795600000000000000000000000000000000000000000000000000)).sqrt()).sub(7001340000000000000000000000000)) / (23337800);
659     // new
660     return ((((((_eth).mul(1000000000000000000)).mul(466756000000000000000000)).add(49018761795600000000000000000000000000000000000000000000000000)).sqrt()).sub(7001340000000000000000000000000)) / (233378);
661   }
662   
663   /**
664     * @dev calculates how much eth would be in contract given a number of shares
665     * @param _shares number of shares "in contract" 
666     * @return eth that would exists
667     */
668   function eth(uint256 _shares) 
669       internal
670       pure
671       returns(uint256)  
672   {
673     // old
674     // return ((11668900).mul(_shares.sq()).add(((14002680000000).mul(_shares.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
675     // new
676     return ((116689).mul(_shares.sq()).add(((14002680000000).mul(_shares.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
677   }
678 }
679 
680 library SafeMath {
681     
682   /**
683   * @dev Multiplies two numbers, throws on overflow.
684   */
685   function mul(uint256 a, uint256 b) 
686       internal 
687       pure 
688       returns (uint256 c) 
689   {
690     if (a == 0) {
691       return 0;
692     }
693     c = a * b;
694     require(c / a == b, "SafeMath mul failed");
695     return c;
696   }
697 
698   /**
699   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
700   */
701   function sub(uint256 a, uint256 b)
702       internal
703       pure
704       returns (uint256) 
705   {
706     require(b <= a, "SafeMath sub failed");
707     return a - b;
708   }
709 
710   /**
711   * @dev Adds two numbers, throws on overflow.
712   */
713   function add(uint256 a, uint256 b)
714       internal
715       pure
716       returns (uint256 c) 
717   {
718     c = a + b;
719     require(c >= a, "SafeMath add failed");
720     return c;
721   }
722   
723   /**
724     * @dev gives square root of given x.
725     */
726   function sqrt(uint256 x)
727       internal
728       pure
729       returns (uint256 y) 
730   {
731     uint256 z = ((add(x,1)) / 2);
732     y = x;
733     while (z < y) 
734     {
735       y = z;
736       z = ((add((x / z),z)) / 2);
737     }
738   }
739   
740   /**
741     * @dev gives square. multiplies x by x
742     */
743   function sq(uint256 x)
744       internal
745       pure
746       returns (uint256)
747   {
748     return (mul(x,x));
749   }
750   
751   /**
752     * @dev x to the power of y 
753     */
754   function pwr(uint256 x, uint256 y)
755       internal 
756       pure 
757       returns (uint256)
758   {
759     if (x==0)
760         return (0);
761     else if (y==0)
762         return (1);
763     else 
764     {
765       uint256 z = x;
766       for (uint256 i = 1; i < y; i++)
767         z = mul(z,x);
768       return (z);
769     }
770   }
771 }