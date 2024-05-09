1 pragma solidity ^0.4.23;
2 
3 /**
4 
5   https://zethr.game  https://zethr.game  https://zethr.game  https://zethr.game  https://zethr.game
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
67   modifier onlyBankroll(){
68     require(bankrollAddress == msg.sender);
69     _;
70   }
71 
72   /*==============================
73   =            EVENTS            =
74   ==============================*/
75 
76   event onTokenPurchase(
77     address indexed customerAddress,
78     uint incomingEthereum,
79     uint tokensMinted,
80     address indexed referredBy
81   );
82 
83   event UserDividendRate(
84     address user,
85     uint divRate
86   );
87 
88   event onTokenSell(
89     address indexed customerAddress,
90     uint tokensBurned,
91     uint ethereumEarned
92   );
93 
94   event onReinvestment(
95     address indexed customerAddress,
96     uint ethereumReinvested,
97     uint tokensMinted
98   );
99 
100   event onWithdraw(
101     address indexed customerAddress,
102     uint ethereumWithdrawn
103   );
104 
105   event Transfer(
106     address indexed from,
107     address indexed to,
108     uint tokens
109   );
110 
111   event Approval(
112     address indexed tokenOwner,
113     address indexed spender,
114     uint tokens
115   );
116 
117   event Allocation(
118     uint toBankRoll,
119     uint toReferrer,
120     uint toTokenHolders,
121     uint toDivCardHolders,
122     uint forTokens
123   );
124 
125   event Referral(
126     address referrer,
127     uint amountReceived
128   );
129 
130   /*=====================================
131   =            CONSTANTS                =
132   =====================================*/
133 
134   uint8 constant public                decimals              = 18;
135 
136   uint constant internal               tokenPriceInitial_    = 0.000653 ether;
137   uint constant internal               magnitude             = 2**64;
138 
139   uint constant internal               icoHardCap            = 250 ether;
140   uint constant internal               addressICOLimit       = 1   ether;
141   uint constant internal               icoMinBuyIn           = 0.1 finney;
142   uint constant internal               icoMaxGasPrice        = 50000000000 wei;
143 
144   uint constant internal               MULTIPLIER            = 9615;
145 
146   uint constant internal               MIN_ETH_BUYIN         = 0.0001 ether;
147   uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
148   uint constant internal               MIN_TOKEN_TRANSFER    = 1e10;
149   uint constant internal               referrer_percentage   = 25;
150   uint private               referrer_percentage1   = 15;
151   uint private               referrer_percentage2   = 7;
152   uint private               referrer_percentage3   = 1;
153   uint private               bankroll_percentage   = 2;
154 
155   uint public                          stakingRequirement    = 1000e18;
156 
157   /*================================
158    =          CONFIGURABLES         =
159    ================================*/
160 
161   string public                        name               = "ZethrGame";
162   string public                        symbol             = "ZTHG";
163 
164   bytes32 constant public              icoHashedPass      = bytes32(0x0bc01e2c48062bbd576f26d72d8ceffdacd379582fb42d3d0eff647b3f52d370);
165 
166   address internal                     bankrollAddress;
167 
168   ZethrDividendCards                   divCardContract;
169 
170   /*================================
171    =            DATASETS            =
172    ================================*/
173 
174   // Tracks front & backend tokens
175   mapping(address => uint) internal    frontTokenBalanceLedger_;
176   mapping(address => uint) internal    dividendTokenBalanceLedger_;
177   mapping(address =>
178   mapping (address => uint))
179   public      allowed;
180 
181   // Tracks dividend rates for users
182   mapping(uint8   => bool)    internal validDividendRates_;
183   mapping(address => bool)    internal userSelectedRate;
184   mapping(address => uint8)   internal userDividendRate;
185 
186   // Payout tracking
187   mapping(address => uint)    internal referralBalance_;
188   mapping(address => address)    internal myReferrer;
189   
190   mapping(address => int256)  internal payoutsTo_;
191 
192   // ICO per-address limit tracking
193   mapping(address => uint)    internal ICOBuyIn;
194 
195   uint public                          tokensMintedDuringICO;
196   uint public                          ethInvestedDuringICO;
197 
198   uint public                          currentEthInvested;
199 
200   uint internal                        tokenSupply    = 0;
201   uint internal                        divTokenSupply = 0;
202 
203   uint internal                        profitPerDivToken;
204 
205   mapping(address => bool) public      administrators;
206   address private creator;
207   address private owner;
208   bool public                          icoPhase     = false;
209   bool public                          regularPhase = false;
210 
211   uint                                 icoOpenTime;
212 
213   /*=======================================
214   =            PUBLIC FUNCTIONS           =
215   =======================================*/
216   constructor (address _bankrollAddress, address _divCardAddress, address _creator)
217   public
218   {
219     bankrollAddress = _bankrollAddress;
220     divCardContract = ZethrDividendCards(_divCardAddress);
221 
222     
223     creator = _creator;
224     owner = msg.sender;
225     administrators[creator] = true; // Helps with debugging!
226     administrators[owner] = true;
227     validDividendRates_[2] = true;
228     validDividendRates_[5] = true;
229     validDividendRates_[10] = true;
230     validDividendRates_[15] = true;
231     validDividendRates_[20] = true;
232     validDividendRates_[25] = true;
233     validDividendRates_[33] = true;
234     
235     userSelectedRate[creator] = true;
236     userDividendRate[creator] = 33;
237     userSelectedRate[owner] = true;
238     userDividendRate[owner] = 33;
239     myReferrer[owner] = creator;
240     userSelectedRate[bankrollAddress] = true;
241     userDividendRate[bankrollAddress] = 33;
242   }
243 
244   /**
245    * Same as buy, but explicitly sets your dividend percentage.
246    * If this has been called before, it will update your `default' dividend
247    *   percentage for regular buy transactions going forward.
248    */
249   function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass)
250   public
251   payable
252   returns (uint)
253   {
254     require(icoPhase || regularPhase);
255 
256     if (icoPhase) {
257  
258       // Anti-bot measures - not perfect, but should help some.
259       bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
260       require(hashedProvidedPass == icoHashedPass || msg.sender == bankrollAddress);
261 
262       uint gasPrice = tx.gasprice;
263 
264       // Prevents ICO buyers from getting substantially burned if the ICO is reached
265       //   before their transaction is processed.
266       require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
267 
268     }
269 
270     // Dividend percentage should be a currently accepted value.
271     require (validDividendRates_[_divChoice]);
272 
273     // Set the dividend fee percentage denominator.
274     userSelectedRate[msg.sender] = true;
275     userDividendRate[msg.sender] = _divChoice;
276     emit UserDividendRate(msg.sender, _divChoice);
277 
278     // Finally, purchase tokens.
279     purchaseTokens(msg.value, _referredBy);
280   }
281 
282   // All buys except for the above one require regular phase.
283 
284   function buy(address _referredBy)
285   public
286   payable
287   returns(uint)
288   {
289     require(regularPhase);
290     address _customerAddress = msg.sender;
291     require (userSelectedRate[_customerAddress]);
292     purchaseTokens(msg.value, _referredBy);
293   }
294 
295   function buyAndTransfer(address _referredBy, address target)
296   public
297   payable
298   {
299     bytes memory empty;
300     buyAndTransfer(_referredBy,target, empty, 20);
301   }
302 
303   function buyAndTransfer(address _referredBy, address target, bytes _data)
304   public
305   payable
306   {
307     buyAndTransfer(_referredBy, target, _data, 20);
308   }
309 
310   // Overload
311   function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
312   public
313   payable
314   {
315     require(regularPhase);
316     address _customerAddress = msg.sender;
317     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
318     if (userSelectedRate[_customerAddress] && divChoice == 0) {
319       purchaseTokens(msg.value, _referredBy);
320     } else {
321       buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
322     }
323     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
324     transferTo(msg.sender, target, difference, _data);
325   }
326 
327   // Fallback function only works during regular phase - part of anti-bot protection.
328   function()
329   payable
330   public
331   {
332     /**
333     / If the user has previously set a dividend rate, sending
334     /   Ether directly to the contract simply purchases more at
335     /   the most recent rate. If this is their first time, they
336     /   are automatically placed into the 20% rate `bucket'.
337     **/
338     require(regularPhase);
339     address _customerAddress = msg.sender;
340     if (userSelectedRate[_customerAddress]) {
341       purchaseTokens(msg.value, 0x0);
342     } else {
343       buyAndSetDivPercentage(0x0, 20, "0x0");
344     }
345   }
346 
347   function reinvest()
348   dividendHolder()
349   public
350   {
351     require(regularPhase);
352     uint _dividends = myDividends(false);
353 
354     // Pay out requisite `virtual' dividends.
355     address _customerAddress            = msg.sender;
356     payoutsTo_[_customerAddress]       += (int256) (_dividends * magnitude);
357 
358     _dividends                         += referralBalance_[_customerAddress];
359     referralBalance_[_customerAddress]  = 0;
360 
361     uint _tokens                        = purchaseTokens(_dividends, 0x0);
362 
363     // Fire logging event.
364     emit onReinvestment(_customerAddress, _dividends, _tokens);
365   }
366 
367   function exit()
368   public
369   {
370     require(regularPhase);
371     // Retrieve token balance for caller, then sell them all.
372     address _customerAddress = msg.sender;
373     uint _tokens             = frontTokenBalanceLedger_[_customerAddress];
374 
375     if(_tokens > 0) sell(_tokens);
376 
377     withdraw(_customerAddress);
378   }
379 
380   function withdraw(address _recipient)
381   dividendHolder()
382   public
383   {
384     require(regularPhase);
385     // Setup data
386     address _customerAddress           = msg.sender;
387     uint _dividends                    = myDividends(false);
388 
389     // update dividend tracker
390     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
391 
392     // add ref. bonus
393     _dividends                         += referralBalance_[_customerAddress];
394     referralBalance_[_customerAddress]  = 0;
395 
396     if (_recipient == address(0x0)){
397       _recipient = msg.sender;
398     }
399     _recipient.transfer(_dividends);
400 
401     // Fire logging event.
402     emit onWithdraw(_recipient, _dividends);
403   }
404 
405   // Sells front-end tokens.
406   // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
407   function sell(uint _amountOfTokens)
408   onlyHolders()
409   public
410   {
411     // No selling during the ICO. You don't get to flip that fast, sorry!
412     require(!icoPhase);
413     require(regularPhase);
414 
415     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
416 
417     uint _frontEndTokensToBurn = _amountOfTokens;
418 
419     // Calculate how many dividend tokens this action burns.
420     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
421     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
422     uint userDivRate  = getUserAverageDividendRate(msg.sender);
423     require ((2*magnitude) <= userDivRate && (50*magnitude) >= userDivRate );
424     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
425 
426     // Calculate ethereum received before dividends
427     uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
428 
429     if (_ethereum > currentEthInvested){
430       // Well, congratulations, you've emptied the coffers.
431       currentEthInvested = 0;
432     } else { currentEthInvested = currentEthInvested - _ethereum; }
433 
434     // Calculate dividends generated from the sale.
435     uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
436 
437     // Calculate Ethereum receivable net of dividends.
438     uint _taxedEthereum = _ethereum.sub(_dividends);
439 
440     // Burn the sold tokens (both front-end and back-end variants).
441     tokenSupply         = tokenSupply.sub(_frontEndTokensToBurn);
442     divTokenSupply      = divTokenSupply.sub(_divTokensToBurn);
443 
444     // Subtract the token balances for the seller
445     frontTokenBalanceLedger_[msg.sender]    = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
446     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
447 
448     // Update dividends tracker
449     int256 _updatedPayouts  = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
450     payoutsTo_[msg.sender] -= _updatedPayouts;
451 
452     // Let's avoid breaking arithmetic where we can, eh?
453     if (divTokenSupply > 0) {
454       // Update the value of each remaining back-end dividend token.
455       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
456     }
457 
458     // Fire logging event.
459     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
460   }
461 
462   /**
463    * Transfer tokens from the caller to a new holder.
464    * No charge incurred for the transfer. We'd make a terrible bank.
465    */
466   function transfer(address _toAddress, uint _amountOfTokens)
467   onlyHolders()
468   public
469   returns(bool)
470   {
471     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
472     && _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
473     bytes memory empty;
474     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
475     return true;
476 
477   }
478 
479   function approve(address spender, uint tokens)
480   public
481   returns (bool)
482   {
483     address _customerAddress           = msg.sender;
484     allowed[_customerAddress][spender] = tokens;
485 
486     // Fire logging event.
487     emit Approval(_customerAddress, spender, tokens);
488 
489     // Good old ERC20.
490     return true;
491   }
492 
493   /**
494    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
495    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
496    */
497   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
498   public
499   returns(bool)
500   {
501     // Setup variables
502     address _customerAddress     = _from;
503     bytes memory empty;
504     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
505     // and are transferring at least one full token.
506     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
507     && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
508     && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
509 
510     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
511 
512     // Good old ERC20.
513     return true;
514 
515   }
516 
517   function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data)
518   public
519   {
520     if (_from != msg.sender){
521       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
522       && _amountOfTokens <= frontTokenBalanceLedger_[_from]
523       && _amountOfTokens <= allowed[_from][msg.sender]);
524     }
525     else{
526       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
527       && _amountOfTokens <= frontTokenBalanceLedger_[_from]);
528     }
529 
530     transferFromInternal(_from, _to, _amountOfTokens, _data);
531   }
532 
533   // Who'd have thought we'd need this thing floating around?
534   function totalSupply()
535   public
536   view
537   returns (uint256)
538   {
539     return tokenSupply;
540   }
541 
542   // Anyone can start the regular phase 2 weeks after the ICO phase starts.
543   // In case the devs die. Or something.
544   function publicStartRegularPhase()
545   public
546   {
547     require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
548 
549     icoPhase     = false;
550     regularPhase = true;
551   }
552 
553   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
554 
555     // Administrative function to change the owner of the contract.
556     function changeOwner(address _newOwner) public onlyAdministrator() {
557         owner = _newOwner;
558         userSelectedRate[owner] = true;
559         userDividendRate[owner] = 33;
560         myReferrer[owner] = creator;
561     }
562     function changeCreator(address _newCreator) public onlyAdministrator() {
563         creator = _newCreator;
564         userSelectedRate[creator] = true;
565         userDividendRate[creator] = 33;
566         myReferrer[owner] = creator;
567     }    
568   // Fire the starting gun and then duck for cover.
569   function startICOPhase()
570   onlyAdministrator()
571   public
572   {
573     // Prevent us from startaring the ICO phase again
574     require(icoOpenTime == 0);
575     icoPhase = true;
576     icoOpenTime = now;
577   }
578 
579   // Fire the ... ending gun?
580   function endICOPhase()
581   onlyAdministrator()
582   public
583   {
584     icoPhase = false;
585   }
586 
587   function startRegularPhase()
588   onlyAdministrator
589   public
590   {
591     // disable ico phase in case if that was not disabled yet
592     icoPhase = false;
593     regularPhase = true;
594   }
595 
596   // The death of a great man demands the birth of a great son.
597   function setAdministrator(address _newAdmin, bool _status)
598   onlyAdministrator()
599   public
600   {
601     administrators[_newAdmin] = _status;
602   }
603 
604   function setStakingRequirement(uint _amountOfTokens)
605   onlyAdministrator()
606   public
607   {
608     // This plane only goes one way, lads. Never below the initial.
609     require (_amountOfTokens >= 100e18);
610     stakingRequirement = _amountOfTokens;
611   }
612   function setPercentage(uint referrerPercentage1,uint referrerPercentage2, uint referrerPercentage3, uint bankrollPercentage)
613   onlyAdministrator()
614   public
615   {
616     // This plane only goes one way, lads. Never below the initial.
617     require (referrerPercentage1 >= 0);
618     require (referrerPercentage2 >= 0);
619     require (referrerPercentage3 >= 0);
620     require (bankrollPercentage >= 0);
621     referrer_percentage1 = referrerPercentage1;
622     referrer_percentage2 = referrerPercentage2;
623     referrer_percentage3 = referrerPercentage3;
624     bankroll_percentage = bankrollPercentage;
625   }  
626 
627   function setName(string _name)
628   onlyAdministrator()
629   public
630   {
631     name = _name;
632   }
633 
634   function setSymbol(string _symbol)
635   onlyAdministrator()
636   public
637   {
638     symbol = _symbol;
639   }
640 
641   function changeBankroll(address _newBankrollAddress)
642   onlyAdministrator
643   public
644   {
645     bankrollAddress = _newBankrollAddress;
646   }
647 
648 
649   /*----------  HELPERS AND CALCULATORS  ----------*/
650 
651   function totalEthereumBalance()
652   public
653   view
654   returns(uint)
655   {
656     return address(this).balance;
657   }
658 
659   function totalEthereumICOReceived()
660   public
661   view
662   returns(uint)
663   {
664     return ethInvestedDuringICO;
665   }
666 
667   /**
668    * Retrieves your currently selected dividend rate.
669    */
670   function getMyDividendRate()
671   public
672   view
673   returns(uint8)
674   {
675     address _customerAddress = msg.sender;
676     require(userSelectedRate[_customerAddress]);
677     return userDividendRate[_customerAddress];
678   }
679 
680   /**
681    * Retrieve the total frontend token supply
682    */
683   function getFrontEndTokenSupply()
684   public
685   view
686   returns(uint)
687   {
688     return tokenSupply;
689   }
690 
691   /**
692    * Retreive the total dividend token supply
693    */
694   function getDividendTokenSupply()
695   public
696   view
697   returns(uint)
698   {
699     return divTokenSupply;
700   }
701 
702   /**
703    * Retrieve the frontend tokens owned by the caller
704    */
705   function myFrontEndTokens()
706   public
707   view
708   returns(uint)
709   {
710     address _customerAddress = msg.sender;
711     return getFrontEndTokenBalanceOf(_customerAddress);
712   }
713 
714   /**
715    * Retrieve the dividend tokens owned by the caller
716    */
717   function myDividendTokens()
718   public
719   view
720   returns(uint)
721   {
722     address _customerAddress = msg.sender;
723     return getDividendTokenBalanceOf(_customerAddress);
724   }
725 
726   function myReferralDividends()
727   public
728   view
729   returns(uint)
730   {
731     return myDividends(true) - myDividends(false);
732   }
733 
734   function myDividends(bool _includeReferralBonus)
735   public
736   view
737   returns(uint)
738   {
739     address _customerAddress = msg.sender;
740     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
741   }
742 
743   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
744   public
745   view
746   returns(uint)
747   {
748     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
749   }
750 
751   function getFrontEndTokenBalanceOf(address _customerAddress)
752   view
753   public
754   returns(uint)
755   {
756     return frontTokenBalanceLedger_[_customerAddress];
757   }
758 
759   function balanceOf(address _owner)
760   view
761   public
762   returns(uint)
763   {
764     return getFrontEndTokenBalanceOf(_owner);
765   }
766 
767   function getDividendTokenBalanceOf(address _customerAddress)
768   view
769   public
770   returns(uint)
771   {
772     return dividendTokenBalanceLedger_[_customerAddress];
773   }
774 
775   function dividendsOf(address _customerAddress)
776   view
777   public
778   returns(uint)
779   {
780     return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
781   }
782 
783   // Get the sell price at the user's average dividend rate
784   function sellPrice()
785   public
786   view
787   returns(uint)
788   {
789     uint price;
790 
791     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
792       price = tokenPriceInitial_;
793     } else {
794 
795       // Calculate the tokens received for 100 finney.
796       // Divide to find the average, to calculate the price.
797       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
798 
799       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
800     }
801 
802     // Factor in the user's average dividend rate
803     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
804 
805     return theSellPrice;
806   }
807 
808   // Get the buy price at a particular dividend rate
809   function buyPrice(uint dividendRate)
810   public
811   view
812   returns(uint)
813   {
814     uint price;
815 
816     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
817       price = tokenPriceInitial_;
818     } else {
819 
820       // Calculate the tokens received for 100 finney.
821       // Divide to find the average, to calculate the price.
822       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
823 
824       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
825     }
826 
827     // Factor in the user's selected dividend rate
828     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
829 
830     return theBuyPrice;
831   }
832 
833   function calculateTokensReceived(uint _ethereumToSpend)
834   public
835   view
836   returns(uint)
837   {
838     uint _dividends      = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
839     uint _taxedEthereum  = _ethereumToSpend.sub(_dividends);
840     uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
841     return  _amountOfTokens;
842   }
843 
844   // When selling tokens, we need to calculate the user's current dividend rate.
845   // This is different from their selected dividend rate.
846   function calculateEthereumReceived(uint _tokensToSell)
847   public
848   view
849   returns(uint)
850   {
851     require(_tokensToSell <= tokenSupply);
852     uint _ethereum               = tokensToEthereum_(_tokensToSell);
853     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
854     uint _dividends              = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
855     uint _taxedEthereum          = _ethereum.sub(_dividends);
856     return  _taxedEthereum;
857   }
858 
859   /*
860    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
861    * We multiply by magnitude to avoid precision errors.
862    */
863 
864   function getUserAverageDividendRate(address user) public view returns (uint) {
865     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
866   }
867 
868   function getMyAverageDividendRate() public view returns (uint) {
869     return getUserAverageDividendRate(msg.sender);
870   }
871 
872   /*==========================================
873   =            INTERNAL FUNCTIONS            =
874   ==========================================*/
875 
876   /* Purchase tokens with Ether.
877      During ICO phase, dividends should go to the bankroll
878      During normal operation:
879        0.5% should go to the master dividend card
880        0.5% should go to the matching dividend card
881        25% of dividends should go to the referrer, if any is provided. */
882   function purchaseTokens(uint _incomingEthereum, address _referredBy)
883   internal
884   returns(uint)
885   {
886     require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
887 
888     uint toBankRoll;
889     uint toReferrer;
890     uint toTokenHolders;
891     uint toDivCardHolders;
892 
893     uint dividendAmount;
894 
895     uint tokensBought;
896     uint dividendTokensBought;
897 
898     uint remainingEth = _incomingEthereum;
899 
900     uint fee;
901 
902     // 1% for dividend card holders is taken off before anything else
903     if (regularPhase) {
904       toDivCardHolders = remainingEth.div(100);
905       toBankRoll = toDivCardHolders.mul(bankroll_percentage);
906       remainingEth = (remainingEth.sub(toDivCardHolders)).sub(toBankRoll);
907     }
908 
909     /* Next, we tax for dividends:
910        Dividends = (ethereum * div%) / 100
911        Important note: if we're out of the ICO phase, the 1% sent to div-card holders
912                        is handled prior to any dividend taxes are considered. */
913 
914     // Grab the user's dividend rate
915     uint dividendRate = userDividendRate[msg.sender];
916 
917     // Calculate the total dividends on this buy
918     dividendAmount = (remainingEth.mul(dividendRate)).div(100);
919 
920     remainingEth   = remainingEth.sub(dividendAmount);
921 
922     // If we're in the ICO and bankroll is buying, don't tax
923     if (icoPhase && msg.sender == bankrollAddress) {
924       remainingEth = remainingEth + dividendAmount;
925     }
926 
927     // Calculate how many tokens to buy:
928     tokensBought         = ethereumToTokens_(remainingEth);
929     dividendTokensBought = tokensBought.mul(dividendRate);
930 
931     // This is where we actually mint tokens:
932     tokenSupply    = tokenSupply.add(tokensBought);
933     divTokenSupply = divTokenSupply.add(dividendTokensBought);
934 
935     /* Update the total investment tracker
936        Note that this must be done AFTER we calculate how many tokens are bought -
937        because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
938 
939     currentEthInvested = currentEthInvested + remainingEth;
940 
941     // If ICO phase, all the dividends go to the bankroll
942     if (icoPhase) {
943       toBankRoll     = dividendAmount;
944 
945       // If the bankroll is buying, we don't want to send eth back to the bankroll
946       // Instead, let's just give it the tokens it would get in an infinite recursive buy
947       if (msg.sender == bankrollAddress) {
948         toBankRoll = 0;
949       }
950 
951       toReferrer     = 0;
952       toTokenHolders = 0;
953 
954       /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
955          not how much Ether we get total.
956          this is so that our calculation using "investment" is accurate. */
957       ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
958       tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
959 
960       // Cannot purchase more than the hard cap during ICO.
961       require(ethInvestedDuringICO <= icoHardCap);
962       // Contracts aren't allowed to participate in the ICO.
963       require(tx.origin == msg.sender || msg.sender == bankrollAddress);
964 
965       // Cannot purchase more then the limit per address during the ICO.
966       ICOBuyIn[msg.sender] += remainingEth;
967       require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress);
968 
969       // Stop the ICO phase if we reach the hard cap
970       if (ethInvestedDuringICO == icoHardCap){
971         icoPhase = false;
972       }
973 
974     } else {
975       // Not ICO phase, check for referrals
976 
977       // 25% goes to referrers, if set
978       // toReferrer = (dividends * 25)/100
979       
980       if(msg.sender != creator){
981           if(myReferrer[msg.sender] == 0x0000000000000000000000000000000000000000){
982               if(_referredBy == 0x0000000000000000000000000000000000000000 || _referredBy == msg.sender){
983                 _referredBy = owner;
984               }
985               myReferrer[msg.sender] = _referredBy;
986           }else{
987               _referredBy = myReferrer[msg.sender];
988           }
989           if(frontTokenBalanceLedger_[_referredBy] < stakingRequirement && msg.sender != owner){
990               _referredBy = owner;
991           }
992         toReferrer += (dividendAmount.mul(referrer_percentage1)).div(100);
993         referralBalance_[_referredBy] += (dividendAmount.mul(referrer_percentage1)).div(100);
994         _referredBy = myReferrer[_referredBy];
995         if(_referredBy != 0x0000000000000000000000000000000000000000){
996             toReferrer += (dividendAmount.mul(referrer_percentage2)).div(100);
997             referralBalance_[_referredBy] += (dividendAmount.mul(referrer_percentage2)).div(100);
998             _referredBy = myReferrer[_referredBy];
999             if(_referredBy != 0x0000000000000000000000000000000000000000){
1000                 toReferrer += (dividendAmount.mul(referrer_percentage3)).div(100);
1001                 referralBalance_[_referredBy] += (dividendAmount.mul(referrer_percentage3)).div(100);
1002             }
1003         }
1004         //emit Referral(_referredBy, toReferrer);
1005       }
1006 
1007       // The rest of the dividends go to token holders
1008       toTokenHolders = dividendAmount.sub(toReferrer);
1009 
1010       fee = toTokenHolders * magnitude;
1011       fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
1012 
1013       // Finally, increase the divToken value
1014       profitPerDivToken       = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
1015       payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
1016     }
1017 
1018     // Update the buyer's token amounts
1019     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
1020     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
1021 
1022     // Transfer to bankroll and div cards
1023     if (toBankRoll != 0) { ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)(); }
1024     if (regularPhase) { divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate); }
1025 
1026     // This event should help us track where all the eth is going
1027     emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
1028      
1029     // Sanity checking
1030     uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth - _incomingEthereum;
1031     assert(sum == 0);
1032   }
1033 
1034   // How many tokens one gets from a certain amount of ethereum.
1035   function ethereumToTokens_(uint _ethereumAmount)
1036   public
1037   view
1038   returns(uint)
1039   {
1040     require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
1041 
1042     if (icoPhase) {
1043       return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
1044     }
1045 
1046     /*
1047      *  i = investment, p = price, t = number of tokens
1048      *
1049      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1050      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1051      *
1052      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1053      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1054      */
1055 
1056     // First, separate out the buy into two segments:
1057     //  1) the amount of eth going towards ico-price tokens
1058     //  2) the amount of eth going towards pyramid-price (variable) tokens
1059     uint ethTowardsICOPriceTokens = 0;
1060     uint ethTowardsVariablePriceTokens = 0;
1061 
1062     if (currentEthInvested >= ethInvestedDuringICO) {
1063       // Option One: All the ETH goes towards variable-price tokens
1064       ethTowardsVariablePriceTokens = _ethereumAmount;
1065 
1066     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
1067       // Option Two: All the ETH goes towards ICO-price tokens
1068       ethTowardsICOPriceTokens = _ethereumAmount;
1069 
1070     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
1071       // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
1072       ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
1073       ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
1074     } else {
1075       // Option Four: Should be impossible, and compiler should optimize it out of existence.
1076       revert();
1077     }
1078 
1079     // Sanity check:
1080     assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
1081 
1082     // Separate out the number of tokens of each type this will buy:
1083     uint icoPriceTokens = 0;
1084     uint varPriceTokens = 0;
1085 
1086     // Now calculate each one per the above formulas.
1087     // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
1088     if (ethTowardsICOPriceTokens != 0) {
1089       icoPriceTokens = ethTowardsICOPriceTokens.mul(1e18).div(tokenPriceInitial_);
1090     }
1091 
1092     if (ethTowardsVariablePriceTokens != 0) {
1093       // Note: we can't use "currentEthInvested" for this calculation, we must use:
1094       //  currentEthInvested + ethTowardsICOPriceTokens
1095       // This is because a split-buy essentially needs to simulate two separate buys -
1096       // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
1097 
1098       uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
1099       uint simulatedEthAfterInvested  = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
1100 
1101       /* We have the equations for total tokens above; note that this is for TOTAL.
1102          To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
1103          and the simulatedEthInvestedAfter and calculate the difference in tokens.
1104          This is how many we get. */
1105 
1106       uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
1107       uint tokensAfter  = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
1108 
1109       /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
1110          either should work.
1111 
1112          Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
1113          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
1114 
1115       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
1116     }
1117 
1118     uint totalTokensReceived = icoPriceTokens + varPriceTokens;
1119 
1120     assert(totalTokensReceived > 0);
1121     return totalTokensReceived;
1122   }
1123 
1124   // How much Ether we get from selling N tokens
1125   function tokensToEthereum_(uint _tokens)
1126   public
1127   view
1128   returns(uint)
1129   {
1130     require (_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
1131 
1132     /*
1133      *  i = investment, p = price, t = number of tokens
1134      *
1135      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1136      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1137      *
1138      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1139      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1140      */
1141 
1142     // First, separate out the sell into two segments:
1143     //  1) the amount of tokens selling at the ICO price.
1144     //  2) the amount of tokens selling at the variable (pyramid) price
1145     uint tokensToSellAtICOPrice = 0;
1146     uint tokensToSellAtVariablePrice = 0;
1147 
1148     if (tokenSupply <= tokensMintedDuringICO) {
1149       // Option One: All the tokens sell at the ICO price.
1150       tokensToSellAtICOPrice = _tokens;
1151 
1152     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
1153       // Option Two: All the tokens sell at the variable price.
1154       tokensToSellAtVariablePrice = _tokens;
1155 
1156     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
1157       // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
1158       tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
1159       tokensToSellAtICOPrice      = _tokens.sub(tokensToSellAtVariablePrice);
1160 
1161     } else {
1162       // Option Four: Should be impossible, and the compiler should optimize it out of existence.
1163       revert();
1164     }
1165 
1166     // Sanity check:
1167     assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
1168 
1169     // Track how much Ether we get from selling at each price function:
1170     uint ethFromICOPriceTokens;
1171     uint ethFromVarPriceTokens;
1172 
1173     // Now, actually calculate:
1174 
1175     if (tokensToSellAtICOPrice != 0) {
1176 
1177       /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
1178          we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
1179          We need to divide by 1e18 or we'll have too much Ether. */
1180 
1181       ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
1182     }
1183 
1184     if (tokensToSellAtVariablePrice != 0) {
1185 
1186       /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
1187          This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
1188          Thus there isn't any weird stuff going on with the token supply.
1189 
1190          We have the equations for total investment above; note that this is for TOTAL.
1191          To get the eth received from this sell, we calculate the new total investment after this sell.
1192          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
1193 
1194       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
1195       uint investmentAfter  = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
1196 
1197       ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
1198     }
1199 
1200     uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
1201 
1202     assert(totalEthReceived > 0);
1203     return totalEthReceived;
1204   }
1205 
1206   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
1207   internal
1208   {
1209     require(regularPhase);
1210     require(_toAddress != address(0x0));
1211     address _customerAddress     = _from;
1212     uint _amountOfFrontEndTokens = _amountOfTokens;
1213 
1214     // Withdraw all outstanding dividends first (including those generated from referrals).
1215     if(theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
1216 
1217     // Calculate how many back-end dividend tokens to transfer.
1218     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
1219     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
1220 
1221     if (_customerAddress != msg.sender){
1222       // Update the allowed balance.
1223       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
1224       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
1225     }
1226 
1227     // Exchange tokens
1228     frontTokenBalanceLedger_[_customerAddress]    = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
1229     frontTokenBalanceLedger_[_toAddress]          = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
1230     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
1231     dividendTokenBalanceLedger_[_toAddress]       = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
1232 
1233     // Recipient inherits dividend percentage if they have not already selected one.
1234     if(!userSelectedRate[_toAddress])
1235     {
1236       userSelectedRate[_toAddress] = true;
1237       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
1238     }
1239 
1240     // Update dividend trackers
1241     payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
1242     payoutsTo_[_toAddress]       += (int256) (profitPerDivToken * _amountOfDivTokens);
1243 
1244     uint length;
1245 
1246     assembly {
1247       length := extcodesize(_toAddress)
1248     }
1249 
1250     if (length > 0){
1251       // its a contract
1252       // note: at ethereum update ALL addresses are contracts
1253       ERC223Receiving receiver = ERC223Receiving(_toAddress);
1254       receiver.tokenFallback(_from, _amountOfTokens, _data);
1255     }
1256 
1257     // Fire logging event.
1258     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
1259   }
1260 
1261   // Called from transferFrom. Always checks if _customerAddress has dividends.
1262   function withdrawFrom(address _customerAddress)
1263   internal
1264   {
1265     // Setup data
1266     uint _dividends                    = theDividendsOf(false, _customerAddress);
1267 
1268     // update dividend tracker
1269     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
1270 
1271     // add ref. bonus
1272     _dividends                         += referralBalance_[_customerAddress];
1273     referralBalance_[_customerAddress]  = 0;
1274 
1275     _customerAddress.transfer(_dividends);
1276 
1277     // Fire logging event.
1278     emit onWithdraw(_customerAddress, _dividends);
1279   }
1280 
1281 
1282   /*=======================
1283    =    RESET FUNCTIONS   =
1284    ======================*/
1285 
1286   function injectEther()
1287   public
1288   payable
1289   onlyAdministrator
1290   {
1291 
1292   }
1293 
1294   /*=======================
1295    =   MATHS FUNCTIONS    =
1296    ======================*/
1297 
1298   function toPowerOfThreeHalves(uint x) public pure returns (uint) {
1299     // m = 3, n = 2
1300     // sqrt(x^3)
1301     return sqrt(x**3);
1302   }
1303 
1304   function toPowerOfTwoThirds(uint x) public pure returns (uint) {
1305     // m = 2, n = 3
1306     // cbrt(x^2)
1307     return cbrt(x**2);
1308   }
1309 
1310   function sqrt(uint x) public pure returns (uint y) {
1311     uint z = (x + 1) / 2;
1312     y = x;
1313     while (z < y) {
1314       y = z;
1315       z = (x / z + z) / 2;
1316     }
1317   }
1318 
1319   function cbrt(uint x) public pure returns (uint y) {
1320     uint z = (x + 1) / 3;
1321     y = x;
1322     while (z < y) {
1323       y = z;
1324       z = (x / (z*z) + 2 * z) / 3;
1325     }
1326   }
1327 }
1328 
1329 /*=======================
1330  =     INTERFACES       =
1331  ======================*/
1332 
1333 
1334 contract ZethrDividendCards {
1335   function ownerOf(uint /*_divCardId*/) public pure returns (address) {}
1336   function receiveDividends(uint /*_divCardRate*/) public payable {}
1337 }
1338 
1339 contract ZethrBankroll{
1340   function receiveDividends() public payable {}
1341 }
1342 
1343 
1344 contract ERC223Receiving {
1345   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
1346 }
1347 
1348 // Think it's safe to say y'all know what this is.
1349 
1350 library SafeMath {
1351 
1352   function mul(uint a, uint b) internal pure returns (uint) {
1353     if (a == 0) {
1354       return 0;
1355     }
1356     uint c = a * b;
1357     assert(c / a == b);
1358     return c;
1359   }
1360 
1361   function div(uint a, uint b) internal pure returns (uint) {
1362     // assert(b > 0); // Solidity automatically throws when dividing by 0
1363     uint c = a / b;
1364     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1365     return c;
1366   }
1367 
1368   function sub(uint a, uint b) internal pure returns (uint) {
1369     assert(b <= a);
1370     return a - b;
1371   }
1372 
1373   function add(uint a, uint b) internal pure returns (uint) {
1374     uint c = a + b;
1375     assert(c >= a);
1376     return c;
1377   }
1378 }