1 pragma solidity ^0.4.24;
2 
3 /*
4 
5 Wall Street Market presents........
6 
7 
8 ___  ___           _                          ______                 _     
9 |  \/  |          | |                         | ___ \               | |    
10 | .  . | ___  _ __| |_ __ _  __ _  __ _  ___  | |_/ / ___  _ __   __| |___ 
11 | |\/| |/ _ \| '__| __/ _` |/ _` |/ _` |/ _ \ | ___ \/ _ \| '_ \ / _` / __|
12 | |  | | (_) | |  | || (_| | (_| | (_| |  __/ | |_/ / (_) | | | | (_| \__ \
13 \_|  |_/\___/|_|   \__\__, |\__,_|\__, |\___| \____/ \___/|_| |_|\__,_|___/
14                        __/ |       __/ |                                   
15                       |___/       |___/                                    
16                                                                   
17                                                                    
18 website:    https://wallstreetmarket.tk
19 
20 discord:    https://discord.gg/8AFP9gS
21 
22 
23 Wall Street MORTGAGE Bonds is a new Bond game for EVERY PLAYER 
24 
25 with earning opportunities avaliable for players actively engaged in the game.   Buy a bond and reap the rewards from other players as they buy in.
26 
27 Bonds also distribute 5% yield from buys and sell of the Stock Exchange which is also available on the Wall Street Market.
28 
29 The price of your bond automatically increases once you buy it.   You earn yield until someone else buys your bond.   Then you collect 50% of the gain.
30 
31 45% of the gain is distributed to the other bond owners.  5% goes to Wall Street Marketing.
32 
33 The yields are based on the relative price of your bond.  If your bond is priced higher than the average of the other bonds, you will get proportionally more
34 yield.  The current yield rate will be listed on your bond at any time along with the price.
35 
36 A bonus referral program is available.   Using your Masternode you will collect 5% of any net gains made during a purcchase by the user of your masternode.
37 
38 */
39 
40 
41 contract STOCKReceivingContract {
42   /**
43    * @dev Standard ERC223 function that will handle incoming token transfers.
44    *
45    * @param _from  Token sender address.
46    * @param _value Amount of tokens.
47    * @param _data  Transaction metadata.
48    */
49   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
50 }
51 
52 
53 contract STOCKInterface 
54 {
55 
56     
57    // function getFrontEndTokenBalanceOf(address who) public view returns (uint);
58     function transfer(address _to, uint _value) public returns (bool);
59     //function approve(address spender, uint tokens) public returns (bool);
60     function transferAndCall(address _sender, uint _value, bytes _data) public returns(bool);
61     function balanceOf(address _customerAddress) public returns(bool);
62 }
63 
64 contract MORTGAGEBONDS is STOCKReceivingContract {
65     /*=================================
66     =        MODIFIERS        =
67     =================================*/
68    
69 
70 
71     modifier onlyOwner(){
72         
73         require(msg.sender == dev);
74         _;
75     }
76     
77 
78     /*==============================
79     =            EVENTS            =
80     ==============================*/
81     event onBondPurchase(
82         address customerAddress,
83         uint256 incomingEthereum,
84         uint256 bond,
85         uint256 newPrice
86     );
87     
88     event onWithdrawETH(
89         address customerAddress,
90         uint256 ethereumWithdrawn
91     );
92 
93       event onWithdrawTokens(
94         address customerAddress,
95         uint256 ethereumWithdrawn
96     );
97     
98     // ERC20
99     event Transfer(
100         address from,
101         address to,
102         uint256 bond
103     );
104 
105 
106     
107     /*=====================================
108     =            CONFIGURABLES            =
109     =====================================*/
110     string public name = "MORTGAGEBONDS";
111     string public symbol = "YIELD";
112 
113     
114 
115     uint8 constant public referralRate = 5; 
116 
117     uint8 constant public decimals = 18;
118   
119     uint public totalBondValue = 17000e18;
120 
121     uint constant dayBlockFactor = 21600;
122 
123     
124    /*================================
125     =            DATASETS            =
126     ================================*/
127     
128     mapping(uint => address) internal bondOwner;
129     mapping(uint => uint) public bondPrice;
130     mapping(uint => uint) internal bondPreviousPrice;
131     mapping(address => uint) internal ownerAccounts;
132     mapping(uint => uint) internal totalBondDivs;
133     mapping(uint => uint) internal totalBondDivsETH;
134     mapping(uint => string) internal bondName;
135 
136     mapping(uint => uint) internal bondBlockNumber;
137 
138     mapping(address => uint) internal ownerAccountsETH;
139 
140     uint bondPriceIncrement = 125;   //25% Price Increases
141     uint totalDivsProduced = 0;
142 
143     uint public maxBonds = 200;
144     
145     uint public initialPrice = 170e18;   //170 Tokens
146 
147     uint public nextAvailableBond;
148 
149     bool allowReferral = false;
150 
151     bool allowAutoNewBond = false;
152 
153     uint8 public devDivRate = 5;
154     uint8 public ownerDivRate = 50;
155     uint8 public distDivRate = 45;
156 
157     uint public bondFund = 0;
158 
159     address public exchangeContract;
160 
161     address public bankRoll;
162 
163     uint contractBalance = 0;
164 
165     STOCKInterface public STOCKTOKEN;
166    
167     address dev;
168 
169     uint256 internal tokenSupply_ = 0;
170 
171     uint public halfLifeTime = 10;   //10 day half life period
172     uint public halfLifeRate = 67;   //cut price by 1/3 each half life period
173 
174     bool public allowHalfLife = false;
175 
176     bool public allowLocalBuy = false;
177 
178 
179     address add1 = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
180     address add2 = 0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61;
181 
182     
183 
184 
185     /*=======================================
186     =            PUBLIC FUNCTIONS            =
187     =======================================*/
188     /*
189     * -- APPLICATION ENTRY POINTS --  
190     */
191     constructor(address _exchangeAddress, address _bankRollAddress)
192         public
193     {
194 
195         STOCKTOKEN = STOCKInterface(_exchangeAddress);
196         exchangeContract = _exchangeAddress;
197 
198         // Set the bankroll
199         bankRoll = _bankRollAddress;
200 
201 
202 
203 
204 
205         dev = msg.sender;
206         nextAvailableBond = 23;
207 
208         bondOwner[1] = add1;
209         bondPrice[1] = 1500e18;
210         bondPreviousPrice[1] = 0;
211 
212         bondOwner[2] = add1;
213         bondPrice[2] = 1430e18;
214         bondPreviousPrice[2] = 0;
215 
216         bondOwner[3] = dev;
217         bondPrice[3] = 1360e18;
218         bondPreviousPrice[3] = 0;
219 
220         bondOwner[4] = dev;
221         bondPrice[4] = 1290e18;
222         bondPreviousPrice[4] = 0;
223 
224         bondOwner[5] = dev;
225         bondPrice[5] = 1220e18;
226         bondPreviousPrice[5] = 0;
227 
228         bondOwner[6] = dev;
229         bondPrice[6] = 1150e18;
230         bondPreviousPrice[6] = 0;
231 
232         bondOwner[7] = dev;
233         bondPrice[7] = 1080e18;
234         bondPreviousPrice[7] = 0;
235 
236         bondOwner[8] = dev;
237         bondPrice[8] = 1010e18;
238         bondPreviousPrice[8] = 0;
239 
240         bondOwner[9] = dev;
241         bondPrice[9] = 940e18;
242         bondPreviousPrice[9] = 0;
243 
244         bondOwner[10] = dev;
245         bondPrice[10] = 870e18;
246         bondPreviousPrice[10] = 0;
247 
248         bondOwner[11] = add2;
249         bondPrice[11] = 800e18;
250         bondPreviousPrice[11] = 0;
251 
252         bondOwner[12] = dev;
253         bondPrice[12] = 730e18;
254         bondPreviousPrice[12] = 0;
255 
256         bondOwner[13] = dev;
257         bondPrice[13] = 660e18;
258         bondPreviousPrice[13] = 0;
259 
260         bondOwner[14] = dev;
261         bondPrice[14] = 590e18;
262         bondPreviousPrice[14] = 0;
263 
264         bondOwner[15] = dev;
265         bondPrice[15] = 520e18;
266         bondPreviousPrice[15] = 0;
267 
268         bondOwner[16] = dev;
269         bondPrice[16] = 450e18;
270         bondPreviousPrice[16] = 0;
271 
272         bondOwner[17] = dev;
273         bondPrice[17] = 380e18;
274         bondPreviousPrice[17] = 0;
275 
276         bondOwner[18] = dev;
277         bondPrice[18] = 310e18;
278         bondPreviousPrice[18] = 0;
279 
280         bondOwner[19] = dev;
281         bondPrice[19] = 240e18;
282         bondPreviousPrice[19] = 0;
283 
284         bondOwner[20] = dev;
285         bondPrice[20] = 170e18;
286         bondPreviousPrice[20] = 0;
287 
288         bondOwner[21] = dev;
289         bondPrice[21] = 150e18;
290         bondPreviousPrice[21] = 0;
291 
292         bondOwner[22] = dev;
293         bondPrice[22] = 150e18;
294         bondPreviousPrice[22] = 0;
295 
296     }
297 
298 
299 
300         // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange 
301      // and other contracts
302 
303     function()
304         payable
305         public
306     {
307 
308         uint devAmount = SafeMath.div(SafeMath.mul(devDivRate,msg.value),100);
309         uint bondAmount = msg.value - devAmount;
310         bondFund = SafeMath.add(bondFund, bondAmount);
311         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], devAmount);
312     }
313 
314 
315 
316      // Token fallback to receive tokens from the exchange
317     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
318         require(msg.sender == exchangeContract);
319         if (_from == bankRoll) { // Just adding tokens to the contract
320         // Update the contract balance
321             contractBalance = SafeMath.add(contractBalance,_value);
322 
323 
324             return true;
325 
326         } else {
327     
328             //address _referrer = 0x0000000000000000000000000000000000000000;
329             //buy(uint(_data[0]), _value, _from, _referrer);
330             ownerAccounts[_from] = SafeMath.add(ownerAccounts[_from],_value);
331 
332 
333         }
334 
335         return true;
336     }
337 
338     //use tokens in this contract for buy if enough available
339     function localBuy(uint _bond, address _from, address _referrer)
340         public
341     {
342         //if (allowLocalBuy){
343             _from = msg.sender;
344 
345             ownerAccounts[_from] = SafeMath.sub(ownerAccounts[_from],bondPrice[_bond]);
346             buy(_bond, bondPrice[_bond], _from, _referrer);
347         //}
348     }
349 
350 
351 
352     function addTotalBondValue(uint _new, uint _old)
353     internal
354     {
355         //uint newPrice = SafeMath.div(SafeMath.mul(_new,bondPriceIncrement),100);
356         totalBondValue = SafeMath.add(totalBondValue, SafeMath.sub(_new,_old));
357     }
358     
359     function buy(uint _bond, uint _value, address _from, address _referrer)
360         internal
361 
362     {
363         require(_bond <= nextAvailableBond);
364         require(_value >= bondPrice[_bond]);
365         //require(msg.sender != bondOwner[_bond]);
366 
367         
368         bondBlockNumber[_bond] = block.number;   //reset block number for this bond for half life calculations
369 
370         uint _newPrice = SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100);
371 
372          //Determine the total dividends
373         uint _baseDividends = _value - bondPreviousPrice[_bond];
374         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
375 
376         //uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
377         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
378 
379         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
380         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
381             
382         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
383 
384         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
385                 
386             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),100);
387             _distDividends = SafeMath.sub(_distDividends,_referralDividends);
388             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
389         }
390             
391 
392 
393         //distribute dividends to accounts
394         address _previousOwner = bondOwner[_bond];
395         address _newOwner = msg.sender;
396 
397         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
398         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100));
399 
400         bondOwner[_bond] = _newOwner;
401 
402         distributeYield(_distDividends);
403         distributeBondFund();
404         //Increment the bond Price
405         bondPreviousPrice[_bond] = _value;
406         bondPrice[_bond] = _newPrice;
407         addTotalBondValue(_newPrice, bondPreviousPrice[_bond]);
408         
409        
410         emit onBondPurchase(msg.sender, _value, _bond, SafeMath.div(SafeMath.mul(_value,bondPriceIncrement),100));
411      
412     }
413 
414     function distributeYield(uint _distDividends) internal
415     //tokens
416     {
417         uint counter = 1;
418         uint currentBlock = block.number;
419 
420         while (counter < nextAvailableBond) { 
421 
422             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
423             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
424             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
425 
426 
427             //HalfLife Check
428             if (allowHalfLife) {
429                 uint _life = SafeMath.sub(currentBlock, bondBlockNumber[counter]);
430 
431                 if (_life > SafeMath.mul(halfLifeTime, dayBlockFactor)) {
432                     
433                     bondBlockNumber[counter] = currentBlock;  //Reset the clock for this bond
434                     bondPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter], halfLifeRate),100);  
435                     bondPreviousPrice[counter] = SafeMath.div(SafeMath.mul(bondPrice[counter],75),100);
436 
437                 }
438                 //HalfLife Check
439             }
440 
441             counter = counter + 1;
442         } 
443       
444 
445     }
446     
447     function distributeBondFund() internal
448     //eth
449     {
450         if(bondFund > 0){
451             uint counter = 1;
452 
453             while (counter < nextAvailableBond) { 
454 
455                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
456                 ownerAccountsETH[bondOwner[counter]] = SafeMath.add(ownerAccountsETH[bondOwner[counter]],_distAmountLocal);
457                 totalBondDivsETH[counter] = SafeMath.add(totalBondDivsETH[counter],_distAmountLocal);
458                 counter = counter + 1;
459             } 
460             bondFund = 0;
461            
462         }
463     }
464 
465     function extDistributeBondFund() public
466     onlyOwner()
467     {
468         if(bondFund > 0){
469             uint counter = 1;
470 
471             while (counter < nextAvailableBond) { 
472 
473                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
474                 ownerAccountsETH[bondOwner[counter]] = SafeMath.add(ownerAccountsETH[bondOwner[counter]],_distAmountLocal);
475                 totalBondDivsETH[counter] = SafeMath.add(totalBondDivsETH[counter],_distAmountLocal);
476                 counter = counter + 1;
477             } 
478             bondFund = 0;
479             
480         }
481     }
482 
483 
484 function returnTokensToExchange()
485     
486         public
487     {
488         address _customerAddress = msg.sender;
489         require(ownerAccounts[_customerAddress] > 0);
490         uint _amount = ownerAccounts[_customerAddress];
491         ownerAccounts[_customerAddress] = 0;
492         //_customerAddress.transfer(_dividends);
493 
494         STOCKTOKEN.transfer(_customerAddress, _amount);
495         // fire event
496         emit onWithdrawTokens(_customerAddress, _amount);
497     }
498 
499 
500 //ZTHTKN.transfer(target, profit + roll.tokenValue);
501 
502     function withdraw()
503     
504         public
505     {
506         address _customerAddress = msg.sender;
507         require(ownerAccountsETH[_customerAddress] > 0);
508         uint _dividends = ownerAccountsETH[_customerAddress];
509         ownerAccountsETH[_customerAddress] = 0;
510         _customerAddress.transfer(_dividends);
511         // fire event
512         emit onWithdrawETH(_customerAddress, _dividends);
513     }
514 
515     function withdrawPart(uint _amount)
516     
517         public
518         onlyOwner()
519     {
520         address _customerAddress = msg.sender;
521         require(ownerAccountsETH[_customerAddress] > 0);
522         require(_amount <= ownerAccountsETH[_customerAddress]);
523         ownerAccountsETH[_customerAddress] = SafeMath.sub(ownerAccountsETH[_customerAddress],_amount);
524         _customerAddress.transfer(_amount);
525         // fire event
526         emit onWithdrawETH(_customerAddress, _amount);
527     }
528 
529 
530     
531 
532  
533     
534     /**
535      * Transfer bond to another address
536      */
537     function transfer(address _to, uint _bond )
538        
539         public
540     {
541         require(bondOwner[_bond] == msg.sender);
542 
543         bondOwner[_bond] = _to;
544 
545         emit Transfer(msg.sender, _to, _bond);
546 
547     }
548 
549 
550       /**
551      * Transfer tokens to another address
552      */
553     function transferTokens(address _to, uint _bond )
554        
555         public
556     {
557         require(bondOwner[_bond] == msg.sender);
558 
559         bondOwner[_bond] = _to;
560 
561         emit Transfer(msg.sender, _to, _bond);
562 
563     }
564     
565     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
566     /**
567 
568     /**
569      * If we want to rebrand, we can.
570      */
571     function setName(string _name)
572         onlyOwner()
573         public
574     {
575         name = _name;
576     }
577     
578     /**
579      * If we want to rebrand, we can.
580      */
581     function setSymbol(string _symbol)
582         onlyOwner()
583         public
584     {
585         symbol = _symbol;
586     }
587 
588 
589     
590     function setExchangeAddress(address _newExchangeAddress)
591         onlyOwner()
592         public
593     {
594         exchangeContract = _newExchangeAddress;
595     }
596 
597 
598     function setHalfLifeTime(uint _time)
599         onlyOwner()
600         public
601     {
602         halfLifeTime = _time;
603     }
604 
605     function setHalfLifeRate(uint _rate)
606         onlyOwner()
607         public
608     {
609         halfLifeRate = _rate;
610     }
611 
612 
613     function setInitialPrice(uint _price)
614         onlyOwner()
615         public
616     {
617         initialPrice = _price;
618     }
619 
620     function setMaxbonds(uint _bond)  
621         onlyOwner()
622         public
623     {
624         maxBonds = _bond;
625     }
626 
627     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it
628         onlyOwner()
629         public
630     {
631         require(bondOwner[_bond] == dev);
632         bondPrice[_bond] = _price;
633     }
634     
635     function addNewbond(uint _price) 
636         onlyOwner()
637         public
638     {
639         require(nextAvailableBond < maxBonds);
640         bondPrice[nextAvailableBond] = _price;
641         bondOwner[nextAvailableBond] = dev;
642         totalBondDivs[nextAvailableBond] = 0;
643         bondPreviousPrice[nextAvailableBond] = 0;
644         nextAvailableBond = nextAvailableBond + 1;
645         addTotalBondValue(_price, 0);
646         
647     }
648 
649     function setAllowLocalBuy(bool _allow)   
650         onlyOwner()
651         public
652     {
653         allowLocalBuy = _allow;
654     }
655 
656     function setAllowHalfLife(bool _allow)   
657         onlyOwner()
658         public
659     {
660         allowHalfLife = _allow;
661     }
662 
663     function setAllowReferral(bool _allowReferral)   
664         onlyOwner()
665         public
666     {
667         allowReferral = _allowReferral;
668     }
669 
670     function setAutoNewbond(bool _autoNewBond)   
671         onlyOwner()
672         public
673     {
674         allowAutoNewBond = _autoNewBond;
675     }
676 
677     function setRates(uint8 _newDistRate, uint8 _newDevRate,  uint8 _newOwnerRate)   
678         onlyOwner()
679         public
680     {
681         require((_newDistRate + _newDevRate + _newOwnerRate) == 100);
682         devDivRate = _newDevRate;
683         ownerDivRate = _newOwnerRate;
684         distDivRate = _newDistRate;
685     }
686 
687     function setLowerBondPrice(uint _bond, uint _newPrice)   //Allow a bond owner to lower the price if they want to dump it. They cannont raise the price
688     
689     {
690         require(bondOwner[_bond] == msg.sender);
691         require(_newPrice < bondPrice[_bond]);
692         require(_newPrice >= initialPrice);
693 
694         totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[_bond],_newPrice));
695 
696         bondPreviousPrice[_bond] = SafeMath.div(SafeMath.mul(_newPrice,75),100);
697 
698         bondPrice[_bond] = _newPrice;
699 
700     }
701 
702  
703     
704     /*----------  HELPERS AND CALCULATORS  ----------*/
705     /**
706      * Method to view the current Ethereum stored in the contract
707      * Example: totalEthereumBalance()
708      */
709 
710  /**
711      * Retrieve the total token supply.
712      */
713     function totalSupply()
714         public
715         view
716         returns(uint256)
717     {
718         return tokenSupply_;
719     }
720 
721 
722     function getMyBalance()
723         public
724         view
725         returns(uint)
726     {
727         return ownerAccounts[msg.sender];
728     }
729 
730     function getOwnerBalance(address _bondOwner)
731         public
732         view
733         returns(uint)
734     {
735         require(msg.sender == dev);
736         return ownerAccounts[_bondOwner];
737     }
738     
739     function getBondPrice(uint _bond)
740         public
741         view
742         returns(uint)
743     {
744         require(_bond <= nextAvailableBond);
745         return bondPrice[_bond];
746     }
747 
748     function getBondOwner(uint _bond)
749         public
750         view
751         returns(address)
752     {
753         require(_bond <= nextAvailableBond);
754         return bondOwner[_bond];
755     }
756 
757     function gettotalBondDivs(uint _bond)
758         public
759         view
760         returns(uint)
761     {
762         require(_bond <= nextAvailableBond);
763         return totalBondDivs[_bond];
764     }
765 
766     function getTotalDivsProduced()
767         public
768         view
769         returns(uint)
770     {
771      
772         return totalDivsProduced;
773     }
774 
775     function getTotalBondValue()
776         public
777         view
778         returns(uint)
779     {
780       
781         return totalBondValue;
782     }
783 
784     function totalEthereumBalance()
785         public
786         view
787         returns(uint)
788     {
789         return address (this).balance;
790     }
791 
792     function getNextAvailableBond()
793         public
794         view
795         returns(uint)
796     {
797         return nextAvailableBond;
798     }
799 
800 }
801 
802 /**
803  * @title SafeMath
804  * @dev Math operations with safety checks that throw on error
805  */
806 library SafeMath {
807 
808     /**
809     * @dev Multiplies two numbers, throws on overflow.
810     */
811     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
812         if (a == 0) {
813             return 0;
814         }
815         uint256 c = a * b;
816         assert(c / a == b);
817         return c;
818     }
819 
820     /**
821     * @dev Integer division of two numbers, truncating the quotient.
822     */
823     function div(uint256 a, uint256 b) internal pure returns (uint256) {
824         // assert(b > 0); // Solidity automatically throws when dividing by 0
825         uint256 c = a / b;
826         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
827         return c;
828     }
829 
830     /**
831     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
832     */
833     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
834         assert(b <= a);
835         return a - b;
836     }
837 
838     /**
839     * @dev Adds two numbers, throws on overflow.
840     */
841     function add(uint256 a, uint256 b) internal pure returns (uint256) {
842         uint256 c = a + b;
843         assert(c >= a);
844         return c;
845     }
846 }