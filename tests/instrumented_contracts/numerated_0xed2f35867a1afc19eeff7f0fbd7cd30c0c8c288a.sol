1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 
6 
7 ******************** ETHEROPOLY *********************
8 * [x] What is new?
9 * [x] REVOLUTIONARY 0% TRANSFER FEES, Now you can send Etheropoly tokens to all your family, no charge
10 * [X] 15% DIVIDENDS AND MASTERNODES! We know you all love your divies :D
11 * [x] Removed charity fee. Giving to charity is a great thing but that is something that should be optional for you all.
12 * [x] DAPP INTEROPERABILITY, games and other dAPPs can incorporate Etheropoly tokens!
13 *
14 * Official website is https://etheropoly.co/
15 * Official discord is https://discord.gg/cQqRbev
16 */
17 
18 
19 /**
20  * Definition of contract accepting Etheropoly tokens
21  * Games, casinos, anything can reuse this contract to support Etheropoly tokens
22  */
23 contract AcceptsEtheropoly {
24     Etheropoly public tokenContract;
25 
26     function AcceptsEtheropoly(address _tokenContract) public {
27         tokenContract = Etheropoly(_tokenContract);
28     }
29 
30     modifier onlyTokenContract {
31         require(msg.sender == address(tokenContract));
32         _;
33     }
34 
35     /**
36     * @dev Standard ERC677 function that will handle incoming token transfers.
37     *
38     * @param _from  Token sender address.
39     * @param _value Amount of tokens.
40     * @param _data  Transaction metadata.
41     */
42     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
43 }
44 
45 
46 contract Etheropoly {
47     /*=================================
48     =            MODIFIERS            =
49     =================================*/
50     // only people with tokens
51     modifier onlyBagholders() {
52         require(myTokens() > 0);
53         _;
54     }
55 
56     // only people with profits
57     modifier onlyStronghands() {
58         require(myDividends(true) > 0);
59         _;
60     }
61 
62     modifier notContract() {
63       require (msg.sender == tx.origin);
64       _;
65     }
66 
67     // administrators can:
68     // -> change the name of the contract
69     // -> change the name of the token
70     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
71     // they CANNOT:
72     // -> take funds
73     // -> disable withdrawals
74     // -> kill the contract
75     // -> change the price of tokens
76     modifier onlyAdministrator(){
77         address _customerAddress = msg.sender;
78         require(administrators[_customerAddress]);
79         _;
80     }
81 
82 
83     // ensures that the first tokens in the contract will be equally distributed
84     // meaning, no divine dump will be ever possible
85     // result: healthy longevity.
86     modifier antiEarlyWhale(uint256 _amountOfEthereum){
87         address _customerAddress = msg.sender;
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
152     string public name = "Etheropoly";
153     string public symbol = "OPOLY";
154     uint8 constant public decimals = 18;
155     uint8 constant internal dividendFee_ = 15; // 15% dividend fee on each buy and sell
156     uint8 constant internal charityFee_ = 0; // 0% charity fee on each buy and sell
157     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
158     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
159     uint256 constant internal magnitude = 2**64;
160 
161     // Address to send the charity  ! :)
162     //  https://giveth.io/
163     // https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
164     address constant public giveEthCharityAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
165     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
166     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
167 
168     // proof of stake (defaults at 100 tokens)
169     uint256 public stakingRequirement = 100e18;
170 
171     // ambassador program
172     mapping(address => bool) internal ambassadors_;
173     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
174     uint256 constant internal ambassadorQuota_ = 4 ether;
175 
176 
177 
178    /*================================
179     =            DATASETS            =
180     ================================*/
181     // amount of shares for each address (scaled number)
182     mapping(address => uint256) internal tokenBalanceLedger_;
183     mapping(address => uint256) internal referralBalance_;
184     mapping(address => int256) internal payoutsTo_;
185     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
186     uint256 internal tokenSupply_ = 0;
187     uint256 internal profitPerShare_;
188 
189     // administrator list (see above on what they can do)
190     mapping(address => bool) public administrators;
191 
192     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
193     bool public onlyAmbassadors = true;
194 
195     // Special Etheropoly Platform control from scam game contracts on Etheropoly platform
196     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Etheropoly tokens
197 
198 
199 
200     /*=======================================
201     =            PUBLIC FUNCTIONS            =
202     =======================================*/
203     /*
204     * -- APPLICATION ENTRY POINTS --
205     */
206     function Etheropoly()
207         public
208     {
209         // add administrators here
210         administrators[0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26] = true;
211 
212         // add the ambassadors here.
213         ambassadors_[0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26] = true;
214         //ambassador S
215         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
216         //ambassador F
217         ambassadors_[0x11756491343b18cb3db47e9734f20096b4f64234] = true;
218         //ambassador W
219         ambassadors_[0x4ffE17a2A72bC7422CB176bC71c04EE6D87cE329] = true;
220         //ambassador J
221         ambassadors_[0xfE8D614431E5fea2329B05839f29B553b1Cb99A2] = true;
222         //ambassador T
223         
224         
225     }
226 
227 
228     /**
229      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
230      */
231     function buy(address _referredBy)
232         public
233         payable
234         returns(uint256)
235     {
236         purchaseInternal(msg.value, _referredBy);
237     }
238 
239     /**
240      * Fallback function to handle ethereum that was send straight to the contract
241      * Unfortunately we cannot use a referral address this way.
242      */
243     function()
244         payable
245         public
246     {
247         purchaseInternal(msg.value, 0x0);
248     }
249 
250     /**
251      * Sends charity money to the  https://giveth.io/
252      * Their charity address is here https://etherscan.io/address/0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc
253      */
254     function payCharity() payable public {
255       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
256       require(ethToPay > 1);
257       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
258       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
259          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
260       }
261     }
262 
263     /**
264      * Converts all of caller's dividends to tokens.
265      */
266     function reinvest()
267         onlyStronghands()
268         public
269     {
270         // fetch dividends
271         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
272 
273         // pay out the dividends virtually
274         address _customerAddress = msg.sender;
275         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
276 
277         // retrieve ref. bonus
278         _dividends += referralBalance_[_customerAddress];
279         referralBalance_[_customerAddress] = 0;
280 
281         // dispatch a buy order with the virtualized "withdrawn dividends"
282         uint256 _tokens = purchaseTokens(_dividends, 0x0);
283 
284         // fire event
285         onReinvestment(_customerAddress, _dividends, _tokens);
286     }
287 
288     /**
289      * Alias of sell() and withdraw().
290      */
291     function exit()
292         public
293     {
294         // get token count for caller & sell them all
295         address _customerAddress = msg.sender;
296         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
297         if(_tokens > 0) sell(_tokens);
298 
299         // lambo delivery service
300         withdraw();
301     }
302 
303     /**
304      * Withdraws all of the callers earnings.
305      */
306     function withdraw()
307         onlyStronghands()
308         public
309     {
310         // setup data
311         address _customerAddress = msg.sender;
312         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
313 
314         // update dividend tracker
315         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
316 
317         // add ref. bonus
318         _dividends += referralBalance_[_customerAddress];
319         referralBalance_[_customerAddress] = 0;
320 
321         // lambo delivery service
322         _customerAddress.transfer(_dividends);
323 
324         // fire event
325         onWithdraw(_customerAddress, _dividends);
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
343         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
344 
345         // Take out dividends and then _charityPayout
346         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
347 
348         // Add ethereum to send to charity
349         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
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
366         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
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
388         if(myDividends(true) > 0) withdraw();
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
400         Transfer(_customerAddress, _toAddress, _amountOfTokens);
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
416       require(canAcceptTokens_[_to] == true); // security check that contract approved by Etheropoly platform
417       require(transfer(_to, _value)); // do a normal token transfer to the contract
418 
419       if (isContract(_to)) {
420         AcceptsEtheropoly receiver = AcceptsEtheropoly(_to);
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
440      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
441      */
442     function disableInitialStage()
443         onlyAdministrator()
444         public
445     {
446         onlyAmbassadors = false;
447     }
448 
449     /**
450      * In case one of us dies, we need to replace ourselves.
451      */
452     function setAdministrator(address _identifier, bool _status)
453         onlyAdministrator()
454         public
455     {
456         administrators[_identifier] = _status;
457     }
458 
459     /**
460      * Precautionary measures in case we need to adjust the masternode rate.
461      */
462     function setStakingRequirement(uint256 _amountOfTokens)
463         onlyAdministrator()
464         public
465     {
466         stakingRequirement = _amountOfTokens;
467     }
468 
469     /**
470      * Add or remove game contract, which can accept Etheropoly tokens
471      */
472     function setCanAcceptTokens(address _address, bool _value)
473       onlyAdministrator()
474       public
475     {
476       canAcceptTokens_[_address] = _value;
477     }
478 
479     /**
480      * If we want to rebrand, we can.
481      */
482     function setName(string _name)
483         onlyAdministrator()
484         public
485     {
486         name = _name;
487     }
488 
489     /**
490      * If we want to rebrand, we can.
491      */
492     function setSymbol(string _symbol)
493         onlyAdministrator()
494         public
495     {
496         symbol = _symbol;
497     }
498 
499 
500     /*----------  HELPERS AND CALCULATORS  ----------*/
501     /**
502      * Method to view the current Ethereum stored in the contract
503      * Example: totalEthereumBalance()
504      */
505     function totalEthereumBalance()
506         public
507         view
508         returns(uint)
509     {
510         return this.balance;
511     }
512 
513     /**
514      * Retrieve the total token supply.
515      */
516     function totalSupply()
517         public
518         view
519         returns(uint256)
520     {
521         return tokenSupply_;
522     }
523 
524     /**
525      * Retrieve the tokens owned by the caller.
526      */
527     function myTokens()
528         public
529         view
530         returns(uint256)
531     {
532         address _customerAddress = msg.sender;
533         return balanceOf(_customerAddress);
534     }
535 
536     /**
537      * Retrieve the dividends owned by the caller.
538      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
539      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
540      * But in the internal calculations, we want them separate.
541      */
542     function myDividends(bool _includeReferralBonus)
543         public
544         view
545         returns(uint256)
546     {
547         address _customerAddress = msg.sender;
548         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
549     }
550 
551     /**
552      * Retrieve the token balance of any single address.
553      */
554     function balanceOf(address _customerAddress)
555         view
556         public
557         returns(uint256)
558     {
559         return tokenBalanceLedger_[_customerAddress];
560     }
561 
562     /**
563      * Retrieve the dividend balance of any single address.
564      */
565     function dividendsOf(address _customerAddress)
566         view
567         public
568         returns(uint256)
569     {
570         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
571     }
572 
573     /**
574      * Return the buy price of 1 individual token.
575      */
576     function sellPrice()
577         public
578         view
579         returns(uint256)
580     {
581         // our calculation relies on the token supply, so we need supply. Doh.
582         if(tokenSupply_ == 0){
583             return tokenPriceInitial_ - tokenPriceIncremental_;
584         } else {
585             uint256 _ethereum = tokensToEthereum_(1e18);
586             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
587             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
588             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
589             return _taxedEthereum;
590         }
591     }
592 
593     /**
594      * Return the sell price of 1 individual token.
595      */
596     function buyPrice()
597         public
598         view
599         returns(uint256)
600     {
601         // our calculation relies on the token supply, so we need supply. Doh.
602         if(tokenSupply_ == 0){
603             return tokenPriceInitial_ + tokenPriceIncremental_;
604         } else {
605             uint256 _ethereum = tokensToEthereum_(1e18);
606             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
607             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
608             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
609             return _taxedEthereum;
610         }
611     }
612 
613     /**
614      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
615      */
616     function calculateTokensReceived(uint256 _ethereumToSpend)
617         public
618         view
619         returns(uint256)
620     {
621         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
622         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
623         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
624         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
625         return _amountOfTokens;
626     }
627 
628     /**
629      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
630      */
631     function calculateEthereumReceived(uint256 _tokensToSell)
632         public
633         view
634         returns(uint256)
635     {
636         require(_tokensToSell <= tokenSupply_);
637         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
638         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
639         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
640         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
641         return _taxedEthereum;
642     }
643 
644     /**
645      * Function for the frontend to show ether waiting to be send to charity in contract
646      */
647     function etherToSendCharity()
648         public
649         view
650         returns(uint256) {
651         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
652     }
653 
654 
655     /*==========================================
656     =            INTERNAL FUNCTIONS            =
657     ==========================================*/
658 
659     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
660     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
661       notContract()// no contracts allowed
662       internal
663       returns(uint256) {
664 
665       uint256 purchaseEthereum = _incomingEthereum;
666       uint256 excess;
667       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
668           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
669               purchaseEthereum = 5 ether;
670               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
671           }
672       }
673 
674       purchaseTokens(purchaseEthereum, _referredBy);
675 
676       if (excess > 0) {
677         msg.sender.transfer(excess);
678       }
679     }
680 
681 
682     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
683         antiEarlyWhale(_incomingEthereum)
684         internal
685         returns(uint256)
686     {
687         // data setup
688         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
689         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
690         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
691         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
692         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
693 
694         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
695 
696         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
697         uint256 _fee = _dividends * magnitude;
698 
699         // no point in continuing execution if OP is a poorfag russian hacker
700         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
701         // (or hackers)
702         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
703         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
704 
705         // is the user referred by a masternode?
706         if(
707             // is this a referred purchase?
708             _referredBy != 0x0000000000000000000000000000000000000000 &&
709 
710             // no cheating!
711             _referredBy != msg.sender &&
712 
713             // does the referrer have at least X whole tokens?
714             // i.e is the referrer a godly chad masternode
715             tokenBalanceLedger_[_referredBy] >= stakingRequirement
716         ){
717             // wealth redistribution
718             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
719         } else {
720             // no ref purchase
721             // add the referral bonus back to the global dividends cake
722             _dividends = SafeMath.add(_dividends, _referralBonus);
723             _fee = _dividends * magnitude;
724         }
725 
726         // we can't give people infinite ethereum
727         if(tokenSupply_ > 0){
728 
729             // add tokens to the pool
730             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
731 
732             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
733             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
734 
735             // calculate the amount of tokens the customer receives over his purchase
736             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
737 
738         } else {
739             // add tokens to the pool
740             tokenSupply_ = _amountOfTokens;
741         }
742 
743         // update circulating supply & the ledger address for the customer
744         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
745 
746         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
747         //really i know you think you do but you don't
748         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
749         payoutsTo_[msg.sender] += _updatedPayouts;
750 
751         // fire event
752         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
753 
754         return _amountOfTokens;
755     }
756 
757     /**
758      * Calculate Token price based on an amount of incoming ethereum
759      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
760      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
761      */
762     function ethereumToTokens_(uint256 _ethereum)
763         internal
764         view
765         returns(uint256)
766     {
767         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
768         uint256 _tokensReceived =
769          (
770             (
771                 // underflow attempts BTFO
772                 SafeMath.sub(
773                     (sqrt
774                         (
775                             (_tokenPriceInitial**2)
776                             +
777                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
778                             +
779                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
780                             +
781                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
782                         )
783                     ), _tokenPriceInitial
784                 )
785             )/(tokenPriceIncremental_)
786         )-(tokenSupply_)
787         ;
788 
789         return _tokensReceived;
790     }
791 
792     /**
793      * Calculate token sell value.
794      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
795      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
796      */
797      function tokensToEthereum_(uint256 _tokens)
798         internal
799         view
800         returns(uint256)
801     {
802 
803         uint256 tokens_ = (_tokens + 1e18);
804         uint256 _tokenSupply = (tokenSupply_ + 1e18);
805         uint256 _etherReceived =
806         (
807             // underflow attempts BTFO
808             SafeMath.sub(
809                 (
810                     (
811                         (
812                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
813                         )-tokenPriceIncremental_
814                     )*(tokens_ - 1e18)
815                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
816             )
817         /1e18);
818         return _etherReceived;
819     }
820 
821 
822     //This is where all your gas goes, sorry
823     //Not sorry, you probably only paid 1 gwei
824     function sqrt(uint x) internal pure returns (uint y) {
825         uint z = (x + 1) / 2;
826         y = x;
827         while (z < y) {
828             y = z;
829             z = (x / z + z) / 2;
830         }
831     }
832 }
833 
834 /**
835  * @title SafeMath
836  * @dev Math operations with safety checks that throw on error
837  */
838 library SafeMath {
839 
840     /**
841     * @dev Multiplies two numbers, throws on overflow.
842     */
843     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
844         if (a == 0) {
845             return 0;
846         }
847         uint256 c = a * b;
848         assert(c / a == b);
849         return c;
850     }
851 
852     /**
853     * @dev Integer division of two numbers, truncating the quotient.
854     */
855     function div(uint256 a, uint256 b) internal pure returns (uint256) {
856         // assert(b > 0); // Solidity automatically throws when dividing by 0
857         uint256 c = a / b;
858         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
859         return c;
860     }
861 
862     /**
863     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
864     */
865     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
866         assert(b <= a);
867         return a - b;
868     }
869 
870     /**
871     * @dev Adds two numbers, throws on overflow.
872     */
873     function add(uint256 a, uint256 b) internal pure returns (uint256) {
874         uint256 c = a + b;
875         assert(c >= a);
876         return c;
877     }
878 }