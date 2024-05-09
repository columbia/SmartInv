1 pragma solidity ^0.4.23;
2 
3 /**
4 
5                           ███████╗███████╗████████╗██╗  ██╗██████╗
6                           ╚══███╔╝██╔════╝╚══██╔══╝██║  ██║██╔══██╗
7                             ███╔╝ █████╗     ██║   ███████║██████╔╝
8                            ███╔╝  ██╔══╝     ██║   ██╔══██║██╔══██╗
9                           ███████╗███████╗   ██║   ██║  ██║██║  ██║
10                           ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
11 
12 
13 .------..------.     .------..------..------.     .------..------..------..------..------.
14 |B.--. ||E.--. |.-.  |T.--. ||H.--. ||E.--. |.-.  |H.--. ||O.--. ||U.--. ||S.--. ||E.--. |
15 | :(): || (\/) (( )) | :/\: || :/\: || (\/) (( )) | :/\: || :/\: || (\/) || :/\: || (\/) |
16 | ()() || :\/: |'-.-.| (__) || (__) || :\/: |'-.-.| (__) || :\/: || :\/: || :\/: || :\/: |
17 | '--'B|| '--'E| (( )) '--'T|| '--'H|| '--'E| (( )) '--'H|| '--'O|| '--'U|| '--'S|| '--'E|
18 `------'`------'  '-'`------'`------'`------'  '-'`------'`------'`------'`------'`------'
19 
20 An interactive, variable-dividend rate contract with an ICO-capped price floor and collectibles.
21 
22 Launched at 00:00 GMT on 12th May 2018.
23 
24 Credits
25 =======
26 
27 Analysis:
28     blurr
29     Randall
30 
31 Contract Developers:
32     Etherguy
33     klob
34     Norsefire
35 
36 Front-End Design:
37     cryptodude
38     oguzhanox
39     TropicalRogue
40 
41 **/
42 
43 contract Zethr {
44     using SafeMath for uint;
45 
46     /*=================================
47     =            MODIFIERS            =
48     =================================*/
49 
50     modifier onlyHolders() {
51         require(myFrontEndTokens() > 0);
52         _;
53     }
54 
55     modifier dividendHolder() {
56         require(myDividends(true) > 0);
57         _;
58     }
59 
60     modifier onlyAdministrator(){
61         address _customerAddress = msg.sender;
62         require(administrators[_customerAddress]);
63         _;
64     }
65 
66     /*==============================
67     =            EVENTS            =
68     ==============================*/
69 
70     event onTokenPurchase(
71         address indexed customerAddress,
72         uint incomingEthereum,
73         uint tokensMinted,
74         address indexed referredBy
75     );
76 
77     event onTokenSell(
78         address indexed customerAddress,
79         uint tokensBurned,
80         uint ethereumEarned
81     );
82 
83     event onReinvestment(
84         address indexed customerAddress,
85         uint ethereumReinvested,
86         uint tokensMinted
87     );
88 
89     event onWithdraw(
90         address indexed customerAddress,
91         uint ethereumWithdrawn
92     );
93 
94     event Transfer(
95         address indexed from,
96         address indexed to,
97         uint tokens
98     );
99 
100     event Approval(
101         address indexed tokenOwner,
102         address indexed spender,
103         uint tokens
104     );
105 
106     event Allocation(
107         uint toBankRoll,
108         uint toReferrer,
109         uint toTokenHolders,
110         uint toDivCardHolders,
111         uint forTokens
112     );
113 
114     /*=====================================
115     =            CONSTANTS                =
116     =====================================*/
117 
118     uint8 constant public                decimals              = 18;
119 
120     uint constant internal               tokenPriceInitial_    = 0.000653 ether;
121     uint constant internal               magnitude             = 2**64;
122 
123     uint constant internal               icoHardCap            = 250 ether;
124     uint constant internal               addressICOLimit       = 2   ether;
125     uint constant internal               icoMinBuyIn           = 0.1 finney;
126     uint constant internal               icoMaxGasPrice        = 50000000000 wei;
127 
128     uint constant internal               MULTIPLIER            = 9615;
129 
130     uint constant internal               MIN_ETH_BUYIN         = 0.0001 ether;
131     uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;
132     uint constant internal               MIN_TOKEN_TRANSFER    = 1e18;
133     uint constant internal               referrer_percentage   = 25;
134 
135     uint public                          stakingRequirement    = 100e18;
136 
137    /*================================
138     =          CONFIGURABLES         =
139     ================================*/
140 
141     string public                        name               = "Zethr";
142     string public                        symbol             = "ZTH";
143     bytes32 constant public              icoHashedPass      = bytes32(0x5d26626a83a2e04be8eab07b75694b6534206d3a4672e8233deea56d00190471);
144 
145     address internal                     bankrollAddress;
146 
147     ZethrDividendCards                   divCardContract;
148 
149    /*================================
150     =            DATASETS            =
151     ================================*/
152 
153     // Tracks front & backend tokens
154     mapping(address => uint) internal    frontTokenBalanceLedger_;
155     mapping(address => uint) internal    dividendTokenBalanceLedger_;
156     mapping(address =>
157         mapping (address => uint))
158                              internal    allowed;
159 
160     // Tracks dividend rates for users
161     mapping(uint8   => bool)    internal validDividendRates_;
162     mapping(address => bool)    internal userSelectedRate;
163     mapping(address => uint8)   internal userDividendRate;
164 
165     // Payout tracking
166     mapping(address => uint)    internal referralBalance_;
167     mapping(address => int256)  internal payoutsTo_;
168 
169     // ICO per-address limit tracking
170     mapping(address => uint)    internal ICOBuyIn;
171 
172     uint public                          tokensMintedDuringICO;
173     uint public                          ethInvestedDuringICO;
174 
175     uint public                          currentEthInvested;
176 
177     uint internal                        tokenSupply    = 0;
178     uint internal                        divTokenSupply = 0;
179 
180     uint internal                        profitPerDivToken;
181 
182     mapping(address => bool) public      administrators;
183 
184     bool public                          icoPhase     = false;
185     bool public                          regularPhase = false;
186 
187     uint                                 icoOpenTime;
188 
189     /*=======================================
190     =            PUBLIC FUNCTIONS            =
191     =======================================*/
192     /*
193     * -- APPLICATION ENTRY POINTS --
194     */
195     constructor (address _bankrollAddress, address _divCardAddress)
196         public
197     {
198         bankrollAddress = _bankrollAddress;
199         divCardContract = ZethrDividendCards(_divCardAddress);
200 
201         administrators[0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae] = true; // Norsefire
202         administrators[0x11e52c75998fe2E7928B191bfc5B25937Ca16741] = true; // klob
203         administrators[0x20C945800de43394F70D789874a4daC9cFA57451] = true; // Etherguy
204         administrators[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = true; // blurr
205 
206         validDividendRates_[2] = true;
207         validDividendRates_[5] = true;
208         validDividendRates_[10] = true;
209         validDividendRates_[15] = true;
210         validDividendRates_[20] = true;
211         validDividendRates_[25] = true;
212         validDividendRates_[33] = true;
213 
214         userSelectedRate[bankrollAddress] = true;
215         userDividendRate[bankrollAddress] = 33;
216 
217     }
218 
219     /**
220      * Same as buy, but explicitly sets your dividend percentage.
221      * If this has been called before, it will update your `default' dividend
222      *   percentage for regular buy transactions going forward.
223      */
224     function buyAndSetDivPercentage(address _referredBy, uint8 _divChoice, string providedUnhashedPass)
225         public
226         payable
227         returns (uint)
228     {
229         require(icoPhase || regularPhase);
230 
231         if (icoPhase) {
232 
233             // This should slow down the ICO scripters a bit
234             // The password will be embedded in the website when we go live
235             // This will be invisible to those buying in through the website
236             bytes32 hashedProvidedPass = keccak256(providedUnhashedPass);
237             require(hashedProvidedPass == icoHashedPass);
238 
239 
240             uint gasPrice = tx.gasprice;
241 
242             // Prevents ICO buyers from getting substantially burned if the ICO is reached
243             //   before their transaction is processed.
244             require(gasPrice <= icoMaxGasPrice && ethInvestedDuringICO <= icoHardCap);
245 
246         }
247 
248         // Dividend percentage should be a currently accepted value.
249         require (validDividendRates_[_divChoice]);
250 
251         // Set the dividend fee percentage denominator.
252         userSelectedRate[msg.sender] = true;
253         userDividendRate[msg.sender] = _divChoice;
254 
255         // Finally, purchase tokens.
256         purchaseTokens(msg.value, _referredBy);
257     }
258 
259     function buy(address _referredBy)
260         public
261         payable
262         returns(uint)
263     {
264         require(icoPhase || regularPhase);
265         address _customerAddress = msg.sender;
266         require (userSelectedRate[_customerAddress]);
267         purchaseTokens(msg.value, _referredBy);
268     }
269 
270     function()
271         payable
272         public
273     {
274         /**
275         / If the user has previously set a dividend rate, sending
276         /   Ether directly to the contract simply purchases more at
277         /   the most recent rate. If this is their first time, they
278         /   are automatically placed into the 20% rate `bucket'.
279         **/
280         require(icoPhase || regularPhase);
281         address _customerAddress = msg.sender;
282         if (userSelectedRate[_customerAddress]) {
283             purchaseTokens(msg.value, 0x0);
284         } else {
285             buyAndSetDivPercentage(0x0, 20, "0x0");
286         }
287     }
288 
289     function reinvest()
290         dividendHolder()
291         public
292     {
293         require(regularPhase);
294         uint _dividends = myDividends(false);
295 
296         // Pay out requisite `virtual' dividends.
297         address _customerAddress            = msg.sender;
298         payoutsTo_[_customerAddress]       += (int256) (_dividends * magnitude);
299 
300         _dividends                         += referralBalance_[_customerAddress];
301         referralBalance_[_customerAddress]  = 0;
302 
303         uint _tokens                        = purchaseTokens(_dividends, 0x0);
304 
305         // Fire logging event.
306         emit onReinvestment(_customerAddress, _dividends, _tokens);
307     }
308 
309     function exit()
310         public
311     {
312         require(regularPhase);
313         // Retrieve token balance for caller, then sell them all.
314         address _customerAddress = msg.sender;
315         uint _tokens             = frontTokenBalanceLedger_[_customerAddress];
316 
317         if(_tokens > 0) sell(_tokens);
318 
319         withdraw(_customerAddress);
320     }
321 
322     function withdraw(address _recipient)
323         dividendHolder()
324         public
325     {
326         require(regularPhase);
327         // Setup data
328         address _customerAddress           = msg.sender;
329         uint _dividends                    = myDividends(false);
330 
331         // update dividend tracker
332         payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
333 
334         // add ref. bonus
335         _dividends                         += referralBalance_[_customerAddress];
336         referralBalance_[_customerAddress]  = 0;
337 
338         if (_recipient == address(0x0)){
339             _recipient = msg.sender;
340         }
341         _recipient.transfer(_dividends);
342 
343         // Fire logging event.
344         emit onWithdraw(_recipient, _dividends);
345     }
346 
347     // Sells front-end tokens.
348     // Logic concerning step-pricing of tokens pre/post-ICO is encapsulated in tokensToEthereum_.
349     function sell(uint _amountOfTokens)
350         onlyHolders()
351         public
352     {
353         // No selling during the ICO. You don't get to flip that fast, sorry!
354         require(!icoPhase);
355         require(regularPhase);
356 
357         require(_amountOfTokens <= frontTokenBalanceLedger_[msg.sender]);
358 
359         uint _frontEndTokensToBurn = _amountOfTokens;
360 
361         // Calculate how many dividend tokens this action burns.
362         // Computed as the caller's average dividend rate multiplied by the number of front-end tokens held.
363         uint _divTokensToBurn = (_frontEndTokensToBurn.mul(getUserAverageDividendRate(msg.sender))).div(magnitude);
364 
365         // Calculate ethereum received before dividends
366         uint _ethereum = tokensToEthereum_(_frontEndTokensToBurn);
367 
368         if (_ethereum > currentEthInvested){
369             // Well, congratulations, you've emptied the coffers.
370             currentEthInvested = 0;
371         } else { currentEthInvested = currentEthInvested - _ethereum; }
372 
373         // Calculate dividends generated from the sale.
374         uint _dividends = (_ethereum.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude);
375 
376         // Calculate Ethereum receivable net of dividends.
377         uint _taxedEthereum = _ethereum.sub(_dividends);
378 
379         // Burn the sold tokens (both front-end and back-end variants).
380         tokenSupply         = tokenSupply.sub(_frontEndTokensToBurn);
381         divTokenSupply      = divTokenSupply.sub(_divTokensToBurn);
382 
383         // Subtract the token balances for the seller
384         frontTokenBalanceLedger_[msg.sender]    = frontTokenBalanceLedger_[msg.sender].sub(_frontEndTokensToBurn);
385         dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].sub(_divTokensToBurn);
386 
387         // Update dividends tracker
388         int256 _updatedPayouts  = (int256) (profitPerDivToken * _divTokensToBurn + (_taxedEthereum * magnitude));
389         payoutsTo_[msg.sender] -= _updatedPayouts;
390 
391         // Let's avoid breaking arithmetic where we can, eh?
392         if (divTokenSupply > 0) {
393             // Update the value of each remaining back-end dividend token.
394             profitPerDivToken = profitPerDivToken.add((_dividends * magnitude) / divTokenSupply);
395         }
396 
397         // Fire logging event.
398         emit onTokenSell(msg.sender, _frontEndTokensToBurn, _taxedEthereum);
399     }
400 
401     /**
402      * Transfer tokens from the caller to a new holder.
403      * No charge incurred for the transfer. We'd make a terrible bank.
404      */
405     function transfer(address _toAddress, uint _amountOfTokens)
406         onlyHolders()
407         public
408         returns(bool)
409     {
410         require(regularPhase);
411         // Setup variables
412         address _customerAddress     = msg.sender;
413         uint _amountOfFrontEndTokens = _amountOfTokens;
414 
415         // Make sure we own the tokens we're transferring, and are transferring at least one full token.
416         require(_amountOfTokens >= MIN_TOKEN_TRANSFER
417              && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]);
418 
419         // Withdraw all outstanding dividends first (including those generated from referrals).
420         if(myDividends(true) > 0) withdraw(_customerAddress);
421 
422         // Calculate how many back-end dividend tokens to transfer.
423         // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
424         uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
425 
426         // Exchange tokens
427         frontTokenBalanceLedger_[_customerAddress]    = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
428         frontTokenBalanceLedger_[_toAddress]          = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
429         dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
430         dividendTokenBalanceLedger_[_toAddress]       = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
431 
432         // Recipient inherits dividend percentage if they have not already selected one.
433         if(!userSelectedRate[_toAddress])
434         {
435             userSelectedRate[_toAddress] = true;
436             userDividendRate[_toAddress] = userDividendRate[_customerAddress];
437         }
438 
439         // Update dividend trackers
440         payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
441         payoutsTo_[_toAddress]       += (int256) (profitPerDivToken * _amountOfDivTokens);
442 
443         // Fire logging event.
444         emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
445 
446         // Good old ERC20.
447         return true;
448 
449     }
450 
451     function approve(address spender, uint tokens)
452         public
453         returns (bool)
454     {
455         address _customerAddress           = msg.sender;
456         allowed[_customerAddress][spender] = tokens;
457 
458         // Fire logging event.
459         emit Approval(_customerAddress, spender, tokens);
460 
461         // Good old ERC20.
462         return true;
463     }
464 
465     /**
466      * Transfer tokens from the caller to a new holder: the Used By Smart Contracts edition.
467      * No charge incurred for the transfer. No seriously, we'd make a terrible bank.
468      */
469     function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
470         public
471         returns(bool)
472     {
473         require(regularPhase);
474         // Setup variables
475         address _customerAddress     = _from;
476         uint _amountOfFrontEndTokens = _amountOfTokens;
477 
478         // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
479         // and are transferring at least one full token.
480         require(_amountOfTokens >= MIN_TOKEN_TRANSFER
481              && _amountOfTokens <= frontTokenBalanceLedger_[_customerAddress]
482              && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
483 
484         // Withdraw all outstanding dividends first (including those generated from referrals).
485         if(theDividendsOf(true, _customerAddress) > 0) withdrawFrom(_customerAddress);
486 
487         // Calculate how many back-end dividend tokens to transfer.
488         // This amount is proportional to the caller's average dividend rate multiplied by the proportion of tokens being transferred.
489         uint _amountOfDivTokens = _amountOfFrontEndTokens.mul(getUserAverageDividendRate(_customerAddress)).div(magnitude);
490 
491         // Update the allowed balance.
492         allowed[_customerAddress][msg.sender] -= _amountOfTokens;
493 
494         // Exchange tokens
495         frontTokenBalanceLedger_[_customerAddress]    = frontTokenBalanceLedger_[_customerAddress].sub(_amountOfFrontEndTokens);
496         frontTokenBalanceLedger_[_toAddress]          = frontTokenBalanceLedger_[_toAddress].add(_amountOfFrontEndTokens);
497         dividendTokenBalanceLedger_[_customerAddress] = dividendTokenBalanceLedger_[_customerAddress].sub(_amountOfDivTokens);
498         dividendTokenBalanceLedger_[_toAddress]       = dividendTokenBalanceLedger_[_toAddress].add(_amountOfDivTokens);
499 
500         // Recipient inherits dividend percentage if they have not already selected one.
501         if(!userSelectedRate[_toAddress])
502         {
503             userSelectedRate[_toAddress] = true;
504             userDividendRate[_toAddress] = userDividendRate[_customerAddress];
505         }
506 
507         // Update dividend trackers
508         payoutsTo_[_customerAddress] -= (int256) (profitPerDivToken * _amountOfDivTokens);
509         payoutsTo_[_toAddress]       += (int256) (profitPerDivToken * _amountOfDivTokens);
510 
511         // Fire logging event.
512         emit Transfer(_customerAddress, _toAddress, _amountOfFrontEndTokens);
513 
514         // Good old ERC20.
515         return true;
516 
517     }
518 
519     // Who'd have thought we'd need this thing floating around?
520     function totalSupply()
521         public
522         view
523         returns (uint256)
524     {
525         return tokenSupply;
526     }
527 
528     // Anyone can start the regular phase 2 weeks after the ICO phase starts.
529     // In case the devs die. Or something.
530     function publicStartRegularPhase()
531         public
532     {
533         require(now > (icoOpenTime + 2 weeks) && icoOpenTime != 0);
534 
535         icoPhase     = false;
536         regularPhase = true;
537     }
538 
539     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
540 
541 
542     // Fire the starting gun and then duck for cover.
543     function startICOPhase()
544         onlyAdministrator()
545         public
546     {
547         // prevent start ico phase again when we already got an ico
548         require(icoOpenTime == 0);
549         icoPhase = true;
550         icoOpenTime = now;
551     }
552 
553     // Fire the ... ending gun?
554     function endICOPhase()
555         onlyAdministrator()
556         public
557     {
558         icoPhase = false;
559     }
560 
561     function startRegularPhase()
562         onlyAdministrator
563                 public
564     {
565         // disable ico phase in case if that was not disabled yet
566         icoPhase = false;
567         regularPhase = true;
568     }
569 
570     // The death of a great man demands the birth of a great son.
571     function setAdministrator(address _newAdmin, bool _status)
572         onlyAdministrator()
573         public
574     {
575         administrators[_newAdmin] = _status;
576     }
577 
578     function setStakingRequirement(uint _amountOfTokens)
579         onlyAdministrator()
580         public
581     {
582         // This plane only goes one way, lads. Never below the initial.
583         require (_amountOfTokens >= 100e18);
584         stakingRequirement = _amountOfTokens;
585     }
586 
587     function setName(string _name)
588         onlyAdministrator()
589         public
590     {
591         name = _name;
592     }
593 
594     function setSymbol(string _symbol)
595         onlyAdministrator()
596         public
597     {
598         symbol = _symbol;
599     }
600 
601     function changeBankroll(address _newBankrollAddress)
602         onlyAdministrator
603         public
604     {
605         bankrollAddress = _newBankrollAddress;
606     }
607 
608     /*----------  HELPERS AND CALCULATORS  ----------*/
609 
610     function totalEthereumBalance()
611         public
612         view
613         returns(uint)
614     {
615         return address(this).balance;
616     }
617 
618     function totalEthereumICOReceived()
619         public
620         view
621         returns(uint)
622     {
623         return ethInvestedDuringICO;
624     }
625 
626     /**
627      * Retrieves your currently selected dividend rate.
628      */
629     function getMyDividendRate()
630         public
631         view
632         returns(uint8)
633     {
634         address _customerAddress = msg.sender;
635         require(userSelectedRate[_customerAddress]);
636         return userDividendRate[_customerAddress];
637     }
638 
639     /**
640      * Retrieve the total frontend token supply
641      */
642     function getFrontEndTokenSupply()
643         public
644         view
645         returns(uint)
646     {
647         return tokenSupply;
648     }
649 
650     /**
651      * Retreive the total dividend token supply
652      */
653     function getDividendTokenSupply()
654         public
655         view
656         returns(uint)
657     {
658         return divTokenSupply;
659     }
660 
661     /**
662      * Retrieve the frontend tokens owned by the caller
663      */
664     function myFrontEndTokens()
665         public
666         view
667         returns(uint)
668     {
669         address _customerAddress = msg.sender;
670         return getFrontEndTokenBalanceOf(_customerAddress);
671     }
672 
673     /**
674      * Retrieve the dividend tokens owned by the caller
675      */
676     function myDividendTokens()
677         public
678         view
679         returns(uint)
680     {
681         address _customerAddress = msg.sender;
682         return getDividendTokenBalanceOf(_customerAddress);
683     }
684 
685     function myDividends(bool _includeReferralBonus)
686         public
687         view
688         returns(uint)
689     {
690         address _customerAddress = msg.sender;
691         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
692     }
693 
694     function theDividendsOf(bool _includeReferralBonus, address _customerAddress)
695         public
696         view
697         returns(uint)
698     {
699         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
700     }
701 
702     function getFrontEndTokenBalanceOf(address _customerAddress)
703         view
704         public
705         returns(uint)
706     {
707         return frontTokenBalanceLedger_[_customerAddress];
708     }
709 
710     function getDividendTokenBalanceOf(address _customerAddress)
711         view
712         public
713         returns(uint)
714     {
715         return dividendTokenBalanceLedger_[_customerAddress];
716     }
717 
718     function dividendsOf(address _customerAddress)
719         view
720         public
721         returns(uint)
722     {
723         return (uint) ((int256)(profitPerDivToken * dividendTokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
724     }
725 
726     // Get the sell price at the user's average dividend rate
727     function sellPrice()
728         public
729         view
730         returns(uint)
731     {
732         uint price;
733 
734         if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
735           price = tokenPriceInitial_;
736         } else {
737 
738           // Calculate the tokens received for 100 finney.
739           // Divide to find the average, to calculate the price.
740           uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
741 
742           price = (1e18 * 0.001 ether) / tokensReceivedForEth;
743         }
744 
745         // Factor in the user's average dividend rate
746         uint theSellPrice = price.sub((price.mul(getUserAverageDividendRate(msg.sender)).div(100)).div(magnitude));
747 
748         return theSellPrice;
749     }
750 
751     // Get the buy price at a particular dividend rate
752     function buyPrice(uint dividendRate)
753         public
754         view
755         returns(uint)
756     {
757         uint price;
758 
759         if (icoPhase || currentEthInvested < ethInvestedDuringICO) {
760           price = tokenPriceInitial_;
761         } else {
762 
763           // Calculate the tokens received for 100 finney.
764           // Divide to find the average, to calculate the price.
765           uint tokensReceivedForEth = ethereumToTokens_(0.001 ether);
766 
767           price = (1e18 * 0.001 ether) / tokensReceivedForEth;
768         }
769 
770         // Factor in the user's selected dividend rate
771         uint theBuyPrice = (price.mul(dividendRate).div(100)).add(price);
772 
773         return theBuyPrice;
774     }
775 
776     function calculateTokensReceived(uint _ethereumToSpend)
777         public
778         view
779         returns(uint)
780     {
781         uint _dividends      = (_ethereumToSpend.mul(userDividendRate[msg.sender])).div(100);
782         uint _taxedEthereum  = _ethereumToSpend.sub(_dividends);
783         uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
784         return  _amountOfTokens;
785     }
786 
787     // When selling tokens, we need to calculate the user's current dividend rate.
788     // This is different from their selected dividend rate.
789     function calculateEthereumReceived(uint _tokensToSell)
790         public
791         view
792         returns(uint)
793     {
794         require(_tokensToSell <= tokenSupply);
795         uint _ethereum               = tokensToEthereum_(_tokensToSell);
796         uint userAverageDividendRate = getUserAverageDividendRate(msg.sender);
797         uint _dividends              = (_ethereum.mul(userAverageDividendRate).div(100)).div(magnitude);
798         uint _taxedEthereum          = _ethereum.sub(_dividends);
799         return  _taxedEthereum;
800     }
801 
802     /*
803      * Get's a user's average dividend rate - which is just their divTokenBalance / tokenBalance
804      * We multiply by magnitude to avoid precision errors.
805      */
806 
807     function getUserAverageDividendRate(address user) public view returns (uint) {
808         return (magnitude * dividendTokenBalanceLedger_[user]).div(frontTokenBalanceLedger_[msg.sender]);
809     }
810 
811     function getMyAverageDividendRate() public view returns (uint) {
812         return getUserAverageDividendRate(msg.sender);
813     }
814 
815     /*==========================================
816     =            INTERNAL FUNCTIONS            =
817     ==========================================*/
818 
819     /* Purchase tokens with Ether.
820        During ICO phase, dividends should go to the bankroll
821        During normal operation:
822          0.5% should go to the master dividend card
823          0.5% should go to the matching dividend card
824          25% of dividends should go to the referrer, if any is provided. */
825     function purchaseTokens(uint _incomingEthereum, address _referredBy)
826         internal
827         returns(uint)
828     {
829         require(_incomingEthereum >= MIN_ETH_BUYIN || msg.sender == bankrollAddress, "Tried to buy below the min eth buyin threshold.");
830 
831         uint toBankRoll;
832         uint toReferrer;
833         uint toTokenHolders;
834         uint toDivCardHolders;
835 
836         uint dividendAmount;
837 
838         uint tokensBought;
839         uint dividendTokensBought;
840 
841         uint remainingEth = _incomingEthereum;
842 
843         uint fee;
844 
845         // 1% for dividend card holders is taken off before anything else
846         if (regularPhase) {
847             toDivCardHolders = _incomingEthereum.div(100);
848             remainingEth = remainingEth.sub(toDivCardHolders);
849         }
850 
851         /* Next, we tax for dividends:
852            Dividends = (ethereum * div%) / 100
853            Important note: if we're out of the ICO phase, the 1% sent to div-card holders
854                            is handled prior to any dividend taxes are considered. */
855 
856         // Grab the user's dividend rate
857         uint dividendRate = userDividendRate[msg.sender];
858 
859         // Calculate the total dividends on this buy
860         dividendAmount = (remainingEth.mul(dividendRate)).div(100);
861 
862         remainingEth   = remainingEth.sub(dividendAmount);
863 
864         if (msg.sender == bankrollAddress){
865                 remainingEth += dividendAmount;
866         }
867 
868         // Calculate how many tokens to buy:
869         tokensBought         = ethereumToTokens_(remainingEth);
870         dividendTokensBought = tokensBought.mul(dividendRate);
871 
872         // This is where we actually mint tokens:
873         tokenSupply    = tokenSupply.add(tokensBought);
874         divTokenSupply = divTokenSupply.add(dividendTokensBought);
875 
876         /* Update the total investment tracker
877            Note that this must be done AFTER we calculate how many tokens are bought -
878            because ethereumToTokens needs to know the amount *before* investment, not *after* investment. */
879 
880         currentEthInvested = currentEthInvested + remainingEth;
881 
882         // If ICO phase, all the dividends go to the bankroll
883         if (icoPhase) {
884             toBankRoll     = dividendAmount;
885             if (msg.sender == bankrollAddress){
886                 // toBankRoll is already in dividendAmount
887                 toBankRoll = 0;
888             }
889             toReferrer     = 0;
890             toTokenHolders = 0;
891 
892             /* ethInvestedDuringICO tracks how much Ether goes straight to tokens,
893                not how much Ether we get total.
894                this is so that our calculation using "investment" is accurate. */
895             ethInvestedDuringICO = ethInvestedDuringICO + remainingEth;
896             tokensMintedDuringICO = tokensMintedDuringICO + tokensBought;
897 
898             // Cannot purchase more than the hard cap during ICO.
899             require(ethInvestedDuringICO <= icoHardCap);
900             // Contracts aren't allowed to participate in the ICO.
901             require(tx.origin == msg.sender || msg.sender == bankrollAddress);
902 
903             // Cannot purchase more then the limit per address during the ICO.
904             ICOBuyIn[msg.sender] += remainingEth;
905             require(ICOBuyIn[msg.sender] <= addressICOLimit || msg.sender == bankrollAddress);
906 
907             // Stop the ICO phase if we reach the hard cap
908             if (ethInvestedDuringICO == icoHardCap){
909                 icoPhase = false;
910             }
911 
912         } else {
913         // Not ICO phase, check for referrals
914 
915             // 25% goes to referrers, if set
916             // toReferrer = (dividends * 25)/100
917             if (_referredBy != 0x0000000000000000000000000000000000000000 &&
918                 _referredBy != msg.sender &&
919                 frontTokenBalanceLedger_[_referredBy] >= stakingRequirement)
920             {
921                 toReferrer = (dividendAmount.mul(referrer_percentage)).div(100);
922                 referralBalance_[_referredBy] += toReferrer;
923             }
924 
925             // The rest of the dividends go to token holders
926             toTokenHolders = dividendAmount.sub(toReferrer);
927 
928             fee = toTokenHolders * magnitude;
929             fee = fee - (fee - (dividendTokensBought * (toTokenHolders * magnitude / (divTokenSupply))));
930 
931             // Finally, increase the divToken value
932             profitPerDivToken       = profitPerDivToken.add((toTokenHolders.mul(magnitude)).div(divTokenSupply));
933             payoutsTo_[msg.sender] += (int256) ((profitPerDivToken * dividendTokensBought) - fee);
934         }
935 
936         // Update the buyer's token amounts
937         frontTokenBalanceLedger_[msg.sender] = frontTokenBalanceLedger_[msg.sender].add(tokensBought);
938         dividendTokenBalanceLedger_[msg.sender] = dividendTokenBalanceLedger_[msg.sender].add(dividendTokensBought);
939 
940         // Transfer to bankroll and div cards
941         if (toBankRoll != 0) { ZethrBankroll(bankrollAddress).receiveDividends.value(toBankRoll)(); }
942         if (regularPhase) { divCardContract.receiveDividends.value(toDivCardHolders)(dividendRate); }
943 
944         // This event should help us track where all the eth is going
945         emit Allocation(toBankRoll, toReferrer, toTokenHolders, toDivCardHolders, remainingEth);
946 
947         // Sanity checking
948         uint sum = toBankRoll + toReferrer + toTokenHolders + toDivCardHolders + remainingEth;
949         assert(sum == _incomingEthereum);
950     }
951 
952     // How many tokens one gets from a certain amount of ethereum.
953     function ethereumToTokens_(uint _ethereumAmount)
954         public
955         view
956         returns(uint)
957     {
958         require(_ethereumAmount > MIN_ETH_BUYIN, "Tried to buy tokens with too little eth.");
959 
960         if (icoPhase) {
961             return _ethereumAmount.div(tokenPriceInitial_) * 1e18;
962         }
963 
964         /*
965          *  i = investment, p = price, t = number of tokens
966          *
967          *  i_current = p_initial * t_current                   (for t_current <= t_initial)
968          *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
969          *
970          *  t_current = i_current / p_initial                   (for i_current <= i_initial)
971          *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
972          */
973 
974         // First, separate out the buy into two segments:
975         //  1) the amount of eth going towards ico-price tokens
976         //  2) the amount of eth going towards pyramid-price (variable) tokens
977         uint ethTowardsICOPriceTokens = 0;
978         uint ethTowardsVariablePriceTokens = 0;
979 
980         if (currentEthInvested >= ethInvestedDuringICO) {
981         // Option One: All the ETH goes towards variable-price tokens
982           ethTowardsVariablePriceTokens = _ethereumAmount;
983 
984         } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount <= ethInvestedDuringICO) {
985         // Option Two: All the ETH goes towards ICO-price tokens
986           ethTowardsICOPriceTokens = _ethereumAmount;
987 
988         } else if (currentEthInvested < ethInvestedDuringICO && currentEthInvested + _ethereumAmount > ethInvestedDuringICO) {
989         // Option Three: Some ETH goes towards ICO-price tokens, some goes towards variable-price tokens
990           ethTowardsICOPriceTokens = ethInvestedDuringICO.sub(currentEthInvested);
991           ethTowardsVariablePriceTokens = _ethereumAmount.sub(ethTowardsICOPriceTokens);
992         } else {
993                 // Option Four: Should be impossible, and compiler should optimize it out of existence.
994                     revert();
995                 }
996 
997         // Sanity check:
998         assert(ethTowardsICOPriceTokens + ethTowardsVariablePriceTokens == _ethereumAmount);
999 
1000         // Separate out the number of tokens of each type this will buy:
1001         uint icoPriceTokens = 0;
1002         uint varPriceTokens = 0;
1003 
1004         // Now calculate each one per the above formulas.
1005         // Note: since tokens have 18 decimals of precision we multiply the result by 1e18.
1006         if (ethTowardsICOPriceTokens != 0) {
1007           icoPriceTokens = ethTowardsICOPriceTokens.div(tokenPriceInitial_) * 1e18;
1008         }
1009 
1010         if (ethTowardsVariablePriceTokens != 0) {
1011           // Note: we can't use "currentEthInvested" for this calculation, we must use:
1012           //  currentEthInvested + ethTowardsICOPriceTokens
1013           // This is because a split-buy essentially needs to simulate two separate buys -
1014           // including the currentEthInvested update that comes BEFORE variable price tokens are bought!
1015 
1016           uint simulatedEthBeforeInvested = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3) + ethTowardsICOPriceTokens;
1017           uint simulatedEthAfterInvested  = simulatedEthBeforeInvested + ethTowardsVariablePriceTokens;
1018 
1019           /* We have the equations for total tokens above; note that this is for TOTAL.
1020              To get the number of tokens this purchase buys, use the simulatedEthInvestedBefore
1021              and the simulatedEthInvestedAfter and calculate the difference in tokens.
1022              This is how many we get. */
1023 
1024           uint tokensBefore = toPowerOfTwoThirds(simulatedEthBeforeInvested.mul(3).div(2)).mul(MULTIPLIER);
1025           uint tokensAfter  = toPowerOfTwoThirds(simulatedEthAfterInvested.mul(3).div(2)).mul(MULTIPLIER);
1026 
1027           /* Note that we could use tokensBefore = tokenSupply + icoPriceTokens instead of dynamically calculating tokensBefore;
1028              either should work.
1029 
1030              Investment IS already multiplied by 1e18; however, because this is taken to a power of (2/3),
1031              we need to multiply the result by 1e6 to get back to the correct number of decimals. */
1032 
1033           varPriceTokens = (1e6) * tokensAfter.sub(tokensBefore);
1034         }
1035 
1036         uint totalTokensReceived = icoPriceTokens + varPriceTokens;
1037 
1038         assert(totalTokensReceived > 0);
1039         return totalTokensReceived;
1040     }
1041 
1042     // How much Ether we get from selling N tokens
1043     function tokensToEthereum_(uint _tokens)
1044         public
1045         view
1046         returns(uint)
1047     {
1048         require (_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");
1049 
1050         /*
1051          *  i = investment, p = price, t = number of tokens
1052          *
1053          *  i_current = p_initial * t_current                   (for t_current <= t_initial)
1054          *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)
1055          *
1056          *  t_current = i_current / p_initial                   (for i_current <= i_initial)
1057          *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)
1058          */
1059 
1060         // First, separate out the sell into two segments:
1061         //  1) the amount of tokens selling at the ICO price.
1062         //  2) the amount of tokens selling at the variable (pyramid) price
1063                 uint tokensToSellAtICOPrice = 0;
1064                 uint tokensToSellAtVariablePrice = 0;
1065 
1066                 if (tokenSupply <= tokensMintedDuringICO) {
1067                 // Option One: All the tokens sell at the ICO price.
1068                     tokensToSellAtICOPrice = _tokens;
1069 
1070                 } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {
1071                 // Option Two: All the tokens sell at the variable price.
1072                     tokensToSellAtVariablePrice = _tokens;
1073 
1074                 } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {
1075                 // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.
1076                     tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);
1077                     tokensToSellAtICOPrice      = _tokens.sub(tokensToSellAtVariablePrice);
1078 
1079                 } else {
1080                 // Option Four: Should be impossible, and the compiler should optimize it out of existence.
1081                     revert();
1082                 }
1083 
1084         // Sanity check:
1085         assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);
1086 
1087         // Track how much Ether we get from selling at each price function:
1088         uint ethFromICOPriceTokens;
1089         uint ethFromVarPriceTokens;
1090 
1091         // Now, actually calculate:
1092 
1093         if (tokensToSellAtICOPrice != 0) {
1094 
1095           /* Here, unlike the sister equation in ethereumToTokens, we DON'T need to multiply by 1e18, since
1096              we will be passed in an amount of tokens to sell that's already at the 18-decimal precision.
1097              We need to divide by 1e18 or we'll have too much Ether. */
1098 
1099           ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);
1100         }
1101 
1102         if (tokensToSellAtVariablePrice != 0) {
1103 
1104           /* Note: Unlike the sister function in ethereumToTokens, we don't have to calculate any "virtual" token count.
1105              This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.
1106              Thus there isn't any weird stuff going on with the token supply.
1107 
1108              We have the equations for total investment above; note that this is for TOTAL.
1109              To get the eth received from this sell, we calculate the new total investment after this sell.
1110              Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */
1111 
1112           uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);
1113           uint investmentAfter  = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);
1114 
1115           ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);
1116         }
1117 
1118         uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;
1119 
1120         assert(totalEthReceived > 0);
1121         return totalEthReceived;
1122     }
1123 
1124     // Called from transferFrom. Always checks if _customerAddress has dividends.
1125     function withdrawFrom(address _customerAddress)
1126         internal
1127     {
1128         // Setup data
1129         uint _dividends                    = theDividendsOf(false, _customerAddress);
1130 
1131         // update dividend tracker
1132         payoutsTo_[_customerAddress]       +=  (int256) (_dividends * magnitude);
1133 
1134         // add ref. bonus
1135         _dividends                         += referralBalance_[_customerAddress];
1136         referralBalance_[_customerAddress]  = 0;
1137 
1138         _customerAddress.transfer(_dividends);
1139 
1140         // Fire logging event.
1141         emit onWithdraw(_customerAddress, _dividends);
1142     }
1143 
1144     /*=======================
1145      =   MATHS FUNCTIONS    =
1146      ======================*/
1147 
1148     function toPowerOfThreeHalves(uint x) public pure returns (uint) {
1149         // m = 3, n = 2
1150         // sqrt(x^3)
1151         return sqrt(x**3);
1152     }
1153 
1154     function toPowerOfTwoThirds(uint x) public pure returns (uint) {
1155         // m = 2, n = 3
1156         // cbrt(x^2)
1157         return cbrt(x**2);
1158     }
1159 
1160     function sqrt(uint x) public pure returns (uint y) {
1161         uint z = (x + 1) / 2;
1162         y = x;
1163         while (z < y) {
1164             y = z;
1165             z = (x / z + z) / 2;
1166         }
1167     }
1168 
1169     function cbrt(uint x) public pure returns (uint y) {
1170         uint z = (x + 1) / 3;
1171         y = x;
1172         while (z < y) {
1173             y = z;
1174             z = (x / (z*z) + 2 * z) / 3;
1175         }
1176     }
1177 }
1178 
1179     /*=======================
1180      =     INTERFACES       =
1181      ======================*/
1182 
1183 
1184 contract ZethrDividendCards {
1185     function ownerOf(uint /*_divCardId*/) public pure returns (address) {}
1186     function receiveDividends(uint /*_divCardRate*/) public payable {}
1187 }
1188 
1189 contract ZethrBankroll{
1190     function receiveDividends() public payable {}
1191 }
1192 
1193 // Think it's safe to say y'all know what this is.
1194 
1195 library SafeMath {
1196 
1197     function mul(uint a, uint b) internal pure returns (uint) {
1198         if (a == 0) {
1199             return 0;
1200         }
1201         uint c = a * b;
1202         assert(c / a == b);
1203         return c;
1204     }
1205 
1206     function div(uint a, uint b) internal pure returns (uint) {
1207         // assert(b > 0); // Solidity automatically throws when dividing by 0
1208         uint c = a / b;
1209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1210         return c;
1211     }
1212 
1213     function sub(uint a, uint b) internal pure returns (uint) {
1214         assert(b <= a);
1215         return a - b;
1216     }
1217 
1218     function add(uint a, uint b) internal pure returns (uint) {
1219         uint c = a + b;
1220         assert(c >= a);
1221         return c;
1222     }
1223 }