1 pragma solidity ^0.4.23;
2 
3 /**
4 
5   https://zethr.io  https://zethr.io  https://zethr.io  https://zethr.io  https://zethr.io
6 
7 
8                           ███████╗███████╗████████╗██╗  ██╗██████╗
9                           ╚══███╔╝██╔════╝╚══██╔══╝██║  ██║██╔══██╗
10                             ███╔╝ █████╗     ██║   ███████║██████╔╝
11                            ███╔╝  ██╔══╝     ██║   ██╔══██║██╔══██╗
12                           ███████╗███████╗   ██║   ██║  ██║██║  ██║
13                           ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
14 
15 
16 .------..------.     .------..------..------.     .------..------..------..------..------.
17 |B.--. ||E.--. |.-.  |T.--. ||H.--. ||E.--. |.-.  |H.--. ||O.--. ||U.--. ||S.--. ||E.--. |
18 | :(): || (\/) (( )) | :/\: || :/\: || (\/) (( )) | :/\: || :/\: || (\/) || :/\: || (\/) |
19 | ()() || :\/: |'-.-.| (__) || (__) || :\/: |'-.-.| (__) || :\/: || :\/: || :\/: || :\/: |
20 | '--'B|| '--'E| (( )) '--'T|| '--'H|| '--'E| (( )) '--'H|| '--'O|| '--'U|| '--'S|| '--'E|
21 `------'`------'  '-'`------'`------'`------'  '-'`------'`------'`------'`------'`------'
22 
23 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
24 
25 Credits
26 =======
27 
28 Analysis:
29     blurr
30     Randall
31 
32 Contract Developers:
33     Etherguy
34     klob
35     Norsefire
36 
37 Front-End Design:
38     cryptodude
39     oguzhanox
40     TropicalRogue
41 
42 **/
43 
44 contract Zethr {
45   using SafeMath for uint;
46 
47   /*=================================
48   =            MODIFIERS            =
49   =================================*/
50 
51   modifier onlyHolders() {
52     require(myFrontEndTokens() > 0);
53     _;
54   }
55 
56   modifier dividendHolder() {
57     require(myDividends(true) > 0);
58     _;
59   }
60 
61   modifier onlyAdministrator(){
62     address _customerAddress = msg.sender;
63     require(administrators[_customerAddress]);
64     _;
65   }
66 
67   /*==============================
68   =            EVENTS            =
69   ==============================*/
70 
71   event onTokenPurchase(
72     address indexed customerAddress,
73     uint incomingEthereum,
74     uint tokensMinted,
75     address indexed referredBy
76   );
77 
78   event UserDividendRate(
79     address user,
80     uint divRate
81   );
82 
83   event onTokenSell(
84     address indexed customerAddress,
85     uint tokensBurned,
86     uint ethereumEarned
87   );
88 
89   event onReinvestment(
90     address indexed customerAddress,
91     uint ethereumReinvested,
92     uint tokensMinted
93   );
94 
95   event onWithdraw(
96     address indexed customerAddress,
97     uint ethereumWithdrawn
98   );
99 
100   event Transfer(
101     address indexed from,
102     address indexed to,
103     uint tokens
104   );
105 
106   event Approval(
107     address indexed tokenOwner,
108     address indexed spender,
109     uint tokens
110   );
111 
112   event Allocation(
113     uint toBankRoll,
114     uint toReferrer,
115     uint toTokenHolders,
116     uint toDivCardHolders,
117     uint forTokens
118   );
119 
120   event Referral(
121     address referrer,
122     uint amountReceived
123   );
124 
125   /*=====================================
126   =            CONSTANTS                =
127   =====================================*/
128 
129   uint8 constant public                decimals              = 18;
130 
131   uint constant internal               tokenPriceInitial_    = 0.000653 ether;
132   uint constant internal               magnitude             = 2**64;
133 
134   uint constant internal               icoHardCap            = 250 ether;
135   uint constant internal               addressICOLimit       = 1   ether;
136   uint constant internal               icoMinBuyIn           = 0.1 finney;
137   uint constant internal               icoMaxGasPrice        = 50000000000 wei;
138 
139   uint constant internal               MULTIPLIER            = 9615;
140 
141   uint constant internal               MIN_ETH_BUYIN         = 0.0001 ether;
142   uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
143   uint constant internal               MIN_TOKEN_TRANSFER    = 1e10;
144   uint constant internal               referrer_percentage   = 25;
145 
146   uint public                          stakingRequirement    = 100e18;
147 
148   /*================================
149    =          CONFIGURABLES         =
150    ================================*/
151 
152   string public                        name               = "Zethr";
153   string public                        symbol             = "ZTH";
154 
155   bytes32 constant public              icoHashedPass      = bytes32(0x5ddcde33b94b19bdef79dd9ea75be591942b9ec78286d64b44a356280fb6a262);
156 
157   address internal                     bankrollAddress;
158 
159   ZethrDividendCards                   divCardContract;
160 
161   /*================================
162    =            DATASETS            =
163    ================================*/
164 
165   // Tracks front & backend tokens
166   mapping(address => uint) internal    frontTokenBalanceLedger_;
167   mapping(address => uint) internal    dividendTokenBalanceLedger_;
168   mapping(address =>
169   mapping (address => uint))
170   public      allowed;
171 
172   // Tracks dividend rates for users
173   mapping(uint8   => bool)    internal validDividendRates_;
174   mapping(address => bool)    internal userSelectedRate;
175   mapping(address => uint8)   internal userDividendRate;
176 
177   // Payout tracking
178   mapping(address => uint)    internal referralBalance_;
179   mapping(address => int256)  internal payoutsTo_;
180 
181   // ICO per-address limit tracking
182   mapping(address => uint)    internal ICOBuyIn;
183 
184   uint public                          tokensMintedDuringICO;
185   uint public                          ethInvestedDuringICO;
186 
187   uint public                          currentEthInvested;
188 
189   uint internal                        tokenSupply    = 0;
190   uint internal                        divTokenSupply = 0;
191 
192   uint internal                        profitPerDivToken;
193 
194   mapping(address => bool) public      administrators;
195 
196   bool public                          icoPhase     = false;
197   bool public                          regularPhase = false;
198 
199   uint                                 icoOpenTime;
200 
201   /*=======================================
202   =            PUBLIC FUNCTIONS           =
203   =======================================*/
204   constructor (address _bankrollAddress, address _divCardAddress)
205   public
206   {
207     bankrollAddress = _bankrollAddress;
208     divCardContract = ZethrDividendCards(_divCardAddress);
209 
210     administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
211     administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
212     administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
213     administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
214     administrators[0x8537aa2911b193e5B377938A723D805bb0865670] = true; // oguzhanox
215     administrators[0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3] = true; // Randall
216     administrators[0xDa83156106c4dba7A26E9bF2Ca91E273350aa551] = true; // TropicalRogue
217     administrators[0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696] = true; // cryptodude
218 
219     administrators[msg.sender] = true; // Helps with debugging!
220 
221     validDividendRates_[2] = true;
222     validDividendRates_[5] = true;
223     validDividendRates_[10] = true;
224     validDividendRates_[15] = true;
225     validDividendRates_[20] = true;
226     validDividendRates_[25] = true;
227     validDividendRates_[33] = true;
228 
229     userSelectedRate[bankrollAddress] = true;
230     userDividendRate[bankrollAddress] = 33;
231 
232   }
233 
234   /**
235    * Same as buy, but explicitly sets your dividend percentage.
236    * If this has been called before, it will update your `default' dividend
237    *   percentage for regular buy transactions going forward.
238    */
239   function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass)
240   public
241   payable
242   returns (uint)
243   {
244     require(icoPhase || regularPhase);
245 
246     if (icoPhase) {
247  
248       // Anti-bot measures - not perfect, but should help some.
249       bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
250       require(hashedProvidedPass == icoHashedPass || msg.sender == bankrollAddress);
251 
252       uint gasPrice = tx.gasprice;
253 
254       // Prevents ICO buyers from getting substantially burned if the ICO is reached
255       //   before their transaction is processed.
256       require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
257 
258     }
259 
260     // Dividend percentage should be a currently accepted value.
261     require (validDividendRates_[_divChoice]);
262 
263     // Set the dividend fee percentage denominator.
264     userSelectedRate[msg.sender] = true;
265     userDividendRate[msg.sender] = _divChoice;
266     emit UserDividendRate(msg.sender, _divChoice);
267 
268     // Finally, purchase tokens.
269     purchaseTokens(msg.value, _referredBy);
270   }
271 
272   // All buys except for the above one require regular phase.
273 
274   function buy(address _referredBy)
275   public
276   payable
277   returns(uint)
278   {
279     require(regularPhase);
280     address _customerAddress = msg.sender;
281     require (userSelectedRate[_customerAddress]);
282     purchaseTokens(msg.value, _referredBy);
283   }
284 
285   function buyAndTransfer(address _referredBy, address target)
286   public
287   payable
288   {
289     bytes memory empty;
290     buyAndTransfer(_referredBy,target, empty, 20);
291   }
292 
293   function buyAndTransfer(address _referredBy, address target, bytes _data)
294   public
295   payable
296   {
297     buyAndTransfer(_referredBy, target, _data, 20);
298   }
299 
300   // Overload
301   function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
302   public
303   payable
304   {
305     require(regularPhase);
306     address _customerAddress = msg.sender;
307     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
308     if (userSelectedRate[_customerAddress] && divChoice == 0) {
309       purchaseTokens(msg.value, _referredBy);
310     } else {
311       buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
312     }
313     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
314     transferTo(msg.sender, target, difference, _data);
315   }
316 
317   // Fallback function only works during regular phase - part of anti-bot protection.
318   function()
319   payable
320   public
321   {
322     /**
323     / If the user has previously set a dividend rate, sending
324     /   Ether directly to the contract simply purchases more at
325     /   the most recent rate. If this is their first time, they
326     /   are automatically placed into the 20% rate `bucket'.
327     **/
328     require(regularPhase);
329     address _customerAddress = msg.sender;
330     if (userSelectedRate[_customerAddress]) {
331       purchaseTokens(msg.value, 0x0);
332     } else {
333       buyAndSetDivPercentage(0x0, 20, "0x0");
334     }
335   }
336 
337   function reinvest()
338   dividendHolder()
339   public
340   {
341     require(regularPhase);
342     uint _dividends = myDividends(false);
343 
344     // Pay out requisite `virtual' dividends.
345     address _customerAddress            = msg.sender;
346     payoutsTo_[_customerAddress]       += (int256) (_dividends * magnitude);
347 
348     _dividends                         += referralBalance_[_customerAddress];
349     referralBalance_[_customerAddress]  = 0;
350 
351     uint _tokens                        = purchaseTokens(_dividends, 0x0);
352 
353     // Fire logging event.
354     emit onReinvestment(_customerAddress, _dividends, _tokens);
355   }
356 
357   function exit()
358   public
359   {
360     require(regularPhase);
361     // Retrieve token balance for caller, then sell them all.
362     address _customerAddress = msg.sender;
363     uint _tokens             = frontTokenBalanceLedger_[_customerAddress];
364 
365     if(_tokens > 0) sell(_tokens);
366 
367     withdraw(_customerAddress);
368   }
369 
370   function withdraw(address _recipient)
371   dividendHolder()
372   public
373   {
374     require(regularPhase);
375     // Setup data
376     address _customerAddress           = msg.sender;
377     uint _dividends                    = myDividends(false);
378 
379     // update dividend tracker
380     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
381 
382     // add ref. bonus
383     _dividends                         += referralBalance_[_customerAddress];
384     referralBalance_[_customerAddress]  = 0;
385 
386     if (_recipient == address(0x0)){
387       _recipient = msg.sender;
388     }
389     _recipient.transfer(_dividends);
390 
391     // Fire logging event.
392     emit onWithdraw(_recipient, _dividends);
393   }
394 
395   // Sells front-end tokens.
396   // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
397   function sell(uint _amountOfTokens)
398   onlyHolders()
399   public
400   {
401     // No selling during the ICO. You don't get to flip that fast, sorry!
402     require(!icoPhase);
403     require(regularPhase);
404 
405     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
406 
407     uint _frontEndTokensToBurn = _amountOfTokens;
408 
409     // Calculate how many dividend tokens this action burns.
410     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
411     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
412     uint userDivRate  = getUserAverageDividendRate(msg.sender);
413     require ((2*magnitude) <= userDivRate && (50*magnitude) >= userDivRate );
414     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
415 
416     // Calculate ethereum received before dividends
417     uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
418 
419     if (_ethereum > currentEthInvested){
420       // Well, congratulations, you've emptied the coffers.
421       currentEthInvested = 0;
422     } else { currentEthInvested = currentEthInvested - _ethereum; }
423 
424     // Calculate dividends generated from the sale.
425     uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
426 
427     // Calculate Ethereum receivable net of dividends.
428     uint _taxedEthereum = _ethereum.sub(_dividends);
429 
430     // Burn the sold tokens (both front-end and back-end variants).
431     tokenSupply         = tokenSupply.sub(_frontEndTokensToBurn);
432     divTokenSupply      = divTokenSupply.sub(_divTokensToBurn);
433 
434     // Subtract the token balances for the seller
435     frontTokenBalanceLedger_[msg.sender]    = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
436     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
437 
438     // Update dividends tracker
439     int256 _updatedPayouts  = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
440     payoutsTo_[msg.sender] -= _updatedPayouts;
441 
442     // Let's avoid breaking arithmetic where we can, eh?
443     if (divTokenSupply > 0) {
444       // Update the value of each remaining back-end dividend token.
445       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
446     }
447 
448     // Fire logging event.
449     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
450   }
451 
452   /**
453    * Transfer tokens from the caller to a new holder.
454    * No charge incurred for the transfer. We'd make a terrible bank.
455    */
456   function transfer(address _toAddress, uint _amountOfTokens)
457   onlyHolders()
458   public
459   returns(bool)
460   {
461     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
462     && _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
463     bytes memory empty;
464     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
465     return true;
466 
467   }
468 
469   function approve(address spender, uint tokens)
470   public
471   returns (bool)
472   {
473     address _customerAddress           = msg.sender;
474     allowed[_customerAddress][spender] = tokens;
475 
476     // Fire logging event.
477     emit Approval(_customerAddress, spender, tokens);
478 
479     // Good old ERC20.
480     return true;
481   }
482 
483   /**
484    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
485    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
486    */
487   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
488   public
489   returns(bool)
490   {
491     // Setup variables
492     address _customerAddress     = _from;
493     bytes memory empty;
494     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
495     // and are transferring at least one full token.
496     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
497     && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
498     && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
499 
500     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
501 
502     // Good old ERC20.
503     return true;
504 
505   }
506 
507   function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data)
508   public
509   {
510     if (_from != msg.sender){
511       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
512       && _amountOfTokens <= frontTokenBalanceLedger_[_from]
513       && _amountOfTokens <= allowed[_from][msg.sender]);
514     }
515     else{
516       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
517       && _amountOfTokens <= frontTokenBalanceLedger_[_from]);
518     }
519 
520     transferFromInternal(_from, _to, _amountOfTokens, _data);
521   }
522 
523   // Who'd have thought we'd need this thing floating around?
524   function totalSupply()
525   public
526   view
527   returns (uint256)
528   {
529     return tokenSupply;
530   }
531 
532   // Anyone can start the regular phase 2 weeks after the ICO phase starts.
533   // In case the devs die. Or something.
534   function publicStartRegularPhase()
535   public
536   {
537     require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
538 
539     icoPhase     = false;
540     regularPhase = true;
541   }
542 
543   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
544 
545 
546   // Fire the starting gun and then duck for cover.
547   function startICOPhase()
548   onlyAdministrator()
549   public
550   {
551     // Prevent us from startaring the ICO phase again
552     require(icoOpenTime == 0);
553     icoPhase = true;
554     icoOpenTime = now;
555   }
556 
557   // Fire the ... ending gun?
558   function endICOPhase()
559   onlyAdministrator()
560   public
561   {
562     icoPhase = false;
563   }
564 
565   function startRegularPhase()
566   onlyAdministrator
567   public
568   {
569     // disable ico phase in case if that was not disabled yet
570     icoPhase = false;
571     regularPhase = true;
572   }
573 
574   // The death of a great man demands the birth of a great son.
575   function setAdministrator(address _newAdmin, bool _status)
576   onlyAdministrator()
577   public
578   {
579     administrators[_newAdmin] = _status;
580   }
581 
582   function setStakingRequirement(uint _amountOfTokens)
583   onlyAdministrator()
584   public
585   {
586     // This plane only goes one way, lads. Never below the initial.
587     require (_amountOfTokens >= 100e18);
588     stakingRequirement = _amountOfTokens;
589   }
590 
591   function setName(string _name)
592   onlyAdministrator()
593   public
594   {
595     name = _name;
596   }
597 
598   function setSymbol(string _symbol)
599   onlyAdministrator()
600   public
601   {
602     symbol = _symbol;
603   }
604 
605   function changeBankroll(address _newBankrollAddress)
606   onlyAdministrator
607   public
608   {
609     bankrollAddress = _newBankrollAddress;
610   }
611 
612   /*----------  HELPERS AND CALCULATORS  ----------*/
613 
614   function totalEthereumBalance()
615   public
616   view
617   returns(uint)
618   {
619     return address(this).balance;
620   }
621 
622   function totalEthereumICOReceived()
623   public
624   view
625   returns(uint)
626   {
627     return ethInvestedDuringICO;
628   }
629 
630   /**
631    * Retrieves your currently selected dividend rate.
632    */
633   function getMyDividendRate()
634   public
635   view
636   returns(uint8)
637   {
638     address _customerAddress = msg.sender;
639     require(userSelectedRate[_customerAddress]);
640     return userDividendRate[_customerAddress];
641   }
642 
643   /**
644    * Retrieve the total frontend token supply
645    */
646   function getFrontEndTokenSupply()
647   public
648   view
649   returns(uint)
650   {
651     return tokenSupply;
652   }
653 
654   /**
655    * Retreive the total dividend token supply
656    */
657   function getDividendTokenSupply()
658   public
659   view
660   returns(uint)
661   {
662     return divTokenSupply;
663   }
664 
665   /**
666    * Retrieve the frontend tokens owned by the caller
667    */
668   function myFrontEndTokens()
669   public
670   view
671   returns(uint)
672   {
673     address _customerAddress = msg.sender;
674     return getFrontEndTokenBalanceOf(_customerAddress);
675   }
676 
677   /**
678    * Retrieve the dividend tokens owned by the caller
679    */
680   function myDividendTokens()
681   public
682   view
683   returns(uint)
684   {
685     address _customerAddress = msg.sender;
686     return getDividendTokenBalanceOf(_customerAddress);
687   }
688 
689   function myReferralDividends()
690   public
691   view
692   returns(uint)
693   {
694     return myDividends(true) - myDividends(false);
695   }
696 
697   function myDividends(bool _includeReferralBonus)
698   public
699   view
700   returns(uint)
701   {
702     address _customerAddress = msg.sender;
703     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
704   }
705 
706   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
707   public
708   view
709   returns(uint)
710   {
711     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
712   }
713 
714   function getFrontEndTokenBalanceOf(address _customerAddress)
715   view
716   public
717   returns(uint)
718   {
719     return frontTokenBalanceLedger_[_customerAddress];
720   }
721 
722   function balanceOf(address _owner)
723   view
724   public
725   returns(uint)
726   {
727     return getFrontEndTokenBalanceOf(_owner);
728   }
729 
730   function getDividendTokenBalanceOf(address _customerAddress)
731   view
732   public
733   returns(uint)
734   {
735     return dividendTokenBalanceLedger_[_customerAddress];
736   }
737 
738   function dividendsOf(address _customerAddress)
739   view
740   public
741   returns(uint)
742   {
743     return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
744   }
745 
746   // Get the sell price at the user's average dividend rate
747   function sellPrice()
748   public
749   view
750   returns(uint)
751   {
752     uint price;
753 
754     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
755       price = tokenPriceInitial_;
756     } else {
757 
758       // Calculate the tokens received for 100 finney.
759       // Divide to find the average, to calculate the price.
760       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
761 
762       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
763     }
764 
765     // Factor in the user's average dividend rate
766     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
767 
768     return theSellPrice;
769   }
770 
771   // Get the buy price at a particular dividend rate
772   function buyPrice(uint dividendRate)
773   public
774   view
775   returns(uint)
776   {
777     uint price;
778 
779     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
780       price = tokenPriceInitial_;
781     } else {
782 
783       // Calculate the tokens received for 100 finney.
784       // Divide to find the average, to calculate the price.
785       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
786 
787       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
788     }
789 
790     // Factor in the user's selected dividend rate
791     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
792 
793     return theBuyPrice;
794   }
795 
796   function calculateTokensReceived(uint _ethereumToSpend)
797   public
798   view
799   returns(uint)
800   {
801     uint _dividends      = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
802     uint _taxedEthereum  = _ethereumToSpend.sub(_dividends);
803     uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
804     return  _amountOfTokens;
805   }
806 
807   // When selling tokens, we need to calculate the user's current dividend rate.
808   // This is different from their selected dividend rate.
809   function calculateEthereumReceived(uint _tokensToSell)
810   public
811   view
812   returns(uint)
813   {
814     require(_tokensToSell <= tokenSupply);
815     uint _ethereum               = tokensToEthereum_(_tokensToSell);
816     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
817     uint _dividends              = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
818     uint _taxedEthereum          = _ethereum.sub(_dividends);
819     return  _taxedEthereum;
820   }
821 
822   /*
823    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
824    * We multiply by magnitude to avoid precision errors.
825    */
826 
827   function getUserAverageDividendRate(address user) public view returns (uint) {
828     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
829   }
830 
831   function getMyAverageDividendRate() public view returns (uint) {
832     return getUserAverageDividendRate(msg.sender);
833   }
834 
835   /*==========================================
836   =            INTERNAL FUNCTIONS            =
837   ==========================================*/
838 
839   /* Purchase tokens with Ether.
840      During ICO phase, dividends should go to the bankroll
841      During normal operation:
842        0.5% should go to the master dividend card
843        0.5% should go to the matching dividend card
844        25% of dividends should go to the referrer, if any is provided. */
845   function purchaseTokens(uint _incomingEthereum, address _referredBy)
846   internal
847   returns(uint)
848   {
849     require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
850 
851     uint toBankRoll;
852     uint toReferrer;
853     uint toTokenHolders;
854     uint toDivCardHolders;
855 
856     uint dividendAmount;
857 
858     uint tokensBought;
859     uint dividendTokensBought;
860 
861     uint remainingEth = _incomingEthereum;
862 
863     uint fee;
864 
865     // 1% for dividend card holders is taken off before anything else
866     if (regularPhase) {
867       toDivCardHolders = _incomingEthereum.div(100);
868       remainingEth = remainingEth.sub(toDivCardHolders);
869     }
870 
871     /* Next, we tax for dividends:
872        Dividends = (ethereum * div%) / 100
873        Important note: if we're out of the ICO phase, the 1% sent to div-card holders
874                        is handled prior to any dividend taxes are considered. */
875 
876     // Grab the user's dividend rate
877     uint dividendRate = userDividendRate[msg.sender];
878 
879     // Calculate the total dividends on this buy
880     dividendAmount = (remainingEth.mul(dividendRate)).div(100);
881 
882     remainingEth   = remainingEth.sub(dividendAmount);
883 
884     // If we're in the ICO and bankroll is buying, don't tax
885     if (icoPhase && msg.sender == bankrollAddress) {
886       remainingEth = remainingEth + dividendAmount;
887     }
888 
889     // Calculate how many tokens to buy:
890     tokensBought         = ethereumToTokens_(remainingEth);
891     dividendTokensBought = tokensBought.mul(dividendRate);
892 
893     // This is where we actually mint tokens:
894     tokenSupply    = tokenSupply.add(tokensBought);
895     divTokenSupply = divTokenSupply.add(dividendTokensBought);
896 
897     /* Update the total investment tracker
898        Note that this must be done AFTER we calculate how many tokens are bought -
899        because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
900 
901     currentEthInvested = currentEthInvested + remainingEth;
902 
903     // If ICO phase, all the dividends go to the bankroll
904     if (icoPhase) {
905       toBankRoll     = dividendAmount;
906 
907       // If the bankroll is buying, we don't want to send eth back to the bankroll
908       // Instead, let's just give it the tokens it would get in an infinite recursive buy
909       if (msg.sender == bankrollAddress) {
910         toBankRoll = 0;
911       }
912 
913       toReferrer     = 0;
914       toTokenHolders = 0;
915 
916       /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
917          not how much Ether we get total.
918          this is so that our calculation using "investment" is accurate. */
919       ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
920       tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
921 
922       // Cannot purchase more than the hard cap during ICO.
923       require(ethInvestedDuringICO <= icoHardCap);
924       // Contracts aren't allowed to participate in the ICO.
925       require(tx.origin == msg.sender || msg.sender == bankrollAddress);
926 
927       // Cannot purchase more then the limit per address during the ICO.
928       ICOBuyIn[msg.sender] += remainingEth;
929       require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress);
930 
931       // Stop the ICO phase if we reach the hard cap
932       if (ethInvestedDuringICO == icoHardCap){
933         icoPhase = false;
934       }
935 
936     } else {
937       // Not ICO phase, check for referrals
938 
939       // 25% goes to referrers, if set
940       // toReferrer = (dividends * 25)/100
941       if (_referredBy != 0x0000000000000000000000000000000000000000 &&
942       _referredBy != msg.sender &&
943       frontTokenBalanceLedger_[_referredBy] >= stakingRequirement)
944       {
945         toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
946         referralBalance_[_referredBy] += toReferrer;
947         emit Referral(_referredBy, toReferrer);
948       }
949 
950       // The rest of the dividends go to token holders
951       toTokenHolders = dividendAmount.sub(toReferrer);
952 
953       fee = toTokenHolders * magnitude;
954       fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
955 
956       // Finally, increase the divToken value
957       profitPerDivToken       = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
958       payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
959     }
960 
961     // Update the buyer's token amounts
962     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
963     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
964 
965     // Transfer to bankroll and div cards
966     if (toBankRoll != 0) { ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)(); }
967     if (regularPhase) { divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate); }
968 
969     // This event should help us track where all the eth is going
970     emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
971 
972     // Sanity checking
973     uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth - _incomingEthereum;
974     assert(sum == 0);
975   }
976 
977   // How many tokens one gets from a certain amount of ethereum.
978   function ethereumToTokens_(uint _ethereumAmount)
979   public
980   view
981   returns(uint)
982   {
983     require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
984 
985     if (icoPhase) {
986       return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
987     }
988 
989     /*
990      *  i = investment, p = price, t = number of tokens
991      *
992      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
993      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
994      *
995      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
996      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
997      */
998 
999     // First, separate out the buy into two segments:
1000     //  1) the amount of eth going towards ico-price tokens
1001     //  2) the amount of eth going towards pyramid-price (variable) tokens
1002     uint ethTowardsICOPriceTokens = 0;
1003     uint ethTowardsVariablePriceTokens = 0;
1004 
1005     if (currentEthInvested >= ethInvestedDuringICO) {
1006       // Option One: All the ETH goes towards variable-price tokens
1007       ethTowardsVariablePriceTokens = _ethereumAmount;
1008 
1009     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
1010       // Option Two: All the ETH goes towards ICO-price tokens
1011       ethTowardsICOPriceTokens = _ethereumAmount;
1012 
1013     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
1014       // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
1015       ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
1016       ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
1017     } else {
1018       // Option Four: Should be impossible, and compiler should optimize it out of existence.
1019       revert();
1020     }
1021 
1022     // Sanity check:
1023     assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
1024 
1025     // Separate out the number of tokens of each type this will buy:
1026     uint icoPriceTokens = 0;
1027     uint varPriceTokens = 0;
1028 
1029     // Now calculate each one per the above formulas.
1030     // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
1031     if (ethTowardsICOPriceTokens != 0) {
1032       icoPriceTokens = ethTowardsICOPriceTokens.mul(1e18).div(tokenPriceInitial_);
1033     }
1034 
1035     if (ethTowardsVariablePriceTokens != 0) {
1036       // Note: we can't use "currentEthInvested" for this calculation, we must use:
1037       //  currentEthInvested + ethTowardsICOPriceTokens
1038       // This is because a split-buy essentially needs to simulate two separate buys -
1039       // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
1040 
1041       uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
1042       uint simulatedEthAfterInvested  = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
1043 
1044       /* We have the equations for total tokens above; note that this is for TOTAL.
1045          To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
1046          and the simulatedEthInvestedAfter and calculate the difference in tokens.
1047          This is how many we get. */
1048 
1049       uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
1050       uint tokensAfter  = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
1051 
1052       /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
1053          either should work.
1054 
1055          Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
1056          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
1057 
1058       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
1059     }
1060 
1061     uint totalTokensReceived = icoPriceTokens + varPriceTokens;
1062 
1063     assert(totalTokensReceived > 0);
1064     return totalTokensReceived;
1065   }
1066 
1067   // How much Ether we get from selling N tokens
1068   function tokensToEthereum_(uint _tokens)
1069   public
1070   view
1071   returns(uint)
1072   {
1073     require (_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
1074 
1075     /*
1076      *  i = investment, p = price, t = number of tokens
1077      *
1078      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1079      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1080      *
1081      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1082      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1083      */
1084 
1085     // First, separate out the sell into two segments:
1086     //  1) the amount of tokens selling at the ICO price.
1087     //  2) the amount of tokens selling at the variable (pyramid) price
1088     uint tokensToSellAtICOPrice = 0;
1089     uint tokensToSellAtVariablePrice = 0;
1090 
1091     if (tokenSupply <= tokensMintedDuringICO) {
1092       // Option One: All the tokens sell at the ICO price.
1093       tokensToSellAtICOPrice = _tokens;
1094 
1095     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
1096       // Option Two: All the tokens sell at the variable price.
1097       tokensToSellAtVariablePrice = _tokens;
1098 
1099     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
1100       // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
1101       tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
1102       tokensToSellAtICOPrice      = _tokens.sub(tokensToSellAtVariablePrice);
1103 
1104     } else {
1105       // Option Four: Should be impossible, and the compiler should optimize it out of existence.
1106       revert();
1107     }
1108 
1109     // Sanity check:
1110     assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
1111 
1112     // Track how much Ether we get from selling at each price function:
1113     uint ethFromICOPriceTokens;
1114     uint ethFromVarPriceTokens;
1115 
1116     // Now, actually calculate:
1117 
1118     if (tokensToSellAtICOPrice != 0) {
1119 
1120       /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
1121          we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
1122          We need to divide by 1e18 or we'll have too much Ether. */
1123 
1124       ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
1125     }
1126 
1127     if (tokensToSellAtVariablePrice != 0) {
1128 
1129       /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
1130          This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
1131          Thus there isn't any weird stuff going on with the token supply.
1132 
1133          We have the equations for total investment above; note that this is for TOTAL.
1134          To get the eth received from this sell, we calculate the new total investment after this sell.
1135          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
1136 
1137       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
1138       uint investmentAfter  = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
1139 
1140       ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
1141     }
1142 
1143     uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
1144 
1145     assert(totalEthReceived > 0);
1146     return totalEthReceived;
1147   }
1148 
1149   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
1150   internal
1151   {
1152     require(regularPhase);
1153     require(_toAddress != address(0x0));
1154     address _customerAddress     = _from;
1155     uint _amountOfFrontEndTokens = _amountOfTokens;
1156 
1157     // Withdraw all outstanding dividends first (including those generated from referrals).
1158     if(theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
1159 
1160     // Calculate how many back-end dividend tokens to transfer.
1161     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
1162     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
1163 
1164     if (_customerAddress != msg.sender){
1165       // Update the allowed balance.
1166       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
1167       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
1168     }
1169 
1170     // Exchange tokens
1171     frontTokenBalanceLedger_[_customerAddress]    = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
1172     frontTokenBalanceLedger_[_toAddress]          = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
1173     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
1174     dividendTokenBalanceLedger_[_toAddress]       = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
1175 
1176     // Recipient inherits dividend percentage if they have not already selected one.
1177     if(!userSelectedRate[_toAddress])
1178     {
1179       userSelectedRate[_toAddress] = true;
1180       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
1181     }
1182 
1183     // Update dividend trackers
1184     payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
1185     payoutsTo_[_toAddress]       += (int256) (profitPerDivToken * _amountOfDivTokens);
1186 
1187     uint length;
1188 
1189     assembly {
1190       length := extcodesize(_toAddress)
1191     }
1192 
1193     if (length > 0){
1194       // its a contract
1195       // note: at ethereum update ALL addresses are contracts
1196       ERC223Receiving receiver = ERC223Receiving(_toAddress);
1197       receiver.tokenFallback(_from, _amountOfTokens, _data);
1198     }
1199 
1200     // Fire logging event.
1201     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
1202   }
1203 
1204   // Called from transferFrom. Always checks if _customerAddress has dividends.
1205   function withdrawFrom(address _customerAddress)
1206   internal
1207   {
1208     // Setup data
1209     uint _dividends                    = theDividendsOf(false, _customerAddress);
1210 
1211     // update dividend tracker
1212     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
1213 
1214     // add ref. bonus
1215     _dividends                         += referralBalance_[_customerAddress];
1216     referralBalance_[_customerAddress]  = 0;
1217 
1218     _customerAddress.transfer(_dividends);
1219 
1220     // Fire logging event.
1221     emit onWithdraw(_customerAddress, _dividends);
1222   }
1223 
1224 
1225   /*=======================
1226    =    RESET FUNCTIONS   =
1227    ======================*/
1228 
1229   function injectEther()
1230   public
1231   payable
1232   onlyAdministrator
1233   {
1234 
1235   }
1236 
1237   /*=======================
1238    =   MATHS FUNCTIONS    =
1239    ======================*/
1240 
1241   function toPowerOfThreeHalves(uint x) public pure returns (uint) {
1242     // m = 3, n = 2
1243     // sqrt(x^3)
1244     return sqrt(x**3);
1245   }
1246 
1247   function toPowerOfTwoThirds(uint x) public pure returns (uint) {
1248     // m = 2, n = 3
1249     // cbrt(x^2)
1250     return cbrt(x**2);
1251   }
1252 
1253   function sqrt(uint x) public pure returns (uint y) {
1254     uint z = (x + 1) / 2;
1255     y = x;
1256     while (z < y) {
1257       y = z;
1258       z = (x / z + z) / 2;
1259     }
1260   }
1261 
1262   function cbrt(uint x) public pure returns (uint y) {
1263     uint z = (x + 1) / 3;
1264     y = x;
1265     while (z < y) {
1266       y = z;
1267       z = (x / (z*z) + 2 * z) / 3;
1268     }
1269   }
1270 }
1271 
1272 /*=======================
1273  =     INTERFACES       =
1274  ======================*/
1275 
1276 
1277 contract ZethrDividendCards {
1278   function ownerOf(uint /*_divCardId*/) public pure returns (address) {}
1279   function receiveDividends(uint /*_divCardRate*/) public payable {}
1280 }
1281 
1282 contract ZethrBankroll{
1283   function receiveDividends() public payable {}
1284 }
1285 
1286 
1287 contract ERC223Receiving {
1288   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
1289 }
1290 
1291 // Think it's safe to say y'all know what this is.
1292 
1293 library SafeMath {
1294 
1295   function mul(uint a, uint b) internal pure returns (uint) {
1296     if (a == 0) {
1297       return 0;
1298     }
1299     uint c = a * b;
1300     assert(c / a == b);
1301     return c;
1302   }
1303 
1304   function div(uint a, uint b) internal pure returns (uint) {
1305     // assert(b > 0); // Solidity automatically throws when dividing by 0
1306     uint c = a / b;
1307     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1308     return c;
1309   }
1310 
1311   function sub(uint a, uint b) internal pure returns (uint) {
1312     assert(b <= a);
1313     return a - b;
1314   }
1315 
1316   function add(uint a, uint b) internal pure returns (uint) {
1317     uint c = a + b;
1318     assert(c >= a);
1319     return c;
1320   }
1321 }