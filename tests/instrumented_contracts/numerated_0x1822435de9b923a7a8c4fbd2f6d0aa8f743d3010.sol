1 pragma solidity ^0.4.21;
2 
3 /*
4 
5 Wall Street Market presents........
6 
7   _      __     ____  ______              __    ___               __  
8  | | /| / /__ _/ / / / __/ /________ ___ / /_  / _ )___  ___  ___/ /__
9  | |/ |/ / _ `/ / / _\ \/ __/ __/ -_) -_) __/ / _  / _ \/ _ \/ _  (_-<
10  |__/|__/\_,_/_/_/ /___/\__/_/  \__/\__/\__/ /____/\___/_//_/\_,_/___/
11                                                                       
12                                                                                                     
13                                                                    
14 website:    https://wallstreetmarket.tk
15 
16 discord:    https://discord.gg/8AFP9gS
17 
18 
19 Wall Street Bonds is a game with earning opportunities avaliable for players actively engaged in the game.   Buy a bond and reap the rewards from other players as they buy in.
20 
21 Bonds also distribute 5% yield from buys and sell of the Stock Exchange which is also available on the Wall Street Market.
22 
23 The price of your bond automatically increases once you buy it.   You earn yield until someone else buys your bond.   Then you collect 50% of the gain.
24 
25 45% of the gain is distributed to the other bond owners.  5% goes to Wall Street Marketing.
26 
27 The yields are based on the relative price of your bond.  If your bond is priced higher than the average of the other bonds, you will get proportionally more
28 yield.  The current yield rate will be listed on your bond at any time along with the price.
29 
30 A bonus referral program is available.   Using your Masternode you will collect 5% of any net gains made during a purcchase by the user of your masternode.
31 
32 */
33 
34 contract BONDS {
35     /*=================================
36     =        MODIFIERS        =
37     =================================*/
38    
39 
40 
41     modifier onlyOwner(){
42         
43         require(msg.sender == dev);
44         _;
45     }
46     
47 
48     /*==============================
49     =            EVENTS            =
50     ==============================*/
51     event onBondPurchase(
52         address customerAddress,
53         uint256 incomingEthereum,
54         uint256 bond,
55         uint256 newPrice
56     );
57     
58     event onWithdraw(
59         address customerAddress,
60         uint256 ethereumWithdrawn
61     );
62     
63     // ERC20
64     event Transfer(
65         address from,
66         address to,
67         uint256 bond
68     );
69 
70     
71     /*=====================================
72     =            CONFIGURABLES            =
73     =====================================*/
74     string public name = "WALLSTREETBONDS";
75     string public symbol = "BOND";
76 
77     
78 
79     uint8 constant public referralRate = 5; 
80 
81     uint8 constant public decimals = 18;
82   
83     uint public totalBondValue = 8e18;
84 
85     
86    /*================================
87     =            DATASETS            =
88     ================================*/
89     
90     mapping(uint => address) internal bondOwner;
91     mapping(uint => uint) public bondPrice;
92     mapping(uint => uint) internal bondPreviousPrice;
93     mapping(address => uint) internal ownerAccounts;
94     mapping(uint => uint) internal totalBondDivs;
95     mapping(uint => string) internal bondName;
96 
97     uint bondPriceIncrement = 110;   //10% Price Increases
98     uint totalDivsProduced = 0;
99 
100     uint public maxBonds = 200;
101     
102     uint public initialPrice = 1e17;   //0.1 ETH
103 
104     uint public nextAvailableBond;
105 
106     bool allowReferral = false;
107 
108     bool allowAutoNewBond = false;
109 
110     uint8 public devDivRate = 5;
111     uint8 public ownerDivRate = 50;
112     uint8 public distDivRate = 45;
113 
114     uint public bondFund = 0;
115    
116     address dev;
117 
118     
119     
120 
121 
122     /*=======================================
123     =            PUBLIC FUNCTIONS            =
124     =======================================*/
125     /*
126     * -- APPLICATION ENTRY POINTS --  
127     */
128     function BONDS()
129         public
130     {
131         dev = msg.sender;
132         nextAvailableBond = 11;
133 
134         bondOwner[1] = dev;
135         bondPrice[1] = 2e18;//initialPrice;
136         bondPreviousPrice[1] = 0;
137 
138         bondOwner[2] = dev;
139         bondPrice[2] = 15e17;//initialPrice;
140         bondPreviousPrice[2] = 0;
141 
142         bondOwner[3] = dev;
143         bondPrice[3] = 10e17;//initialPrice;
144         bondPreviousPrice[3] = 0;
145 
146         bondOwner[4] = dev;
147         bondPrice[4] = 9e17;//initialPrice;
148         bondPreviousPrice[4] = 0;
149 
150         bondOwner[5] = dev;
151         bondPrice[5] = 8e17;//initialPrice;
152         bondPreviousPrice[5] = 0;
153 
154         bondOwner[6] = dev;
155         bondPrice[6] = 7e17;//initialPrice;
156         bondPreviousPrice[6] = 0;
157 
158         bondOwner[7] = dev;
159         bondPrice[7] = 5e17;//initialPrice;
160         bondPreviousPrice[7] = 0;
161 
162         bondOwner[8] = dev;
163         bondPrice[8] = 3e17;//initialPrice;
164         bondPreviousPrice[8] = 0;
165 
166         bondOwner[9] = dev;
167         bondPrice[9] = 2e17;//initialPrice;
168         bondPreviousPrice[9] = 0;
169 
170         bondOwner[10] = dev;
171         bondPrice[10] = 1e17;//initialPrice;
172         bondPreviousPrice[10] = 0;
173 
174     
175 
176 
177     }
178 
179     function addTotalBondValue(uint _new, uint _old)
180     internal
181     {
182         //uint newPrice = SafeMath.div(SafeMath.mul(_new,bondPriceIncrement),100);
183         totalBondValue = SafeMath.add(totalBondValue, SafeMath.sub(_new,_old));
184     }
185     
186     function buy(uint _bond, address _referrer)
187         public
188         payable
189 
190     {
191         require(_bond <= nextAvailableBond);
192         require(msg.value >= bondPrice[_bond]);
193         require(msg.sender != bondOwner[_bond]);
194 
195         
196   
197 
198         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100);
199 
200          //Determine the total dividends
201         uint _baseDividends = msg.value - bondPreviousPrice[_bond];
202         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
203 
204         uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
205         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
206 
207         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
208         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
209             
210         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
211 
212         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
213                 
214             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),100);
215             _distDividends = SafeMath.sub(_distDividends,_referralDividends);
216             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
217         }
218             
219 
220 
221         //distribute dividends to accounts
222         address _previousOwner = bondOwner[_bond];
223         address _newOwner = msg.sender;
224 
225         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
226         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],_devDividends);
227 
228         bondOwner[_bond] = _newOwner;
229 
230         distributeYield(_distDividends);
231         distributeBondFund();
232         //Increment the bond Price
233         bondPreviousPrice[_bond] = msg.value;
234         bondPrice[_bond] = _newPrice;
235         addTotalBondValue(_newPrice, bondPreviousPrice[_bond]);
236         
237        
238         emit onBondPurchase(msg.sender, msg.value, _bond, SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100));
239      
240     }
241 
242     function distributeYield(uint _distDividends) internal
243     
244     {
245         uint counter = 1;
246 
247         while (counter < nextAvailableBond) { 
248 
249             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
250             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
251             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
252             counter = counter + 1;
253         } 
254 
255     }
256     
257     function distributeBondFund() internal
258     
259     {
260         if(bondFund > 0){
261             uint counter = 1;
262 
263             while (counter < nextAvailableBond) { 
264 
265                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
266                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
267                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
268                 counter = counter + 1;
269             } 
270             bondFund = 0;
271         }
272     }
273 
274     function extDistributeBondFund() public
275     onlyOwner()
276     {
277         if(bondFund > 0){
278             uint counter = 1;
279 
280             while (counter < nextAvailableBond) { 
281 
282                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
283                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
284                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
285                 counter = counter + 1;
286             } 
287             bondFund = 0;
288         }
289     }
290 
291 
292     function withdraw()
293     
294         public
295     {
296         address _customerAddress = msg.sender;
297         require(ownerAccounts[_customerAddress] > 0);
298         uint _dividends = ownerAccounts[_customerAddress];
299         ownerAccounts[_customerAddress] = 0;
300         _customerAddress.transfer(_dividends);
301         // fire event
302         onWithdraw(_customerAddress, _dividends);
303     }
304 
305     function withdrawPart(uint _amount)
306     
307         public
308         onlyOwner()
309     {
310         address _customerAddress = msg.sender;
311         require(ownerAccounts[_customerAddress] > 0);
312         require(_amount <= ownerAccounts[_customerAddress]);
313         ownerAccounts[_customerAddress] = SafeMath.sub(ownerAccounts[_customerAddress],_amount);
314         _customerAddress.transfer(_amount);
315         // fire event
316         onWithdraw(_customerAddress, _amount);
317     }
318 
319 
320     
321 
322      // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange 
323      // and other contracts
324 
325     function()
326         payable
327         public
328     {
329         uint devAmount = SafeMath.div(SafeMath.mul(devDivRate,msg.value),100);
330         uint bondAmount = msg.value - devAmount;
331         bondFund = SafeMath.add(bondFund, bondAmount);
332         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], devAmount);
333     }
334     
335     /**
336      * Transfer bond to another address
337      */
338     function transfer(address _to, uint _bond )
339        
340         public
341     {
342         require(bondOwner[_bond] == msg.sender);
343 
344         bondOwner[_bond] = _to;
345 
346         emit Transfer(msg.sender, _to, _bond);
347 
348     }
349     
350     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
351     /**
352 
353     /**
354      * If we want to rebrand, we can.
355      */
356     function setName(string _name)
357         onlyOwner()
358         public
359     {
360         name = _name;
361     }
362     
363     /**
364      * If we want to rebrand, we can.
365      */
366     function setSymbol(string _symbol)
367         onlyOwner()
368         public
369     {
370         symbol = _symbol;
371     }
372 
373     function setInitialPrice(uint _price)
374         onlyOwner()
375         public
376     {
377         initialPrice = _price;
378     }
379 
380     function setMaxbonds(uint _bond)  
381         onlyOwner()
382         public
383     {
384         maxBonds = _bond;
385     }
386 
387     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it
388         onlyOwner()
389         public
390     {
391         require(bondOwner[_bond] == dev);
392         bondPrice[_bond] = _price;
393     }
394     
395     function addNewbond(uint _price) 
396         onlyOwner()
397         public
398     {
399         require(nextAvailableBond < maxBonds);
400         bondPrice[nextAvailableBond] = _price;
401         bondOwner[nextAvailableBond] = dev;
402         totalBondDivs[nextAvailableBond] = 0;
403         bondPreviousPrice[nextAvailableBond] = 0;
404         nextAvailableBond = nextAvailableBond + 1;
405         addTotalBondValue(_price, 0);
406         
407     }
408 
409     function setAllowReferral(bool _allowReferral)   
410         onlyOwner()
411         public
412     {
413         allowReferral = _allowReferral;
414     }
415 
416     function setAutoNewbond(bool _autoNewBond)   
417         onlyOwner()
418         public
419     {
420         allowAutoNewBond = _autoNewBond;
421     }
422 
423     function setRates(uint8 _newDistRate, uint8 _newDevRate,  uint8 _newOwnerRate)   
424         onlyOwner()
425         public
426     {
427         require((_newDistRate + _newDevRate + _newOwnerRate) == 100);
428         devDivRate = _newDevRate;
429         ownerDivRate = _newOwnerRate;
430         distDivRate = _newDistRate;
431     }
432 
433     function setLowerBondPrice(uint _bond, uint _newPrice)   //Allow a bond owner to lower the price if they want to dump it. They cannont raise the price
434     
435     {
436         require(bondOwner[_bond] == msg.sender);
437         require(_newPrice < bondPrice[_bond]);
438         require(_newPrice >= initialPrice);
439 
440         totalBondValue = SafeMath.sub(totalBondValue,SafeMath.sub(bondPrice[_bond],_newPrice));
441 
442         bondPrice[_bond] = _newPrice;
443 
444     }
445 
446 
447     
448     /*----------  HELPERS AND CALCULATORS  ----------*/
449     /**
450      * Method to view the current Ethereum stored in the contract
451      * Example: totalEthereumBalance()
452      */
453 
454 
455     function getMyBalance()
456         public
457         view
458         returns(uint)
459     {
460         return ownerAccounts[msg.sender];
461     }
462 
463     function getOwnerBalance(address _bondOwner)
464         public
465         view
466         returns(uint)
467     {
468         require(msg.sender == dev);
469         return ownerAccounts[_bondOwner];
470     }
471     
472     function getBondPrice(uint _bond)
473         public
474         view
475         returns(uint)
476     {
477         require(_bond <= nextAvailableBond);
478         return bondPrice[_bond];
479     }
480 
481     function getBondOwner(uint _bond)
482         public
483         view
484         returns(address)
485     {
486         require(_bond <= nextAvailableBond);
487         return bondOwner[_bond];
488     }
489 
490     function gettotalBondDivs(uint _bond)
491         public
492         view
493         returns(uint)
494     {
495         require(_bond <= nextAvailableBond);
496         return totalBondDivs[_bond];
497     }
498 
499     function getTotalDivsProduced()
500         public
501         view
502         returns(uint)
503     {
504      
505         return totalDivsProduced;
506     }
507 
508     function getTotalBondValue()
509         public
510         view
511         returns(uint)
512     {
513       
514         return totalBondValue;
515     }
516 
517     function totalEthereumBalance()
518         public
519         view
520         returns(uint)
521     {
522         return address (this).balance;
523     }
524 
525     function getNextAvailableBond()
526         public
527         view
528         returns(uint)
529     {
530         return nextAvailableBond;
531     }
532 
533 }
534 
535 /**
536  * @title SafeMath
537  * @dev Math operations with safety checks that throw on error
538  */
539 library SafeMath {
540 
541     /**
542     * @dev Multiplies two numbers, throws on overflow.
543     */
544     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
545         if (a == 0) {
546             return 0;
547         }
548         uint256 c = a * b;
549         assert(c / a == b);
550         return c;
551     }
552 
553     /**
554     * @dev Integer division of two numbers, truncating the quotient.
555     */
556     function div(uint256 a, uint256 b) internal pure returns (uint256) {
557         // assert(b > 0); // Solidity automatically throws when dividing by 0
558         uint256 c = a / b;
559         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
560         return c;
561     }
562 
563     /**
564     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
565     */
566     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
567         assert(b <= a);
568         return a - b;
569     }
570 
571     /**
572     * @dev Adds two numbers, throws on overflow.
573     */
574     function add(uint256 a, uint256 b) internal pure returns (uint256) {
575         uint256 c = a + b;
576         assert(c >= a);
577         return c;
578     }
579 }