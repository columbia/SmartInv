1 pragma solidity ^0.4.25;
2 
3 contract AcceptsExchange {
4     Exchange public tokenContract;
5 
6     constructor(address _tokenContract) public {
7         tokenContract = Exchange(_tokenContract);
8     }
9 
10     modifier onlyTokenContract {
11         require(msg.sender == address(tokenContract));
12         _;
13     }
14 
15     /**
16     * @dev Standard ERC677 function that will handle incoming token transfers.
17     *
18     * @param _from  Token sender address.
19     * @param _value Amount of tokens.
20     * @param _data  Transaction metadata.
21     */
22     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
23 }
24 
25 
26 contract Exchange {
27     /*=================================
28     =            MODIFIERS            =
29     =================================*/
30     // only people with tokens
31     modifier onlyBagholders() {
32         require(myTokens() > 0);
33         _;
34     }
35 
36     // only people with profits
37     modifier onlyStronghands() {
38         require(myDividends(true) > 0);
39         _;
40     }
41 
42     modifier notContract() {
43       require (msg.sender == tx.origin);
44       _;
45     }
46 
47     // administrators can:
48     // -> change the name of the contract
49     // -> change the name of the token
50     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
51     // they CANNOT:
52     // -> take funds
53     // -> disable withdrawals
54     // -> kill the contract
55     // -> change the price of tokens
56     modifier onlyAdministrator(){
57         address _customerAddress = msg.sender;
58         require(administrators[_customerAddress]);
59         _;
60     }
61 
62     uint ACTIVATION_TIME = 1547996400;
63 
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68 
69         if (now >= ACTIVATION_TIME) {
70             onlyAmbassadors = false;
71         }
72 
73         // are we still in the vulnerable phase?
74         // if so, enact anti early whale protocol
75         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
76             require(
77                 // is the customer in the ambassador list?
78                 ambassadors_[msg.sender] == true &&
79 
80                 // does the customer purchase exceed the max ambassador quota?
81                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_
82 
83             );
84 
85             // updated the accumulated quota
86             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
87 
88             // execute
89             _;
90         } else {
91             // in case the ether count drops low, the ambassador phase won't reinitiate
92             onlyAmbassadors = false;
93             _;
94         }
95 
96     }
97 
98     /*==============================
99     =            EVENTS            =
100     ==============================*/
101     event onTokenPurchase(
102         address indexed customerAddress,
103         uint256 incomingEthereum,
104         uint256 tokensMinted,
105         address indexed referredBy,
106         bool isReinvest,
107         uint timestamp,
108         uint256 price
109     );
110 
111     event onTokenSell(
112         address indexed customerAddress,
113         uint256 tokensBurned,
114         uint256 ethereumEarned,
115         uint timestamp,
116         uint256 price
117     );
118 
119     event onReinvestment(
120         address indexed customerAddress,
121         uint256 ethereumReinvested,
122         uint256 tokensMinted
123     );
124 
125     event onWithdraw(
126         address indexed customerAddress,
127         uint256 ethereumWithdrawn,
128         uint256 estimateTokens,
129         bool isTransfer
130     );
131 
132     // ERC20
133     event Transfer(
134         address indexed from,
135         address indexed to,
136         uint256 tokens
137     );
138 
139 
140     /*=====================================
141     =            CONFIGURABLES            =
142     =====================================*/
143     string public name = "EXCHANGE";
144     string public symbol = "DICE";
145     uint8 constant public decimals = 18;
146 
147     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
148     uint8 constant internal fundFee_ = 5; // 5% to dice game
149 
150     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
151     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
152     uint256 constant internal magnitude = 2**64;
153 
154     // Address to send the 5% Fee
155     address public giveEthFundAddress = 0x0;
156     bool public finalizedEthFundAddress = false;
157     uint256 public totalEthFundReceived; // total ETH charity received from this contract
158     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
159 
160     // proof of stake (defaults at 250 tokens)
161     uint256 public stakingRequirement = 25e18;
162 
163     // ambassador program
164     mapping(address => bool) internal ambassadors_;
165     uint256 constant internal ambassadorMaxPurchase_ = 4 ether;
166     uint256 constant internal ambassadorQuota_ = 4 ether;
167 
168    /*================================
169     =            DATASETS            =
170     ================================*/
171     // amount of shares for each address (scaled number)
172     mapping(address => uint256) internal tokenBalanceLedger_;
173     mapping(address => uint256) internal referralBalance_;
174     mapping(address => int256) internal payoutsTo_;
175     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
176     uint256 internal tokenSupply_ = 0;
177     uint256 internal profitPerShare_;
178 
179     // administrator list (see above on what they can do)
180     mapping(address => bool) public administrators;
181 
182     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
183     bool public onlyAmbassadors = true;
184 
185     // To whitelist game contracts on the platform
186     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
187 
188     /*=======================================
189     =            PUBLIC FUNCTIONS            =
190     =======================================*/
191     /*
192     * -- APPLICATION ENTRY POINTS --
193     */
194     constructor()
195         public
196     {
197         // add administrators here
198         administrators[0xB477ACeb6262b12a3c7b2445027a072f95C75Bd3] = true;
199 
200         // add the ambassadors here
201         ambassadors_[0xB477ACeb6262b12a3c7b2445027a072f95C75Bd3] = true;
202     }
203 
204 
205     /**
206      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
207      */
208     function buy(address _referredBy)
209         public
210         payable
211         returns(uint256)
212     {
213 
214         require(tx.gasprice <= 0.05 szabo);
215         purchaseTokens(msg.value, _referredBy, false);
216     }
217 
218     /**
219      * Fallback function to handle ethereum that was send straight to the contract
220      * Unfortunately we cannot use a referral address this way.
221      */
222     function()
223         payable
224         public
225     {
226 
227         require(tx.gasprice <= 0.05 szabo);
228         purchaseTokens(msg.value, 0x0, false);
229     }
230 
231     function updateFundAddress(address _newAddress)
232         onlyAdministrator()
233         public
234     {
235         require(finalizedEthFundAddress == false);
236         giveEthFundAddress = _newAddress;
237     }
238 
239     function finalizeFundAddress(address _finalAddress)
240         onlyAdministrator()
241         public
242     {
243         require(finalizedEthFundAddress == false);
244         giveEthFundAddress = _finalAddress;
245         finalizedEthFundAddress = true;
246     }
247 
248     /**
249      * Sends fund to dice smart contract
250      * No Reentrancy attack as address is finalized to dice smart contract
251      */
252     function payFund() payable public {
253         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
254         require(ethToPay > 0);
255         totalEthFundReceived = SafeMath.add(totalEthFundReceived, ethToPay);
256         if(!giveEthFundAddress.call.value(ethToPay)()) {
257             revert();
258         }
259     }
260 
261     /**
262      * Converts all of caller's dividends to tokens.
263      */
264     function reinvest()
265         onlyStronghands()
266         public
267     {
268         // fetch dividends
269         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
270 
271         // pay out the dividends virtually
272         address _customerAddress = msg.sender;
273         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
274 
275         // retrieve ref. bonus
276         _dividends += referralBalance_[_customerAddress];
277         referralBalance_[_customerAddress] = 0;
278 
279         // dispatch a buy order with the virtualized "withdrawn dividends"
280         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
281 
282         // fire event
283         emit onReinvestment(_customerAddress, _dividends, _tokens);
284     }
285 
286     /**
287      * Alias of sell() and withdraw().
288      */
289     function exit()
290         public
291     {
292         // get token count for caller & sell them all
293         address _customerAddress = msg.sender;
294         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
295         if(_tokens > 0) sell(_tokens);
296 
297         // lambo delivery service
298         withdraw(false);
299     }
300 
301     /**
302      * Withdraws all of the callers earnings.
303      */
304     function withdraw(bool _isTransfer)
305         onlyStronghands()
306         public
307     {
308         // setup data
309         address _customerAddress = msg.sender;
310         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
311 
312         uint256 _estimateTokens = calculateTokensReceived(_dividends);
313 
314         // update dividend tracker
315         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
316 
317         // add ref. bonus
318         _dividends += referralBalance_[_customerAddress];
319         referralBalance_[_customerAddress] = 0;
320 
321         // lambo delivery service
322         _customerAddress.transfer(_dividends);
323 
324         // fire event
325         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
326     }
327 
328     /**
329      * Liquifies tokens to ethereum.
330      */
331     function sell(uint256 _amountOfTokens)
332         onlyBagholders()
333         public
334     {
335         // setup data
336         address _customerAddress = msg.sender;
337         // russian hackers BTFO
338         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
339         uint256 _tokens = _amountOfTokens;
340         uint256 _ethereum = tokensToEthereum_(_tokens);
341 
342         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
343         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
344 
345         // Take out dividends and then _fundPayout
346         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
347 
348         // Add ethereum to send to fund
349         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
350 
351         // burn the sold tokens
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
354 
355         // update dividends tracker
356         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
357         payoutsTo_[_customerAddress] -= _updatedPayouts;
358 
359         // dividing by zero is a bad idea
360         if (tokenSupply_ > 0) {
361             // update the amount of dividends per token
362             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
363         }
364 
365         // fire event
366         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
367     }
368 
369 
370     /**
371      * Transfer tokens from the caller to a new holder.
372      * REMEMBER THIS IS 0% TRANSFER FEE
373      */
374     function transfer(address _toAddress, uint256 _amountOfTokens)
375         onlyBagholders()
376         public
377         returns(bool)
378     {
379         // setup
380         address _customerAddress = msg.sender;
381 
382         // make sure we have the requested tokens
383         // also disables transfers until ambassador phase is over
384         // ( we dont want whale premines )
385         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
386 
387         // withdraw all outstanding dividends first
388         if(myDividends(true) > 0) withdraw(true);
389 
390         // exchange tokens
391         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
392         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
393 
394         // update dividend trackers
395         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
396         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
397 
398 
399         // fire event
400         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
401 
402         // ERC20
403         return true;
404     }
405 
406     /**
407     * Transfer token to a specified address and forward the data to recipient
408     * ERC-677 standard
409     * https://github.com/ethereum/EIPs/issues/677
410     * @param _to    Receiver address.
411     * @param _value Amount of tokens that will be transferred.
412     * @param _data  Transaction metadata.
413     */
414     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
415       require(_to != address(0));
416       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
417       require(transfer(_to, _value)); // do a normal token transfer to the contract
418 
419       if (isContract(_to)) {
420         AcceptsExchange receiver = AcceptsExchange(_to);
421         require(receiver.tokenFallback(msg.sender, _value, _data));
422       }
423 
424       return true;
425     }
426 
427     /**
428      * Additional check that the game address we are sending tokens to is a contract
429      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
430      */
431      function isContract(address _addr) private constant returns (bool is_contract) {
432        // retrieve the size of the code on target address, this needs assembly
433        uint length;
434        assembly { length := extcodesize(_addr) }
435        return length > 0;
436      }
437 
438     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
439     /**
440 
441     /**
442      * In case one of us dies, we need to replace ourselves.
443      */
444     function setAdministrator(address _identifier, bool _status)
445         onlyAdministrator()
446         public
447     {
448         administrators[_identifier] = _status;
449     }
450 
451     /**
452      * Precautionary measures in case we need to adjust the masternode rate.
453      */
454     function setStakingRequirement(uint256 _amountOfTokens)
455         onlyAdministrator()
456         public
457     {
458         stakingRequirement = _amountOfTokens;
459     }
460 
461     /**
462      * Add or remove game contract, which can accept tokens
463      */
464     function setCanAcceptTokens(address _address, bool _value)
465       onlyAdministrator()
466       public
467     {
468       canAcceptTokens_[_address] = _value;
469     }
470 
471     /**
472      * If we want to rebrand, we can.
473      */
474     function setName(string _name)
475         onlyAdministrator()
476         public
477     {
478         name = _name;
479     }
480 
481     /**
482      * If we want to rebrand, we can.
483      */
484     function setSymbol(string _symbol)
485         onlyAdministrator()
486         public
487     {
488         symbol = _symbol;
489     }
490 
491 
492     /*----------  HELPERS AND CALCULATORS  ----------*/
493     /**
494      * Method to view the current Ethereum stored in the contract
495      * Example: totalEthereumBalance()
496      */
497     function totalEthereumBalance()
498         public
499         view
500         returns(uint)
501     {
502         return address(this).balance;
503     }
504 
505     /**
506      * Retrieve the total token supply.
507      */
508     function totalSupply()
509         public
510         view
511         returns(uint256)
512     {
513         return tokenSupply_;
514     }
515 
516     /**
517      * Retrieve the tokens owned by the caller.
518      */
519     function myTokens()
520         public
521         view
522         returns(uint256)
523     {
524         address _customerAddress = msg.sender;
525         return balanceOf(_customerAddress);
526     }
527 
528     /**
529      * Retrieve the dividends owned by the caller.
530      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
531      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
532      * But in the internal calculations, we want them separate.
533      */
534     function myDividends(bool _includeReferralBonus)
535         public
536         view
537         returns(uint256)
538     {
539         address _customerAddress = msg.sender;
540         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
541     }
542 
543     /**
544      * Retrieve the token balance of any single address.
545      */
546     function balanceOf(address _customerAddress)
547         view
548         public
549         returns(uint256)
550     {
551         return tokenBalanceLedger_[_customerAddress];
552     }
553 
554     /**
555      * Retrieve the dividend balance of any single address.
556      */
557     function dividendsOf(address _customerAddress)
558         view
559         public
560         returns(uint256)
561     {
562         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
563     }
564 
565     /**
566      * Return the buy price of 1 individual token.
567      */
568     function sellPrice()
569         public
570         view
571         returns(uint256)
572     {
573         // our calculation relies on the token supply, so we need supply. Doh.
574         if(tokenSupply_ == 0){
575             return tokenPriceInitial_ - tokenPriceIncremental_;
576         } else {
577             uint256 _ethereum = tokensToEthereum_(1e18);
578             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
579             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
580             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
581             return _taxedEthereum;
582         }
583     }
584 
585     /**
586      * Return the sell price of 1 individual token.
587      */
588     function buyPrice()
589         public
590         view
591         returns(uint256)
592     {
593         // our calculation relies on the token supply, so we need supply. Doh.
594         if(tokenSupply_ == 0){
595             return tokenPriceInitial_ + tokenPriceIncremental_;
596         } else {
597             uint256 _ethereum = tokensToEthereum_(1e18);
598             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
599             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
600             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
601             return _taxedEthereum;
602         }
603     }
604 
605     /**
606      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
607      */
608     function calculateTokensReceived(uint256 _ethereumToSpend)
609         public
610         view
611         returns(uint256)
612     {
613         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
614         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
615         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
616         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
617         return _amountOfTokens;
618     }
619 
620     /**
621      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
622      */
623     function calculateEthereumReceived(uint256 _tokensToSell)
624         public
625         view
626         returns(uint256)
627     {
628         require(_tokensToSell <= tokenSupply_);
629         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
630         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
631         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
632         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
633         return _taxedEthereum;
634     }
635 
636     /**
637      * Function for the frontend to show ether waiting to be send to fund in contract
638      */
639     function etherToSendFund()
640         public
641         view
642         returns(uint256) {
643         return SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
644     }
645 
646     /*==========================================
647     =            INTERNAL FUNCTIONS            =
648     ==========================================*/
649 
650     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest)
651         antiEarlyWhale(_incomingEthereum)
652         internal
653         returns(uint256)
654     {
655         // data setup
656         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
657         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
658         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
659         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
660         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
661         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
662 
663         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
664         uint256 _fee = _dividends * magnitude;
665 
666         // no point in continuing execution if OP is a poor russian hacker
667         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
668         // (or hackers)
669         // and yes we know that the safemath function automatically rules out the "greater then" equation.
670         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
671 
672         // is the user referred by a masternode?
673         if(
674             // is this a referred purchase?
675             _referredBy != 0x0000000000000000000000000000000000000000 &&
676 
677             // no cheating!
678             _referredBy != msg.sender &&
679 
680             // does the referrer have at least X whole tokens?
681             // i.e is the referrer a godly chad masternode
682             tokenBalanceLedger_[_referredBy] >= stakingRequirement
683         ){
684             // wealth redistribution
685             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
686         } else {
687             // no ref purchase
688             // add the referral bonus back to the global dividends cake
689             _dividends = SafeMath.add(_dividends, _referralBonus);
690             _fee = _dividends * magnitude;
691         }
692 
693         // we can't give people infinite ethereum
694         if(tokenSupply_ > 0){
695 
696             // add tokens to the pool
697             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
698 
699             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
700             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
701 
702             // calculate the amount of tokens the customer receives over his purchase
703             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
704 
705         } else {
706             // add tokens to the pool
707             tokenSupply_ = _amountOfTokens;
708         }
709 
710         // update circulating supply & the ledger address for the customer
711         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
712 
713         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
714         //really i know you think you do but you don't
715         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
716         payoutsTo_[msg.sender] += _updatedPayouts;
717 
718         // fire event
719         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
720 
721         return _amountOfTokens;
722     }
723 
724     /**
725      * Calculate Token price based on an amount of incoming ethereum
726      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
727      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
728      */
729     function ethereumToTokens_(uint256 _ethereum)
730         internal
731         view
732         returns(uint256)
733     {
734         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
735         uint256 _tokensReceived =
736          (
737             (
738                 // underflow attempts BTFO
739                 SafeMath.sub(
740                     (sqrt
741                         (
742                             (_tokenPriceInitial**2)
743                             +
744                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
745                             +
746                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
747                             +
748                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
749                         )
750                     ), _tokenPriceInitial
751                 )
752             )/(tokenPriceIncremental_)
753         )-(tokenSupply_)
754         ;
755 
756         return _tokensReceived;
757     }
758 
759     /**
760      * Calculate token sell value.
761      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
762      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
763      */
764      function tokensToEthereum_(uint256 _tokens)
765         internal
766         view
767         returns(uint256)
768     {
769 
770         uint256 tokens_ = (_tokens + 1e18);
771         uint256 _tokenSupply = (tokenSupply_ + 1e18);
772         uint256 _etherReceived =
773         (
774             // underflow attempts BTFO
775             SafeMath.sub(
776                 (
777                     (
778                         (
779                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
780                         )-tokenPriceIncremental_
781                     )*(tokens_ - 1e18)
782                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
783             )
784         /1e18);
785         return _etherReceived;
786     }
787 
788 
789     //This is where all your gas goes, sorry
790     //Not sorry, you probably only paid 1 gwei
791     function sqrt(uint x) internal pure returns (uint y) {
792         uint z = (x + 1) / 2;
793         y = x;
794         while (z < y) {
795             y = z;
796             z = (x / z + z) / 2;
797         }
798     }
799 }
800 
801 /**
802  * @title SafeMath
803  * @dev Math operations with safety checks that throw on error
804  */
805 library SafeMath {
806 
807     /**
808     * @dev Multiplies two numbers, throws on overflow.
809     */
810     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
811         if (a == 0) {
812             return 0;
813         }
814         uint256 c = a * b;
815         assert(c / a == b);
816         return c;
817     }
818 
819     /**
820     * @dev Integer division of two numbers, truncating the quotient.
821     */
822     function div(uint256 a, uint256 b) internal pure returns (uint256) {
823         // assert(b > 0); // Solidity automatically throws when dividing by 0
824         uint256 c = a / b;
825         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
826         return c;
827     }
828 
829     /**
830     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
831     */
832     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
833         assert(b <= a);
834         return a - b;
835     }
836 
837     /**
838     * @dev Adds two numbers, throws on overflow.
839     */
840     function add(uint256 a, uint256 b) internal pure returns (uint256) {
841         uint256 c = a + b;
842         assert(c >= a);
843         return c;
844     }
845 }