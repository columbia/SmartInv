1 pragma solidity ^0.4.24;
2 
3 /*
4 
5 Wall Street Market presents........
6 
7 
8 
9  ______   __                     ______  __        _            ______                          __         
10 |_   _ \ [  |                  .' ___  |[  |      (_)          |_   _ \                        |  ]        
11   | |_) | | | __   _   .---.  / .'   \_| | |--.   __  _ .--.     | |_) |   .--.   _ .--.   .--.| |  .--.   
12   |  __'. | |[  | | | / /__\\ | |        | .-. | [  |[ '/'`\ \   |  __'. / .'`\ \[ `.-. |/ /'`\' | ( (`\]  
13  _| |__) || | | \_/ |,| \__., \ `.___.'\ | | | |  | | | \__/ |  _| |__) || \__. | | | | || \__/  |  `'.'.  
14 |_______/[___]'.__.'_/ '.__.'  `.____ .'[___]|__][___]| ;.__/  |_______/  '.__.' [___||__]'.__.;__][\__) ) 
15                                                      [__|                                                  
16                                           
17 
18 
19 website:    https://wallstreetmarket.tk
20 
21 discord:    https://discord.gg/8AFP9gS
22 
23 
24 Blue Chip Bonds is a new Bond game using BCHIPs
25 
26 with earning opportunities avaliable for players actively engaged in the game.   Buy a bond and reap the rewards from other players as they buy in.
27 
28 The price of your bond automatically increases 25% once you buy it.   You earn yield until someone else buys your bond.   Then you collect 50% of the gain.
29 
30 45% of the gain is distributed to the other bond owners.  5% goes to Wall Street Marketing.
31 
32 The yields are based on the relative price of your bond.  If your bond is priced higher than the average of the other bonds, you will get proportionally more
33 yield.  The current yield rate will be listed on your bond at any time along with the price.
34 
35 The bonds have a half-life.   When the half-life is reached the price of the bond is cut in half.
36 
37 A bonus referral program is available.   Using your Masternode you will collect 5% of any net gains made during a purcchase by the user of your masternode.
38 
39 */
40 
41 
42 contract BCHIPReceivingContract {
43   /**
44    * @dev Standard ERC223 function that will handle incoming token transfers.
45    *
46    * @param _from  Token sender address.
47    * @param _value Amount of tokens.
48    * @param _data  Transaction metadata.
49    */
50   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
51 //   function tokenFallbackExpanded(address _from, uint _value, bytes _data, address _sender) public returns (bool);
52 }
53 
54 
55 contract BCHIPInterface 
56 {
57 
58     
59    // function getFrontEndTokenBalanceOf(address who) public view returns (uint);
60     function transfer(address _to, uint _value) public returns (bool);
61     //function approve(address spender, uint tokens) public returns (bool);
62     function transferAndCall(address _sender, uint _value, bytes _data) public returns(bool);
63     function balanceOf(address _customerAddress) public returns(bool);
64 }
65 
66 contract BLUECHIPBONDS is BCHIPReceivingContract {
67     /*=================================
68     =        MODIFIERS        =
69     =================================*/
70    
71 
72 
73     modifier onlyOwner(){
74         
75         require(msg.sender == dev);
76         _;
77     }
78 
79     
80     modifier onlyActive(){
81         
82         require(boolContractActive);
83         _;
84     }
85 
86     modifier allowPlayer(){
87         
88         require(boolAllowPlayer);
89         _;
90     }
91     
92 
93     /*==============================
94     =            EVENTS            =
95     ==============================*/
96     event onBondBuy(
97         address customerAddress,
98         uint256 incomingEthereum,
99         uint256 bond,
100         uint256 newPrice,
101         uint256 halfLifeTime
102     );
103     
104     event onWithdrawETH(
105         address customerAddress,
106         uint256 ethereumWithdrawn
107     );
108 
109       event onWithdrawTokens(
110         address customerAddress,
111         uint256 ethereumWithdrawn
112     );
113     
114     // ERC20
115     event transferBondEvent(
116         address from,
117         address to,
118         uint256 bond
119     );
120 
121      // HalfLife
122     event Halflife(
123         uint bond,
124         uint price,
125         uint newBlockTime
126     );
127 
128 
129     
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "BLUECHIPBONDS";
134     string public symbol = "BLU";
135 
136     
137 
138     uint8 constant public referralRate = 5; 
139 
140     uint8 constant public decimals = 18;
141   
142     uint public totalBondValue = 17000e18;
143 
144     uint public totalOwnerAccounts = 0;
145 
146     uint constant dayBlockFactor = 21600;
147 
148     uint contractETH = 0;
149 
150     
151    /*================================
152     =            DATASETS            =
153     ================================*/
154     
155     mapping(uint => address) internal bondOwner;
156     mapping(uint => uint) public bondPrice;
157     mapping(uint => uint) public basePrice;
158     mapping(uint => uint) internal bondPreviousPrice;
159     mapping(address => uint) internal ownerAccounts;
160     mapping(uint => uint) internal totalBondDivs;
161     mapping(uint => uint) internal totalBondDivsETH;
162     mapping(uint => string) internal bondName;
163 
164     mapping(uint => uint) internal bondBlockNumber;
165 
166     mapping(address => uint) internal ownerAccountsETH;
167 
168     uint bondPriceIncrement = 125;   //25% Price Increases
169     uint totalDivsProduced = 0;
170 
171     uint public maxBonds = 200;
172     
173     uint public initialPrice = 170e18;   //170 Tokens
174 
175     uint public nextAvailableBond;
176 
177     bool allowReferral = false;
178 
179     bool allowAutoNewBond = false;
180 
181     uint8 public devDivRate = 5;
182     uint8 public ownerDivRate = 50;
183     uint8 public distDivRate = 45;
184 
185     uint public bondFund = 0;
186 
187     address public exchangeContract;
188 
189     address public bankRoll;
190 
191     uint contractBalance = 0;
192 
193     BCHIPInterface public BCHIPTOKEN;
194    
195     address dev;
196 
197     uint256 internal tokenSupply_ = 0;
198 
199     uint public halfLifeTime = 5900;   //1 day to start block half life period
200     uint public halfLifeRate = 90;   //cut price by 1/10 each half life period
201 
202     bool public allowHalfLife = false;
203 
204     bool public allowLocalBuy = true;
205     bool public allowPriceLower = false;
206 
207     bool public boolContractActive = true;
208 
209     bool public boolAllowPlayer = false;
210 
211 
212     //address add1 = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
213     address add2 = 0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61;
214 
215     
216 
217 
218     /*=======================================
219     =            PUBLIC FUNCTIONS            =
220     =======================================*/
221     /*
222     * -- APPLICATION ENTRY POINTS --  
223     */
224     constructor(address _exchangeAddress, address _bankRollAddress)
225         public
226     {
227 
228         BCHIPTOKEN = BCHIPInterface(_exchangeAddress);
229         exchangeContract = _exchangeAddress;
230 
231         // Set the bankroll
232         bankRoll = _bankRollAddress;
233 
234 
235 
236 
237 
238         dev = msg.sender;
239         nextAvailableBond = 23;
240 
241         bondOwner[1] = dev;
242         bondPrice[1] = 1500e18;
243         basePrice[1] = bondPrice[1];
244         bondPreviousPrice[1] = 0;
245 
246         bondOwner[2] = dev;
247         bondPrice[2] = 1430e18;
248         basePrice[2] = bondPrice[2];
249         bondPreviousPrice[2] = 0;
250 
251         bondOwner[3] = dev;
252         bondPrice[3] = 1360e18;
253         basePrice[3] = bondPrice[3];
254         bondPreviousPrice[3] = 0;
255 
256         bondOwner[4] = dev;
257         bondPrice[4] = 1290e18;
258         basePrice[4] = bondPrice[4];
259         bondPreviousPrice[4] = 0;
260 
261         bondOwner[5] = dev;
262         bondPrice[5] = 1220e18;
263         basePrice[5] = bondPrice[5];
264         bondPreviousPrice[5] = 0;
265 
266         bondOwner[6] = dev;
267         bondPrice[6] = 1150e18;
268         basePrice[6] = bondPrice[6];
269         bondPreviousPrice[6] = 0;
270 
271         bondOwner[7] = dev;
272         bondPrice[7] = 1080e18;
273         basePrice[7] = bondPrice[7];
274         bondPreviousPrice[7] = 0;
275 
276         bondOwner[8] = dev;
277         bondPrice[8] = 1010e18;
278         basePrice[8] = bondPrice[8];
279         bondPreviousPrice[8] = 0;
280 
281         bondOwner[9] = dev;
282         bondPrice[9] = 940e18;
283         basePrice[9] = bondPrice[9];
284         bondPreviousPrice[9] = 0;
285 
286         bondOwner[10] = add2;
287         bondPrice[10] = 870e18;
288         basePrice[10] = bondPrice[10];
289         bondPreviousPrice[10] = 0;
290 
291         bondOwner[11] = dev;
292         bondPrice[11] = 800e18;
293         basePrice[11] = bondPrice[11];
294         bondPreviousPrice[11] = 0;
295 
296         bondOwner[12] = dev;
297         bondPrice[12] = 730e18;
298         basePrice[12] = bondPrice[12];
299         bondPreviousPrice[12] = 0;
300 
301         bondOwner[13] = dev;
302         bondPrice[13] = 660e18;
303         basePrice[13] = bondPrice[13];
304         bondPreviousPrice[13] = 0;
305 
306         bondOwner[14] = dev;
307         bondPrice[14] = 590e18;
308         basePrice[14] = bondPrice[14];
309         bondPreviousPrice[14] = 0;
310 
311         bondOwner[15] = dev;
312         bondPrice[15] = 520e18;
313         basePrice[15] = bondPrice[15];
314         bondPreviousPrice[15] = 0;
315 
316         bondOwner[16] = dev;
317         bondPrice[16] = 450e18;
318         basePrice[16] = bondPrice[16];
319         bondPreviousPrice[16] = 0;
320 
321         bondOwner[17] = dev;
322         bondPrice[17] = 380e18;
323         basePrice[17] = bondPrice[17];
324         bondPreviousPrice[17] = 0;
325 
326         bondOwner[18] = dev;
327         bondPrice[18] = 310e18;
328         basePrice[18] = bondPrice[18];
329         bondPreviousPrice[18] = 0;
330 
331         bondOwner[19] = dev;
332         bondPrice[19] = 240e18;
333         basePrice[19] = bondPrice[19];
334         bondPreviousPrice[19] = 0;
335 
336         bondOwner[20] = dev;
337         bondPrice[20] = 170e18;
338         basePrice[20] = bondPrice[20];
339         bondPreviousPrice[20] = 0;
340 
341         bondOwner[21] = dev;
342         bondPrice[21] = 150e18;
343         basePrice[21] = bondPrice[21];
344         bondPreviousPrice[21] = 0;
345 
346         bondOwner[22] = dev;
347         bondPrice[22] = 150e18;
348         basePrice[22] = bondPrice[22];
349         bondPreviousPrice[22] = 0;
350 
351         getTotalBondValue();
352        
353 
354     }
355 
356 
357 
358         // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange 
359      // and other contracts
360 
361     function()
362         payable
363         public
364     {
365         
366     }
367 
368 
369 
370      // Token fallback to receive tokens from the exchange
371     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
372         require(msg.sender == exchangeContract);
373         if (_from == bankRoll) { // Just adding tokens to the contract
374         // Update the contract balance
375             contractBalance = SafeMath.add(contractBalance,_value);
376 
377 
378             return true;
379 
380         } else {
381     
382             //address _referrer = 0x0000000000000000000000000000000000000000;
383             //buy(uint(_data[0]), _value, _from, _referrer);
384             ownerAccounts[_from] = SafeMath.add(ownerAccounts[_from],_value);
385 
386 
387         }
388 
389         return true;
390     }
391 
392 
393     
394     //  // Token fallback to receive tokens from the exchange
395     // function tokenFallbackExpanded(address _from, uint _value, bytes _data, address _sender, address _referrer) public returns (bool) {
396     //     require(msg.sender == exchangeContract);
397     //     uint16 _bond = _data[0];
398 
399     //     if (_from == bankRoll) { // Just adding tokens to the contract
400     //     // Update the contract balance
401     //         contractBalance = SafeMath.add(contractBalance,_value);
402 
403 
404     //         return true;
405 
406     //     } else {
407     
408     //         //address _referrer = 0x0000000000000000000000000000000000000000;
409     //         //buy(uint(_data[0]), _value, _from, _referrer);
410     //         ownerAccounts[_sender] = SafeMath.add(ownerAccounts[_sender],_value);
411     //         buy(_bond, bondPrice[_bond], _from, _referrer, _sender);
412 
413     //     }
414 
415     //     return true;
416     // }
417 
418     //use tokens in this contract for buy if enough available
419     function localBuy(uint _bond, address _from, address _referrer)
420         public
421         onlyActive()
422     {
423         //if (allowLocalBuy){
424             require(_bond <= nextAvailableBond);
425             require(ownerAccounts[_from] >= bondPrice[_bond]);
426             _from = msg.sender;
427 
428             ownerAccounts[_from] = SafeMath.sub(ownerAccounts[_from],bondPrice[_bond]);
429             buy(_bond, bondPrice[_bond], _from, _referrer, msg.sender);
430         //}
431     }
432 
433     
434     function buy(uint _bond, uint _value, address _from, address _referrer, address _sender)
435         internal
436         onlyActive()
437     {
438         require(_bond <= nextAvailableBond);
439         require(_value >= bondPrice[_bond]);
440         //require(msg.sender != bondOwner[_bond]);
441 
442         
443         bondBlockNumber[_bond] = block.number;   //reset block number for this bond for half life calculations
444 
445         //uint _newPrice = SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100);
446 
447          //Determine the total dividends
448         uint _baseDividends = _value - bondPreviousPrice[_bond];
449         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
450 
451         //uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
452         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
453 
454         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
455         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
456             
457         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
458 
459         if (allowReferral && (_referrer != _sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
460                 
461             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),100);
462             _distDividends = SafeMath.sub(_distDividends,_referralDividends);
463             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
464         }
465             
466 
467 
468         //distribute dividends to accounts
469         address _previousOwner = bondOwner[_bond];
470         address _newOwner = _sender;
471 
472         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
473         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100));
474 
475         bondOwner[_bond] = _newOwner;
476 
477         distributeYield(_distDividends);
478         distributeBondFund();
479         //Increment the bond Price
480         bondPreviousPrice[_bond] = _value;
481         bondPrice[_bond] = SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100);
482         //addTotalBondValue(SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100), bondPreviousPrice[_bond]);
483         
484         getTotalBondValue();
485         getTotalOwnerAccounts();
486         emit onBondBuy(_sender, _value, _bond, SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100), halfLifeTime);
487      
488     }
489 
490     function distributeYield(uint _distDividends) internal
491     //tokens
492     {
493         uint counter = 1;
494         uint currentBlock = block.number;
495 
496         while (counter < nextAvailableBond) { 
497 
498             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
499             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
500             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
501 
502 
503              //HalfLife Check
504             if (allowHalfLife) {
505 
506                 if (bondPrice[counter] > basePrice[counter]) {
507                     uint _life = SafeMath.sub(currentBlock, bondBlockNumber[counter]);
508 
509                     //if (_life > SafeMath.mul(halfLifeTime, dayBlockFactor)) {
510                     if (_life > halfLifeTime) {
511                     
512                         bondBlockNumber[counter] = currentBlock;  //Reset the clock for this bond
513                         if (SafeMath.div(SafeMath.mul(bondPrice[counter], halfLifeRate),100) < basePrice[counter]){
514                             
515                             //totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[counter],basePrice[counter]));
516                             bondPrice[counter] = basePrice[counter];
517                             
518                         }else{
519 
520                             bondPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter], halfLifeRate),100);  
521                             bondPreviousPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter],75),100);
522 
523                         }
524 
525                         emit Halflife(counter,  bondPrice[counter], halfLifeTime);
526 
527                     }
528                     //HalfLife Check
529 
530 
531                 }
532                
533             }
534             
535             counter = counter + 1;
536         } 
537         getTotalBondValue();
538         getTotalOwnerAccounts();
539 
540     }
541 
542     function checkHalfLife() public
543     
544     //tokens
545     {
546 
547         bool _boolDev = (msg.sender == dev);
548         if (_boolDev || boolAllowPlayer){
549 
550         
551         uint counter = 1;
552         uint currentBlock = block.number;
553 
554         while (counter < nextAvailableBond) { 
555 
556             //HalfLife Check
557             if (allowHalfLife) {
558 
559                 if (bondPrice[counter] > basePrice[counter]) {
560                     uint _life = SafeMath.sub(currentBlock, bondBlockNumber[counter]);
561 
562                     //if (_life > SafeMath.mul(halfLifeTime, dayBlockFactor)) {
563                     if (_life > halfLifeTime) {
564                     
565                         bondBlockNumber[counter] = currentBlock;  //Reset the clock for this bond
566                         if (SafeMath.div(SafeMath.mul(bondPrice[counter], halfLifeRate),100) < basePrice[counter]){
567                             
568                             //totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[counter],basePrice[counter]));
569                             bondPrice[counter] = basePrice[counter];
570                             
571                         }else{
572 
573                             bondPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter], halfLifeRate),100);  
574                             bondPreviousPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter],75),100);
575 
576                         }
577 
578                         
579                         
580                         emit Halflife(counter,  bondPrice[counter], halfLifeTime);
581 
582                     }
583                     //HalfLife Check
584 
585 
586                 }
587                
588             }
589             
590             
591             counter = counter + 1;
592         } 
593         getTotalBondValue();
594         getTotalOwnerAccounts();
595 
596         }
597 
598     }
599     
600     function distributeBondFund() internal
601     //eth
602 
603     {
604         if(bondFund > 0){
605             uint counter = 1;
606 
607             while (counter < nextAvailableBond) { 
608 
609                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
610                 ownerAccountsETH[bondOwner[counter]] = SafeMath.add(ownerAccountsETH[bondOwner[counter]],_distAmountLocal);
611                 totalBondDivsETH[counter] = SafeMath.add(totalBondDivsETH[counter],_distAmountLocal);
612                 counter = counter + 1;
613             } 
614 
615             bondFund = 0;
616            
617         }
618     }
619 
620     function extDistributeBondFund() public
621     onlyOwner()
622     {
623         if(bondFund > 0){
624             uint counter = 1;
625 
626             while (counter < nextAvailableBond) { 
627 
628                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
629                 ownerAccountsETH[bondOwner[counter]] = SafeMath.add(ownerAccountsETH[bondOwner[counter]],_distAmountLocal);
630                 totalBondDivsETH[counter] = SafeMath.add(totalBondDivsETH[counter],_distAmountLocal);
631                 counter = counter + 1;
632             } 
633             bondFund = 0;
634             
635         }
636     }
637 
638 
639 function returnTokensToExchange()
640     
641         public
642     {
643         address _customerAddress = msg.sender;
644         require(ownerAccounts[_customerAddress] > 0);
645         uint _amount = ownerAccounts[_customerAddress];
646         ownerAccounts[_customerAddress] = 0;
647         //_customerAddress.transfer(_dividends);
648 
649         BCHIPTOKEN.transfer(_customerAddress, _amount);
650         // fire event
651         emit onWithdrawTokens(_customerAddress, _amount);
652     }
653 
654 
655     function withdraw()
656     
657         public
658     {
659         address _customerAddress = msg.sender;
660         require(ownerAccountsETH[_customerAddress] > 0);
661         uint _dividends = ownerAccountsETH[_customerAddress];
662         ownerAccountsETH[_customerAddress] = 0;
663         _customerAddress.transfer(_dividends);
664         // fire event
665         emit onWithdrawETH(_customerAddress, _dividends);
666     }
667 
668     function withdrawPart(uint _amount)
669     
670         public
671         onlyOwner()
672     {
673         address _customerAddress = msg.sender;
674         require(ownerAccountsETH[_customerAddress] > 0);
675         require(_amount <= ownerAccountsETH[_customerAddress]);
676         ownerAccountsETH[_customerAddress] = SafeMath.sub(ownerAccountsETH[_customerAddress],_amount);
677         _customerAddress.transfer(_amount);
678         // fire event
679         emit onWithdrawETH(_customerAddress, _amount);
680     }
681 
682     function refund(address _to)  //this is to distribute accumulated dividends the contract gains from tokens
683         public
684         onlyOwner()
685     {
686         
687         uint _divAmount = SafeMath.sub(address(this).balance, bondFund);
688         require (_divAmount <= address(this).balance);
689         contractETH = SafeMath.sub(contractETH, _divAmount);
690         _to.transfer(_divAmount);
691     }
692 
693     function deposit(){
694         
695         contractETH = SafeMath.add(contractETH, msg.value);
696         bondFund = SafeMath.add(bondFund, msg.value);
697     }
698     
699 
700  
701     
702     /**
703      * Transfer bond to another address
704      */
705     function transferBond(address _to, uint _bond )
706        
707         public
708     {
709         require(bondOwner[_bond] == msg.sender);
710 
711         bondOwner[_bond] = _to;
712 
713         emit transferBondEvent(msg.sender, _to, _bond);
714 
715     }
716 
717     
718     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
719     /**
720 
721     /**
722      * If we want to rebrand, we can.
723      */
724     function setName(string _name)
725         onlyOwner()
726         public
727     {
728         name = _name;
729     }
730     
731     /**
732      * If we want to rebrand, we can.
733      */
734     function setSymbol(string _symbol)
735         onlyOwner()
736         public
737     {
738         symbol = _symbol;
739     }
740 
741 
742     
743     function setExchangeAddress(address _newExchangeAddress)
744         onlyOwner()
745         public
746     {
747         exchangeContract = _newExchangeAddress;
748     }
749 
750 
751     function setHalfLifeTime(uint _time)
752         onlyOwner()
753         public
754     {
755         halfLifeTime = _time;
756     }
757 
758     function setHalfLifeRate(uint _rate)
759         onlyOwner()
760         public
761     {
762         halfLifeRate = _rate;
763     }
764 
765 
766     function setInitialPrice(uint _price)
767         onlyOwner()
768         public
769     {
770         initialPrice = _price;
771     }
772 
773     function setMaxbonds(uint _bond)  
774         onlyOwner()
775         public
776     {
777         maxBonds = _bond;
778     }
779 
780     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it and only lower it
781         onlyOwner()
782         public
783     {
784         require(bondOwner[_bond] == dev);
785         require(_price < bondPrice[_bond]);
786 
787         //totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[_bond],_price));
788 
789         bondPreviousPrice[_bond] = SafeMath.div(SafeMath.mul(_price,75),100);
790 
791         bondPrice[_bond] = _price;
792 
793         getTotalBondValue();
794         getTotalOwnerAccounts();
795     }
796     
797     function addNewbond(uint _price) 
798         onlyOwner()
799         public
800     {
801         require(nextAvailableBond < maxBonds);
802         bondPrice[nextAvailableBond] = _price;
803         bondOwner[nextAvailableBond] = dev;
804         totalBondDivs[nextAvailableBond] = 0;
805         bondPreviousPrice[nextAvailableBond] = 0;
806         nextAvailableBond = nextAvailableBond + 1;
807         //addTotalBondValue(_price, 0);
808         getTotalBondValue();
809         getTotalOwnerAccounts();
810         
811     }
812 
813     function setAllowLocalBuy(bool _allow)   
814         onlyOwner()
815         public
816     {
817         allowLocalBuy = _allow;
818     }
819 
820      function setAllowPlayer(bool _allow)   
821         onlyOwner()
822         public
823     {
824         boolAllowPlayer = _allow;
825     }
826 
827     function setAllowPriceLower(bool _allow)   
828         onlyOwner()
829         public
830     {
831         allowPriceLower = _allow;
832     }
833 
834     function setAllowHalfLife(bool _allow)   
835         onlyOwner()
836         public
837     {
838         allowHalfLife = _allow;
839     }
840 
841     function setAllowReferral(bool _allowReferral)   
842         onlyOwner()
843         public
844     {
845         allowReferral = _allowReferral;
846     }
847 
848     function setAutoNewbond(bool _autoNewBond)   
849         onlyOwner()
850         public
851     {
852         allowAutoNewBond = _autoNewBond;
853     }
854 
855     function setRates(uint8 _newDistRate, uint8 _newDevRate,  uint8 _newOwnerRate)   
856         onlyOwner()
857         public
858     {
859         require((_newDistRate + _newDevRate + _newOwnerRate) == 100);
860         require(_newDevRate <= 10);
861         devDivRate = _newDevRate;
862         ownerDivRate = _newOwnerRate;
863         distDivRate = _newDistRate;
864     }
865 
866     function setLowerBondPrice(uint _bond, uint _newPrice)   //Allow a bond owner to lower the price if they want to dump it. They cannont raise the price
867     
868     {
869         require(allowPriceLower);
870         require(bondOwner[_bond] == msg.sender);
871         require(_newPrice < bondPrice[_bond]);
872         require(_newPrice >= initialPrice);
873 
874         //totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[_bond],_newPrice));
875 
876         bondPreviousPrice[_bond] = SafeMath.div(SafeMath.mul(_newPrice,75),100);
877 
878         bondPrice[_bond] = _newPrice;
879         getTotalBondValue();
880         getTotalOwnerAccounts();
881     }
882 
883  
884     
885     /*----------  HELPERS AND CALCULATORS  ----------*/
886     /**
887      * Method to view the current Ethereum stored in the contract
888      * Example: totalEthereumBalance()
889      */
890 
891  /**
892      * Retrieve the total token supply.
893      */
894     function totalSupply()
895         public
896         view
897         returns(uint256)
898     {
899         return tokenSupply_;
900     }
901 
902 
903     function getMyBalance()
904         public
905         view
906         returns(uint)
907     {
908         return ownerAccounts[msg.sender];
909     }
910 
911     function getOwnerBalance(address _bondOwner)
912         public
913         view
914         returns(uint)
915     {
916         require(msg.sender == dev);
917         return ownerAccounts[_bondOwner];
918     }
919     
920     function getBondPrice(uint _bond)
921         public
922         view
923         returns(uint)
924     {
925         require(_bond <= nextAvailableBond);
926         return bondPrice[_bond];
927     }
928 
929     function getBondOwner(uint _bond)
930         public
931         view
932         returns(address)
933     {
934         require(_bond <= nextAvailableBond);
935         return bondOwner[_bond];
936     }
937 
938     function gettotalBondDivs(uint _bond)
939         public
940         view
941         returns(uint)
942     {
943         require(_bond <= nextAvailableBond);
944         return totalBondDivs[_bond];
945     }
946 
947     function getTotalDivsProduced()
948         public
949         view
950         returns(uint)
951     {
952      
953         return totalDivsProduced;
954     }
955 
956     function totalEthereumBalance()
957         public
958         view
959         returns(uint)
960     {
961         return address (this).balance;
962     }
963 
964     function getNextAvailableBond()
965         public
966         view
967         returns(uint)
968     {
969         return nextAvailableBond;
970     }
971 
972     function getTotalBondValue()
973         internal
974         view
975         {
976             uint counter = 1;
977             uint _totalVal = 0;
978 
979             while (counter < nextAvailableBond) { 
980 
981                 _totalVal = SafeMath.add(_totalVal,bondPrice[counter]);
982                 
983                 counter = counter + 1;
984             } 
985             totalBondValue = _totalVal;
986             
987         }
988 
989     function getTotalOwnerAccounts()
990         internal
991         view
992         {
993     
994         }
995 
996     }
997 
998 /**
999  * @title SafeMath
1000  * @dev Math operations with safety checks that throw on error
1001  */
1002 library SafeMath {
1003 
1004     /**
1005     * @dev Multiplies two numbers, throws on overflow.
1006     */
1007     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1008         if (a == 0) {
1009             return 0;
1010         }
1011         uint256 c = a * b;
1012         assert(c / a == b);
1013         return c;
1014     }
1015 
1016     /**
1017     * @dev Integer division of two numbers, truncating the quotient.
1018     */
1019     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1020         // assert(b > 0); // Solidity automatically throws when dividing by 0
1021         uint256 c = a / b;
1022         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1023         return c;
1024     }
1025 
1026     /**
1027     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1028     */
1029     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1030         assert(b <= a);
1031         return a - b;
1032     }
1033 
1034     /**
1035     * @dev Adds two numbers, throws on overflow.
1036     */
1037     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1038         uint256 c = a + b;
1039         assert(c >= a);
1040         return c;
1041     }
1042 }