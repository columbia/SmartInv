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
68         address _customerAddress = msg.sender;
69 
70         if (now >= ACTIVATION_TIME) {
71             onlyAmbassadors = false;
72         }
73 
74         // are we still in the vulnerable phase?
75         // if so, enact anti early whale protocol
76         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
77             require(
78                 // is the customer in the ambassador list?
79                 ambassadors_[_customerAddress] == true &&
80 
81                 // does the customer purchase exceed the max ambassador quota?
82                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
83 
84             );
85 
86             // updated the accumulated quota
87             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
88 
89             // execute
90             _;
91         } else {
92             if((totalEthereumBalance() - _amountOfEthereum) < 250 ether)
93               require(tx.gasprice <= 0.05 szabo);
94 
95             // in case the ether count drops low, the ambassador phase won't reinitiate
96             onlyAmbassadors = false;
97             _;
98         }
99 
100     }
101 
102     /*==============================
103     =            EVENTS            =
104     ==============================*/
105     event onTokenPurchase(
106         address indexed customerAddress,
107         uint256 incomingEthereum,
108         uint256 tokensMinted,
109         address indexed referredBy,
110         bool isReinvest,
111         uint timestamp,
112         uint256 price
113     );
114 
115     event onTokenSell(
116         address indexed customerAddress,
117         uint256 tokensBurned,
118         uint256 ethereumEarned,
119         uint timestamp,
120         uint256 price
121     );
122 
123     event onReinvestment(
124         address indexed customerAddress,
125         uint256 ethereumReinvested,
126         uint256 tokensMinted
127     );
128 
129     event onWithdraw(
130         address indexed customerAddress,
131         uint256 ethereumWithdrawn,
132         uint256 estimateTokens,
133         bool isTransfer
134     );
135 
136     // ERC20
137     event Transfer(
138         address indexed from,
139         address indexed to,
140         uint256 tokens
141     );
142 
143 
144     /*=====================================
145     =            CONFIGURABLES            =
146     =====================================*/
147     string public name = "EXCHANGE";
148     string public symbol = "DICE";
149     uint8 constant public decimals = 18;
150 
151     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
152     uint8 constant internal fundFee_ = 5; // 5% to dice game
153 
154     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
155     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
156     uint256 constant internal magnitude = 2**64;
157 
158     // Address to send the 5% Fee
159     address public giveEthFundAddress = 0x0;
160     bool public finalizedEthFundAddress = false;
161     uint256 public totalEthFundReceived; // total ETH charity received from this contract
162     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
163 
164     // proof of stake (defaults at 250 tokens)
165     uint256 public stakingRequirement = 250e18;
166 
167     // ambassador program
168     mapping(address => bool) internal ambassadors_;
169     uint256 constant internal ambassadorMaxPurchase_ = 4 ether;
170     uint256 constant internal ambassadorQuota_ = 4 ether;
171 
172    /*================================
173     =            DATASETS            =
174     ================================*/
175     // amount of shares for each address (scaled number)
176     mapping(address => uint256) internal tokenBalanceLedger_;
177     mapping(address => uint256) internal referralBalance_;
178     mapping(address => int256) internal payoutsTo_;
179     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
180     uint256 internal tokenSupply_ = 0;
181     uint256 internal profitPerShare_;
182 
183     // administrator list (see above on what they can do)
184     mapping(address => bool) public administrators;
185 
186     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
187     bool public onlyAmbassadors = true;
188 
189     // To whitelist game contracts on the platform
190     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --
197     */
198     constructor()
199         public
200     {
201         // add administrators here
202         administrators[0xB477ACeb6262b12a3c7b2445027a072f95C75Bd3] = true;
203 
204         // add the ambassadors here
205         ambassadors_[0xB477ACeb6262b12a3c7b2445027a072f95C75Bd3] = true;
206     }
207 
208 
209     /**
210      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
211      */
212     function buy(address _referredBy)
213         public
214         payable
215         returns(uint256)
216     {
217         purchaseTokens(msg.value, _referredBy, false);
218     }
219 
220     /**
221      * Fallback function to handle ethereum that was send straight to the contract
222      * Unfortunately we cannot use a referral address this way.
223      */
224     function()
225         payable
226         public
227     {
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
252     function payFund() public {
253         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
254         require(ethToPay > 0);
255         totalEthFundReceived = SafeMath.add(totalEthFundReceived, ethToPay);
256         giveEthFundAddress.transfer(ethToPay);
257     }
258 
259     /**
260      * Converts all of caller's dividends to tokens.
261      */
262     function reinvest()
263         onlyStronghands()
264         public
265     {
266         // fetch dividends
267         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
268 
269         // pay out the dividends virtually
270         address _customerAddress = msg.sender;
271         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
272 
273         // retrieve ref. bonus
274         _dividends += referralBalance_[_customerAddress];
275         referralBalance_[_customerAddress] = 0;
276 
277         // dispatch a buy order with the virtualized "withdrawn dividends"
278         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
279 
280         // fire event
281         emit onReinvestment(_customerAddress, _dividends, _tokens);
282     }
283 
284     /**
285      * Alias of sell() and withdraw().
286      */
287     function exit()
288         public
289     {
290         // get token count for caller & sell them all
291         address _customerAddress = msg.sender;
292         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
293         if(_tokens > 0) sell(_tokens);
294 
295         // lambo delivery service
296         withdraw(false);
297     }
298 
299     /**
300      * Withdraws all of the callers earnings.
301      */
302     function withdraw(bool _isTransfer)
303         onlyStronghands()
304         public
305     {
306         // setup data
307         address _customerAddress = msg.sender;
308         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
309 
310         uint256 _estimateTokens = calculateTokensReceived(_dividends);
311 
312         // update dividend tracker
313         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
314 
315         // add ref. bonus
316         _dividends += referralBalance_[_customerAddress];
317         referralBalance_[_customerAddress] = 0;
318 
319         // lambo delivery service
320         _customerAddress.transfer(_dividends);
321 
322         // fire event
323         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
324     }
325 
326     /**
327      * Liquifies tokens to ethereum.
328      */
329     function sell(uint256 _amountOfTokens)
330         onlyBagholders()
331         public
332     {
333         // setup data
334         address _customerAddress = msg.sender;
335         // russian hackers BTFO
336         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
337         uint256 _tokens = _amountOfTokens;
338         uint256 _ethereum = tokensToEthereum_(_tokens);
339 
340         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
341         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
342 
343         // Take out dividends and then _fundPayout
344         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
345 
346         // Add ethereum to send to fund
347         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
348 
349         // burn the sold tokens
350         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
351         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
352 
353         // update dividends tracker
354         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
355         payoutsTo_[_customerAddress] -= _updatedPayouts;
356 
357         // dividing by zero is a bad idea
358         if (tokenSupply_ > 0) {
359             // update the amount of dividends per token
360             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
361         }
362 
363         // fire event
364         emit Transfer(_customerAddress, address(0), _tokens);
365 
366         // fire event
367         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
368     }
369 
370 
371     /**
372      * Transfer tokens from the caller to a new holder.
373      * REMEMBER THIS IS 0% TRANSFER FEE
374      */
375     function transfer(address _toAddress, uint256 _amountOfTokens)
376         onlyBagholders()
377         public
378         returns(bool)
379     {
380         // setup
381         address _customerAddress = msg.sender;
382 
383         // make sure we have the requested tokens
384         // also disables transfers until ambassador phase is over
385         // ( we dont want whale premines )
386         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
387 
388         // withdraw all outstanding dividends first
389         if(myDividends(true) > 0) withdraw(true);
390 
391         // exchange tokens
392         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
393         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
394 
395         // update dividend trackers
396         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
397         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
398 
399 
400         // fire event
401         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
402 
403         // ERC20
404         return true;
405     }
406 
407     /**
408     * Transfer token to a specified address and forward the data to recipient
409     * ERC-677 standard
410     * https://github.com/ethereum/EIPs/issues/677
411     * @param _to    Receiver address.
412     * @param _value Amount of tokens that will be transferred.
413     * @param _data  Transaction metadata.
414     */
415     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
416       require(_to != address(0));
417       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
418       require(transfer(_to, _value)); // do a normal token transfer to the contract
419 
420       if (isContract(_to)) {
421         AcceptsExchange receiver = AcceptsExchange(_to);
422         require(receiver.tokenFallback(msg.sender, _value, _data));
423       }
424 
425       return true;
426     }
427 
428     /**
429      * Additional check that the game address we are sending tokens to is a contract
430      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
431      */
432      function isContract(address _addr) private constant returns (bool is_contract) {
433        // retrieve the size of the code on target address, this needs assembly
434        uint length;
435        assembly { length := extcodesize(_addr) }
436        return length > 0;
437      }
438 
439     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
440     /**
441 
442     /**
443      * In case one of us dies, we need to replace ourselves.
444      */
445     function setAdministrator(address _identifier, bool _status)
446         onlyAdministrator()
447         public
448     {
449         administrators[_identifier] = _status;
450     }
451 
452     /**
453      * Precautionary measures in case we need to adjust the masternode rate.
454      */
455     function setStakingRequirement(uint256 _amountOfTokens)
456         onlyAdministrator()
457         public
458     {
459         stakingRequirement = _amountOfTokens;
460     }
461 
462     /**
463      * Add or remove game contract, which can accept tokens
464      */
465     function setCanAcceptTokens(address _address, bool _value)
466       onlyAdministrator()
467       public
468     {
469       canAcceptTokens_[_address] = _value;
470     }
471 
472     /**
473      * If we want to rebrand, we can.
474      */
475     function setName(string _name)
476         onlyAdministrator()
477         public
478     {
479         name = _name;
480     }
481 
482     /**
483      * If we want to rebrand, we can.
484      */
485     function setSymbol(string _symbol)
486         onlyAdministrator()
487         public
488     {
489         symbol = _symbol;
490     }
491 
492 
493     /*----------  HELPERS AND CALCULATORS  ----------*/
494     /**
495      * Method to view the current Ethereum stored in the contract
496      * Example: totalEthereumBalance()
497      */
498     function totalEthereumBalance()
499         public
500         view
501         returns(uint)
502     {
503         return address(this).balance;
504     }
505 
506     /**
507      * Retrieve the total token supply.
508      */
509     function totalSupply()
510         public
511         view
512         returns(uint256)
513     {
514         return tokenSupply_;
515     }
516 
517     /**
518      * Retrieve the tokens owned by the caller.
519      */
520     function myTokens()
521         public
522         view
523         returns(uint256)
524     {
525         address _customerAddress = msg.sender;
526         return balanceOf(_customerAddress);
527     }
528 
529     /**
530      * Retrieve the dividends owned by the caller.
531      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
532      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
533      * But in the internal calculations, we want them separate.
534      */
535     function myDividends(bool _includeReferralBonus)
536         public
537         view
538         returns(uint256)
539     {
540         address _customerAddress = msg.sender;
541         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
542     }
543 
544     /**
545      * Retrieve the token balance of any single address.
546      */
547     function balanceOf(address _customerAddress)
548         view
549         public
550         returns(uint256)
551     {
552         return tokenBalanceLedger_[_customerAddress];
553     }
554 
555     /**
556      * Retrieve the dividend balance of any single address.
557      */
558     function dividendsOf(address _customerAddress)
559         view
560         public
561         returns(uint256)
562     {
563         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
564     }
565 
566     /**
567      * Return the buy price of 1 individual token.
568      */
569     function sellPrice()
570         public
571         view
572         returns(uint256)
573     {
574         // our calculation relies on the token supply, so we need supply. Doh.
575         if(tokenSupply_ == 0){
576             return tokenPriceInitial_ - tokenPriceIncremental_;
577         } else {
578             uint256 _ethereum = tokensToEthereum_(1e18);
579             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
580             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
581             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
582             return _taxedEthereum;
583         }
584     }
585 
586     /**
587      * Return the sell price of 1 individual token.
588      */
589     function buyPrice()
590         public
591         view
592         returns(uint256)
593     {
594         // our calculation relies on the token supply, so we need supply. Doh.
595         if(tokenSupply_ == 0){
596             return tokenPriceInitial_ + tokenPriceIncremental_;
597         } else {
598             uint256 _ethereum = tokensToEthereum_(1e18);
599             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
600             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
601             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
602             return _taxedEthereum;
603         }
604     }
605 
606     /**
607      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
608      */
609     function calculateTokensReceived(uint256 _ethereumToSpend)
610         public
611         view
612         returns(uint256)
613     {
614         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
615         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
616         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
617         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
618         return _amountOfTokens;
619     }
620 
621     /**
622      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
623      */
624     function calculateEthereumReceived(uint256 _tokensToSell)
625         public
626         view
627         returns(uint256)
628     {
629         require(_tokensToSell <= tokenSupply_);
630         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
631         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
632         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
633         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
634         return _taxedEthereum;
635     }
636 
637     /**
638      * Function for the frontend to show ether waiting to be send to fund in contract
639      */
640     function etherToSendFund()
641         public
642         view
643         returns(uint256) {
644         return SafeMath.sub(totalEthFundCollected, totalEthFundReceived);
645     }
646 
647     /*==========================================
648     =            INTERNAL FUNCTIONS            =
649     ==========================================*/
650 
651     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest)
652         antiEarlyWhale(_incomingEthereum)
653         internal
654         returns(uint256)
655     {
656         // data setup
657         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
658         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
659         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.div(_undividedDividends, 3));
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
685             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(_undividedDividends, 3));
686         } else {
687             // no ref purchase
688             // add the referral bonus back to the global dividends cake
689             _dividends = SafeMath.add(_dividends, SafeMath.div(_undividedDividends, 3));
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
719         emit Transfer(address(0), msg.sender, _amountOfTokens);
720 
721         // fire event
722         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
723 
724         return _amountOfTokens;
725     }
726 
727     /**
728      * Calculate Token price based on an amount of incoming ethereum
729      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
730      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
731      */
732     function ethereumToTokens_(uint256 _ethereum)
733         internal
734         view
735         returns(uint256)
736     {
737         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
738         uint256 _tokensReceived =
739          (
740             (
741                 // underflow attempts BTFO
742                 SafeMath.sub(
743                     (sqrt
744                         (
745                             (_tokenPriceInitial**2)
746                             +
747                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
748                             +
749                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
750                             +
751                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
752                         )
753                     ), _tokenPriceInitial
754                 )
755             )/(tokenPriceIncremental_)
756         )-(tokenSupply_)
757         ;
758 
759         return _tokensReceived;
760     }
761 
762     /**
763      * Calculate token sell value.
764      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
765      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
766      */
767      function tokensToEthereum_(uint256 _tokens)
768         internal
769         view
770         returns(uint256)
771     {
772 
773         uint256 tokens_ = (_tokens + 1e18);
774         uint256 _tokenSupply = (tokenSupply_ + 1e18);
775         uint256 _etherReceived =
776         (
777             // underflow attempts BTFO
778             SafeMath.sub(
779                 (
780                     (
781                         (
782                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
783                         )-tokenPriceIncremental_
784                     )*(tokens_ - 1e18)
785                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
786             )
787         /1e18);
788         return _etherReceived;
789     }
790 
791 
792     //This is where all your gas goes, sorry
793     //Not sorry, you probably only paid 1 gwei
794     function sqrt(uint x) internal pure returns (uint y) {
795         uint z = (x + 1) / 2;
796         y = x;
797         while (z < y) {
798             y = z;
799             z = (x / z + z) / 2;
800         }
801     }
802 }
803 
804 /**
805  * @title SafeMath
806  * @dev Math operations with safety checks that throw on error
807  */
808 library SafeMath {
809 
810     /**
811     * @dev Multiplies two numbers, throws on overflow.
812     */
813     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
814         if (a == 0) {
815             return 0;
816         }
817         uint256 c = a * b;
818         assert(c / a == b);
819         return c;
820     }
821 
822     /**
823     * @dev Integer division of two numbers, truncating the quotient.
824     */
825     function div(uint256 a, uint256 b) internal pure returns (uint256) {
826         // assert(b > 0); // Solidity automatically throws when dividing by 0
827         uint256 c = a / b;
828         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
829         return c;
830     }
831 
832     /**
833     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
834     */
835     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
836         assert(b <= a);
837         return a - b;
838     }
839 
840     /**
841     * @dev Adds two numbers, throws on overflow.
842     */
843     function add(uint256 a, uint256 b) internal pure returns (uint256) {
844         uint256 c = a + b;
845         assert(c >= a);
846         return c;
847     }
848 }