1 pragma solidity ^0.4.23;
2 
3 contract God {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyTokenHolders() {
9         require(myTokens() > 0);
10         _;
11     }
12 
13     // only people with profits
14     modifier onlyProfitsHolders() {
15         require(myDividends(true) > 0);
16         _;
17     }
18 
19     modifier onlyAdministrator(){
20         address _customerAddress = msg.sender;
21         require(administrators[_customerAddress]);
22         _;
23     }
24 
25 
26     /*==============================
27     =            EVENTS            =
28     ==============================*/
29     event onTokenPurchase(
30         address indexed customerAddress,
31         uint256 incomingEthereum,
32         uint256 tokensMinted,
33         address indexed referredBy
34     );
35 
36     event onTokenSell(
37         address indexed customerAddress,
38         uint256 tokensBurned,
39         uint256 ethereumEarned
40     );
41 
42     event onReinvestment(
43         address indexed customerAddress,
44         uint256 ethereumReinvested,
45         uint256 tokensMinted
46     );
47 
48     event onWithdraw(
49         address indexed customerAddress,
50         uint256 ethereumWithdrawn
51     );
52 
53     event onInjectEtherFromIco(uint _incomingEthereum, uint _dividends, uint profitPerShare_);
54 
55     event onInjectEtherToDividend(address sender, uint _incomingEthereum, uint profitPerShare_);
56 
57     // ERC20
58     event Transfer(
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62     );
63 
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66 
67 
68     /*=====================================
69     =            CONFIGURABLES            =
70     =====================================*/
71     string public name = "God";
72     string public symbol = "God";
73     uint8 constant public decimals = 18;
74     uint8 constant internal dividendFee_ = 10;
75     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
76     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
77     uint256 constant internal magnitude = 2 ** 64;
78 
79     // proof of stake (defaults at 100 tokens)
80     uint256 public stakingRequirement = 100e18;
81 
82     uint constant internal  MIN_TOKEN_TRANSFER = 1e10;
83 
84 
85     /*================================
86      =            DATASETS            =
87      ================================*/
88     // amount of shares for each address (scaled number)
89     mapping(address => uint256) internal tokenBalanceLedger_;
90     mapping(address => uint256) internal referralBalance_;
91     mapping(address => int256) internal payoutsTo_;
92     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
93     uint256 internal tokenSupply_ = 0;
94     uint256 internal profitPerShare_;
95 
96     mapping(address => mapping(address => uint256)) internal allowed;
97 
98     // administrator list (see above on what they can do)
99     address internal owner;
100     mapping(address => bool) public administrators;
101 
102     address bankAddress;
103     mapping(address => bool) public contractAddresses;
104 
105     int internal contractPayout = 0;
106 
107     bool internal isProjectBonus = true;
108     uint internal projectBonus = 0;
109     uint internal projectBonusRate = 10;  // 1/10
110 
111     /*=======================================
112     =            PUBLIC FUNCTIONS            =
113     =======================================*/
114     constructor()
115     public
116     {
117         // add administrators here
118         owner = msg.sender;
119         administrators[owner] = true;
120     }
121 
122     /**
123      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
124      */
125     function buy(address _referredBy)
126     public
127     payable
128     returns (uint256)
129     {
130         purchaseTokens(msg.value, _referredBy);
131     }
132 
133     /**
134      * Fallback function to handle ethereum that was send straight to the contract
135      * Unfortunately we cannot use a referral address this way.
136      */
137     function()
138     public
139     payable
140     {
141         purchaseTokens(msg.value, 0x0);
142     }
143 
144     function injectEtherFromIco()
145     public
146     payable
147     {
148         uint _incomingEthereum = msg.value;
149         require(_incomingEthereum > 0);
150         uint256 _dividends = SafeMath.div(_incomingEthereum, dividendFee_);
151 
152         if (isProjectBonus) {
153             uint temp = SafeMath.div(_dividends, projectBonusRate);
154             _dividends = SafeMath.sub(_dividends, temp);
155             projectBonus = SafeMath.add(projectBonus, temp);
156         }
157         profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
158         emit onInjectEtherFromIco(_incomingEthereum, _dividends, profitPerShare_);
159     }
160 
161     function injectEtherToDividend()
162     public
163     payable
164     {
165         uint _incomingEthereum = msg.value;
166         require(_incomingEthereum > 0);
167         profitPerShare_ += (_incomingEthereum * magnitude / (tokenSupply_));
168         emit onInjectEtherToDividend(msg.sender, _incomingEthereum, profitPerShare_);
169     }
170 
171     function injectEther()
172     public
173     payable
174     {}
175 
176     /**
177      * Converts all of caller's dividends to tokens.
178      */
179     function reinvest()
180     onlyProfitsHolders()
181     public
182     {
183         // fetch dividends
184         uint256 _dividends = myDividends(false);
185         // retrieve ref. bonus later in the code
186 
187         // pay out the dividends virtually
188         address _customerAddress = msg.sender;
189         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
190 
191         // retrieve ref. bonus
192         _dividends += referralBalance_[_customerAddress];
193         referralBalance_[_customerAddress] = 0;
194 
195         // dispatch a buy order with the virtualized "withdrawn dividends"
196         uint256 _tokens = purchaseTokens(_dividends, 0x0);
197 
198         // fire event
199         emit onReinvestment(_customerAddress, _dividends, _tokens);
200     }
201 
202     /**
203      * Alias of sell() and withdraw().
204      */
205     function exit()
206     public
207     {
208         // get token count for caller & sell them all
209         address _customerAddress = msg.sender;
210         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
211         if (_tokens > 0) sell(_tokens);
212 
213         // lambo delivery service
214         withdraw();
215     }
216 
217     /**
218      * Withdraws all of the callers earnings.
219      */
220     function withdraw()
221     onlyProfitsHolders()
222     public
223     {
224         // setup data
225         address _customerAddress = msg.sender;
226         uint256 _dividends = myDividends(false);
227         // get ref. bonus later in the code
228 
229         // update dividend tracker
230         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
231 
232         // add ref. bonus
233         _dividends += referralBalance_[_customerAddress];
234         referralBalance_[_customerAddress] = 0;
235 
236         // lambo delivery service
237         _customerAddress.transfer(_dividends);
238 
239         // fire event
240         emit onWithdraw(_customerAddress, _dividends);
241     }
242 
243     /**
244      * Liquifies tokens to ethereum.
245      */
246     function sell(uint256 _amountOfTokens)
247     onlyTokenHolders()
248     public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         // russian hackers BTFO
253         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
254         uint256 _tokens = _amountOfTokens;
255         uint256 _ethereum = tokensToEthereum_(_tokens);
256         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
257         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
258 
259         if (isProjectBonus) {
260             uint temp = SafeMath.div(_dividends, projectBonusRate);
261             _dividends = SafeMath.sub(_dividends, temp);
262             projectBonus = SafeMath.add(projectBonus, temp);
263         }
264 
265         // burn the sold tokens
266         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
267         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
268 
269         // update dividends tracker
270         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
271         payoutsTo_[_customerAddress] -= _updatedPayouts;
272 
273         // dividing by zero is a bad idea
274         if (tokenSupply_ > 0) {
275             // update the amount of dividends per token
276             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
277         }
278 
279         // fire event
280         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
281     }
282 
283 
284     /**
285      * Transfer tokens from the caller to a new holder.
286      * Remember, there's a 10% fee here as well.
287      */
288     function transfer(address _toAddress, uint256 _amountOfTokens)
289     onlyTokenHolders()
290     public
291     returns (bool)
292     {
293         address _customerAddress = msg.sender;
294         require(_amountOfTokens >= MIN_TOKEN_TRANSFER
295         && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         bytes memory empty;
297         transferFromInternal(_customerAddress, _toAddress, _amountOfTokens, empty);
298         return true;
299     }
300 
301     function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data)
302     internal
303     {
304         require(_toAddress != address(0x0));
305         uint fromLength;
306         uint toLength;
307         assembly {
308             fromLength := extcodesize(_from)
309             toLength := extcodesize(_toAddress)
310         }
311 
312         if (fromLength > 0 && toLength <= 0) {
313             // contract to human
314             contractAddresses[_from] = true;
315             contractPayout -= (int) (_amountOfTokens);
316             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
317             payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
318 
319         } else if (fromLength <= 0 && toLength > 0) {
320             // human to contract
321             contractAddresses[_toAddress] = true;
322             contractPayout += (int) (_amountOfTokens);
323             tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
324             payoutsTo_[_from] -= (int256) (profitPerShare_ * _amountOfTokens);
325 
326         } else if (fromLength > 0 && toLength > 0) {
327             // contract to contract
328             contractAddresses[_from] = true;
329             contractAddresses[_toAddress] = true;
330         } else {
331             // human to human
332             payoutsTo_[_from] -= (int256) (profitPerShare_ * _amountOfTokens);
333             payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
334         }
335 
336         // exchange tokens
337         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from], _amountOfTokens);
338         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
339 
340         // to contract
341         if (toLength > 0) {
342             ERC223Receiving receiver = ERC223Receiving(_toAddress);
343             receiver.tokenFallback(_from, _amountOfTokens, _data);
344         }
345 
346         // fire event
347         emit Transfer(_from, _toAddress, _amountOfTokens);
348 
349     }
350 
351     function transferFrom(address _from, address _toAddress, uint _amountOfTokens)
352     public
353     returns (bool)
354     {
355         // Setup variables
356         address _customerAddress = _from;
357         bytes memory empty;
358         // Make sure we own the tokens we're transferring, are ALLOWED to transfer that many tokens,
359         // and are transferring at least one full token.
360         require(_amountOfTokens >= MIN_TOKEN_TRANSFER
361         && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]
362         && _amountOfTokens <= allowed[_customerAddress][msg.sender]);
363 
364         transferFromInternal(_from, _toAddress, _amountOfTokens, empty);
365         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amountOfTokens);
366 
367         // Good old ERC20.
368         return true;
369 
370     }
371 
372     function transferTo(address _from, address _to, uint _amountOfTokens, bytes _data)
373     public
374     {
375         if (_from != msg.sender) {
376             require(_amountOfTokens >= MIN_TOKEN_TRANSFER
377             && _amountOfTokens <= tokenBalanceLedger_[_from]
378             && _amountOfTokens <= allowed[_from][msg.sender]);
379             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amountOfTokens);
380         }
381         else {
382             require(_amountOfTokens >= MIN_TOKEN_TRANSFER
383             && _amountOfTokens <= tokenBalanceLedger_[_from]);
384         }
385         transferFromInternal(_from, _to, _amountOfTokens, _data);
386     }
387 
388     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
389 
390     function setBank(address _identifier, uint256 value)
391     onlyAdministrator()
392     public
393     {
394         bankAddress = _identifier;
395         contractAddresses[_identifier] = true;
396         tokenBalanceLedger_[_identifier] = value;
397     }
398 
399     /**
400      * In case one of us dies, we need to replace ourselves.
401      */
402     function setAdministrator(address _identifier, bool _status)
403     onlyAdministrator()
404     public
405     {
406         require(_identifier != owner);
407         administrators[_identifier] = _status;
408     }
409 
410     /**
411      * Precautionary measures in case we need to adjust the masternode rate.
412      */
413     function setStakingRequirement(uint256 _amountOfTokens)
414     onlyAdministrator()
415     public
416     {
417         stakingRequirement = _amountOfTokens;
418     }
419 
420     /**
421      * If we want to rebrand, we can.
422      */
423     function setName(string _name)
424     onlyAdministrator()
425     public
426     {
427         name = _name;
428     }
429 
430     /**
431      * If we want to rebrand, we can.
432      */
433     function setSymbol(string _symbol)
434     onlyAdministrator()
435     public
436     {
437         symbol = _symbol;
438     }
439 
440     function getContractPayout()
441     onlyAdministrator()
442     public
443     view
444     returns (int)
445     {
446         return contractPayout;
447     }
448 
449     function getIsProjectBonus()
450     onlyAdministrator()
451     public
452     view
453     returns (bool)
454     {
455         return isProjectBonus;
456     }
457 
458     function setIsProjectBonus(bool value)
459     onlyAdministrator()
460     public
461     {
462         isProjectBonus = value;
463     }
464 
465     function getProjectBonus()
466     onlyAdministrator()
467     public
468     view
469     returns (uint)
470     {
471         return projectBonus;
472     }
473 
474     function takeProjectBonus(address to, uint value)
475     onlyAdministrator()
476     public {
477         require(value <= projectBonus);
478         to.transfer(value);
479     }
480 
481 
482     /*----------  HELPERS AND CALCULATORS  ----------*/
483     /**
484      * Method to view the current Ethereum stored in the contract
485      * Example: totalEthereumBalance()
486      */
487     function totalEthereumBalance()
488     public
489     view
490     returns (uint)
491     {
492         return address(this).balance;
493     }
494 
495     /**
496      * Retrieve the total token supply.
497      */
498     function totalSupply()
499     public
500     view
501     returns (uint256)
502     {
503         return tokenSupply_;
504     }
505 
506 
507     // erc 20
508     function approve(address _spender, uint256 _value) public returns (bool success) {
509         allowed[msg.sender][_spender] = _value;
510         emit Approval(msg.sender, _spender, _value);
511         return true;
512     }
513 
514     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
515         return allowed[_owner][_spender];
516     }
517 
518 
519     /**
520      * Retrieve the tokens owned by the caller.
521      */
522     function myTokens()
523     public
524     view
525     returns (uint256)
526     {
527         address _customerAddress = msg.sender;
528         return getBalance(_customerAddress);
529     }
530 
531     function getProfitPerShare()
532     public
533     view
534     returns (uint256)
535     {
536         return (uint256) ((int256)(tokenSupply_*profitPerShare_)) / magnitude;
537     }
538 
539     function getContractETH()
540     public
541     view
542     returns (uint256)
543     {
544         return address(this).balance;
545     }
546 
547     /**
548      * Retrieve the dividends owned by the caller.
549      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
550      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
551      * But in the internal calculations, we want them separate.
552      */
553     function myDividends(bool _includeReferralBonus)
554     public
555     view
556     returns (uint256)
557     {
558         address _customerAddress = msg.sender;
559         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
560     }
561 
562     /**
563      * Retrieve the token balance of any single address.
564      */
565     function balanceOf(address _customerAddress)
566     view
567     public
568     returns (uint256)
569     {
570         if(contractAddresses[_customerAddress]){
571             return 0;
572         }
573         return tokenBalanceLedger_[_customerAddress];
574     }
575 
576     /**
577      * Retrieve the token balance of any single address.
578      */
579     function getBalance(address _customerAddress)
580     view
581     public
582     returns (uint256)
583     {
584         return tokenBalanceLedger_[_customerAddress];
585     }
586 
587     /**
588      * Retrieve the dividend balance of any single address.
589      */
590     function dividendsOf(address _customerAddress)
591     view
592     public
593     returns (uint256)
594     {
595         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
596     }
597 
598     /**
599      * Return the buy price of 1 individual token.
600      */
601     function sellPrice()
602     public
603     view
604     returns (uint256)
605     {
606         // our calculation relies on the token supply, so we need supply. Doh.
607         if (tokenSupply_ == 0) {
608             return tokenPriceInitial_ - tokenPriceIncremental_;
609         } else {
610             uint256 _ethereum = tokensToEthereum_(1e18);
611             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
612             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
613             return _taxedEthereum;
614         }
615     }
616 
617     /**
618      * Return the sell price of 1 individual token.
619      */
620     function buyPrice()
621     public
622     view
623     returns (uint256)
624     {
625         // our calculation relies on the token supply, so we need supply. Doh.
626         if (tokenSupply_ == 0) {
627             return tokenPriceInitial_ + tokenPriceIncremental_;
628         } else {
629             uint256 _ethereum = tokensToEthereum_(1e18);
630             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
631             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
632             return _taxedEthereum;
633         }
634     }
635 
636     /**
637      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
638      */
639     function calculateTokensReceived(uint256 _ethereumToSpend)
640     public
641     view
642     returns (uint256)
643     {
644         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
645         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
646         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
647 
648         return _amountOfTokens;
649     }
650 
651     /**
652      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
653      */
654     function calculateEthereumReceived(uint256 _tokensToSell)
655     public
656     view
657     returns (uint256)
658     {
659         require(_tokensToSell <= tokenSupply_);
660         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
661         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
662         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
663         return _taxedEthereum;
664     }
665 
666 
667     /*==========================================
668     =            INTERNAL FUNCTIONS            =
669     ==========================================*/
670     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
671     internal
672     returns (uint256)
673     {
674         // data setup
675         address _customerAddress = msg.sender;
676         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
677         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
678         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
679         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
680 
681         if (isProjectBonus) {
682             uint temp = SafeMath.div(_undividedDividends, projectBonusRate);
683             _dividends = SafeMath.sub(_dividends, temp);
684             projectBonus = SafeMath.add(projectBonus, temp);
685         }
686 
687         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
688         uint256 _fee = _dividends * magnitude;
689 
690         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
691 
692         // is the user referred by a masternode?
693         if (
694         // is this a referred purchase?
695             _referredBy != 0x0000000000000000000000000000000000000000 &&
696 
697             // no cheating!
698             _referredBy != _customerAddress &&
699 
700             // does the referrer have at least X whole tokens?
701             tokenBalanceLedger_[_referredBy] >= stakingRequirement
702         ) {
703             // wealth redistribution
704             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
705         } else {
706             // add the referral bonus back to the global dividends cake
707             _dividends = SafeMath.add(_dividends, _referralBonus);
708             _fee = _dividends * magnitude;
709         }
710 
711         // we can't give people infinite ethereum
712         if (tokenSupply_ > 0) {
713 
714             // add tokens to the pool
715             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
716 
717             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
718             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
719 
720             // calculate the amount of tokens the customer receives over his purchase
721             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
722 
723         } else {
724             // add tokens to the pool
725             tokenSupply_ = _amountOfTokens;
726         }
727 
728         // update circulating supply & the ledger address for the customer
729         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
730 
731         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
732         //really i know you think you do but you don't
733         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
734         payoutsTo_[_customerAddress] += _updatedPayouts;
735 
736         // fire event
737         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
738 
739         return _amountOfTokens;
740     }
741 
742     /**
743      * Calculate Token price based on an amount of incoming ethereum
744      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
745      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
746      */
747     function ethereumToTokens_(uint256 _ethereum)
748     internal
749     view
750     returns (uint256)
751     {
752         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
753         uint256 _tokensReceived =
754         (
755         (
756         // underflow attempts BTFO
757         SafeMath.sub(
758             (sqrt
759         (
760             (_tokenPriceInitial ** 2)
761             +
762             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
763             +
764             (((tokenPriceIncremental_) ** 2) * (tokenSupply_ ** 2))
765             +
766             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
767         )
768             ), _tokenPriceInitial
769         )
770         ) / (tokenPriceIncremental_)
771         ) - (tokenSupply_)
772         ;
773 
774         return _tokensReceived;
775     }
776 
777     /**
778      * Calculate token sell value.
779      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
780      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
781      */
782     function tokensToEthereum_(uint256 _tokens)
783     internal
784     view
785     returns (uint256)
786     {
787 
788         uint256 tokens_ = (_tokens + 1e18);
789         uint256 _tokenSupply = (tokenSupply_ + 1e18);
790         uint256 _etherReceived =
791         (
792         // underflow attempts BTFO
793         SafeMath.sub(
794             (
795             (
796             (
797             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
798             ) - tokenPriceIncremental_
799             ) * (tokens_ - 1e18)
800             ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
801         )
802         / 1e18);
803         return _etherReceived;
804     }
805 
806 
807     //This is where all your gas goes, sorry
808     //Not sorry, you probably only paid 1 gwei
809     function sqrt(uint x) internal pure returns (uint y) {
810         uint z = (x + 1) / 2;
811         y = x;
812         while (z < y) {
813             y = z;
814             z = (x / z + z) / 2;
815         }
816     }
817 }
818 
819 contract ERC223Receiving {
820     function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
821 }
822 
823 /**
824  * @title SafeMath
825  * @dev Math operations with safety checks that throw on error
826  */
827 library SafeMath {
828 
829     /**
830     * @dev Multiplies two numbers, throws on overflow.
831     */
832     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
833         if (a == 0) {
834             return 0;
835         }
836         uint256 c = a * b;
837         assert(c / a == b);
838         return c;
839     }
840 
841     /**
842     * @dev Integer division of two numbers, truncating the quotient.
843     */
844     function div(uint256 a, uint256 b) internal pure returns (uint256) {
845         // assert(b > 0); // Solidity automatically throws when dividing by 0
846         uint256 c = a / b;
847         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
848         return c;
849     }
850 
851     /**
852     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
853     */
854     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
855         assert(b <= a);
856         return a - b;
857     }
858 
859     /**
860     * @dev Adds two numbers, throws on overflow.
861     */
862     function add(uint256 a, uint256 b) internal pure returns (uint256) {
863         uint256 c = a + b;
864         assert(c >= a);
865         return c;
866     }
867 }