1 pragma solidity ^0.4.24;
2 
3 /**
4 
5   https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com
6 
7                                                                                                   
8 FFFFFFFFFFFFFFFFFFFFFF                                           tttt            iiii                   
9 F::::::::::::::::::::F                                        ttt:::t           i::::i                  
10 F::::::::::::::::::::F                                        t:::::t            iiii                   
11 FF::::::FFFFFFFFF::::F                                        t:::::t                                   
12   F:::::F       FFFFFFooooooooooo   rrrrr   rrrrrrrrr   ttttttt:::::ttttttt    iiiiiii     ssssssssss   
13   F:::::F           oo:::::::::::oo r::::rrr:::::::::r  t:::::::::::::::::t    i:::::i   ss::::::::::s  
14   F::::::FFFFFFFFFFo:::::::::::::::or:::::::::::::::::r t:::::::::::::::::t     i::::i ss:::::::::::::s 
15   F:::::::::::::::Fo:::::ooooo:::::orr::::::rrrrr::::::rtttttt:::::::tttttt     i::::i s::::::ssss:::::s
16   F:::::::::::::::Fo::::o     o::::o r:::::r     r:::::r      t:::::t           i::::i  s:::::s  ssssss 
17   F::::::FFFFFFFFFFo::::o     o::::o r:::::r     rrrrrrr      t:::::t           i::::i    s::::::s      
18   F:::::F          o::::o     o::::o r:::::r                  t:::::t           i::::i       s::::::s   
19   F:::::F          o::::o     o::::o r:::::r                  t:::::t    tttttt i::::i ssssss   s:::::s 
20 FF:::::::FF        o:::::ooooo:::::o r:::::r                  t::::::tttt:::::ti::::::is:::::ssss::::::s
21 F::::::::FF        o:::::::::::::::o r:::::r                  tt::::::::::::::ti::::::is::::::::::::::s 
22 F::::::::FF         oo:::::::::::oo  r:::::r                    tt:::::::::::tti::::::i s:::::::::::ss  
23 FFFFFFFFFFF           ooooooooooo    rrrrrrr                      ttttttttttt  iiiiiiii  sssssssssss    
24                                                                                                         
25 
26 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
27 
28 Discord:   https://discord.gg/gDtTX62
29 
30 
31 **/
32 
33 
34 contract Fortis {
35   using SafeMath for uint;
36 
37   /*=================================
38   =            MODIFIERS            =
39   =================================*/
40 
41   modifier onlyHolders() {
42     require(myFrontEndTokens() > 0);
43     _;
44   }
45 
46   modifier dividendHolder() {
47     require(myDividends(true) > 0);
48     _;
49   }
50 
51   modifier onlyAdministrator(){
52     address _customerAddress = msg.sender;
53     require(administrators[_customerAddress]);
54     _;
55   }
56 
57   /*==============================
58   =            EVENTS            =
59   ==============================*/
60 
61   event onTokenPurchase(
62     address indexed customerAddress,
63     uint incomingEthereum,
64     uint tokensMinted,
65     address indexed referredBy
66   );
67 
68   event UserDividendRate(
69     address user,
70     uint divRate
71   );
72 
73   event onTokenSell(
74     address indexed customerAddress,
75     uint tokensBurned,
76     uint ethereumEarned
77   );
78 
79   event onReinvestment(
80     address indexed customerAddress,
81     uint ethereumReinvested,
82     uint tokensMinted
83   );
84 
85   event onWithdraw(
86     address indexed customerAddress,
87     uint ethereumWithdrawn
88   );
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint tokens
94   );
95 
96   event Approval(
97     address indexed tokenOwner,
98     address indexed spender,
99     uint tokens
100   );
101 
102   event Allocation(
103     uint toBankRoll,
104     uint toReferrer,
105     uint toTokenHolders,
106     uint toDivCardHolders,
107     uint forTokens
108   );
109 
110   event Referral(
111     address referrer,
112     uint amountReceived
113   );
114 
115   /*=====================================
116   =            CONSTANTS                =
117   =====================================*/
118 
119   uint8 constant public                decimals              = 18;
120 
121   uint constant internal               tokenPriceInitial_    = 0.000653 ether;
122   uint constant internal               magnitude             = 2**64;
123 
124   uint constant internal               icoHardCap            = 250 ether;
125   uint constant internal               addressICOLimit       = 1   ether;
126   uint constant internal               icoMinBuyIn           = 0.1 finney;
127   uint constant internal               icoMaxGasPrice        = 50000000000 wei;
128 
129   uint constant internal               MULTIPLIER            = 9615;
130 
131   uint constant internal               MIN_ETH_BUYIN         = 0.0001 ether;
132   uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
133   uint constant internal               MIN_TOKEN_TRANSFER    = 1e10;
134   uint constant internal               referrer_percentage   = 25;
135 
136   uint public                          stakingRequirement    = 100e18;
137 
138   /*================================
139    =          CONFIGURABLES         =
140    ================================*/
141 
142   string public                        name               = "Fortis";
143   string public                        symbol             = "IRON";
144 
145   bytes32 constant public              icoHashedPass      = bytes32(0x5ddcde33b94b19bdef79dd9ea75be591942b9ec78286d64b44a356280fb6a262);
146 
147   address internal                     bankrollAddress;
148 
149   ZethrDividendCards                   divCardContract;
150 
151   /*================================
152    =            DATASETS            =
153    ================================*/
154 
155   // Tracks front & backend tokens
156   mapping(address => uint) internal    frontTokenBalanceLedger_;
157   mapping(address => uint) internal    dividendTokenBalanceLedger_;
158   mapping(address =>
159   mapping (address => uint))
160   public      allowed;
161 
162   // Tracks dividend rates for users
163   mapping(uint8   => bool)    internal validDividendRates_;
164   mapping(address => bool)    internal userSelectedRate;
165   mapping(address => uint8)   internal userDividendRate;
166 
167   // Payout tracking
168   mapping(address => uint)    internal referralBalance_;
169   mapping(address => int256)  internal payoutsTo_;
170 
171   // ICO per-address limit tracking
172   mapping(address => uint)    internal ICOBuyIn;
173 
174   uint public                          tokensMintedDuringICO;
175   uint public                          ethInvestedDuringICO;
176 
177   uint public                          currentEthInvested;
178 
179   uint internal                        tokenSupply    = 0;
180   uint internal                        divTokenSupply = 0;
181 
182   uint internal                        profitPerDivToken;
183 
184   mapping(address => bool) public      administrators;
185 
186   bool public                          icoPhase     = false;
187   bool public                          regularPhase = false;
188 
189   uint                                 icoOpenTime;
190 
191   /*=======================================
192   =            PUBLIC FUNCTIONS           =
193   =======================================*/
194   constructor (address _bankrollAddress, address _divCardAddress)
195   public
196   {
197     bankrollAddress = _bankrollAddress;
198     divCardContract = ZethrDividendCards(_divCardAddress);
199 
200     administrators[0x9b3bb44b1a9243db229e5ccc6d20cada9efce5f8] = true; // Rayner
201     administrators[0x487a03097b4d7320d5a0e7451f6a0e1224c37f09] = true; // Rustam
202     administrators[0x24d6e2d15a85c27b0282bbc2afbc06cfbd9c15a0] = true; // Glandur
203 
204     administrators[msg.sender] = true; // Helps with debugging!
205 
206     validDividendRates_[2] = true;
207     validDividendRates_[5] = true;
208     validDividendRates_[10] = true;
209     validDividendRates_[15] = true;
210     validDividendRates_[20] = true;
211     validDividendRates_[25] = true;
212     validDividendRates_[33] = true;
213 
214     userSelectedRate[bankrollAddress] = true;
215     userDividendRate[bankrollAddress] = 33;
216 
217   }
218 
219   /**
220    * Same as buy, but explicitly sets your dividend percentage.
221    * If this has been called before, it will update your `default' dividend
222    *   percentage for regular buy transactions going forward.
223    */
224   function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass)
225   public
226   payable
227   returns (uint)
228   {
229     require(icoPhase || regularPhase);
230 
231     if (icoPhase) {
232  
233       // Anti-bot measures - not perfect, but should help some.
234       bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
235       require(hashedProvidedPass == icoHashedPass || msg.sender == bankrollAddress);
236 
237       uint gasPrice = tx.gasprice;
238 
239       // Prevents ICO buyers from getting substantially burned if the ICO is reached
240       //   before their transaction is processed.
241       require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
242 
243     }
244 
245     // Dividend percentage should be a currently accepted value.
246     require (validDividendRates_[_divChoice]);
247 
248     // Set the dividend fee percentage denominator.
249     userSelectedRate[msg.sender] = true;
250     userDividendRate[msg.sender] = _divChoice;
251     emit UserDividendRate(msg.sender, _divChoice);
252 
253     // Finally, purchase tokens.
254     purchaseTokens(msg.value, _referredBy);
255   }
256 
257   // All buys except for the above one require regular phase.
258 
259   function buy(address _referredBy)
260   public
261   payable
262   returns(uint)
263   {
264     require(regularPhase);
265     address _customerAddress = msg.sender;
266     require (userSelectedRate[_customerAddress]);
267     purchaseTokens(msg.value, _referredBy);
268   }
269 
270   function buyAndTransfer(address _referredBy, address target)
271   public
272   payable
273   {
274     bytes memory empty;
275     buyAndTransfer(_referredBy,target, empty, 20);
276   }
277 
278   function buyAndTransfer(address _referredBy, address target, bytes _data)
279   public
280   payable
281   {
282     buyAndTransfer(_referredBy, target, _data, 20);
283   }
284 
285   // Overload
286   function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
287   public
288   payable
289   {
290     require(regularPhase);
291     address _customerAddress = msg.sender;
292     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
293     if (userSelectedRate[_customerAddress] && divChoice == 0) {
294       purchaseTokens(msg.value, _referredBy);
295     } else {
296       buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
297     }
298     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
299     transferTo(msg.sender, target, difference, _data);
300   }
301 
302   // Fallback function only works during regular phase - part of anti-bot protection.
303   function()
304   payable
305   public
306   {
307     /**
308     / If the user has previously set a dividend rate, sending
309     /   Ether directly to the contract simply purchases more at
310     /   the most recent rate. If this is their first time, they
311     /   are automatically placed into the 20% rate `bucket'.
312     **/
313     require(regularPhase);
314     address _customerAddress = msg.sender;
315     if (userSelectedRate[_customerAddress]) {
316       purchaseTokens(msg.value, 0x0);
317     } else {
318       buyAndSetDivPercentage(0x0, 20, "0x0");
319     }
320   }
321 
322   function reinvest()
323   dividendHolder()
324   public
325   {
326     require(regularPhase);
327     uint _dividends = myDividends(false);
328 
329     // Pay out requisite `virtual' dividends.
330     address _customerAddress            = msg.sender;
331     payoutsTo_[_customerAddress]       += (int256) (_dividends * magnitude);
332 
333     _dividends                         += referralBalance_[_customerAddress];
334     referralBalance_[_customerAddress]  = 0;
335 
336     uint _tokens                        = purchaseTokens(_dividends, 0x0);
337 
338     // Fire logging event.
339     emit onReinvestment(_customerAddress, _dividends, _tokens);
340   }
341 
342   function exit()
343   public
344   {
345     require(regularPhase);
346     // Retrieve token balance for caller, then sell them all.
347     address _customerAddress = msg.sender;
348     uint _tokens             = frontTokenBalanceLedger_[_customerAddress];
349 
350     if(_tokens > 0) sell(_tokens);
351 
352     withdraw(_customerAddress);
353   }
354 
355   function withdraw(address _recipient)
356   dividendHolder()
357   public
358   {
359     require(regularPhase);
360     // Setup data
361     address _customerAddress           = msg.sender;
362     uint _dividends                    = myDividends(false);
363 
364     // update dividend tracker
365     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
366 
367     // add ref. bonus
368     _dividends                         += referralBalance_[_customerAddress];
369     referralBalance_[_customerAddress]  = 0;
370 
371     if (_recipient == address(0x0)){
372       _recipient = msg.sender;
373     }
374     _recipient.transfer(_dividends);
375 
376     // Fire logging event.
377     emit onWithdraw(_recipient, _dividends);
378   }
379 
380   // Sells front-end tokens.
381   // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
382   function sell(uint _amountOfTokens)
383   onlyHolders()
384   public
385   {
386     // No selling during the ICO. You don't get to flip that fast, sorry!
387     require(!icoPhase);
388     require(regularPhase);
389 
390     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
391 
392     uint _frontEndTokensToBurn = _amountOfTokens;
393 
394     // Calculate how many dividend tokens this action burns.
395     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
396     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
397     uint userDivRate  = getUserAverageDividendRate(msg.sender);
398     require ((2*magnitude) <= userDivRate && (50*magnitude) >= userDivRate );
399     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
400 
401     // Calculate ethereum received before dividends
402     uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
403 
404     if (_ethereum > currentEthInvested){
405       // Well, congratulations, you've emptied the coffers.
406       currentEthInvested = 0;
407     } else { currentEthInvested = currentEthInvested - _ethereum; }
408 
409     // Calculate dividends generated from the sale.
410     uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
411 
412     // Calculate Ethereum receivable net of dividends.
413     uint _taxedEthereum = _ethereum.sub(_dividends);
414 
415     // Burn the sold tokens (both front-end and back-end variants).
416     tokenSupply         = tokenSupply.sub(_frontEndTokensToBurn);
417     divTokenSupply      = divTokenSupply.sub(_divTokensToBurn);
418 
419     // Subtract the token balances for the seller
420     frontTokenBalanceLedger_[msg.sender]    = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
421     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
422 
423     // Update dividends tracker
424     int256 _updatedPayouts  = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
425     payoutsTo_[msg.sender] -= _updatedPayouts;
426 
427     // Let's avoid breaking arithmetic where we can, eh?
428     if (divTokenSupply > 0) {
429       // Update the value of each remaining back-end dividend token.
430       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
431     }
432 
433     // Fire logging event.
434     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
435   }
436 
437   /**
438    * Transfer tokens from the caller to a new holder.
439    * No charge incurred for the transfer. We'd make a terrible bank.
440    */
441   function transfer(address _toAddress, uint _amountOfTokens)
442   onlyHolders()
443   public
444   returns(bool)
445   {
446     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
447     && _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
448     bytes memory empty;
449     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
450     return true;
451 
452   }
453 
454   function approve(address spender, uint tokens)
455   public
456   returns (bool)
457   {
458     address _customerAddress           = msg.sender;
459     allowed[_customerAddress][spender] = tokens;
460 
461     // Fire logging event.
462     emit Approval(_customerAddress, spender, tokens);
463 
464     // Good old ERC20.
465     return true;
466   }
467 
468   /**
469    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
470    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
471    */
472   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
473   public
474   returns(bool)
475   {
476     // Setup variables
477     address _customerAddress     = _from;
478     bytes memory empty;
479     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
480     // and are transferring at least one full token.
481     require(_amountOfTokens >= MIN_TOKEN_TRANSFER
482     && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
483     && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
484 
485     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
486 
487     // Good old ERC20.
488     return true;
489 
490   }
491 
492   function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data)
493   public
494   {
495     if (_from != msg.sender){
496       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
497       && _amountOfTokens <= frontTokenBalanceLedger_[_from]
498       && _amountOfTokens <= allowed[_from][msg.sender]);
499     }
500     else{
501       require(_amountOfTokens >= MIN_TOKEN_TRANSFER
502       && _amountOfTokens <= frontTokenBalanceLedger_[_from]);
503     }
504 
505     transferFromInternal(_from, _to, _amountOfTokens, _data);
506   }
507 
508   // Who'd have thought we'd need this thing floating around?
509   function totalSupply()
510   public
511   view
512   returns (uint256)
513   {
514     return tokenSupply;
515   }
516 
517   // Anyone can start the regular phase 2 weeks after the ICO phase starts.
518   // In case the devs die. Or something.
519   function publicStartRegularPhase()
520   public
521   {
522     require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
523 
524     icoPhase     = false;
525     regularPhase = true;
526   }
527 
528   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
529 
530 
531   // Fire the starting gun and then duck for cover.
532   function startICOPhase()
533   onlyAdministrator()
534   public
535   {
536     // Prevent us from startaring the ICO phase again
537     require(icoOpenTime == 0);
538     icoPhase = true;
539     icoOpenTime = now;
540   }
541 
542   // Fire the ... ending gun?
543   function endICOPhase()
544   onlyAdministrator()
545   public
546   {
547     icoPhase = false;
548   }
549 
550   function startRegularPhase()
551   onlyAdministrator
552   public
553   {
554     // disable ico phase in case if that was not disabled yet
555     icoPhase = false;
556     regularPhase = true;
557   }
558 
559   // The death of a great man demands the birth of a great son.
560   function setAdministrator(address _newAdmin, bool _status)
561   onlyAdministrator()
562   public
563   {
564     administrators[_newAdmin] = _status;
565   }
566 
567   function setStakingRequirement(uint _amountOfTokens)
568   onlyAdministrator()
569   public
570   {
571     // This plane only goes one way, lads. Never below the initial.
572     require (_amountOfTokens >= 100e18);
573     stakingRequirement = _amountOfTokens;
574   }
575 
576   function setName(string _name)
577   onlyAdministrator()
578   public
579   {
580     name = _name;
581   }
582 
583   function setSymbol(string _symbol)
584   onlyAdministrator()
585   public
586   {
587     symbol = _symbol;
588   }
589 
590   function changeBankroll(address _newBankrollAddress)
591   onlyAdministrator
592   public
593   {
594     bankrollAddress = _newBankrollAddress;
595   }
596 
597   /*----------  HELPERS AND CALCULATORS  ----------*/
598 
599   function totalEthereumBalance()
600   public
601   view
602   returns(uint)
603   {
604     return address(this).balance;
605   }
606 
607   function totalEthereumICOReceived()
608   public
609   view
610   returns(uint)
611   {
612     return ethInvestedDuringICO;
613   }
614 
615   /**
616    * Retrieves your currently selected dividend rate.
617    */
618   function getMyDividendRate()
619   public
620   view
621   returns(uint8)
622   {
623     address _customerAddress = msg.sender;
624     require(userSelectedRate[_customerAddress]);
625     return userDividendRate[_customerAddress];
626   }
627 
628   /**
629    * Retrieve the total frontend token supply
630    */
631   function getFrontEndTokenSupply()
632   public
633   view
634   returns(uint)
635   {
636     return tokenSupply;
637   }
638 
639   /**
640    * Retreive the total dividend token supply
641    */
642   function getDividendTokenSupply()
643   public
644   view
645   returns(uint)
646   {
647     return divTokenSupply;
648   }
649 
650   /**
651    * Retrieve the frontend tokens owned by the caller
652    */
653   function myFrontEndTokens()
654   public
655   view
656   returns(uint)
657   {
658     address _customerAddress = msg.sender;
659     return getFrontEndTokenBalanceOf(_customerAddress);
660   }
661 
662   /**
663    * Retrieve the dividend tokens owned by the caller
664    */
665   function myDividendTokens()
666   public
667   view
668   returns(uint)
669   {
670     address _customerAddress = msg.sender;
671     return getDividendTokenBalanceOf(_customerAddress);
672   }
673 
674   function myReferralDividends()
675   public
676   view
677   returns(uint)
678   {
679     return myDividends(true) - myDividends(false);
680   }
681 
682   function myDividends(bool _includeReferralBonus)
683   public
684   view
685   returns(uint)
686   {
687     address _customerAddress = msg.sender;
688     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
689   }
690 
691   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
692   public
693   view
694   returns(uint)
695   {
696     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
697   }
698 
699   function getFrontEndTokenBalanceOf(address _customerAddress)
700   view
701   public
702   returns(uint)
703   {
704     return frontTokenBalanceLedger_[_customerAddress];
705   }
706 
707   function balanceOf(address _owner)
708   view
709   public
710   returns(uint)
711   {
712     return getFrontEndTokenBalanceOf(_owner);
713   }
714 
715   function getDividendTokenBalanceOf(address _customerAddress)
716   view
717   public
718   returns(uint)
719   {
720     return dividendTokenBalanceLedger_[_customerAddress];
721   }
722 
723   function dividendsOf(address _customerAddress)
724   view
725   public
726   returns(uint)
727   {
728     return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
729   }
730 
731   // Get the sell price at the user's average dividend rate
732   function sellPrice()
733   public
734   view
735   returns(uint)
736   {
737     uint price;
738 
739     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
740       price = tokenPriceInitial_;
741     } else {
742 
743       // Calculate the tokens received for 100 finney.
744       // Divide to find the average, to calculate the price.
745       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
746 
747       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
748     }
749 
750     // Factor in the user's average dividend rate
751     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
752 
753     return theSellPrice;
754   }
755 
756   // Get the buy price at a particular dividend rate
757   function buyPrice(uint dividendRate)
758   public
759   view
760   returns(uint)
761   {
762     uint price;
763 
764     if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
765       price = tokenPriceInitial_;
766     } else {
767 
768       // Calculate the tokens received for 100 finney.
769       // Divide to find the average, to calculate the price.
770       uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
771 
772       price = (1e18 * 0.001 ether) / tokensReceivedForEth;
773     }
774 
775     // Factor in the user's selected dividend rate
776     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
777 
778     return theBuyPrice;
779   }
780 
781   function calculateTokensReceived(uint _ethereumToSpend)
782   public
783   view
784   returns(uint)
785   {
786     uint _dividends      = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
787     uint _taxedEthereum  = _ethereumToSpend.sub(_dividends);
788     uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
789     return  _amountOfTokens;
790   }
791 
792   // When selling tokens, we need to calculate the user's current dividend rate.
793   // This is different from their selected dividend rate.
794   function calculateEthereumReceived(uint _tokensToSell)
795   public
796   view
797   returns(uint)
798   {
799     require(_tokensToSell <= tokenSupply);
800     uint _ethereum               = tokensToEthereum_(_tokensToSell);
801     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
802     uint _dividends              = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
803     uint _taxedEthereum          = _ethereum.sub(_dividends);
804     return  _taxedEthereum;
805   }
806 
807   /*
808    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
809    * We multiply by magnitude to avoid precision errors.
810    */
811 
812   function getUserAverageDividendRate(address user) public view returns (uint) {
813     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
814   }
815 
816   function getMyAverageDividendRate() public view returns (uint) {
817     return getUserAverageDividendRate(msg.sender);
818   }
819 
820   /*==========================================
821   =            INTERNAL FUNCTIONS            =
822   ==========================================*/
823 
824   /* Purchase tokens with Ether.
825      During ICO phase, dividends should go to the bankroll
826      During normal operation:
827        0.5% should go to the master dividend card
828        0.5% should go to the matching dividend card
829        25% of dividends should go to the referrer, if any is provided. */
830   function purchaseTokens(uint _incomingEthereum, address _referredBy)
831   internal
832   returns(uint)
833   {
834     require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
835 
836     uint toBankRoll;
837     uint toReferrer;
838     uint toTokenHolders;
839     uint toDivCardHolders;
840 
841     uint dividendAmount;
842 
843     uint tokensBought;
844     uint dividendTokensBought;
845 
846     uint remainingEth = _incomingEthereum;
847 
848     uint fee;
849 
850     // 1% for dividend card holders is taken off before anything else
851     if (regularPhase) {
852       toDivCardHolders = _incomingEthereum.div(100);
853       remainingEth = remainingEth.sub(toDivCardHolders);
854     }
855 
856     /* Next, we tax for dividends:
857        Dividends = (ethereum * div%) / 100
858        Important note: if we're out of the ICO phase, the 1% sent to div-card holders
859                        is handled prior to any dividend taxes are considered. */
860 
861     // Grab the user's dividend rate
862     uint dividendRate = userDividendRate[msg.sender];
863 
864     // Calculate the total dividends on this buy
865     dividendAmount = (remainingEth.mul(dividendRate)).div(100);
866 
867     remainingEth   = remainingEth.sub(dividendAmount);
868 
869     // If we're in the ICO and bankroll is buying, don't tax
870     if (icoPhase && msg.sender == bankrollAddress) {
871       remainingEth = remainingEth + dividendAmount;
872     }
873 
874     // Calculate how many tokens to buy:
875     tokensBought         = ethereumToTokens_(remainingEth);
876     dividendTokensBought = tokensBought.mul(dividendRate);
877 
878     // This is where we actually mint tokens:
879     tokenSupply    = tokenSupply.add(tokensBought);
880     divTokenSupply = divTokenSupply.add(dividendTokensBought);
881 
882     /* Update the total investment tracker
883        Note that this must be done AFTER we calculate how many tokens are bought -
884        because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
885 
886     currentEthInvested = currentEthInvested + remainingEth;
887 
888     // If ICO phase, all the dividends go to the bankroll
889     if (icoPhase) {
890       toBankRoll     = dividendAmount;
891 
892       // If the bankroll is buying, we don't want to send eth back to the bankroll
893       // Instead, let's just give it the tokens it would get in an infinite recursive buy
894       if (msg.sender == bankrollAddress) {
895         toBankRoll = 0;
896       }
897 
898       toReferrer     = 0;
899       toTokenHolders = 0;
900 
901       /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
902          not how much Ether we get total.
903          this is so that our calculation using "investment" is accurate. */
904       ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
905       tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
906 
907       // Cannot purchase more than the hard cap during ICO.
908       require(ethInvestedDuringICO <= icoHardCap);
909       // Contracts aren't allowed to participate in the ICO.
910       require(tx.origin == msg.sender || msg.sender == bankrollAddress);
911 
912       // Cannot purchase more then the limit per address during the ICO.
913       ICOBuyIn[msg.sender] += remainingEth;
914       require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress);
915 
916       // Stop the ICO phase if we reach the hard cap
917       if (ethInvestedDuringICO == icoHardCap){
918         icoPhase = false;
919       }
920 
921     } else {
922       // Not ICO phase, check for referrals
923 
924       // 25% goes to referrers, if set
925       // toReferrer = (dividends * 25)/100
926       if (_referredBy != 0x0000000000000000000000000000000000000000 &&
927       _referredBy != msg.sender &&
928       frontTokenBalanceLedger_[_referredBy] >= stakingRequirement)
929       {
930         toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
931         referralBalance_[_referredBy] += toReferrer;
932         emit Referral(_referredBy, toReferrer);
933       }
934 
935       // The rest of the dividends go to token holders
936       toTokenHolders = dividendAmount.sub(toReferrer);
937 
938       fee = toTokenHolders * magnitude;
939       fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
940 
941       // Finally, increase the divToken value
942       profitPerDivToken       = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
943       payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
944     }
945 
946     // Update the buyer's token amounts
947     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
948     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
949 
950     // Transfer to bankroll and div cards
951     if (toBankRoll != 0) { ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)(); }
952     if (regularPhase) { divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate); }
953 
954     // This event should help us track where all the eth is going
955     emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
956 
957     // Sanity checking
958     uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth - _incomingEthereum;
959     assert(sum == 0);
960   }
961 
962   // How many tokens one gets from a certain amount of ethereum.
963   function ethereumToTokens_(uint _ethereumAmount)
964   public
965   view
966   returns(uint)
967   {
968     require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
969 
970     if (icoPhase) {
971       return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
972     }
973 
974     /*
975      *  i = investment, p = price, t = number of tokens
976      *
977      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
978      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
979      *
980      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
981      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
982      */
983 
984     // First, separate out the buy into two segments:
985     //  1) the amount of eth going towards ico-price tokens
986     //  2) the amount of eth going towards pyramid-price (variable) tokens
987     uint ethTowardsICOPriceTokens = 0;
988     uint ethTowardsVariablePriceTokens = 0;
989 
990     if (currentEthInvested >= ethInvestedDuringICO) {
991       // Option One: All the ETH goes towards variable-price tokens
992       ethTowardsVariablePriceTokens = _ethereumAmount;
993 
994     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
995       // Option Two: All the ETH goes towards ICO-price tokens
996       ethTowardsICOPriceTokens = _ethereumAmount;
997 
998     } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
999       // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
1000       ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
1001       ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
1002     } else {
1003       // Option Four: Should be impossible, and compiler should optimize it out of existence.
1004       revert();
1005     }
1006 
1007     // Sanity check:
1008     assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
1009 
1010     // Separate out the number of tokens of each type this will buy:
1011     uint icoPriceTokens = 0;
1012     uint varPriceTokens = 0;
1013 
1014     // Now calculate each one per the above formulas.
1015     // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
1016     if (ethTowardsICOPriceTokens != 0) {
1017       icoPriceTokens = ethTowardsICOPriceTokens.mul(1e18).div(tokenPriceInitial_);
1018     }
1019 
1020     if (ethTowardsVariablePriceTokens != 0) {
1021       // Note: we can't use "currentEthInvested" for this calculation, we must use:
1022       //  currentEthInvested + ethTowardsICOPriceTokens
1023       // This is because a split-buy essentially needs to simulate two separate buys -
1024       // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
1025 
1026       uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
1027       uint simulatedEthAfterInvested  = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
1028 
1029       /* We have the equations for total tokens above; note that this is for TOTAL.
1030          To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
1031          and the simulatedEthInvestedAfter and calculate the difference in tokens.
1032          This is how many we get. */
1033 
1034       uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
1035       uint tokensAfter  = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
1036 
1037       /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
1038          either should work.
1039 
1040          Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
1041          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
1042 
1043       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
1044     }
1045 
1046     uint totalTokensReceived = icoPriceTokens + varPriceTokens;
1047 
1048     assert(totalTokensReceived > 0);
1049     return totalTokensReceived;
1050   }
1051 
1052   // How much Ether we get from selling N tokens
1053   function tokensToEthereum_(uint _tokens)
1054   public
1055   view
1056   returns(uint)
1057   {
1058     require (_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
1059 
1060     /*
1061      *  i = investment, p = price, t = number of tokens
1062      *
1063      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1064      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1065      *
1066      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1067      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1068      */
1069 
1070     // First, separate out the sell into two segments:
1071     //  1) the amount of tokens selling at the ICO price.
1072     //  2) the amount of tokens selling at the variable (pyramid) price
1073     uint tokensToSellAtICOPrice = 0;
1074     uint tokensToSellAtVariablePrice = 0;
1075 
1076     if (tokenSupply <= tokensMintedDuringICO) {
1077       // Option One: All the tokens sell at the ICO price.
1078       tokensToSellAtICOPrice = _tokens;
1079 
1080     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
1081       // Option Two: All the tokens sell at the variable price.
1082       tokensToSellAtVariablePrice = _tokens;
1083 
1084     } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
1085       // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
1086       tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
1087       tokensToSellAtICOPrice      = _tokens.sub(tokensToSellAtVariablePrice);
1088 
1089     } else {
1090       // Option Four: Should be impossible, and the compiler should optimize it out of existence.
1091       revert();
1092     }
1093 
1094     // Sanity check:
1095     assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
1096 
1097     // Track how much Ether we get from selling at each price function:
1098     uint ethFromICOPriceTokens;
1099     uint ethFromVarPriceTokens;
1100 
1101     // Now, actually calculate:
1102 
1103     if (tokensToSellAtICOPrice != 0) {
1104 
1105       /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
1106          we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
1107          We need to divide by 1e18 or we'll have too much Ether. */
1108 
1109       ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
1110     }
1111 
1112     if (tokensToSellAtVariablePrice != 0) {
1113 
1114       /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
1115          This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
1116          Thus there isn't any weird stuff going on with the token supply.
1117 
1118          We have the equations for total investment above; note that this is for TOTAL.
1119          To get the eth received from this sell, we calculate the new total investment after this sell.
1120          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
1121 
1122       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
1123       uint investmentAfter  = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
1124 
1125       ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
1126     }
1127 
1128     uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
1129 
1130     assert(totalEthReceived > 0);
1131     return totalEthReceived;
1132   }
1133 
1134   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
1135   internal
1136   {
1137     require(regularPhase);
1138     require(_toAddress != address(0x0));
1139     address _customerAddress     = _from;
1140     uint _amountOfFrontEndTokens = _amountOfTokens;
1141 
1142     // Withdraw all outstanding dividends first (including those generated from referrals).
1143     if(theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
1144 
1145     // Calculate how many back-end dividend tokens to transfer.
1146     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
1147     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
1148 
1149     if (_customerAddress != msg.sender){
1150       // Update the allowed balance.
1151       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
1152       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
1153     }
1154 
1155     // Exchange tokens
1156     frontTokenBalanceLedger_[_customerAddress]    = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
1157     frontTokenBalanceLedger_[_toAddress]          = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
1158     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
1159     dividendTokenBalanceLedger_[_toAddress]       = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
1160 
1161     // Recipient inherits dividend percentage if they have not already selected one.
1162     if(!userSelectedRate[_toAddress])
1163     {
1164       userSelectedRate[_toAddress] = true;
1165       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
1166     }
1167 
1168     // Update dividend trackers
1169     payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
1170     payoutsTo_[_toAddress]       += (int256) (profitPerDivToken * _amountOfDivTokens);
1171 
1172     uint length;
1173 
1174     assembly {
1175       length := extcodesize(_toAddress)
1176     }
1177 
1178     if (length > 0){
1179       // its a contract
1180       // note: at ethereum update ALL addresses are contracts
1181       ERC223Receiving receiver = ERC223Receiving(_toAddress);
1182       receiver.tokenFallback(_from, _amountOfTokens, _data);
1183     }
1184 
1185     // Fire logging event.
1186     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
1187   }
1188 
1189   // Called from transferFrom. Always checks if _customerAddress has dividends.
1190   function withdrawFrom(address _customerAddress)
1191   internal
1192   {
1193     // Setup data
1194     uint _dividends                    = theDividendsOf(false, _customerAddress);
1195 
1196     // update dividend tracker
1197     payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
1198 
1199     // add ref. bonus
1200     _dividends                         += referralBalance_[_customerAddress];
1201     referralBalance_[_customerAddress]  = 0;
1202 
1203     _customerAddress.transfer(_dividends);
1204 
1205     // Fire logging event.
1206     emit onWithdraw(_customerAddress, _dividends);
1207   }
1208 
1209 
1210   /*=======================
1211    =    RESET FUNCTIONS   =
1212    ======================*/
1213 
1214   function injectEther()
1215   public
1216   payable
1217   onlyAdministrator
1218   {
1219 
1220   }
1221 
1222   /*=======================
1223    =   MATHS FUNCTIONS    =
1224    ======================*/
1225 
1226   function toPowerOfThreeHalves(uint x) public pure returns (uint) {
1227     // m = 3, n = 2
1228     // sqrt(x^3)
1229     return sqrt(x**3);
1230   }
1231 
1232   function toPowerOfTwoThirds(uint x) public pure returns (uint) {
1233     // m = 2, n = 3
1234     // cbrt(x^2)
1235     return cbrt(x**2);
1236   }
1237 
1238   function sqrt(uint x) public pure returns (uint y) {
1239     uint z = (x + 1) / 2;
1240     y = x;
1241     while (z < y) {
1242       y = z;
1243       z = (x / z + z) / 2;
1244     }
1245   }
1246 
1247   function cbrt(uint x) public pure returns (uint y) {
1248     uint z = (x + 1) / 3;
1249     y = x;
1250     while (z < y) {
1251       y = z;
1252       z = (x / (z*z) + 2 * z) / 3;
1253     }
1254   }
1255 }
1256 
1257 /*=======================
1258  =     INTERFACES       =
1259  ======================*/
1260 
1261 
1262 contract ZethrDividendCards {
1263   function ownerOf(uint /*_divCardId*/) public pure returns (address) {}
1264   function receiveDividends(uint /*_divCardRate*/) public payable {}
1265 }
1266 
1267 contract ZethrBankroll{
1268   function receiveDividends() public payable {}
1269 }
1270 
1271 
1272 contract ERC223Receiving {
1273   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
1274 }
1275 
1276 // Think it's safe to say y'all know what this is.
1277 
1278 library SafeMath {
1279 
1280   function mul(uint a, uint b) internal pure returns (uint) {
1281     if (a == 0) {
1282       return 0;
1283     }
1284     uint c = a * b;
1285     assert(c / a == b);
1286     return c;
1287   }
1288 
1289   function div(uint a, uint b) internal pure returns (uint) {
1290     // assert(b > 0); // Solidity automatically throws when dividing by 0
1291     uint c = a / b;
1292     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1293     return c;
1294   }
1295 
1296   function sub(uint a, uint b) internal pure returns (uint) {
1297     assert(b <= a);
1298     return a - b;
1299   }
1300 
1301   function add(uint a, uint b) internal pure returns (uint) {
1302     uint c = a + b;
1303     assert(c >= a);
1304     return c;
1305   }
1306 }