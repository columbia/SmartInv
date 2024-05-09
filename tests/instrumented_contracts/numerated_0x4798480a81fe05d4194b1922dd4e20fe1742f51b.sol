1 pragma solidity ^0.4.21;
2 
3 
4 contract AcceptsProofofHumanity {
5     ProofofHumanity public tokenContract;
6 
7     function AcceptsProofofHumanity(address _tokenContract) public {
8         tokenContract = ProofofHumanity(_tokenContract);
9     }
10 
11     modifier onlyTokenContract {
12         require(msg.sender == address(tokenContract));
13         _;
14     }
15 
16     /**
17     * @dev Standard ERC677 function that will handle incoming token transfers.
18     *
19     * @param _from  Token sender address.
20     * @param _value Amount of tokens.
21     * @param _data  Transaction metadata.
22     */
23     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
24 }
25 
26 
27 contract ProofofHumanity {
28     /*=================================
29     =            MODIFIERS            =
30     =================================*/
31     // only people with tokens
32     modifier onlyBagholders() {
33         require(myTokens() > 0);
34         _;
35     }
36 
37     // only people with profits
38     modifier onlyStronghands() {
39         require(myDividends(true) > 0);
40         _;
41     }
42 
43     modifier notContract() {
44       require (msg.sender == tx.origin);
45       _;
46     }
47 
48     // administrators can:
49     // -> change the name of the contract
50     // -> change the name of the token
51     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
52     // they CANNOT:
53     // -> take funds
54     // -> disable withdrawals
55     // -> kill the contract
56     // -> change the price of tokens
57     modifier onlyAdministrator(){
58         address _customerAddress = msg.sender;
59         require(administrators[_customerAddress]);
60         _;
61     }
62 
63 
64     // ensures that the first tokens in the contract will be equally distributed
65     // meaning, no divine dump will be ever possible
66     // result: healthy longevity.
67     modifier antiEarlyWhale(uint256 _amountOfEthereum){
68         address _customerAddress = msg.sender;
69 
70         // are we still in the vulnerable phase?
71         // if so, enact anti early whale protocol
72         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
73             require(
74                 // is the customer in the ambassador list?
75                 ambassadors_[_customerAddress] == true &&
76 
77                 // does the customer purchase exceed the max ambassador quota?
78                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
79 
80             );
81 
82             // updated the accumulated quota
83             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
84 
85             // execute
86             _;
87         } else {
88             // in case the ether count drops low, the ambassador phase won't reinitiate
89             onlyAmbassadors = false;
90             _;
91         }
92 
93     }
94 
95     /*==============================
96     =            EVENTS            =
97     ==============================*/
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy
103     );
104 
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 ethereumEarned
109     );
110 
111     event onReinvestment(
112         address indexed customerAddress,
113         uint256 ethereumReinvested,
114         uint256 tokensMinted
115     );
116 
117     event onWithdraw(
118         address indexed customerAddress,
119         uint256 ethereumWithdrawn
120     );
121 
122     // ERC20
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128 
129 
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "Proof of Humanity";
134     string public symbol = "PoH";
135     uint8 constant public decimals = 18;
136     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
137     uint8 constant internal charityFee_ = 2; // 2% charity fee on each buy and sell
138     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
139     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
140     uint256 constant internal magnitude = 2**64;
141 
142     // Address to send the charity  ! :)
143     //  https://giveth.io/
144     // https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
145     address constant public giveEthCharityAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
146     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
147     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
148 
149     // proof of stake (defaults at 100 tokens)
150     uint256 public stakingRequirement = 10e18;
151 
152     // ambassador program
153     mapping(address => bool) internal ambassadors_;
154     uint256 constant internal ambassadorMaxPurchase_ = 0.4 ether;
155     uint256 constant internal ambassadorQuota_ = 10 ether;
156 
157 
158 
159    /*================================
160     =            DATASETS            =
161     ================================*/
162     // amount of shares for each address (scaled number)
163     mapping(address => uint256) internal tokenBalanceLedger_;
164     mapping(address => uint256) internal referralBalance_;
165     mapping(address => int256) internal payoutsTo_;
166     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
167     uint256 internal tokenSupply_ = 0;
168     uint256 internal profitPerShare_;
169 
170     // administrator list (see above on what they can do)
171     mapping(address => bool) public administrators;
172 
173     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
174     bool public onlyAmbassadors = false;
175 
176     // Special ProofofHumanity Platform control from scam game contracts on ProofofHumanity platform
177     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept ProofofHumanity tokens
178 
179 
180 
181     /*=======================================
182     =            PUBLIC FUNCTIONS            =
183     =======================================*/
184     /*
185     * -- APPLICATION ENTRY POINTS --
186     */
187     function ProofofHumanity()
188         public
189     {
190         // add administrators here
191         administrators[0xFEb461A778Be56aEE6F8138D1ddA8fcc768E5800] = true;
192 
193         // add the ambassadors here.
194         ambassadors_[0xFEb461A778Be56aEE6F8138D1ddA8fcc768E5800] = true;
195         
196     }
197 
198 
199     /**
200      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
201      */
202     function buy(address _referredBy)
203         public
204         payable
205         returns(uint256)
206     {
207         purchaseInternal(msg.value, _referredBy);
208     }
209 
210     /**
211      * Fallback function to handle ethereum that was send straight to the contract
212      * Unfortunately we cannot use a referral address this way.
213      */
214     function()
215         payable
216         public
217     {
218         purchaseInternal(msg.value, 0x0);
219     }
220 
221     /**
222      * Sends charity money to the  https://giveth.io/
223      * Their charity address is here https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
224      */
225     function payCharity() payable public {
226       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
227       require(ethToPay > 1);
228       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
229       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
230          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
231       }
232     }
233 
234     /**
235      * Converts all of caller's dividends to tokens.
236      */
237     function reinvest()
238         onlyStronghands()
239         public
240     {
241         // fetch dividends
242         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
243 
244         // pay out the dividends virtually
245         address _customerAddress = msg.sender;
246         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
247 
248         // retrieve ref. bonus
249         _dividends += referralBalance_[_customerAddress];
250         referralBalance_[_customerAddress] = 0;
251 
252         // dispatch a buy order with the virtualized "withdrawn dividends"
253         uint256 _tokens = purchaseTokens(_dividends, 0x0);
254 
255         // fire event
256         onReinvestment(_customerAddress, _dividends, _tokens);
257     }
258 
259     /**
260      * Alias of sell() and withdraw().
261      */
262     function exit()
263         public
264     {
265         // get token count for caller & sell them all
266         address _customerAddress = msg.sender;
267         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
268         if(_tokens > 0) sell(_tokens);
269 
270         // lambo delivery service
271         withdraw();
272     }
273 
274     /**
275      * Withdraws all of the callers earnings.
276      */
277     function withdraw()
278         onlyStronghands()
279         public
280     {
281         // setup data
282         address _customerAddress = msg.sender;
283         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
284 
285         // update dividend tracker
286         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
287 
288         // add ref. bonus
289         _dividends += referralBalance_[_customerAddress];
290         referralBalance_[_customerAddress] = 0;
291 
292         // lambo delivery service
293         _customerAddress.transfer(_dividends);
294 
295         // fire event
296         onWithdraw(_customerAddress, _dividends);
297     }
298 
299     /**
300      * Liquifies tokens to ethereum.
301      */
302     function sell(uint256 _amountOfTokens)
303         onlyBagholders()
304         public
305     {
306         // setup data
307         address _customerAddress = msg.sender;
308         // russian hackers BTFO
309         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
310         uint256 _tokens = _amountOfTokens;
311         uint256 _ethereum = tokensToEthereum_(_tokens);
312 
313         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
314         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
315 
316         // Take out dividends and then _charityPayout
317         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
318 
319         // Add ethereum to send to charity
320         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
321 
322         // burn the sold tokens
323         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
324         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
325 
326         // update dividends tracker
327         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
328         payoutsTo_[_customerAddress] -= _updatedPayouts;
329 
330         // dividing by zero is a bad idea
331         if (tokenSupply_ > 0) {
332             // update the amount of dividends per token
333             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334         }
335 
336         // fire event
337         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
338     }
339 
340 
341     /**
342      * Transfer tokens from the caller to a new holder.
343      * REMEMBER THIS IS 0% TRANSFER FEE
344      */
345     function transfer(address _toAddress, uint256 _amountOfTokens)
346         onlyBagholders()
347         public
348         returns(bool)
349     {
350         // setup
351         address _customerAddress = msg.sender;
352 
353         // make sure we have the requested tokens
354         // also disables transfers until ambassador phase is over
355         // ( we dont want whale premines )
356         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
357 
358         // withdraw all outstanding dividends first
359         if(myDividends(true) > 0) withdraw();
360 
361         // exchange tokens
362         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
363         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
364 
365         // update dividend trackers
366         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
367         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
368 
369 
370         // fire event
371         Transfer(_customerAddress, _toAddress, _amountOfTokens);
372 
373         // ERC20
374         return true;
375     }
376 
377     /**
378     * Transfer token to a specified address and forward the data to recipient
379     * ERC-677 standard
380     * https://github.com/ethereum/EIPs/issues/677
381     * @param _to    Receiver address.
382     * @param _value Amount of tokens that will be transferred.
383     * @param _data  Transaction metadata.
384     */
385     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
386       require(_to != address(0));
387       require(canAcceptTokens_[_to] == true); // security check that contract approved by ProofofHumanity platform
388       require(transfer(_to, _value)); // do a normal token transfer to the contract
389 
390       if (isContract(_to)) {
391         AcceptsProofofHumanity receiver = AcceptsProofofHumanity(_to);
392         require(receiver.tokenFallback(msg.sender, _value, _data));
393       }
394 
395       return true;
396     }
397 
398     /**
399      * Additional check that the game address we are sending tokens to is a contract
400      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
401      */
402      function isContract(address _addr) private constant returns (bool is_contract) {
403        // retrieve the size of the code on target address, this needs assembly
404        uint length;
405        assembly { length := extcodesize(_addr) }
406        return length > 0;
407      }
408 
409     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
410     /**
411      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
412      */
413     function disableInitialStage()
414         onlyAdministrator()
415         public
416     {
417         onlyAmbassadors = false;
418     }
419 
420     /**
421      * In case one of us dies, we need to replace ourselves.
422      */
423     function setAdministrator(address _identifier, bool _status)
424         onlyAdministrator()
425         public
426     {
427         administrators[_identifier] = _status;
428     }
429 
430     /**
431      * Precautionary measures in case we need to adjust the masternode rate.
432      */
433     function setStakingRequirement(uint256 _amountOfTokens)
434         onlyAdministrator()
435         public
436     {
437         stakingRequirement = _amountOfTokens;
438     }
439 
440     /**
441      * Add or remove game contract, which can accept ProofofHumanity tokens
442      */
443     function setCanAcceptTokens(address _address, bool _value)
444       onlyAdministrator()
445       public
446     {
447       canAcceptTokens_[_address] = _value;
448     }
449 
450     /**
451      * If we want to rebrand, we can.
452      */
453     function setName(string _name)
454         onlyAdministrator()
455         public
456     {
457         name = _name;
458     }
459 
460     /**
461      * If we want to rebrand, we can.
462      */
463     function setSymbol(string _symbol)
464         onlyAdministrator()
465         public
466     {
467         symbol = _symbol;
468     }
469 
470 
471     /*----------  HELPERS AND CALCULATORS  ----------*/
472     /**
473      * Method to view the current Ethereum stored in the contract
474      * Example: totalEthereumBalance()
475      */
476     function totalEthereumBalance()
477         public
478         view
479         returns(uint)
480     {
481         return this.balance;
482     }
483 
484     /**
485      * Retrieve the total token supply.
486      */
487     function totalSupply()
488         public
489         view
490         returns(uint256)
491     {
492         return tokenSupply_;
493     }
494 
495     /**
496      * Retrieve the tokens owned by the caller.
497      */
498     function myTokens()
499         public
500         view
501         returns(uint256)
502     {
503         address _customerAddress = msg.sender;
504         return balanceOf(_customerAddress);
505     }
506 
507     /**
508      * Retrieve the dividends owned by the caller.
509      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
510      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
511      * But in the internal calculations, we want them separate.
512      */
513     function myDividends(bool _includeReferralBonus)
514         public
515         view
516         returns(uint256)
517     {
518         address _customerAddress = msg.sender;
519         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
520     }
521 
522     /**
523      * Retrieve the token balance of any single address.
524      */
525     function balanceOf(address _customerAddress)
526         view
527         public
528         returns(uint256)
529     {
530         return tokenBalanceLedger_[_customerAddress];
531     }
532 
533     /**
534      * Retrieve the dividend balance of any single address.
535      */
536     function dividendsOf(address _customerAddress)
537         view
538         public
539         returns(uint256)
540     {
541         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
542     }
543 
544     /**
545      * Return the buy price of 1 individual token.
546      */
547     function sellPrice()
548         public
549         view
550         returns(uint256)
551     {
552         // our calculation relies on the token supply, so we need supply. Doh.
553         if(tokenSupply_ == 0){
554             return tokenPriceInitial_ - tokenPriceIncremental_;
555         } else {
556             uint256 _ethereum = tokensToEthereum_(1e18);
557             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
558             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
559             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
560             return _taxedEthereum;
561         }
562     }
563 
564     /**
565      * Return the sell price of 1 individual token.
566      */
567     function buyPrice()
568         public
569         view
570         returns(uint256)
571     {
572         // our calculation relies on the token supply, so we need supply. Doh.
573         if(tokenSupply_ == 0){
574             return tokenPriceInitial_ + tokenPriceIncremental_;
575         } else {
576             uint256 _ethereum = tokensToEthereum_(1e18);
577             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
578             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
579             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
580             return _taxedEthereum;
581         }
582     }
583 
584     /**
585      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
586      */
587     function calculateTokensReceived(uint256 _ethereumToSpend)
588         public
589         view
590         returns(uint256)
591     {
592         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
593         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
594         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
595         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
596         return _amountOfTokens;
597     }
598 
599     /**
600      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
601      */
602     function calculateEthereumReceived(uint256 _tokensToSell)
603         public
604         view
605         returns(uint256)
606     {
607         require(_tokensToSell <= tokenSupply_);
608         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
609         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
610         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
611         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
612         return _taxedEthereum;
613     }
614 
615     /**
616      * Function for the frontend to show ether waiting to be send to charity in contract
617      */
618     function etherToSendCharity()
619         public
620         view
621         returns(uint256) {
622         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
623     }
624 
625 
626     /*==========================================
627     =            INTERNAL FUNCTIONS            =
628     ==========================================*/
629 
630     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
631     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
632       notContract()// no contracts allowed
633       internal
634       returns(uint256) {
635 
636       uint256 purchaseEthereum = _incomingEthereum;
637       uint256 excess;
638       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
639           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
640               purchaseEthereum = 5 ether;
641               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
642           }
643       }
644 
645       purchaseTokens(purchaseEthereum, _referredBy);
646 
647       if (excess > 0) {
648         msg.sender.transfer(excess);
649       }
650     }
651 
652 
653     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
654         antiEarlyWhale(_incomingEthereum)
655         internal
656         returns(uint256)
657     {
658         // data setup
659         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
660         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
661         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
662         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
663         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
664 
665         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
666 
667         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
668         uint256 _fee = _dividends * magnitude;
669 
670         // no point in continuing execution if OP is a poorfag russian hacker
671         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
672         // (or hackers)
673         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
674         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
675 
676         // is the user referred by a masternode?
677         if(
678             // is this a referred purchase?
679             _referredBy != 0x0000000000000000000000000000000000000000 &&
680 
681             // no cheating!
682             _referredBy != msg.sender &&
683 
684             // does the referrer have at least X whole tokens?
685             // i.e is the referrer a godly chad masternode
686             tokenBalanceLedger_[_referredBy] >= stakingRequirement
687         ){
688             // wealth redistribution
689             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
690         } else {
691             // no ref purchase
692             // add the referral bonus back to the global dividends cake
693             _dividends = SafeMath.add(_dividends, _referralBonus);
694             _fee = _dividends * magnitude;
695         }
696 
697         // we can't give people infinite ethereum
698         if(tokenSupply_ > 0){
699 
700             // add tokens to the pool
701             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
702 
703             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
704             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
705 
706             // calculate the amount of tokens the customer receives over his purchase
707             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
708 
709         } else {
710             // add tokens to the pool
711             tokenSupply_ = _amountOfTokens;
712         }
713 
714         // update circulating supply & the ledger address for the customer
715         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
716 
717         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
718         //really i know you think you do but you don't
719         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
720         payoutsTo_[msg.sender] += _updatedPayouts;
721 
722         // fire event
723         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
724 
725         return _amountOfTokens;
726     }
727 
728     /**
729      * Calculate Token price based on an amount of incoming ethereum
730      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
731      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
732      */
733     function ethereumToTokens_(uint256 _ethereum)
734         internal
735         view
736         returns(uint256)
737     {
738         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
739         uint256 _tokensReceived =
740          (
741             (
742                 // underflow attempts BTFO
743                 SafeMath.sub(
744                     (sqrt
745                         (
746                             (_tokenPriceInitial**2)
747                             +
748                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
749                             +
750                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
751                             +
752                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
753                         )
754                     ), _tokenPriceInitial
755                 )
756             )/(tokenPriceIncremental_)
757         )-(tokenSupply_)
758         ;
759 
760         return _tokensReceived;
761     }
762 
763     /**
764      * Calculate token sell value.
765      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
766      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
767      */
768      function tokensToEthereum_(uint256 _tokens)
769         internal
770         view
771         returns(uint256)
772     {
773 
774         uint256 tokens_ = (_tokens + 1e18);
775         uint256 _tokenSupply = (tokenSupply_ + 1e18);
776         uint256 _etherReceived =
777         (
778             // underflow attempts BTFO
779             SafeMath.sub(
780                 (
781                     (
782                         (
783                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
784                         )-tokenPriceIncremental_
785                     )*(tokens_ - 1e18)
786                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
787             )
788         /1e18);
789         return _etherReceived;
790     }
791 
792 
793     //This is where all your gas goes, sorry
794     //Not sorry, you probably only paid 1 gwei
795     function sqrt(uint x) internal pure returns (uint y) {
796         uint z = (x + 1) / 2;
797         y = x;
798         while (z < y) {
799             y = z;
800             z = (x / z + z) / 2;
801         }
802     }
803 }
804 
805 /**
806  * @title SafeMath
807  * @dev Math operations with safety checks that throw on error
808  */
809 library SafeMath {
810 
811     /**
812     * @dev Multiplies two numbers, throws on overflow.
813     */
814     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
815         if (a == 0) {
816             return 0;
817         }
818         uint256 c = a * b;
819         assert(c / a == b);
820         return c;
821     }
822 
823     /**
824     * @dev Integer division of two numbers, truncating the quotient.
825     */
826     function div(uint256 a, uint256 b) internal pure returns (uint256) {
827         // assert(b > 0); // Solidity automatically throws when dividing by 0
828         uint256 c = a / b;
829         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
830         return c;
831     }
832 
833     /**
834     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
835     */
836     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
837         assert(b <= a);
838         return a - b;
839     }
840 
841     /**
842     * @dev Adds two numbers, throws on overflow.
843     */
844     function add(uint256 a, uint256 b) internal pure returns (uint256) {
845         uint256 c = a + b;
846         assert(c >= a);
847         return c;
848     }
849 }