1 pragma solidity ^0.4.21;
2 
3 //
4 //		 _              _       _________ _______    _________ _______ 
5 //		( \   |\     /|( (    /|\__   __/(  ___  )   \__   __/(  ___  )
6 //		| (   ( \   / )|  \  ( |   ) (   | (   ) |      ) (   | (   ) |
7 //		| |    \ (_) / |   \ | |   | |   | (___) |      | |   | |   | |
8 //		| |     \   /  | (\ \) |   | |   |  ___  |      | |   | |   | |
9 //		| |      ) (   | | \   |   | |   | (   ) |      | |   | |   | |
10 //		| (____/\| |   | )  \  |___) (___| )   ( | _ ___) (___| (___) |
11 //		(_______/\_/   |/    )_)\_______/|/     \|(_)\_______/(_______)
12 //
13 //	https://lynia.io  https://lynia.io  https://lynia.io  https://lynia.io
14 //	https://lynia.io  https://lynia.io  https://lynia.io  https://lynia.io
15 //	
16 //	Cryptocurrency carries a high level of risk since leverage can work both to your advantage and disadvantage. 
17 //	As a result, cryptocurrency may not be suitable for all people because it is possible to lose all of your invested capital. 
18 //	You should never invest money that you cannot afford to lose. Before playing on LYNIA products, please ensure to understand the risks involved.
19 //	
20 
21 	
22 contract AcceptsLYNIA {
23     LYNIA public tokenContract;
24 
25     function AcceptsLYNIA(address _tokenContract) public {
26         tokenContract = LYNIA(_tokenContract);
27     }
28 
29     modifier onlyTokenContract {
30         require(msg.sender == address(tokenContract));
31         _;
32     }
33 
34     /**
35     * @dev Standard ERC677 function that will handle incoming token transfers.
36     *
37     * @param _from  Token sender address.
38     * @param _value Amount of tokens.
39     * @param _data  Transaction metadata.
40     */
41     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
42 }
43 
44 
45 contract LYNIA {
46     /*=================================
47     =            MODIFIERS            =
48     =================================*/
49     // only people with tokens
50     modifier onlyBagholders() {
51         require(myTokens() > 0);
52         _;
53     }
54 
55     // only people with profits
56     modifier onlyStronghands() {
57         require(myDividends(true) > 0);
58         _;
59     }
60 
61     modifier notContract() {
62       require (msg.sender == tx.origin);
63       _;
64     }
65 
66     // administrators can:
67     // -> change the name of the contract
68     // -> change the name of the token
69     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
70     // they CANNOT:
71     // -> take funds
72     // -> disable withdrawals
73     // -> kill the contract
74     // -> change the price of tokens
75     modifier onlyAdministrator(){
76         address _customerAddress = msg.sender;
77         require(administrators[_customerAddress]);
78         _;
79     }
80 
81 
82     // ensures that the first tokens in the contract will be equally distributed
83     // meaning, no divine dump will be ever possible
84     // result: healthy longevity.
85     modifier antiEarlyWhale(uint256 _amountOfEthereum){
86         address _customerAddress = msg.sender;
87 
88         // are we still in the vulnerable phase?
89         // if so, enact anti early whale protocol
90         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
91             require(
92                 // is the customer in the ambassador list?
93                 ambassadors_[_customerAddress] == true &&
94 
95                 // does the customer purchase exceed the max ambassador quota?
96                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
97 
98             );
99 
100             // updated the accumulated quota
101             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
102 
103             // execute
104             _;
105         } else {
106             // in case the ether count drops low, the ambassador phase won't reinitiate
107             onlyAmbassadors = false;
108             _;
109         }
110 
111     }
112 
113     /*==============================
114     =            EVENTS            =
115     ==============================*/
116     event onTokenPurchase(
117         address indexed customerAddress,
118         uint256 incomingEthereum,
119         uint256 tokensMinted,
120         address indexed referredBy
121     );
122 
123     event onTokenSell(
124         address indexed customerAddress,
125         uint256 tokensBurned,
126         uint256 ethereumEarned
127     );
128 
129     event onReinvestment(
130         address indexed customerAddress,
131         uint256 ethereumReinvested,
132         uint256 tokensMinted
133     );
134 
135     event onWithdraw(
136         address indexed customerAddress,
137         uint256 ethereumWithdrawn
138     );
139 
140     // ERC20
141     event Transfer(
142         address indexed from,
143         address indexed to,
144         uint256 tokens
145     );
146 
147 
148     /*=====================================
149     =            CONFIGURABLES            =
150     =====================================*/
151     string public name = "LYNIA";
152     string public symbol = "LYNI";
153     uint8 constant public decimals = 18;
154     uint8 constant internal dividendFee_ = 10; // 10% dividend fee on each buy and sell
155     uint8 constant internal charityFee_ = 1; // 1% Charity Pool 
156     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
157     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
158     uint256 constant internal magnitude = 2**64;
159 
160     // Charity Pool
161     // https://etherscan.io/address/0xCFBa51DB22873706E151838bE891f3D89c039Afd
162     address constant public giveEthCharityAddress = 0xCFBa51DB22873706E151838bE891f3D89c039Afd;
163     uint256 public totalEthCharityRecieved; // total ETH charity recieved from this contract
164     uint256 public totalEthCharityCollected; // total ETH charity collected in this contract
165 
166     // proof of stake (defaults at 100 tokens)
167     uint256 public stakingRequirement = 10e18;
168 
169     // ambassador program
170     mapping(address => bool) internal ambassadors_;
171     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
172     uint256 constant internal ambassadorQuota_ = 3 ether;
173 
174 
175 
176    /*================================
177     =            DATASETS            =
178     ================================*/
179     // amount of shares for each address (scaled number)
180     mapping(address => uint256) internal tokenBalanceLedger_;
181     mapping(address => uint256) internal referralBalance_;
182     mapping(address => int256) internal payoutsTo_;
183     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
184     uint256 internal tokenSupply_ = 0;
185     uint256 internal profitPerShare_;
186 
187     // administrator list (see above on what they can do)
188     mapping(address => bool) public administrators;
189 
190     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper game)
191     bool public onlyAmbassadors = true;
192 
193     // Special LYNIA Platform control from scam game contracts on LYNIA platform
194     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept LYNIA tokens
195 
196 
197 
198     /*=======================================
199     =            PUBLIC FUNCTIONS            =
200     =======================================*/
201     /*
202     * -- APPLICATION ENTRY POINTS --
203     */
204     function LYNIA()
205         public
206     {
207         // add administrators here
208         administrators[0x4eCFCfAD7e5E50F4B3581a65E9eF1774D5622d6b] = true;
209 
210         // add the ambassadors here.
211         ambassadors_[0x4eCFCfAD7e5E50F4B3581a65E9eF1774D5622d6b] = true;
212         
213     }
214 
215 
216     /**
217      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
218      */
219     function buy(address _referredBy)
220         public
221         payable
222         returns(uint256)
223     {
224         purchaseInternal(msg.value, _referredBy);
225     }
226 
227     /**
228      * Fallback function to handle ethereum that was send straight to the contract
229      * Unfortunately we cannot use a referral address this way.
230      */
231     function()
232         payable
233         public
234     {
235         purchaseInternal(msg.value, 0x0);
236     }
237 
238     /**
239      * The Lynia Chariy Pool
240      * Their charity address is here https://etherscan.io/address/0xCFBa51DB22873706E151838bE891f3D89c039Afd
241      */
242     function payCharity() payable public {
243       uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
244       require(ethToPay > 1);
245       totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);
246       if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {
247          totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);
248       }
249     }
250 
251     /**
252      * Converts all of caller's dividends to tokens.
253      */
254     function reinvest()
255         onlyStronghands()
256         public
257     {
258         // fetch dividends
259         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
260 
261         // pay out the dividends virtually
262         address _customerAddress = msg.sender;
263         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
264 
265         // retrieve ref. bonus
266         _dividends += referralBalance_[_customerAddress];
267         referralBalance_[_customerAddress] = 0;
268 
269         // dispatch a buy order with the virtualized "withdrawn dividends"
270         uint256 _tokens = purchaseTokens(_dividends, 0x0);
271 
272         // fire event
273         onReinvestment(_customerAddress, _dividends, _tokens);
274     }
275 
276     /**
277      * Alias of sell() and withdraw().
278      */
279     function exit()
280         public
281     {
282         // get token count for caller & sell them all
283         address _customerAddress = msg.sender;
284         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
285         if(_tokens > 0) sell(_tokens);
286 
287         // lambo delivery service
288         withdraw();
289     }
290 
291     /**
292      * Withdraws all of the callers earnings.
293      */
294     function withdraw()
295         onlyStronghands()
296         public
297     {
298         // setup data
299         address _customerAddress = msg.sender;
300         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
301 
302         // update dividend tracker
303         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
304 
305         // add ref. bonus
306         _dividends += referralBalance_[_customerAddress];
307         referralBalance_[_customerAddress] = 0;
308 
309         // lambo delivery service
310         _customerAddress.transfer(_dividends);
311 
312         // fire event
313         onWithdraw(_customerAddress, _dividends);
314     }
315 
316     /**
317      * Liquifies tokens to ethereum.
318      */
319     function sell(uint256 _amountOfTokens)
320         onlyBagholders()
321         public
322     {
323         // setup data
324         address _customerAddress = msg.sender;
325         // russian hackers BTFO
326         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
327         uint256 _tokens = _amountOfTokens;
328         uint256 _ethereum = tokensToEthereum_(_tokens);
329 
330         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
331         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
332 
333         // Take out dividends and then _charityPayout
334         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
335 
336         // Add ethereum to send to charity
337         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
338 
339         // burn the sold tokens
340         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
341         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
342 
343         // update dividends tracker
344         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
345         payoutsTo_[_customerAddress] -= _updatedPayouts;
346 
347         // dividing by zero is a bad idea
348         if (tokenSupply_ > 0) {
349             // update the amount of dividends per token
350             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
351         }
352 
353         // fire event
354         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
355     }
356 
357 
358     /**
359      * Transfer tokens from the caller to a new holder.
360      * REMEMBER THIS IS 0% TRANSFER FEE
361      */
362     function transfer(address _toAddress, uint256 _amountOfTokens)
363         onlyBagholders()
364         public
365         returns(bool)
366     {
367         // setup
368         address _customerAddress = msg.sender;
369 
370         // make sure we have the requested tokens
371         // also disables transfers until ambassador phase is over
372         // ( we dont want whale premines )
373         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
374 
375         // withdraw all outstanding dividends first
376         if(myDividends(true) > 0) withdraw();
377 
378         // exchange tokens
379         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
380         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
381 
382         // update dividend trackers
383         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
384         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
385 
386 
387         // fire event
388         Transfer(_customerAddress, _toAddress, _amountOfTokens);
389 
390         // ERC20
391         return true;
392     }
393 
394     /**
395     * Transfer token to a specified address and forward the data to recipient
396     * ERC-677 standard
397     * https://github.com/ethereum/EIPs/issues/677
398     * @param _to    Receiver address.
399     * @param _value Amount of tokens that will be transferred.
400     * @param _data  Transaction metadata.
401     */
402     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
403       require(_to != address(0));
404       require(canAcceptTokens_[_to] == true); // security check that contract approved by LYNIA platform
405       require(transfer(_to, _value)); // do a normal token transfer to the contract
406 
407       if (isContract(_to)) {
408         AcceptsLYNIA receiver = AcceptsLYNIA(_to);
409         require(receiver.tokenFallback(msg.sender, _value, _data));
410       }
411 
412       return true;
413     }
414 
415     /**
416      * Additional check that the game address we are sending tokens to is a contract
417      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
418      */
419      function isContract(address _addr) private constant returns (bool is_contract) {
420        // retrieve the size of the code on target address, this needs assembly
421        uint length;
422        assembly { length := extcodesize(_addr) }
423        return length > 0;
424      }
425 
426     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
427     /**
428      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
429      */
430     function disableInitialStage()
431         onlyAdministrator()
432         public
433     {
434         onlyAmbassadors = false;
435     }
436 
437     /**
438      * In case one of us dies, we need to replace ourselves.
439      */
440     function setAdministrator(address _identifier, bool _status)
441         onlyAdministrator()
442         public
443     {
444         administrators[_identifier] = _status;
445     }
446 
447     /**
448      * Precautionary measures in case we need to adjust the masternode rate.
449      */
450     function setStakingRequirement(uint256 _amountOfTokens)
451         onlyAdministrator()
452         public
453     {
454         stakingRequirement = _amountOfTokens;
455     }
456 
457     /**
458      * Add or remove game contract, which can accept LYNIA tokens
459      */
460     function setCanAcceptTokens(address _address, bool _value)
461       onlyAdministrator()
462       public
463     {
464       canAcceptTokens_[_address] = _value;
465     }
466 
467     /**
468      * If we want to rebrand, we can.
469      */
470     function setName(string _name)
471         onlyAdministrator()
472         public
473     {
474         name = _name;
475     }
476 
477     /**
478      * If we want to rebrand, we can.
479      */
480     function setSymbol(string _symbol)
481         onlyAdministrator()
482         public
483     {
484         symbol = _symbol;
485     }
486 
487 
488     /*----------  HELPERS AND CALCULATORS  ----------*/
489     /**
490      * Method to view the current Ethereum stored in the contract
491      * Example: totalEthereumBalance()
492      */
493     function totalEthereumBalance()
494         public
495         view
496         returns(uint)
497     {
498         return this.balance;
499     }
500 
501     /**
502      * Retrieve the total token supply.
503      */
504     function totalSupply()
505         public
506         view
507         returns(uint256)
508     {
509         return tokenSupply_;
510     }
511 
512     /**
513      * Retrieve the tokens owned by the caller.
514      */
515     function myTokens()
516         public
517         view
518         returns(uint256)
519     {
520         address _customerAddress = msg.sender;
521         return balanceOf(_customerAddress);
522     }
523 
524     /**
525      * Retrieve the dividends owned by the caller.
526      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
527      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
528      * But in the internal calculations, we want them separate.
529      */
530     function myDividends(bool _includeReferralBonus)
531         public
532         view
533         returns(uint256)
534     {
535         address _customerAddress = msg.sender;
536         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
537     }
538 
539     /**
540      * Retrieve the token balance of any single address.
541      */
542     function balanceOf(address _customerAddress)
543         view
544         public
545         returns(uint256)
546     {
547         return tokenBalanceLedger_[_customerAddress];
548     }
549 
550     /**
551      * Retrieve the dividend balance of any single address.
552      */
553     function dividendsOf(address _customerAddress)
554         view
555         public
556         returns(uint256)
557     {
558         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
559     }
560 
561     /**
562      * Return the buy price of 1 individual token.
563      */
564     function sellPrice()
565         public
566         view
567         returns(uint256)
568     {
569         // our calculation relies on the token supply, so we need supply. Doh.
570         if(tokenSupply_ == 0){
571             return tokenPriceInitial_ - tokenPriceIncremental_;
572         } else {
573             uint256 _ethereum = tokensToEthereum_(1e18);
574             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
575             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
576             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
577             return _taxedEthereum;
578         }
579     }
580 
581     /**
582      * Return the sell price of 1 individual token.
583      */
584     function buyPrice()
585         public
586         view
587         returns(uint256)
588     {
589         // our calculation relies on the token supply, so we need supply. Doh.
590         if(tokenSupply_ == 0){
591             return tokenPriceInitial_ + tokenPriceIncremental_;
592         } else {
593             uint256 _ethereum = tokensToEthereum_(1e18);
594             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
595             uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
596             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);
597             return _taxedEthereum;
598         }
599     }
600 
601     /**
602      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
603      */
604     function calculateTokensReceived(uint256 _ethereumToSpend)
605         public
606         view
607         returns(uint256)
608     {
609         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
610         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);
611         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);
612         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
613         return _amountOfTokens;
614     }
615 
616     /**
617      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
618      */
619     function calculateEthereumReceived(uint256 _tokensToSell)
620         public
621         view
622         returns(uint256)
623     {
624         require(_tokensToSell <= tokenSupply_);
625         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
626         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
627         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);
628         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);
629         return _taxedEthereum;
630     }
631 
632     /**
633      * Function for the frontend to show ether waiting to be send to charity in contract
634      */
635     function etherToSendCharity()
636         public
637         view
638         returns(uint256) {
639         return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);
640     }
641 
642 
643     /*==========================================
644     =            INTERNAL FUNCTIONS            =
645     ==========================================*/
646 
647     // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract
648     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
649       notContract()// no contracts allowed
650       internal
651       returns(uint256) {
652 
653       uint256 purchaseEthereum = _incomingEthereum;
654       uint256 excess;
655       if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
656           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
657               purchaseEthereum = 5 ether;
658               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
659           }
660       }
661 
662       purchaseTokens(purchaseEthereum, _referredBy);
663 
664       if (excess > 0) {
665         msg.sender.transfer(excess);
666       }
667     }
668 
669 
670     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
671         antiEarlyWhale(_incomingEthereum)
672         internal
673         returns(uint256)
674     {
675         // data setup
676         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
677         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
678         uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);
679         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
680         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);
681 
682         totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);
683 
684         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
685         uint256 _fee = _dividends * magnitude;
686 
687         // no point in continuing execution if OP is a poorfag russian hacker
688         // prevents overflow in the case that the game somehow magically starts being used by everyone in the world
689         // (or hackers)
690         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
691         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
692 
693         // is the user referred by a masternode?
694         if(
695             // is this a referred purchase?
696             _referredBy != 0x0000000000000000000000000000000000000000 &&
697 
698             // no cheating!
699             _referredBy != msg.sender &&
700 
701             // does the referrer have at least X whole tokens?
702             // i.e is the referrer a godly chad masternode
703             tokenBalanceLedger_[_referredBy] >= stakingRequirement
704         ){
705             // wealth redistribution
706             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
707         } else {
708             // no ref purchase
709             // add the referral bonus back to the global dividends cake
710             _dividends = SafeMath.add(_dividends, _referralBonus);
711             _fee = _dividends * magnitude;
712         }
713 
714         // we can't give people infinite ethereum
715         if(tokenSupply_ > 0){
716 
717             // add tokens to the pool
718             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
719 
720             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
721             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
722 
723             // calculate the amount of tokens the customer receives over his purchase
724             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
725 
726         } else {
727             // add tokens to the pool
728             tokenSupply_ = _amountOfTokens;
729         }
730 
731         // update circulating supply & the ledger address for the customer
732         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
733 
734         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
735         //really i know you think you do but you don't
736         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
737         payoutsTo_[msg.sender] += _updatedPayouts;
738 
739         // fire event
740         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
741 
742         return _amountOfTokens;
743     }
744 
745     /**
746      * Calculate Token price based on an amount of incoming ethereum
747      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
748      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
749      */
750     function ethereumToTokens_(uint256 _ethereum)
751         internal
752         view
753         returns(uint256)
754     {
755         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
756         uint256 _tokensReceived =
757          (
758             (
759                 // underflow attempts BTFO
760                 SafeMath.sub(
761                     (sqrt
762                         (
763                             (_tokenPriceInitial**2)
764                             +
765                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
766                             +
767                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
768                             +
769                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
770                         )
771                     ), _tokenPriceInitial
772                 )
773             )/(tokenPriceIncremental_)
774         )-(tokenSupply_)
775         ;
776 
777         return _tokensReceived;
778     }
779 
780     /**
781      * Calculate token sell value.
782      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
783      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
784      */
785      function tokensToEthereum_(uint256 _tokens)
786         internal
787         view
788         returns(uint256)
789     {
790 
791         uint256 tokens_ = (_tokens + 1e18);
792         uint256 _tokenSupply = (tokenSupply_ + 1e18);
793         uint256 _etherReceived =
794         (
795             // underflow attempts BTFO
796             SafeMath.sub(
797                 (
798                     (
799                         (
800                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
801                         )-tokenPriceIncremental_
802                     )*(tokens_ - 1e18)
803                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
804             )
805         /1e18);
806         return _etherReceived;
807     }
808 
809 
810     //This is where all your gas goes, sorry
811     //Not sorry, you probably only paid 1 gwei
812     function sqrt(uint x) internal pure returns (uint y) {
813         uint z = (x + 1) / 2;
814         y = x;
815         while (z < y) {
816             y = z;
817             z = (x / z + z) / 2;
818         }
819     }
820 }
821 
822 /**
823  * @title SafeMath
824  * @dev Math operations with safety checks that throw on error
825  */
826 library SafeMath {
827 
828     /**
829     * @dev Multiplies two numbers, throws on overflow.
830     */
831     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
832         if (a == 0) {
833             return 0;
834         }
835         uint256 c = a * b;
836         assert(c / a == b);
837         return c;
838     }
839 
840     /**
841     * @dev Integer division of two numbers, truncating the quotient.
842     */
843     function div(uint256 a, uint256 b) internal pure returns (uint256) {
844         // assert(b > 0); // Solidity automatically throws when dividing by 0
845         uint256 c = a / b;
846         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
847         return c;
848     }
849 
850     /**
851     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
852     */
853     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
854         assert(b <= a);
855         return a - b;
856     }
857 
858     /**
859     * @dev Adds two numbers, throws on overflow.
860     */
861     function add(uint256 a, uint256 b) internal pure returns (uint256) {
862         uint256 c = a + b;
863         assert(c >= a);
864         return c;
865     }
866 }