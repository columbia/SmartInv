1 pragma solidity 0.4.25;
2 
3 contract ERC20Interface {
4 
5   function totalSupply() public constant returns(uint);
6 
7   function balanceOf(address tokenOwner) public constant returns(uint balance);
8 
9   function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
10 
11   function transfer(address to, uint tokens) public returns(bool success);
12 
13   function approve(address spender, uint tokens) public returns(bool success);
14 
15   function transferFrom(address from, address to, uint tokens) public returns(bool success);
16   event Transfer(address indexed from, address indexed to, uint tokens);
17   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 
19 }
20 
21 contract _0xBitconnect {
22   using SafeMath
23   for uint;
24 
25   /*=================================
26   =            MODIFIERS            =
27   =================================*/
28 
29   modifier onlyHolders() {
30     require(myFrontEndTokens() > 0);
31     _;
32   }
33 
34   modifier dividendHolder() {
35     require(myDividends(true) > 0);
36     _;
37   }
38 
39   modifier onlyAdministrator() {
40     address _customerAddress = msg.sender;
41     require(administrators[_customerAddress]);
42     _;
43   }
44 
45   /*==============================
46   =            EVENTS            =
47   ==============================*/
48 
49   event onTokenPurchase(
50     address indexed customerAddress,
51     uint incoming,
52     uint8 dividendRate,
53     uint tokensMinted,
54     address indexed referredBy
55   );
56 
57   event UserDividendRate(
58     address user,
59     uint divRate
60   );
61 
62   event onTokenSell(
63     address indexed customerAddress,
64     uint tokensBurned,
65     uint earned
66   );
67 
68   event onReinvestment(
69     address indexed customerAddress,
70     uint reinvested,
71     uint tokensMinted
72   );
73 
74   event onWithdraw(
75     address indexed customerAddress,
76     uint withdrawn
77   );
78 
79   event Transfer(
80     address indexed from,
81     address indexed to,
82     uint tokens
83   );
84 
85   event Approval(
86     address indexed tokenOwner,
87     address indexed spender,
88     uint tokens
89   );
90 
91   event Allocation(
92     uint toBankRoll,
93     uint toReferrer,
94     uint toTokenHolders,
95     uint toDivCardHolders,
96     uint forTokens
97   );
98 
99   event Referral(
100     address referrer,
101     uint amountReceived
102   );
103 
104   /*=====================================
105   =            CONSTANTS                =
106   =====================================*/
107 
108   uint8 constant public decimals = 18;
109 
110   uint constant internal magnitude = 2 ** 64;
111 
112   uint constant internal MULTIPLIER = 1140;
113 
114   uint constant internal MIN_TOK_BUYIN = 0.0001 ether;
115   uint constant internal MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
116   uint constant internal MIN_TOKEN_TRANSFER = 1e10;
117   uint constant internal referrer_percentage = 25;
118   uint constant internal MAX_SUPPLY = 1e25;
119 
120   ERC20Interface internal _0xBTC;
121 
122   uint public stakingRequirement = 100e18;
123 
124   /*================================
125    =          CONFIGURABLES         =
126    ================================*/
127 
128   string public name = "0xBitconnect";
129   string public symbol = "0xBCC";
130 
131   address internal bankrollAddress;
132 
133   _0xBitconnectDividendCards divCardContract;
134 
135   /*================================
136    =            DATASETS            =
137    ================================*/
138 
139   // Tracks front & backend tokens
140   mapping(address => uint) internal frontTokenBalanceLedger_;
141   mapping(address => uint) internal dividendTokenBalanceLedger_;
142   mapping(address =>
143     mapping(address => uint))
144   public allowed;
145 
146   // Tracks dividend rates for users
147   mapping(uint8 => bool) internal validDividendRates_;
148   mapping(address => bool) internal userSelectedRate;
149   mapping(address => uint8) internal userDividendRate;
150 
151   // Payout tracking
152   mapping(address => uint) internal referralBalance_;
153   mapping(address => int256) internal payoutsTo_;
154 
155   uint public current0xbtcInvested;
156 
157   uint internal tokenSupply = 0;
158   uint internal divTokenSupply = 0;
159 
160   uint internal profitPerDivToken;
161 
162   mapping(address => bool) public administrators;
163 
164   bool public regularPhase = false;
165 
166   /*=======================================
167   =            PUBLIC FUNCTIONS           =
168   =======================================*/
169   constructor(address _bankrollAddress, address _divCardAddress, address _btcAddress)
170   public {
171     bankrollAddress = _bankrollAddress;
172     divCardContract = _0xBitconnectDividendCards(_divCardAddress);
173     _0xBTC = ERC20Interface(_btcAddress);
174 
175     administrators[msg.sender] = true; // Helps with debugging!
176 
177     validDividendRates_[10] = true;
178     validDividendRates_[20] = true;
179     validDividendRates_[30] = true;
180 
181     userSelectedRate[bankrollAddress] = true;
182     userDividendRate[bankrollAddress] = 30;
183 
184   /*=======================================
185   =             INITIAL HEAVEN            =
186   =======================================*/
187 
188     uint initiallyAssigned = 3*10**24;
189 
190     address heavenA = 0xA7cDc6cF8E8a4db39bc03ac675662D6E2F8F84f3;
191     address heavenB = 0xbC539A28e85c587987297da7039949eA23b51723;
192 
193     userSelectedRate[heavenA] = true;
194     userDividendRate[heavenA] = 30;
195 
196     userSelectedRate[heavenB] = true;
197     userDividendRate[heavenB] = 30;
198 
199     tokenSupply = tokenSupply.add(initiallyAssigned);
200     divTokenSupply = divTokenSupply.add(initiallyAssigned.mul(30));
201 
202     profitPerDivToken = profitPerDivToken.add((initiallyAssigned.mul(magnitude)).div(divTokenSupply));
203     
204     payoutsTo_[heavenA] += (int256)((profitPerDivToken * (initiallyAssigned.div(3)).mul(userDividendRate[heavenA])));
205     payoutsTo_[heavenB] += (int256)((profitPerDivToken * (initiallyAssigned.div(3)).mul(userDividendRate[heavenB])));
206     payoutsTo_[bankrollAddress] += (int256)((profitPerDivToken * (initiallyAssigned.div(3)).mul(userDividendRate[bankrollAddress])));
207 
208 
209     frontTokenBalanceLedger_[heavenA] = frontTokenBalanceLedger_[heavenA].add(initiallyAssigned.div(3));
210     dividendTokenBalanceLedger_[heavenA] = dividendTokenBalanceLedger_[heavenA].add((initiallyAssigned.div(3)).mul(userDividendRate[heavenA]));
211 
212     frontTokenBalanceLedger_[heavenB] = frontTokenBalanceLedger_[heavenB].add(initiallyAssigned.div(3));
213     dividendTokenBalanceLedger_[heavenB] = dividendTokenBalanceLedger_[heavenB].add((initiallyAssigned.div(3)).mul(userDividendRate[heavenB]));
214 
215     frontTokenBalanceLedger_[bankrollAddress] = frontTokenBalanceLedger_[bankrollAddress].add(initiallyAssigned.div(3));
216     dividendTokenBalanceLedger_[bankrollAddress] = dividendTokenBalanceLedger_[bankrollAddress].add((initiallyAssigned.div(3)).mul(userDividendRate[bankrollAddress]));
217 
218 
219   }
220 
221   /**
222    * Same as buy, but explicitly sets your dividend percentage.
223    * If this has been called before, it will update your `default' dividend
224    *   percentage for regular buy transactions going forward.
225    */
226   function buyAndSetDivPercentage(uint _0xbtcAmount, address _referredBy, uint8 _divChoice, string providedUnhashedPass)
227   public
228   returns(uint) {
229 
230     require(regularPhase);
231 
232     // Dividend percentage should be a currently accepted value.
233     require(validDividendRates_[_divChoice]);
234 
235     // Set the dividend fee percentage denominator.
236     userSelectedRate[msg.sender] = true;
237     userDividendRate[msg.sender] = _divChoice;
238     emit UserDividendRate(msg.sender, _divChoice);
239 
240     // Finally, purchase tokens.
241     purchaseTokens(_0xbtcAmount, _referredBy, false);
242   }
243 
244   // All buys except for the above one require regular phase.
245 
246   function buy(uint _0xbtcAmount, address _referredBy)
247   public
248   returns(uint) {
249     require(regularPhase);
250     address _customerAddress = msg.sender;
251     require(userSelectedRate[_customerAddress]);
252     purchaseTokens(_0xbtcAmount, _referredBy, false);
253   }
254 
255   function buyAndTransfer(uint _0xbtcAmount, address _referredBy, address target)
256   public {
257     bytes memory empty;
258     buyAndTransfer(_0xbtcAmount, _referredBy, target, empty, 20);
259   }
260 
261   function buyAndTransfer(uint _0xbtcAmount, address _referredBy, address target, bytes _data)
262   public {
263     buyAndTransfer(_0xbtcAmount, _referredBy, target, _data, 20);
264   }
265 
266   // Overload
267   function buyAndTransfer(uint _0xbtcAmount, address _referredBy, address target, bytes _data, uint8 divChoice)
268   public {
269     require(regularPhase);
270     address _customerAddress = msg.sender;
271     uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
272     if (userSelectedRate[_customerAddress] && divChoice == 0) {
273       purchaseTokens(_0xbtcAmount, _referredBy, false);
274     } else {
275       buyAndSetDivPercentage(_0xbtcAmount, _referredBy, divChoice, "0x0");
276     }
277     uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
278     transferTo(msg.sender, target, difference, _data);
279   }
280 
281   // No Fallback functionality
282   function () public {
283     revert();
284   }
285 
286   function reinvest()
287   dividendHolder()
288   public {
289     require(regularPhase);
290     uint _dividends = myDividends(false);
291 
292     // Pay out requisite `virtual' dividends.
293     address _customerAddress = msg.sender;
294     payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
295 
296     _dividends += referralBalance_[_customerAddress];
297     referralBalance_[_customerAddress] = 0;
298 
299     uint _tokens = purchaseTokens(_dividends.div(1e10), address(0), true); //to 8 Decimals
300 
301     // Fire logging event.
302     emit onReinvestment(_customerAddress, _dividends, _tokens);
303   }
304 
305   function exit()
306   public {
307     require(regularPhase);
308     // Retrieve token balance for caller, then sell them all.
309     address _customerAddress = msg.sender;
310     uint _tokens = frontTokenBalanceLedger_[_customerAddress];
311 
312     if (_tokens > 0) sell(_tokens);
313 
314     withdraw(_customerAddress);
315   }
316 
317   function withdraw(address _recipient)
318   dividendHolder()
319   public {
320     require(regularPhase);
321     // Setup data
322     address _customerAddress = msg.sender;
323     uint _dividends = myDividends(false);
324 
325     // update dividend tracker
326     payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
327 
328     // add ref. bonus
329     _dividends += referralBalance_[_customerAddress];
330     referralBalance_[_customerAddress] = 0;
331 
332     if (_recipient == address(0x0)) {
333       _recipient = msg.sender;
334     }
335 
336     _dividends = _dividends.div(1e10); //to 8 decimals
337     _0xBTC.transfer(_recipient, _dividends);
338 
339     // Fire logging event.
340     emit onWithdraw(_recipient, _dividends);
341   }
342 
343   // Sells front-end tokens.
344   function sell(uint _amountOfTokens)
345   onlyHolders()
346   public {
347     require(regularPhase);
348 
349     require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
350 
351     uint _frontEndTokensToBurn = _amountOfTokens;
352 
353     // Calculate how many dividend tokens this action burns.
354     // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
355     // As an additional guard, we ensure that the dividend rate is between 2 and 50 inclusive.
356     uint userDivRate = getUserAverageDividendRate(msg.sender);
357     require((2 * magnitude) <= userDivRate && (50 * magnitude) >= userDivRate);
358     uint _divTokensToBurn = (_frontEndTokensToBurn.mul(userDivRate)).div(magnitude);
359 
360     // Calculate 0xbtc received before dividends
361     uint _0xbtc = tokensTo0xbtc_(_frontEndTokensToBurn);
362 
363     if (_0xbtc > current0xbtcInvested) {
364       // Well, congratulations, you've emptied the coffers.
365       current0xbtcInvested = 0;
366     } else {
367       current0xbtcInvested = current0xbtcInvested - _0xbtc;
368     }
369 
370     // Calculate dividends generated from the sale.
371     uint _dividends = (_0xbtc.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
372 
373     // Calculate 0xbtc receivable net of dividends.
374     uint _taxed0xbtc = _0xbtc.sub(_dividends);
375 
376     // Burn the sold tokens (both front-end and back-end variants).
377     tokenSupply = tokenSupply.sub(_frontEndTokensToBurn);
378     divTokenSupply = divTokenSupply.sub(_divTokensToBurn);
379 
380     // Subtract the token balances for the seller
381     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
382     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
383 
384     // Update dividends tracker
385     int256 _updatedPayouts = (int256)(profitPerDivToken * _divTokensToBurn + (_taxed0xbtc * magnitude));
386     payoutsTo_[msg.sender] -= _updatedPayouts;
387 
388     // Let's avoid breaking arithmetic where we can, eh?
389     if (divTokenSupply > 0) {
390       // Update the value of each remaining back-end dividend token.
391       profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
392     }
393 
394     // Fire logging event.
395     emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxed0xbtc);
396   }
397 
398   /**
399    * Transfer tokens from the caller to a new holder.
400    * No charge incurred for the transfer. We'd make a terrible bank.
401    */
402   function transfer(address _toAddress, uint _amountOfTokens)
403   onlyHolders()
404   public
405   returns(bool) {
406     require(_amountOfTokens >= MIN_TOKEN_TRANSFER &&
407       _amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
408     bytes memory empty;
409     transferFromInternal(msg.sender, _toAddress, _amountOfTokens, empty);
410     return true;
411 
412   }
413 
414   function approve(address spender, uint tokens)
415   public
416   returns(bool) {
417     address _customerAddress = msg.sender;
418     allowed[_customerAddress][spender] = tokens;
419 
420     // Fire logging event.
421     emit Approval(_customerAddress, spender, tokens);
422 
423     // Good old ERC20.
424     return true;
425   }
426 
427   /**
428    * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
429    * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
430    */
431   function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
432   public
433   returns(bool) {
434     // Setup variables
435     address _customerAddress = _from;
436     bytes memory empty;
437     // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
438     // and are transferring at least one full token.
439     require(_amountOfTokens >= MIN_TOKEN_TRANSFER &&
440       _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress] &&
441       _amountOfTokens <= allowed[_customerAddress][msg.sender]);
442 
443     transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
444 
445     // Good old ERC20.
446     return true;
447 
448   }
449 
450   function transferTo(address _from, address _to, uint _amountOfTokens, bytes _data)
451   public {
452     if (_from != msg.sender) {
453       require(_amountOfTokens >= MIN_TOKEN_TRANSFER &&
454         _amountOfTokens <= frontTokenBalanceLedger_[_from] &&
455         _amountOfTokens <= allowed[_from][msg.sender]);
456     } else {
457       require(_amountOfTokens >= MIN_TOKEN_TRANSFER &&
458         _amountOfTokens <= frontTokenBalanceLedger_[_from]);
459     }
460 
461     transferFromInternal(_from, _to, _amountOfTokens, _data);
462   }
463 
464   // Who'd have thought we'd need this thing floating around?
465   function totalSupply()
466   public
467   view
468   returns(uint256) {
469     return tokenSupply;
470   }
471 
472   /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
473 
474   function startRegularPhase()
475   onlyAdministrator
476   public {
477     regularPhase = true;
478   }
479 
480   // The death of a great man demands the birth of a great son.
481   function setAdministrator(address _newAdmin, bool _status)
482   onlyAdministrator()
483   public {
484     administrators[_newAdmin] = _status;
485   }
486 
487   function setStakingRequirement(uint _amountOfTokens)
488   onlyAdministrator()
489   public {
490     // This plane only goes one way, lads. Never below the initial.
491     require(_amountOfTokens >= 100e18);
492     stakingRequirement = _amountOfTokens;
493   }
494 
495   function setName(string _name)
496   onlyAdministrator()
497   public {
498     name = _name;
499   }
500 
501   function setSymbol(string _symbol)
502   onlyAdministrator()
503   public {
504     symbol = _symbol;
505   }
506 
507   function changeBankroll(address _newBankrollAddress)
508   onlyAdministrator
509   public {
510     bankrollAddress = _newBankrollAddress;
511   }
512 
513   /*----------  HELPERS AND CALCULATORS  ----------*/
514 
515   function total0xbtcBalance()
516   public
517   view
518   returns(uint) {
519     return _0xBTC.balanceOf(address(this));
520   }
521 
522   function total0xbtcReceived()
523   public
524   view
525   returns(uint) {
526     return current0xbtcInvested;
527   }
528 
529   /**
530    * Retrieves your currently selected dividend rate.
531    */
532   function getMyDividendRate()
533   public
534   view
535   returns(uint8) {
536     address _customerAddress = msg.sender;
537     require(userSelectedRate[_customerAddress]);
538     return userDividendRate[_customerAddress];
539   }
540 
541   /**
542    * Retrieve the total frontend token supply
543    */
544   function getFrontEndTokenSupply()
545   public
546   view
547   returns(uint) {
548     return tokenSupply;
549   }
550 
551   /**
552    * Retreive the total dividend token supply
553    */
554   function getDividendTokenSupply()
555   public
556   view
557   returns(uint) {
558     return divTokenSupply;
559   }
560 
561   /**
562    * Retrieve the frontend tokens owned by the caller
563    */
564   function myFrontEndTokens()
565   public
566   view
567   returns(uint) {
568     address _customerAddress = msg.sender;
569     return getFrontEndTokenBalanceOf(_customerAddress);
570   }
571 
572   /**
573    * Retrieve the dividend tokens owned by the caller
574    */
575   function myDividendTokens()
576   public
577   view
578   returns(uint) {
579     address _customerAddress = msg.sender;
580     return getDividendTokenBalanceOf(_customerAddress);
581   }
582 
583   function myReferralDividends()
584   public
585   view
586   returns(uint) {
587     return myDividends(true) - myDividends(false);
588   }
589 
590   function myDividends(bool _includeReferralBonus)
591   public
592   view
593   returns(uint) {
594     address _customerAddress = msg.sender;
595     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
596   }
597 
598   function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
599   public
600   view
601   returns(uint) {
602     return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
603   }
604 
605   function getFrontEndTokenBalanceOf(address _customerAddress)
606   view
607   public
608   returns(uint) {
609     return frontTokenBalanceLedger_[_customerAddress];
610   }
611 
612   function balanceOf(address _owner)
613   view
614   public
615   returns(uint) {
616     return getFrontEndTokenBalanceOf(_owner);
617   }
618 
619   function getDividendTokenBalanceOf(address _customerAddress)
620   view
621   public
622   returns(uint) {
623     return dividendTokenBalanceLedger_[_customerAddress];
624   }
625 
626   function dividendsOf(address _customerAddress)
627   view
628   public
629   returns(uint) {
630     return (uint)((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
631   }
632 
633   // Get the sell price at the user's average dividend rate
634   function sellPrice()
635   public
636   view
637   returns(uint) {
638     uint price;
639 
640     // Calculate the tokens received for 0.001 0xbtc.
641     // Divide to find the average, to calculate the price.
642     uint tokensReceivedFor0xbtc = btcToTokens_(0.001 ether);
643 
644     price = (1e18 * 0.001 ether) / tokensReceivedFor0xbtc;
645 
646     // Factor in the user's average dividend rate
647     uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
648 
649     return theSellPrice;
650   }
651 
652   // Get the buy price at a particular dividend rate
653   function buyPrice(uint dividendRate)
654   public
655   view
656   returns(uint) {
657     uint price;
658 
659     // Calculate the tokens received for 100 finney.
660     // Divide to find the average, to calculate the price.
661     uint tokensReceivedFor0xbtc = btcToTokens_(0.001 ether);
662 
663     price = (1e18 * 0.001 ether) / tokensReceivedFor0xbtc;
664 
665     // Factor in the user's selected dividend rate
666     uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
667 
668     return theBuyPrice;
669   }
670 
671   function calculateTokensReceived(uint _0xbtcToSpend)
672   public
673   view
674   returns(uint) {
675     uint fixedAmount = _0xbtcToSpend.mul(1e10);
676     uint _dividends = (fixedAmount.mul(userDividendRate[msg.sender])).div(100);
677     uint _taxed0xbtc = fixedAmount.sub(_dividends);
678     uint _amountOfTokens = btcToTokens_(_taxed0xbtc);
679     return _amountOfTokens;
680   }
681 
682   // When selling tokens, we need to calculate the user's current dividend rate.
683   // This is different from their selected dividend rate.
684   function calculate0xbtcReceived(uint _tokensToSell)
685   public
686   view
687   returns(uint) {
688     require(_tokensToSell <= tokenSupply);
689     uint _0xbtc = tokensTo0xbtc_(_tokensToSell);
690     uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
691     uint _dividends = (_0xbtc.mul(userAverageDividendRate).div(100)).div(magnitude);
692     uint _taxed0xbtc = _0xbtc.sub(_dividends);
693     return _taxed0xbtc.div(1e10);
694   }
695 
696   /*
697    * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
698    * We multiply by magnitude to avoid precision errors.
699    */
700 
701   function getUserAverageDividendRate(address user) public view returns(uint) {
702     return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[user]);
703   }
704 
705   function getMyAverageDividendRate() public view returns(uint) {
706     return getUserAverageDividendRate(msg.sender);
707   }
708 
709   /*==========================================
710   =            INTERNAL FUNCTIONS            =
711   ==========================================*/
712 
713   /* Purchase tokens with 0xbtc.
714      During normal operation:
715        0.5% should go to the master dividend card
716        0.5% should go to the matching dividend card
717        25% of dividends should go to the referrer, if any is provided. */
718   function purchaseTokens(uint _incoming, address _referredBy, bool _reinvest)
719   internal
720   returns(uint) {
721 
722     require(_incoming.mul(1e10) >= MIN_TOK_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min 0xbtc buyin threshold.");
723 
724     uint toReferrer;
725     uint toTokenHolders;
726     uint toDivCardHolders;
727 
728     uint dividendAmount;
729 
730     uint tokensBought;
731 
732     uint remaining0xbtc = _incoming.mul(1e10);
733 
734     uint fee;
735 
736     // 1% for dividend card holders is taken off before anything else
737     if (regularPhase) {
738       toDivCardHolders = _incoming.mul(1e8);
739       remaining0xbtc = remaining0xbtc.sub(toDivCardHolders);
740     }
741 
742     /* Next, we tax for dividends:
743        Dividends = (0xbtc * div%) / 100
744        Important note: the 1% sent to div-card holders
745                        is handled prior to any dividend taxes are considered. */
746 
747     // Calculate the total dividends on this buy
748     dividendAmount = (remaining0xbtc.mul(userDividendRate[msg.sender])).div(100);
749 
750     remaining0xbtc = remaining0xbtc.sub(dividendAmount);
751 
752     // Calculate how many tokens to buy:
753     tokensBought = btcToTokens_(remaining0xbtc);
754 
755     // This is where we actually mint tokens:
756     require(tokenSupply.add(tokensBought) <= MAX_SUPPLY);
757     tokenSupply = tokenSupply.add(tokensBought);
758     divTokenSupply = divTokenSupply.add(tokensBought.mul(userDividendRate[msg.sender]));
759 
760     /* Update the total investment tracker
761        Note that this must be done AFTER we calculate how many tokens are bought -
762        because btcToTokens needs to know the amount *before* investment, not *after* investment. */
763 
764     current0xbtcInvested = current0xbtcInvested + remaining0xbtc;
765 
766     // Ccheck for referrals
767 
768     // 25% goes to referrers, if set
769     // toReferrer = (dividends * 25)/100
770     if (_referredBy != 0x0000000000000000000000000000000000000000 &&
771       _referredBy != msg.sender &&
772       frontTokenBalanceLedger_[_referredBy] >= stakingRequirement) {
773       toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
774       referralBalance_[_referredBy] += toReferrer;
775       emit Referral(_referredBy, toReferrer);
776     }
777 
778     // The rest of the dividends go to token holders
779     toTokenHolders = dividendAmount.sub(toReferrer);
780 
781     fee = toTokenHolders * magnitude;
782     fee = fee - (fee - (tokensBought.mul(userDividendRate[msg.sender]) * (toTokenHolders * magnitude / (divTokenSupply))));
783 
784     // Finally, increase the divToken value
785     profitPerDivToken = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
786     payoutsTo_[msg.sender] += (int256)((profitPerDivToken * tokensBought.mul(userDividendRate[msg.sender])) - fee);
787 
788     // Update the buyer's token amounts
789     frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
790     dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(tokensBought.mul(userDividendRate[msg.sender]));
791 
792     if (_reinvest == false) {
793       //Lets receive the 0xbtc
794       _0xBTC.transferFrom(msg.sender, address(this), _incoming);
795     }
796 
797     // Transfer to div cards
798     if (regularPhase) {
799       _0xBTC.approve(address(divCardContract), toDivCardHolders.div(1e10));
800       divCardContract.receiveDividends(toDivCardHolders.div(1e10), userDividendRate[msg.sender]);
801     }
802 
803     // This event should help us track where all the 0xbtc is going
804     emit Allocation(0, toReferrer, toTokenHolders, toDivCardHolders, remaining0xbtc);
805 
806     emit onTokenPurchase(msg.sender, _incoming, userDividendRate[msg.sender], tokensBought, _referredBy);
807 
808     // Sanity checking
809     uint sum = toReferrer + toTokenHolders + toDivCardHolders + remaining0xbtc - _incoming.mul(1e10);
810     assert(sum == 0);
811   }
812 
813   // How many tokens one gets from a certain amount of 0xbtc.
814   function btcToTokens_(uint _0xbtcAmount)
815   public
816   view
817   returns(uint) {
818 
819     //0xbtcAmount expected as 18 decimals instead of 8
820 
821     require(_0xbtcAmount > MIN_TOK_BUYIN, "Tried to buy tokens with too little 0xbtc.");
822 
823     uint _0xbtcTowardsVariablePriceTokens = _0xbtcAmount;
824 
825     uint varPriceTokens = 0;
826 
827     if (_0xbtcTowardsVariablePriceTokens != 0) {
828 
829       uint simulated0xbtcBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
830       uint simulated0xbtcAfterInvested = simulated0xbtcBeforeInvested + _0xbtcTowardsVariablePriceTokens;
831 
832       uint tokensBefore = toPowerOfTwoThirds(simulated0xbtcBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
833       uint tokensAfter = toPowerOfTwoThirds(simulated0xbtcAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
834 
835       /*  Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
836          we need to multiply the result by 1e6 to get back to the correct number of decimals. */
837 
838       varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
839     }
840 
841     uint totalTokensReceived = varPriceTokens;
842 
843     assert(totalTokensReceived > 0);
844     return totalTokensReceived;
845   }
846 
847   // How much 0xBTC we get from selling N tokens
848   function tokensTo0xbtc_(uint _tokens)
849   public
850   view
851   returns(uint) {
852     require(_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
853 
854     /*
855      *  i = investment, p = price, t = number of tokens
856      *
857      *  i_current = p_initial * t_current                   (for t_current <= t_initial)
858      *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
859      *
860      *  t_current = i_current / p_initial                   (for i_current <= i_initial)
861      *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
862      */
863 
864     uint tokensToSellAtVariablePrice = _tokens;
865 
866     uint _0xbtcFromVarPriceTokens;
867 
868     // Now, actually calculate:
869 
870     if (tokensToSellAtVariablePrice != 0) {
871 
872       /* Note: Unlike the sister function in btcToTokens, we don't have to calculate any "virtual" token count.
873 
874          We have the equations for total investment above; note that this is for TOTAL.
875          To get the 0xbtc received from this sell, we calculate the new total investment after this sell.
876          Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in btcToTokens. */
877 
878       uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
879       uint investmentAfter = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
880 
881       _0xbtcFromVarPriceTokens = investmentBefore.sub(investmentAfter);
882     }
883 
884     uint _0xbtcReceived = _0xbtcFromVarPriceTokens;
885 
886     assert(_0xbtcReceived > 0);
887     return _0xbtcReceived;
888   }
889 
890   function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
891   internal {
892     require(regularPhase);
893     require(_toAddress != address(0x0));
894     address _customerAddress = _from;
895     uint _amountOfFrontEndTokens = _amountOfTokens;
896 
897     // Withdraw all outstanding dividends first (including those generated from referrals).
898     if (theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
899 
900     // Calculate how many back-end dividend tokens to transfer.
901     // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
902     uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
903 
904     if (_customerAddress != msg.sender) {
905       // Update the allowed balance.
906       // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
907       allowed[_customerAddress][msg.sender] -= _amountOfTokens;
908     }
909 
910     // Exchange tokens
911     frontTokenBalanceLedger_[_customerAddress] = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
912     frontTokenBalanceLedger_[_toAddress] = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
913     dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
914     dividendTokenBalanceLedger_[_toAddress] = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
915 
916     // Recipient inherits dividend percentage if they have not already selected one.
917     if (!userSelectedRate[_toAddress]) {
918       userSelectedRate[_toAddress] = true;
919       userDividendRate[_toAddress] = userDividendRate[_customerAddress];
920     }
921 
922     // Update dividend trackers
923     payoutsTo_[_customerAddress] -= (int256)(profitPerDivToken * _amountOfDivTokens);
924     payoutsTo_[_toAddress] += (int256)(profitPerDivToken * _amountOfDivTokens);
925 
926     uint length;
927 
928     assembly {
929       length: = extcodesize(_toAddress)
930     }
931 
932     if (length > 0) {
933       // its a contract
934       // note: at ethereum update ALL addresses are contracts
935       ERC223Receiving receiver = ERC223Receiving(_toAddress);
936       receiver.tokenFallback(_from, _amountOfTokens, _data);
937     }
938 
939     // Fire logging event.
940     emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
941   }
942 
943   // Called from transferFrom. Always checks if _customerAddress has dividends.
944   function withdrawFrom(address _customerAddress)
945   internal {
946     // Setup data
947     uint _dividends = theDividendsOf(false, _customerAddress);
948 
949     // update dividend tracker
950     payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
951 
952     // add ref. bonus
953     _dividends += referralBalance_[_customerAddress];
954     referralBalance_[_customerAddress] = 0;
955 
956     _dividends = _dividends.div(1e10); //to 8 decimals
957     _0xBTC.transfer(_customerAddress, _dividends); //8 decimals correction
958 
959     // Fire logging event.
960     emit onWithdraw(_customerAddress, _dividends);
961   }
962 
963   /*=======================
964    =   MATHS FUNCTIONS    =
965    ======================*/
966 
967   function toPowerOfThreeHalves(uint x) public pure returns(uint) {
968     // m = 3, n = 2
969     // sqrt(x^3)
970     return sqrt(x ** 3);
971   }
972 
973   function toPowerOfTwoThirds(uint x) public pure returns(uint) {
974     // m = 2, n = 3
975     // cbrt(x^2)
976     return cbrt(x ** 2);
977   }
978 
979   function sqrt(uint x) public pure returns(uint y) {
980     uint z = (x + 1) / 2;
981     y = x;
982     while (z < y) {
983       y = z;
984       z = (x / z + z) / 2;
985     }
986   }
987 
988   function cbrt(uint x) public pure returns(uint y) {
989     uint z = (x + 1) / 3;
990     y = x;
991     while (z < y) {
992       y = z;
993       z = (x / (z * z) + 2 * z) / 3;
994     }
995   }
996 }
997 
998 /*=======================
999  =     INTERFACES       =
1000  ======================*/
1001 
1002 
1003 interface _0xBitconnectDividendCards {
1004   function ownerOf(uint /*_divCardId*/ ) external pure returns(address);
1005 
1006   function receiveDividends(uint amount, uint divCardRate) external;
1007 }
1008 
1009 interface _0xBitconnectBankroll {
1010   function receiveDividends(uint amount) external;
1011 }
1012 
1013 
1014 interface ERC223Receiving {
1015   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) external returns(bool);
1016 }
1017 
1018 // Think it's safe to say y'all know what this is.
1019 
1020 library SafeMath {
1021 
1022   function mul(uint a, uint b) internal pure returns(uint) {
1023     if (a == 0) {
1024       return 0;
1025     }
1026     uint c = a * b;
1027     assert(c / a == b);
1028     return c;
1029   }
1030 
1031   function div(uint a, uint b) internal pure returns(uint) {
1032     // assert(b > 0); // Solidity automatically throws when dividing by 0
1033     uint c = a / b;
1034     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1035     return c;
1036   }
1037 
1038   function sub(uint a, uint b) internal pure returns(uint) {
1039     assert(b <= a);
1040     return a - b;
1041   }
1042 
1043   function add(uint a, uint b) internal pure returns(uint) {
1044     uint c = a + b;
1045     assert(c >= a);
1046     return c;
1047   }
1048 }