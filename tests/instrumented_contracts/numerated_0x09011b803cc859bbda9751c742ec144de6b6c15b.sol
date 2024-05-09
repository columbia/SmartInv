1 pragma solidity ^0.4.24;
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
62     uint ACTIVATION_TIME = 1538694000;
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
143     string public name = "Nasdaq";
144     string public symbol = "SHARES";
145     uint8 constant public decimals = 18;
146     uint8 constant internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
147     uint8 constant internal fundFee_ = 5; // 5% to bond game
148     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
149     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
150     uint256 constant internal magnitude = 2**64;
151 
152     // Address to send the 5% Fee
153     address public giveEthFundAddress = 0x0;
154     bool public finalizedEthFundAddress = false;
155     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
156     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
157 
158     // proof of stake (defaults at 100 tokens)
159     uint256 public stakingRequirement = 25e18;
160 
161     // ambassador program
162     mapping(address => bool) internal ambassadors_;
163     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
164     uint256 constant internal ambassadorQuota_ = 2.5 ether;
165 
166    /*================================
167     =            DATASETS            =
168     ================================*/
169     // amount of shares for each address (scaled number)
170     mapping(address => uint256) internal tokenBalanceLedger_;
171     mapping(address => uint256) internal referralBalance_;
172     mapping(address => int256) internal payoutsTo_;
173     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
174     uint256 internal tokenSupply_ = 0;
175     uint256 internal profitPerShare_;
176 
177     // administrator list (see above on what they can do)
178     mapping(address => bool) public administrators;
179 
180     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
181     bool public onlyAmbassadors = true;
182 
183     // To whitelist game contracts on the platform
184     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept the exchanges tokens
185 
186     mapping(address => address) public stickyRef;
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
198         administrators[0x7191cbD8BBCacFE989aa60FB0bE85B47f922FE21] = true;
199 
200         // add the ambassadors here - Tokens will be distributed to these addresses from main premine
201         ambassadors_[0x7191cbD8BBCacFE989aa60FB0bE85B47f922FE21] = true;
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
248     function payFund() payable public {
249         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
250         require(ethToPay > 0);
251         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
252         if(!giveEthFundAddress.call.value(ethToPay).gas(400000)()) {
253            totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, ethToPay);
254         }
255     }
256 
257     /**
258      * Converts all of caller's dividends to tokens.
259      */
260     function reinvest()
261         onlyStronghands()
262         public
263     {
264         // fetch dividends
265         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
266 
267         // pay out the dividends virtually
268         address _customerAddress = msg.sender;
269         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
270 
271         // retrieve ref. bonus
272         _dividends += referralBalance_[_customerAddress];
273         referralBalance_[_customerAddress] = 0;
274 
275         // dispatch a buy order with the virtualized "withdrawn dividends"
276         uint256 _tokens = purchaseTokens(_dividends, 0x0, true);
277 
278         // fire event
279         emit onReinvestment(_customerAddress, _dividends, _tokens);
280     }
281 
282     /**
283      * Alias of sell() and withdraw().
284      */
285     function exit()
286         public
287     {
288         // get token count for caller & sell them all
289         address _customerAddress = msg.sender;
290         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
291         if(_tokens > 0) sell(_tokens);
292 
293         // lambo delivery service
294         withdraw(false);
295     }
296 
297     /**
298      * Withdraws all of the callers earnings.
299      */
300     function withdraw(bool _isTransfer)
301         onlyStronghands()
302         public
303     {
304         // setup data
305         address _customerAddress = msg.sender;
306         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
307 
308         uint256 _estimateTokens = calculateTokensReceived(_dividends);
309 
310         // update dividend tracker
311         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
312 
313         // add ref. bonus
314         _dividends += referralBalance_[_customerAddress];
315         referralBalance_[_customerAddress] = 0;
316 
317         // lambo delivery service
318         _customerAddress.transfer(_dividends);
319 
320         // fire event
321         emit onWithdraw(_customerAddress, _dividends, _estimateTokens, _isTransfer);
322     }
323 
324     /**
325      * Liquifies tokens to ethereum.
326      */
327     function sell(uint256 _amountOfTokens)
328         onlyBagholders()
329         public
330     {
331         // setup data
332         address _customerAddress = msg.sender;
333         // russian hackers BTFO
334         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
335         uint256 _tokens = _amountOfTokens;
336         uint256 _ethereum = tokensToEthereum_(_tokens);
337 
338         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
339         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
340         uint256 _refPayout = _dividends / 3;
341         _dividends = SafeMath.sub(_dividends, _refPayout);
342         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
343 
344         // Take out dividends and then _fundPayout
345         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
346 
347         // Add ethereum to send to fund
348         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
349 
350         // burn the sold tokens
351         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
353 
354         // update dividends tracker
355         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
356         payoutsTo_[_customerAddress] -= _updatedPayouts;
357 
358         // dividing by zero is a bad idea
359         if (tokenSupply_ > 0) {
360             // update the amount of dividends per token
361             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
362         }
363 
364         // fire event
365         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
366     }
367 
368 
369     /**
370      * Transfer tokens from the caller to a new holder.
371      * REMEMBER THIS IS 0% TRANSFER FEE
372      */
373     function transfer(address _toAddress, uint256 _amountOfTokens)
374         onlyBagholders()
375         public
376         returns(bool)
377     {
378         // setup
379         address _customerAddress = msg.sender;
380 
381         // make sure we have the requested tokens
382         // also disables transfers until ambassador phase is over
383         // ( we dont want whale premines )
384         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
385 
386         // withdraw all outstanding dividends first
387         if(myDividends(true) > 0) withdraw(true);
388 
389         // exchange tokens
390         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
391         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
392 
393         // update dividend trackers
394         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
395         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
396 
397 
398         // fire event
399         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
400 
401         // ERC20
402         return true;
403     }
404 
405     /**
406     * Transfer token to a specified address and forward the data to recipient
407     * ERC-677 standard
408     * https://github.com/ethereum/EIPs/issues/677
409     * @param _to    Receiver address.
410     * @param _value Amount of tokens that will be transferred.
411     * @param _data  Transaction metadata.
412     */
413     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
414       require(_to != address(0));
415       require(canAcceptTokens_[_to] == true); // security check that contract approved by the exchange
416       require(transfer(_to, _value)); // do a normal token transfer to the contract
417 
418       if (isContract(_to)) {
419         AcceptsExchange receiver = AcceptsExchange(_to);
420         require(receiver.tokenFallback(msg.sender, _value, _data));
421       }
422 
423       return true;
424     }
425 
426     /**
427      * Additional check that the game address we are sending tokens to is a contract
428      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
429      */
430      function isContract(address _addr) private constant returns (bool is_contract) {
431        // retrieve the size of the code on target address, this needs assembly
432        uint length;
433        assembly { length := extcodesize(_addr) }
434        return length > 0;
435      }
436 
437     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
438     /**
439 
440     /**
441      * In case one of us dies, we need to replace ourselves.
442      */
443     function setAdministrator(address _identifier, bool _status)
444         onlyAdministrator()
445         public
446     {
447         administrators[_identifier] = _status;
448     }
449 
450     /**
451      * Precautionary measures in case we need to adjust the masternode rate.
452      */
453     function setStakingRequirement(uint256 _amountOfTokens)
454         onlyAdministrator()
455         public
456     {
457         stakingRequirement = _amountOfTokens;
458     }
459 
460     /**
461      * Add or remove game contract, which can accept tokens
462      */
463     function setCanAcceptTokens(address _address, bool _value)
464       onlyAdministrator()
465       public
466     {
467       canAcceptTokens_[_address] = _value;
468     }
469 
470     /**
471      * If we want to rebrand, we can.
472      */
473     function setName(string _name)
474         onlyAdministrator()
475         public
476     {
477         name = _name;
478     }
479 
480     /**
481      * If we want to rebrand, we can.
482      */
483     function setSymbol(string _symbol)
484         onlyAdministrator()
485         public
486     {
487         symbol = _symbol;
488     }
489 
490 
491     /*----------  HELPERS AND CALCULATORS  ----------*/
492     /**
493      * Method to view the current Ethereum stored in the contract
494      * Example: totalEthereumBalance()
495      */
496     function totalEthereumBalance()
497         public
498         view
499         returns(uint)
500     {
501         return address(this).balance;
502     }
503 
504     /**
505      * Retrieve the total token supply.
506      */
507     function totalSupply()
508         public
509         view
510         returns(uint256)
511     {
512         return tokenSupply_;
513     }
514 
515     /**
516      * Retrieve the tokens owned by the caller.
517      */
518     function myTokens()
519         public
520         view
521         returns(uint256)
522     {
523         address _customerAddress = msg.sender;
524         return balanceOf(_customerAddress);
525     }
526 
527     /**
528      * Retrieve the dividends owned by the caller.
529      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
530      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
531      * But in the internal calculations, we want them separate.
532      */
533     function myDividends(bool _includeReferralBonus)
534         public
535         view
536         returns(uint256)
537     {
538         address _customerAddress = msg.sender;
539         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
540     }
541 
542     /**
543      * Retrieve the token balance of any single address.
544      */
545     function balanceOf(address _customerAddress)
546         view
547         public
548         returns(uint256)
549     {
550         return tokenBalanceLedger_[_customerAddress];
551     }
552 
553     /**
554      * Retrieve the dividend balance of any single address.
555      */
556     function dividendsOf(address _customerAddress)
557         view
558         public
559         returns(uint256)
560     {
561         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
562     }
563 
564     /**
565      * Return the buy price of 1 individual token.
566      */
567     function sellPrice()
568         public
569         view
570         returns(uint256)
571     {
572         // our calculation relies on the token supply, so we need supply. Doh.
573         if(tokenSupply_ == 0){
574             return tokenPriceInitial_ - tokenPriceIncremental_;
575         } else {
576             uint256 _ethereum = tokensToEthereum_(1e18);
577             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
578             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
579             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
580             return _taxedEthereum;
581         }
582     }
583 
584     /**
585      * Return the sell price of 1 individual token.
586      */
587     function buyPrice()
588         public
589         view
590         returns(uint256)
591     {
592         // our calculation relies on the token supply, so we need supply. Doh.
593         if(tokenSupply_ == 0){
594             return tokenPriceInitial_ + tokenPriceIncremental_;
595         } else {
596             uint256 _ethereum = tokensToEthereum_(1e18);
597             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
598             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
599             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
600             return _taxedEthereum;
601         }
602     }
603 
604     /**
605      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
606      */
607     function calculateTokensReceived(uint256 _ethereumToSpend)
608         public
609         view
610         returns(uint256)
611     {
612         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
613         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
614         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
615         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
616         return _amountOfTokens;
617     }
618 
619     /**
620      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
621      */
622     function calculateEthereumReceived(uint256 _tokensToSell)
623         public
624         view
625         returns(uint256)
626     {
627         require(_tokensToSell <= tokenSupply_);
628         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
629         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
630         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
631         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
632         return _taxedEthereum;
633     }
634 
635     /**
636      * Function for the frontend to show ether waiting to be send to fund in contract
637      */
638     function etherToSendFund()
639         public
640         view
641         returns(uint256) {
642         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
643     }
644 
645 
646     /*==========================================
647     =            INTERNAL FUNCTIONS            =
648     ==========================================*/
649 
650     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
651         uint _dividends = _currentDividends;
652         uint _fee = _currentFee;
653         address _referredBy = stickyRef[msg.sender];
654         if (_referredBy == address(0x0)){
655             _referredBy = _ref;
656         }
657         // is the user referred by a masternode?
658         if(
659             // is this a referred purchase?
660             _referredBy != 0x0000000000000000000000000000000000000000 &&
661 
662             // no cheating!
663             _referredBy != msg.sender &&
664 
665             // does the referrer have at least X whole tokens?
666             // i.e is the referrer a godly chad masternode
667             tokenBalanceLedger_[_referredBy] >= stakingRequirement
668         ){
669             // wealth redistribution
670             if (stickyRef[msg.sender] == address(0x0)){
671                 stickyRef[msg.sender] = _referredBy;
672             }
673             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
674             address currentRef = stickyRef[_referredBy];
675             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
676                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
677                 currentRef = stickyRef[currentRef];
678                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
679                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
680                 }
681                 else{
682                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
683                     _fee = _dividends * magnitude;
684                 }
685             }
686             else{
687                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
688                 _fee = _dividends * magnitude;
689             }
690 
691 
692         } else {
693             // no ref purchase
694             // add the referral bonus back to the global dividends cake
695             _dividends = SafeMath.add(_dividends, _referralBonus);
696             _fee = _dividends * magnitude;
697         }
698         return (_dividends, _fee);
699     }
700 
701 
702     function purchaseTokens(uint256 _incomingEthereum, address _referredBy, bool _isReinvest)
703         antiEarlyWhale(_incomingEthereum)
704         internal
705         returns(uint256)
706     {
707         // data setup
708         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
709         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
710         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
711         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
712         uint256 _fee;
713         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
714         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
715         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
716 
717         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
718 
719 
720         // no point in continuing execution if OP is a poor russian hacker
721         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
722         // (or hackers)
723         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
724         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
725 
726 
727 
728         // we can't give people infinite ethereum
729         if(tokenSupply_ > 0){
730 
731             // add tokens to the pool
732             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
733 
734             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
735             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
736 
737             // calculate the amount of tokens the customer receives over his purchase
738             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
739 
740         } else {
741             // add tokens to the pool
742             tokenSupply_ = _amountOfTokens;
743         }
744 
745         // update circulating supply & the ledger address for the customer
746         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
747 
748         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
749         //really i know you think you do but you don't
750         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
751         payoutsTo_[msg.sender] += _updatedPayouts;
752 
753         // fire event
754         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy, _isReinvest, now, buyPrice());
755 
756         return _amountOfTokens;
757     }
758 
759     /**
760      * Calculate Token price based on an amount of incoming ethereum
761      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
762      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
763      */
764     function ethereumToTokens_(uint256 _ethereum)
765         internal
766         view
767         returns(uint256)
768     {
769         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
770         uint256 _tokensReceived =
771          (
772             (
773                 // underflow attempts BTFO
774                 SafeMath.sub(
775                     (sqrt
776                         (
777                             (_tokenPriceInitial**2)
778                             +
779                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
780                             +
781                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
782                             +
783                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
784                         )
785                     ), _tokenPriceInitial
786                 )
787             )/(tokenPriceIncremental_)
788         )-(tokenSupply_)
789         ;
790 
791         return _tokensReceived;
792     }
793 
794     /**
795      * Calculate token sell value.
796      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
797      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
798      */
799      function tokensToEthereum_(uint256 _tokens)
800         internal
801         view
802         returns(uint256)
803     {
804 
805         uint256 tokens_ = (_tokens + 1e18);
806         uint256 _tokenSupply = (tokenSupply_ + 1e18);
807         uint256 _etherReceived =
808         (
809             // underflow attempts BTFO
810             SafeMath.sub(
811                 (
812                     (
813                         (
814                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
815                         )-tokenPriceIncremental_
816                     )*(tokens_ - 1e18)
817                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
818             )
819         /1e18);
820         return _etherReceived;
821     }
822 
823 
824     //This is where all your gas goes, sorry
825     //Not sorry, you probably only paid 1 gwei
826     function sqrt(uint x) internal pure returns (uint y) {
827         uint z = (x + 1) / 2;
828         y = x;
829         while (z < y) {
830             y = z;
831             z = (x / z + z) / 2;
832         }
833     }
834 }
835 
836 /**
837  * @title SafeMath
838  * @dev Math operations with safety checks that throw on error
839  */
840 library SafeMath {
841 
842     /**
843     * @dev Multiplies two numbers, throws on overflow.
844     */
845     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
846         if (a == 0) {
847             return 0;
848         }
849         uint256 c = a * b;
850         assert(c / a == b);
851         return c;
852     }
853 
854     /**
855     * @dev Integer division of two numbers, truncating the quotient.
856     */
857     function div(uint256 a, uint256 b) internal pure returns (uint256) {
858         // assert(b > 0); // Solidity automatically throws when dividing by 0
859         uint256 c = a / b;
860         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
861         return c;
862     }
863 
864     /**
865     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
866     */
867     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
868         assert(b <= a);
869         return a - b;
870     }
871 
872     /**
873     * @dev Adds two numbers, throws on overflow.
874     */
875     function add(uint256 a, uint256 b) internal pure returns (uint256) {
876         uint256 c = a + b;
877         assert(c >= a);
878         return c;
879     }
880 }