1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 EXPERIMENT
6 
7 THIS IS AN EXPERIMENT OF PSYCHOLOGY
8 
9 AND NOTHING MORE
10 */
11 
12 
13 /**
14  * Definition of contract accepting EXP tokens
15  * EXP Lending and other games can reuse this contract to support EXP tokens
16  */
17 contract AcceptsExp {
18     Experiment public tokenContract;
19 
20     function AcceptsExp(address _tokenContract) public {
21         tokenContract = Experiment(_tokenContract);
22     }
23 
24     modifier onlyTokenContract {
25         require(msg.sender == address(tokenContract));
26         _;
27     }
28 
29     /**
30     * @dev Standard ERC677 function that will handle incoming token transfers.
31     *
32     * @param _from  Token sender address.
33     * @param _value Amount of tokens.
34     * @param _data  Transaction metadata.
35     */
36     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
37 }
38 
39 
40 contract Experiment {
41     /*=================================
42     =            MODIFIERS            =
43     =================================*/
44     // only people with tokens
45     modifier onlyBagholders() {
46         require(myTokens() > 0);
47         _;
48     }
49 
50     // only people with profits
51     modifier onlyStronghands() {
52         require(myDividends(true) > 0);
53         _;
54     }
55 
56     modifier notContract() {
57       require (msg.sender == tx.origin);
58       _;
59     }
60 
61     // administrators can:
62     // -> change the name of the contract
63     // -> change the name of the token
64     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
65     // they CANNOT:
66     // -> take funds
67     // -> disable withdrawals
68     // -> kill the contract
69     // -> change the price of tokens
70     modifier onlyAdministrator(){
71         address _customerAddress = msg.sender;
72         require(administrators[_customerAddress]);
73         _;
74     }
75     
76     uint ACTIVATION_TIME = 1540957500;
77 
78 
79     // ensures that the first tokens in the contract will be equally distributed
80     // meaning, no divine dump will be ever possible
81     // result: healthy longevity.
82     modifier antiEarlyWhale(uint256 _amountOfEthereum){
83         address _customerAddress = msg.sender;
84         
85         if (now >= ACTIVATION_TIME) {
86             onlyAmbassadors = false;
87         }
88 
89         // are we still in the vulnerable phase?
90         // if so, enact anti early whale protocol
91         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
92             require(
93                 // is the customer in the ambassador list?
94                 ambassadors_[_customerAddress] == true &&
95 
96                 // does the customer purchase exceed the max ambassador quota?
97                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
98 
99             );
100 
101             // updated the accumulated quota
102             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
103 
104             // execute
105             _;
106         } else {
107             // in case the ether count drops low, the ambassador phase won't reinitiate
108             onlyAmbassadors = false;
109             _;
110         }
111 
112     }
113 
114     /*==============================
115     =            EVENTS            =
116     ==============================*/
117     event onTokenPurchase(
118         address indexed customerAddress,
119         uint256 incomingEthereum,
120         uint256 tokensMinted,
121         address indexed referredBy
122     );
123 
124     event onTokenSell(
125         address indexed customerAddress,
126         uint256 tokensBurned,
127         uint256 ethereumEarned
128     );
129 
130     event onReinvestment(
131         address indexed customerAddress,
132         uint256 ethereumReinvested,
133         uint256 tokensMinted
134     );
135 
136     event onWithdraw(
137         address indexed customerAddress,
138         uint256 ethereumWithdrawn
139     );
140 
141     // ERC20
142     event Transfer(
143         address indexed from,
144         address indexed to,
145         uint256 tokens
146     );
147 
148 
149     /*=====================================
150     =            CONFIGURABLES            =
151     =====================================*/
152     string public name = "Experiment";
153     string public symbol = "EXP";
154     uint8 constant public decimals = 18;
155     uint8 constant internal dividendFee_ = 4; // 4% dividend fee on each buy and sell
156     uint8 constant internal fundFee_ = 1; // 1% fund tax on buys/sells/reinvest (split 80/20)
157     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
158     uint256 constant internal tokenPriceIncremental_ = 0.00000008 ether;
159     uint256 constant internal magnitude = 2**64;
160 
161     
162     // 80/20 FUND TAX CONTRACT ADDRESS
163     address constant public giveEthFundAddress = 0x183feBd8828a9ac6c70C0e27FbF441b93004fC05;
164     uint256 public totalEthFundRecieved; // total ETH FUND recieved from this contract
165     uint256 public totalEthFundCollected; // total ETH FUND collected in this contract
166 
167     // proof of stake (defaults at 100 tokens)
168     uint256 public stakingRequirement = 1e18;
169 
170     // ambassador program
171     mapping(address => bool) internal ambassadors_;
172     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
173     uint256 constant internal ambassadorQuota_ = 1.5 ether;
174 
175 
176 
177    /*================================
178     =            DATASETS            =
179     ================================*/
180     // amount of shares for each address (scaled number)
181     mapping(address => uint256) internal tokenBalanceLedger_;
182     mapping(address => uint256) internal referralBalance_;
183     mapping(address => int256) internal payoutsTo_;
184     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
185     uint256 internal tokenSupply_ = 0;
186     uint256 internal profitPerShare_;
187 
188     // administrator list (see above on what they can do)
189     mapping(address => bool) public administrators;
190 
191     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
192     bool public onlyAmbassadors = true;
193 
194     // Special Experiment Platform control from scam game contracts on EXP platform
195     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept EXP tokens
196 
197 
198 
199     /*=======================================
200     =            PUBLIC FUNCTIONS            =
201     =======================================*/
202     /*
203     * -- APPLICATION ENTRY POINTS --
204     */
205     function Experiment()
206         public
207     {
208         // add administrators here
209         administrators[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
210         
211         // admin
212         ambassadors_[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = true;
213 
214         
215         
216         
217     }
218 
219 
220     /**
221      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
222      */
223     function buy(address _referredBy)
224         public
225         payable
226         returns(uint256)
227     {
228         
229         require(tx.gasprice <= 0.05 szabo);
230         purchaseInternal(msg.value, _referredBy);
231     }
232 
233     /**
234      * Fallback function to handle ethereum that was send straight to the contract
235      * Unfortunately we cannot use a referral address this way.
236      */
237     function()
238         payable
239         public
240     {
241         
242         require(tx.gasprice <= 0.01 szabo);
243         purchaseInternal(msg.value, 0x0);
244     }
245 
246     /**
247    
248      */
249     function payFund() payable public {
250       uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
251       require(ethToPay > 1);
252       totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
253       if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
254          totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
255       }
256     }
257 
258     /**
259      * Converts all of caller's dividends to tokens.
260      */
261     function reinvest()
262         onlyStronghands()
263         public
264     {
265         // fetch dividends
266         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
267 
268         // pay out the dividends virtually
269         address _customerAddress = msg.sender;
270         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
271 
272         // retrieve ref. bonus
273         _dividends += referralBalance_[_customerAddress];
274         referralBalance_[_customerAddress] = 0;
275 
276         // dispatch a buy order with the virtualized "withdrawn dividends"
277         uint256 _tokens = purchaseTokens(_dividends, 0x0);
278 
279         // fire event
280         onReinvestment(_customerAddress, _dividends, _tokens);
281     }
282 
283     /**
284      * Alias of sell() and withdraw().
285      */
286     function exit()
287         public
288     {
289         // get token count for caller & sell them all
290         address _customerAddress = msg.sender;
291         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
292         if(_tokens > 0) sell(_tokens);
293 
294         // lambo delivery service
295         withdraw();
296     }
297 
298     /**
299      * Withdraws all of the callers earnings.
300      */
301     function withdraw()
302         onlyStronghands()
303         public
304     {
305         // setup data
306         address _customerAddress = msg.sender;
307         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
308 
309         // update dividend tracker
310         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
311 
312         // add ref. bonus
313         _dividends += referralBalance_[_customerAddress];
314         referralBalance_[_customerAddress] = 0;
315 
316         // lambo delivery service
317         _customerAddress.transfer(_dividends);
318 
319         // fire event
320         onWithdraw(_customerAddress, _dividends);
321     }
322 
323     /**
324      * Liquifies tokens to ethereum.
325      */
326     function sell(uint256 _amountOfTokens)
327         onlyBagholders()
328         public
329     {
330         // setup data
331         address _customerAddress = msg.sender;
332         // russian hackers BTFO
333         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
334         uint256 _tokens = _amountOfTokens;
335         uint256 _ethereum = tokensToEthereum_(_tokens);
336 
337         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
338         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
339 
340         // Take out dividends and then _fundPayout
341         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
342 
343         // Add ethereum to send to Fund Tax Contract
344         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
345 
346         // burn the sold tokens
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
349 
350         // update dividends tracker
351         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
352         payoutsTo_[_customerAddress] -= _updatedPayouts;
353 
354         // dividing by zero is a bad idea
355         if (tokenSupply_ > 0) {
356             // update the amount of dividends per token
357             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
358         }
359 
360         // fire event
361         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
362     }
363 
364 
365     /**
366      * Transfer tokens from the caller to a new holder.
367      * REMEMBER THIS IS 0% TRANSFER FEE
368      */
369     function transfer(address _toAddress, uint256 _amountOfTokens)
370         onlyBagholders()
371         public
372         returns(bool)
373     {
374         // setup
375         address _customerAddress = msg.sender;
376 
377         // make sure we have the requested tokens
378         // also disables transfers until ambassador phase is over
379         // ( we dont want whale premines )
380         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
381 
382         // withdraw all outstanding dividends first
383         if(myDividends(true) > 0) withdraw();
384 
385         // exchange tokens
386         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
387         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
388 
389         // update dividend trackers
390         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
391         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
392 
393 
394         // fire event
395         Transfer(_customerAddress, _toAddress, _amountOfTokens);
396 
397         // ERC20
398         return true;
399     }
400 
401     /**
402     * Transfer token to a specified address and forward the data to recipient
403     * ERC-677 standard
404     * https://github.com/ethereum/EIPs/issues/677
405     * @param _to    Receiver address.
406     * @param _value Amount of tokens that will be transferred.
407     * @param _data  Transaction metadata.
408     */
409     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
410       require(_to != address(0));
411       require(canAcceptTokens_[_to] == true); // security check that contract approved by EXP platform
412       require(transfer(_to, _value)); // do a normal token transfer to the contract
413 
414       if (isContract(_to)) {
415         AcceptsExp receiver = AcceptsExp(_to);
416         require(receiver.tokenFallback(msg.sender, _value, _data));
417       }
418 
419       return true;
420     }
421 
422     /**
423      * Additional check that the game address we are sending tokens to is a contract
424      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
425      */
426      function isContract(address _addr) private constant returns (bool is_contract) {
427        // retrieve the size of the code on target address, this needs assembly
428        uint length;
429        assembly { length := extcodesize(_addr) }
430        return length > 0;
431      }
432 
433     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
434     /**
435      * In case the ambassador quota is not met, the administrator can manually disable the ambassador phase.
436      */
437     //function disableInitialStage()
438     //    onlyAdministrator()
439     //    public
440     //{
441     //    onlyAmbassadors = false;
442     //}
443 
444     /**
445      * In case one of us dies, we need to replace ourselves.
446      */
447     function setAdministrator(address _identifier, bool _status)
448         onlyAdministrator()
449         public
450     {
451         administrators[_identifier] = _status;
452     }
453 
454     /**
455      * Precautionary measures in case we need to adjust the masternode rate.
456      */
457     function setStakingRequirement(uint256 _amountOfTokens)
458         onlyAdministrator()
459         public
460     {
461         stakingRequirement = _amountOfTokens;
462     }
463 
464     /**
465      * Add or remove game contract, which can accept EXP tokens
466      */
467     function setCanAcceptTokens(address _address, bool _value)
468       onlyAdministrator()
469       public
470     {
471       canAcceptTokens_[_address] = _value;
472     }
473 
474     /**
475      * If we want to rebrand, we can.
476      */
477     function setName(string _name)
478         onlyAdministrator()
479         public
480     {
481         name = _name;
482     }
483 
484     /**
485      * If we want to rebrand, we can.
486      */
487     function setSymbol(string _symbol)
488         onlyAdministrator()
489         public
490     {
491         symbol = _symbol;
492     }
493 
494 
495     /*----------  HELPERS AND CALCULATORS  ----------*/
496     /**
497      * Method to view the current Ethereum stored in the contract
498      * Example: totalEthereumBalance()
499      */
500     function totalEthereumBalance()
501         public
502         view
503         returns(uint)
504     {
505         return this.balance;
506     }
507 
508     /**
509      * Retrieve the total token supply.
510      */
511     function totalSupply()
512         public
513         view
514         returns(uint256)
515     {
516         return tokenSupply_;
517     }
518 
519     /**
520      * Retrieve the tokens owned by the caller.
521      */
522     function myTokens()
523         public
524         view
525         returns(uint256)
526     {
527         address _customerAddress = msg.sender;
528         return balanceOf(_customerAddress);
529     }
530 
531     /**
532      * Retrieve the dividends owned by the caller.
533      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
534      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
535      * But in the internal calculations, we want them separate.
536      */
537     function myDividends(bool _includeReferralBonus)
538         public
539         view
540         returns(uint256)
541     {
542         address _customerAddress = msg.sender;
543         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
544     }
545 
546     /**
547      * Retrieve the token balance of any single address.
548      */
549     function balanceOf(address _customerAddress)
550         view
551         public
552         returns(uint256)
553     {
554         return tokenBalanceLedger_[_customerAddress];
555     }
556 
557     /**
558      * Retrieve the dividend balance of any single address.
559      */
560     function dividendsOf(address _customerAddress)
561         view
562         public
563         returns(uint256)
564     {
565         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
566     }
567 
568     /**
569      * Return the buy price of 1 individual token.
570      */
571     function sellPrice()
572         public
573         view
574         returns(uint256)
575     {
576         // our calculation relies on the token supply, so we need supply. Doh.
577         if(tokenSupply_ == 0){
578             return tokenPriceInitial_ - tokenPriceIncremental_;
579         } else {
580             uint256 _ethereum = tokensToEthereum_(1e18);
581             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
582             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
583             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
584             return _taxedEthereum;
585         }
586     }
587 
588     /**
589      * Return the sell price of 1 individual token.
590      */
591     function buyPrice()
592         public
593         view
594         returns(uint256)
595     {
596         // our calculation relies on the token supply, so we need supply. Doh.
597         if(tokenSupply_ == 0){
598             return tokenPriceInitial_ + tokenPriceIncremental_;
599         } else {
600             uint256 _ethereum = tokensToEthereum_(1e18);
601             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
602             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
603             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
604             return _taxedEthereum;
605         }
606     }
607 
608     /**
609      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
610      */
611     function calculateTokensReceived(uint256 _ethereumToSpend)
612         public
613         view
614         returns(uint256)
615     {
616         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
617         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
618         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
619         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
620         return _amountOfTokens;
621     }
622 
623     /**
624      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
625      */
626     function calculateEthereumReceived(uint256 _tokensToSell)
627         public
628         view
629         returns(uint256)
630     {
631         require(_tokensToSell <= tokenSupply_);
632         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
633         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
634         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
635         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
636         return _taxedEthereum;
637     }
638 
639     /**
640      * Function for the frontend to show ether waiting to be sent to Fund Contract from the exchange contract
641      */
642     function etherToSendFund()
643         public
644         view
645         returns(uint256) {
646         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
647     }
648 
649 
650     /*==========================================
651     =            INTERNAL FUNCTIONS            =
652     ==========================================*/
653 
654     // Make sure we will send back excess if user sends more then 2 ether before 200 ETH in contract
655     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
656       notContract()// no contracts allowed
657       internal
658       returns(uint256) {
659 
660       uint256 purchaseEthereum = _incomingEthereum;
661       uint256 excess;
662       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
663           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 200 ether) { // if so check the contract is less then 200 ether
664               purchaseEthereum = 2 ether;
665               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
666           }
667       }
668 
669       purchaseTokens(purchaseEthereum, _referredBy);
670 
671       if (excess > 0) {
672         msg.sender.transfer(excess);
673       }
674     }
675 
676 
677     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
678         antiEarlyWhale(_incomingEthereum)
679         internal
680         returns(uint256)
681     {
682         // data setup
683         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
684         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
685         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
686         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
687         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
688 
689         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
690 
691         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
692         uint256 _fee = _dividends * magnitude;
693 
694         // no point in continuing execution if OP is a poorfag russian hacker
695         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
696         // (or hackers)
697         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
698         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
699 
700         // is the user referred by a masternode?
701         if(
702             // is this a referred purchase?
703             _referredBy != 0x0000000000000000000000000000000000000000 &&
704 
705             // no cheating!
706             _referredBy != msg.sender &&
707 
708             // does the referrer have at least X whole tokens?
709             // i.e is the referrer a godly chad masternode
710             tokenBalanceLedger_[_referredBy] >= stakingRequirement
711         ){
712             // wealth redistribution
713             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
714         } else {
715             // no ref purchase
716             // add the referral bonus back to the global dividends cake
717             _dividends = SafeMath.add(_dividends, _referralBonus);
718             _fee = _dividends * magnitude;
719         }
720 
721         // we can't give people infinite ethereum
722         if(tokenSupply_ > 0){
723 
724             // add tokens to the pool
725             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
726 
727             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
728             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
729 
730             // calculate the amount of tokens the customer receives over his purchase
731             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
732 
733         } else {
734             // add tokens to the pool
735             tokenSupply_ = _amountOfTokens;
736         }
737 
738         // update circulating supply & the ledger address for the customer
739         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
740 
741         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
742         //really i know you think you do but you don't
743         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
744         payoutsTo_[msg.sender] += _updatedPayouts;
745 
746         // fire event
747         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
748 
749         return _amountOfTokens;
750     }
751 
752     /**
753      * Calculate Token price based on an amount of incoming ethereum
754      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
755      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
756      */
757     function ethereumToTokens_(uint256 _ethereum)
758         internal
759         view
760         returns(uint256)
761     {
762         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
763         uint256 _tokensReceived =
764          (
765             (
766                 // underflow attempts BTFO
767                 SafeMath.sub(
768                     (sqrt
769                         (
770                             (_tokenPriceInitial**2)
771                             +
772                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
773                             +
774                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
775                             +
776                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
777                         )
778                     ), _tokenPriceInitial
779                 )
780             )/(tokenPriceIncremental_)
781         )-(tokenSupply_)
782         ;
783 
784         return _tokensReceived;
785     }
786 
787     /**
788      * Calculate token sell value.
789      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
790      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
791      */
792      function tokensToEthereum_(uint256 _tokens)
793         internal
794         view
795         returns(uint256)
796     {
797 
798         uint256 tokens_ = (_tokens + 1e18);
799         uint256 _tokenSupply = (tokenSupply_ + 1e18);
800         uint256 _etherReceived =
801         (
802             // underflow attempts BTFO
803             SafeMath.sub(
804                 (
805                     (
806                         (
807                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
808                         )-tokenPriceIncremental_
809                     )*(tokens_ - 1e18)
810                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
811             )
812         /1e18);
813         return _etherReceived;
814     }
815 
816 
817     //This is where all your gas goes, sorry
818     //Not sorry, you probably only paid 1 gwei
819     function sqrt(uint x) internal pure returns (uint y) {
820         uint z = (x + 1) / 2;
821         y = x;
822         while (z < y) {
823             y = z;
824             z = (x / z + z) / 2;
825         }
826     }
827 }
828 
829 /**
830  * @title SafeMath
831  * @dev Math operations with safety checks that throw on error
832  */
833 library SafeMath {
834 
835     /**
836     * @dev Multiplies two numbers, throws on overflow.
837     */
838     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
839         if (a == 0) {
840             return 0;
841         }
842         uint256 c = a * b;
843         assert(c / a == b);
844         return c;
845     }
846 
847     /**
848     * @dev Integer division of two numbers, truncating the quotient.
849     */
850     function div(uint256 a, uint256 b) internal pure returns (uint256) {
851         // assert(b > 0); // Solidity automatically throws when dividing by 0
852         uint256 c = a / b;
853         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
854         return c;
855     }
856 
857     /**
858     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
859     */
860     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
861         assert(b <= a);
862         return a - b;
863     }
864 
865     /**
866     * @dev Adds two numbers, throws on overflow.
867     */
868     function add(uint256 a, uint256 b) internal pure returns (uint256) {
869         uint256 c = a + b;
870         assert(c >= a);
871         return c;
872     }
873 }