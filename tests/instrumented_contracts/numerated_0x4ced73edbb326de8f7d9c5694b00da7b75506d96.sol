1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 
6 
7 ******************** Elyxr **********************************
8 * _______   ___           ___    ___ ___    ___ ________     
9 *|\  ___ \ |\  \         |\  \  /  /|\  \  /  /|\   __  \    
10 *\ \   __/|\ \  \        \ \  \/  / | \  \/  / | \  \|\  \   
11 * \ \  \_|/_\ \  \        \ \    / / \ \    / / \ \   _  _\  
12 *  \ \  \_|\ \ \  \____    \/  /  /   /     \/   \ \  \\  \| 
13 *   \ \_______\ \_______\__/  / /    /  /\   \    \ \__\\ _\ 
14 *    \|_______|\|_______|\___/ /    /__/ /\ __\    \|__|\|__|
15 *                       \|___|/     |__|/ \|__|              
16 ***************************************************************                                                            
17                                                             
18 
19 
20 * [x] 0% TRANSFER FEES! This allows for tokens to be used in future games with out being taxed
21 * [X] 10% DIVIDENDS AND MASTERNODES!
22 * [x] 5% Jackpot Fee 
23 * 50% of Jackpot goes to the winner in our discord. The other 50% is used to buy back into the exchange which will give divs to all token 
24 * holders so make sure you HODL!
25 * [x] DAPP INTEROPERABILITY, games and other dAPPs can incorporate Elyxr tokens!
26 *
27 */
28 
29 
30 /**
31  * Definition of contract accepting Elyxr tokens
32  * Games, casinos, anything can reuse this contract to support Elyxr tokens
33  */
34 contract AcceptsElyxr {
35     Elyxr public tokenContract;
36 
37     function AcceptsElyxr(address _tokenContract) public {
38         tokenContract = Elyxr(_tokenContract);
39     }
40 
41     modifier onlyTokenContract {
42         require(msg.sender == address(tokenContract));
43         _;
44     }
45 
46     /**
47     * @dev Standard ERC677 function that will handle incoming token transfers.
48     *
49     * @param _from  Token sender address.
50     * @param _value Amount of tokens.
51     * @param _data  Transaction metadata.
52     */
53     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
54 }
55 
56 
57 contract Elyxr {
58     /*=================================
59     =            MODIFIERS            =
60     =================================*/
61     // only people with tokens
62     modifier onlyBagholders() {
63         require(myTokens() > 0);
64         _;
65     }
66 
67     // only people with profits
68     modifier onlyStronghands() {
69         require(myDividends(true) > 0);
70         _;
71     }
72 
73     modifier notContract() {
74       require (msg.sender == tx.origin);
75       _;
76     }
77 
78     // administrators can:
79     // -> change the name of the contract
80     // -> change the name of the token
81     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
82     // they CANNOT:
83     // -> take funds
84     // -> disable withdrawals
85     // -> kill the contract
86     // -> change the price of tokens
87     modifier onlyAdministrator(){
88         address _customerAddress = msg.sender;
89         require(administrators[_customerAddress]);
90         _;
91     }
92 
93 
94     // ensures that the first tokens in the contract will be equally distributed
95     // meaning, no divine dump will be ever possible
96     // result: healthy longevity.
97     modifier antiEarlyWhale(uint256 _amountOfEthereum){
98         address _customerAddress = msg.sender;
99 
100         // are we still in the vulnerable phase?
101         // if so, enact anti early whale protocol
102         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
103             require(
104                 // is the customer in the ambassador list?
105                 ambassadors_[_customerAddress] == true &&
106 
107                 // does the customer purchase exceed the max ambassador quota?
108                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
109 
110             );
111 
112             // updated the accumulated quota
113             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
114 
115             // execute
116             _;
117         } else {
118             // in case the ether count drops low, the ambassador phase won't reinitiate
119             onlyAmbassadors = false;
120             _;
121         }
122 
123     }
124 
125     /*==============================
126     =            EVENTS            =
127     ==============================*/
128     event onTokenPurchase(
129         address indexed customerAddress,
130         uint256 incomingEthereum,
131         uint256 tokensMinted,
132         address indexed referredBy
133     );
134 
135     event onTokenSell(
136         address indexed customerAddress,
137         uint256 tokensBurned,
138         uint256 ethereumEarned
139     );
140 
141     event onReinvestment(
142         address indexed customerAddress,
143         uint256 ethereumReinvested,
144         uint256 tokensMinted
145     );
146 
147     event onWithdraw(
148         address indexed customerAddress,
149         uint256 ethereumWithdrawn
150     );
151 
152     // ERC20
153     event Transfer(
154         address indexed from,
155         address indexed to,
156         uint256 tokens
157     );
158 
159 
160     /*=====================================
161     =            CONFIGURABLES            =
162     =====================================*/
163     string public name = "Elyxr";
164     string public symbol = "ELXR";
165     uint8 constant public decimals = 18;
166     uint8 constant internal dividendFee_ = 10; // 10% dividend fee on each buy and sell
167     uint8 constant internal jackpotFee_ = 5; // 5% Jackpot fee on each buy and sell
168     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
169     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
170     uint256 constant internal magnitude = 2**64;
171 
172     // Address to send the Jackpot 
173     
174     address constant public giveEthJackpotAddress = 0x083EA7627ED7F4b48E7aFA3AF552cd30B2Dff3af;
175     uint256 public totalEthJackpotRecieved; // total ETH Jackpot recieved from this contract
176     uint256 public totalEthJackpotCollected; // total ETH Jackpot collected in this contract
177 
178     // proof of stake (defaults at 100 tokens)
179     uint256 public stakingRequirement = 30e18;
180 
181     // ambassador program
182     mapping(address => bool) internal ambassadors_;
183     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
184     uint256 constant internal ambassadorQuota_ = 3 ether; // If ambassor quota not met, disable to open to public.
185 
186 
187 
188    /*================================
189     =            DATASETS            =
190     ================================*/
191     // amount of shares for each address (scaled number)
192     mapping(address => uint256) internal tokenBalanceLedger_;
193     mapping(address => uint256) internal referralBalance_;
194     mapping(address => int256) internal payoutsTo_;
195     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
196     uint256 internal tokenSupply_ = 0;
197     uint256 internal profitPerShare_;
198 
199     // administrator list (see above on what they can do)
200     mapping(address => bool) public administrators;
201 
202     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
203     bool public onlyAmbassadors = true;
204 
205     // Special Elyxr Platform control from scam game contracts on Elyxr platform
206     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Elyxr tokens
207 
208 
209 
210     /*=======================================
211     =            PUBLIC FUNCTIONS            =
212     =======================================*/
213     /*
214     * -- APPLICATION ENTRY POINTS --
215     */
216     function Elyxr()
217         public
218     {
219         // add administrators here
220         administrators[0xA1D81A181ad53ccfFD643f23102ee6CB5F6d5E4B] = true;
221 
222         // add the ambassadors here.
223         ambassadors_[0xA1D81A181ad53ccfFD643f23102ee6CB5F6d5E4B] = true;
224         //ambassador Dev
225         ambassadors_[0xb03bEF1D9659363a9357aB29a05941491AcCb4eC] = true;
226         //ambassador TR
227         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
228         //ambassador FF
229         ambassadors_[0xab73e01ba3a8009d682726b752c11b1e9722f059] = true;
230         //ambassador YB
231         ambassadors_[0x008ca4f1ba79d1a265617c6206d7884ee8108a78] = true;
232         //ambassador CA
233         ambassadors_[0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8] = true;
234         //ambassador KH
235         
236         
237         
238         
239     }
240 
241 
242     /**
243      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
244      */
245     function buy(address _referredBy)
246         public
247         payable
248         returns(uint256)
249     {
250         purchaseInternal(msg.value, _referredBy);
251     }
252 
253     /**
254      * Fallback function to handle ethereum that was send straight to the contract
255      * Unfortunately we cannot use a referral address this way.
256      */
257     function()
258         payable
259         public
260     {
261         purchaseInternal(msg.value, 0x0);
262     }
263 
264     /**
265      * Sends Jackpot funds for additional dividends
266      * Jackpot Address: https://etherscan.io/address/0x083EA7627ED7F4b48E7aFA3AF552cd30B2Dff3af
267      */
268     function payJackpot() payable public {
269       uint256 ethToPay = SafeMath.sub(totalEthJackpotCollected, totalEthJackpotRecieved);
270       require(ethToPay > 1);
271       totalEthJackpotRecieved = SafeMath.add(totalEthJackpotRecieved, ethToPay);
272       if(!giveEthJackpotAddress.call.value(ethToPay).gas(400000)()) {
273          totalEthJackpotRecieved = SafeMath.sub(totalEthJackpotRecieved, ethToPay);
274       }
275     }
276 
277     /**
278      * Converts all of caller's dividends to tokens.
279      */
280     function reinvest()
281         onlyStronghands()
282         public
283     {
284         // fetch dividends
285         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
286 
287         // pay out the dividends virtually
288         address _customerAddress = msg.sender;
289         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
290 
291         // retrieve ref. bonus
292         _dividends += referralBalance_[_customerAddress];
293         referralBalance_[_customerAddress] = 0;
294 
295         // dispatch a buy order with the virtualized "withdrawn dividends"
296         uint256 _tokens = purchaseTokens(_dividends, 0x0);
297 
298         // fire event
299         onReinvestment(_customerAddress, _dividends, _tokens);
300     }
301 
302     /**
303      * Alias of sell() and withdraw().
304      */
305     function exit()
306         public
307     {
308         // get token count for caller & sell them all
309         address _customerAddress = msg.sender;
310         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
311         if(_tokens > 0) sell(_tokens);
312 
313         // lambo delivery service
314         withdraw();
315     }
316 
317     /**
318      * Withdraws all of the callers earnings.
319      */
320     function withdraw()
321         onlyStronghands()
322         public
323     {
324         // setup data
325         address _customerAddress = msg.sender;
326         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
327 
328         // update dividend tracker
329         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
330 
331         // add ref. bonus
332         _dividends += referralBalance_[_customerAddress];
333         referralBalance_[_customerAddress] = 0;
334 
335         // lambo delivery service
336         _customerAddress.transfer(_dividends);
337 
338         // fire event
339         onWithdraw(_customerAddress, _dividends);
340     }
341 
342     /**
343      * Liquifies tokens to ethereum.
344      */
345     function sell(uint256 _amountOfTokens)
346         onlyBagholders()
347         public
348     {
349         // setup data
350         address _customerAddress = msg.sender;
351         // russian hackers BTFO
352         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
353         uint256 _tokens = _amountOfTokens;
354         uint256 _ethereum = tokensToEthereum_(_tokens);
355 
356         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
357         uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
358 
359         // Take out dividends and then _jackpotPayout
360         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPayout);
361 
362         // Add ethereum to send to Jackpot
363         totalEthJackpotCollected = SafeMath.add(totalEthJackpotCollected, _jackpotPayout);
364 
365         // burn the sold tokens
366         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
367         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
368 
369         // update dividends tracker
370         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
371         payoutsTo_[_customerAddress] -= _updatedPayouts;
372 
373         // dividing by zero is a bad idea
374         if (tokenSupply_ > 0) {
375             // update the amount of dividends per token
376             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
377         }
378 
379         // fire event
380         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
381     }
382 
383 
384     /**
385      * Transfer tokens from the caller to a new holder.
386      * REMEMBER THIS IS 0% TRANSFER FEE
387      */
388     function transfer(address _toAddress, uint256 _amountOfTokens)
389         onlyBagholders()
390         public
391         returns(bool)
392     {
393         // setup
394         address _customerAddress = msg.sender;
395 
396         // make sure we have the requested tokens
397         // also disables transfers until ambassador phase is over
398         // ( we dont want whale premines )
399         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
400 
401         // withdraw all outstanding dividends first
402         if(myDividends(true) > 0) withdraw();
403 
404         // exchange tokens
405         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
406         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
407 
408         // update dividend trackers
409         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
410         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
411 
412 
413         // fire event
414         Transfer(_customerAddress, _toAddress, _amountOfTokens);
415 
416         // ERC20
417         return true;
418     }
419 
420     /**
421     * Transfer token to a specified address and forward the data to recipient
422     * ERC-677 standard
423     * https://github.com/ethereum/EIPs/issues/677
424     * @param _to    Receiver address.
425     * @param _value Amount of tokens that will be transferred.
426     * @param _data  Transaction metadata.
427     */
428     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
429       require(_to != address(0));
430       require(canAcceptTokens_[_to] == true); // security check that contract approved by Elyxr platform
431       require(transfer(_to, _value)); // do a normal token transfer to the contract
432 
433       if (isContract(_to)) {
434         AcceptsElyxr receiver = AcceptsElyxr(_to);
435         require(receiver.tokenFallback(msg.sender, _value, _data));
436       }
437 
438       return true;
439     }
440 
441     /**
442      * Additional check that the game address we are sending tokens to is a contract
443      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
444      */
445      function isContract(address _addr) private constant returns (bool is_contract) {
446        // retrieve the size of the code on target address, this needs assembly
447        uint length;
448        assembly { length := extcodesize(_addr) }
449        return length > 0;
450      }
451 
452     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
453     /**
454      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
455      */
456     function disableInitialStage()
457         onlyAdministrator()
458         public
459     {
460         onlyAmbassadors = false;
461     }
462 
463     /**
464      * In case one of us dies, we need to replace ourselves.
465      */
466     function setAdministrator(address _identifier, bool _status)
467         onlyAdministrator()
468         public
469     {
470         administrators[_identifier] = _status;
471     }
472 
473     /**
474      * Precautionary measures in case we need to adjust the masternode rate.
475      */
476     function setStakingRequirement(uint256 _amountOfTokens)
477         onlyAdministrator()
478         public
479     {
480         stakingRequirement = _amountOfTokens;
481     }
482 
483     /**
484      * Add or remove game contract, which can accept Elyxr tokens
485      */
486     function setCanAcceptTokens(address _address, bool _value)
487       onlyAdministrator()
488       public
489     {
490       canAcceptTokens_[_address] = _value;
491     }
492 
493     /**
494      * If we want to rebrand, we can.
495      */
496     function setName(string _name)
497         onlyAdministrator()
498         public
499     {
500         name = _name;
501     }
502 
503     /**
504      * If we want to rebrand, we can.
505      */
506     function setSymbol(string _symbol)
507         onlyAdministrator()
508         public
509     {
510         symbol = _symbol;
511     }
512 
513 
514     /*----------  HELPERS AND CALCULATORS  ----------*/
515     /**
516      * Method to view the current Ethereum stored in the contract
517      * Example: totalEthereumBalance()
518      */
519     function totalEthereumBalance()
520         public
521         view
522         returns(uint)
523     {
524         return this.balance;
525     }
526 
527     /**
528      * Retrieve the total token supply.
529      */
530     function totalSupply()
531         public
532         view
533         returns(uint256)
534     {
535         return tokenSupply_;
536     }
537 
538     /**
539      * Retrieve the tokens owned by the caller.
540      */
541     function myTokens()
542         public
543         view
544         returns(uint256)
545     {
546         address _customerAddress = msg.sender;
547         return balanceOf(_customerAddress);
548     }
549 
550     /**
551      * Retrieve the dividends owned by the caller.
552      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
553      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
554      * But in the internal calculations, we want them separate.
555      */
556     function myDividends(bool _includeReferralBonus)
557         public
558         view
559         returns(uint256)
560     {
561         address _customerAddress = msg.sender;
562         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
563     }
564 
565     /**
566      * Retrieve the token balance of any single address.
567      */
568     function balanceOf(address _customerAddress)
569         view
570         public
571         returns(uint256)
572     {
573         return tokenBalanceLedger_[_customerAddress];
574     }
575 
576     /**
577      * Retrieve the dividend balance of any single address.
578      */
579     function dividendsOf(address _customerAddress)
580         view
581         public
582         returns(uint256)
583     {
584         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
585     }
586 
587     /**
588      * Return the buy price of 1 individual token.
589      */
590     function sellPrice()
591         public
592         view
593         returns(uint256)
594     {
595         // our calculation relies on the token supply, so we need supply. Doh.
596         if(tokenSupply_ == 0){
597             return tokenPriceInitial_ - tokenPriceIncremental_;
598         } else {
599             uint256 _ethereum = tokensToEthereum_(1e18);
600             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
601             uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
602             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPayout);
603             return _taxedEthereum;
604         }
605     }
606 
607     /**
608      * Return the sell price of 1 individual token.
609      */
610     function buyPrice()
611         public
612         view
613         returns(uint256)
614     {
615         // our calculation relies on the token supply, so we need supply. Doh.
616         if(tokenSupply_ == 0){
617             return tokenPriceInitial_ + tokenPriceIncremental_;
618         } else {
619             uint256 _ethereum = tokensToEthereum_(1e18);
620             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
621             uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
622             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _jackpotPayout);
623             return _taxedEthereum;
624         }
625     }
626 
627     /**
628      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
629      */
630     function calculateTokensReceived(uint256 _ethereumToSpend)
631         public
632         view
633         returns(uint256)
634     {
635         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
636         uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, jackpotFee_), 100);
637         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _jackpotPayout);
638         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
639         return _amountOfTokens;
640     }
641 
642     /**
643      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
644      */
645     function calculateEthereumReceived(uint256 _tokensToSell)
646         public
647         view
648         returns(uint256)
649     {
650         require(_tokensToSell <= tokenSupply_);
651         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
652         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
653         uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
654         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPayout);
655         return _taxedEthereum;
656     }
657 
658     /**
659      * Function for the frontend to show ether waiting to be sent to Jackpot in contract
660      */
661     function etherToSendJackpot()
662         public
663         view
664         returns(uint256) {
665         return SafeMath.sub(totalEthJackpotCollected, totalEthJackpotRecieved);
666     }
667 
668 
669     /*==========================================
670     =            INTERNAL FUNCTIONS            =
671     ==========================================*/
672 
673     // Make sure we will send back excess if user sends more then 4 ether before 100 ETH in contract
674     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
675       notContract()// no contracts allowed
676       internal
677       returns(uint256) {
678 
679       uint256 purchaseEthereum = _incomingEthereum;
680       uint256 excess;
681       if(purchaseEthereum > 4 ether) { // check if the transaction is over 4 ether
682           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
683               purchaseEthereum = 4 ether;
684               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
685           }
686       }
687 
688       purchaseTokens(purchaseEthereum, _referredBy);
689 
690       if (excess > 0) {
691         msg.sender.transfer(excess);
692       }
693     }
694 
695 
696     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
697         antiEarlyWhale(_incomingEthereum)
698         internal
699         returns(uint256)
700     {
701         // data setup
702         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
703         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
704         uint256 _jackpotPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, jackpotFee_), 100);
705         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
706         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _jackpotPayout);
707 
708         totalEthJackpotCollected = SafeMath.add(totalEthJackpotCollected, _jackpotPayout);
709 
710         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
711         uint256 _fee = _dividends * magnitude;
712 
713         // no point in continuing execution if OP is a poorfag russian hacker
714         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
715         // (or hackers)
716         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
717         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
718 
719         // is the user referred by a masternode?
720         if(
721             // is this a referred purchase?
722             _referredBy != 0x0000000000000000000000000000000000000000 &&
723 
724             // no cheating!
725             _referredBy != msg.sender &&
726 
727             // does the referrer have at least X whole tokens?
728             // i.e is the referrer a godly chad masternode
729             tokenBalanceLedger_[_referredBy] >= stakingRequirement
730         ){
731             // wealth redistribution
732             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
733         } else {
734             // no ref purchase
735             // add the referral bonus back to the global dividends cake
736             _dividends = SafeMath.add(_dividends, _referralBonus);
737             _fee = _dividends * magnitude;
738         }
739 
740         // we can't give people infinite ethereum
741         if(tokenSupply_ > 0){
742 
743             // add tokens to the pool
744             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
745 
746             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
747             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
748 
749             // calculate the amount of tokens the customer receives over his purchase
750             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
751 
752         } else {
753             // add tokens to the pool
754             tokenSupply_ = _amountOfTokens;
755         }
756 
757         // update circulating supply & the ledger address for the customer
758         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
759 
760         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
761         //really i know you think you do but you don't
762         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
763         payoutsTo_[msg.sender] += _updatedPayouts;
764 
765         // fire event
766         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
767 
768         return _amountOfTokens;
769     }
770 
771     /**
772      * Calculate Token price based on an amount of incoming ethereum
773      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
774      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
775      */
776     function ethereumToTokens_(uint256 _ethereum)
777         internal
778         view
779         returns(uint256)
780     {
781         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
782         uint256 _tokensReceived =
783          (
784             (
785                 // underflow attempts BTFO
786                 SafeMath.sub(
787                     (sqrt
788                         (
789                             (_tokenPriceInitial**2)
790                             +
791                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
792                             +
793                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
794                             +
795                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
796                         )
797                     ), _tokenPriceInitial
798                 )
799             )/(tokenPriceIncremental_)
800         )-(tokenSupply_)
801         ;
802 
803         return _tokensReceived;
804     }
805 
806     /**
807      * Calculate token sell value.
808      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
809      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
810      */
811      function tokensToEthereum_(uint256 _tokens)
812         internal
813         view
814         returns(uint256)
815     {
816 
817         uint256 tokens_ = (_tokens + 1e18);
818         uint256 _tokenSupply = (tokenSupply_ + 1e18);
819         uint256 _etherReceived =
820         (
821             // underflow attempts BTFO
822             SafeMath.sub(
823                 (
824                     (
825                         (
826                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
827                         )-tokenPriceIncremental_
828                     )*(tokens_ - 1e18)
829                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
830             )
831         /1e18);
832         return _etherReceived;
833     }
834 
835 
836     //This is where all your gas goes, sorry
837     //Not sorry, you probably only paid 1 gwei
838     function sqrt(uint x) internal pure returns (uint y) {
839         uint z = (x + 1) / 2;
840         y = x;
841         while (z < y) {
842             y = z;
843             z = (x / z + z) / 2;
844         }
845     }
846 }
847 
848 /**
849  * @title SafeMath
850  * @dev Math operations with safety checks that throw on error
851  */
852 library SafeMath {
853 
854     /**
855     * @dev Multiplies two numbers, throws on overflow.
856     */
857     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
858         if (a == 0) {
859             return 0;
860         }
861         uint256 c = a * b;
862         assert(c / a == b);
863         return c;
864     }
865 
866     /**
867     * @dev Integer division of two numbers, truncating the quotient.
868     */
869     function div(uint256 a, uint256 b) internal pure returns (uint256) {
870         // assert(b > 0); // Solidity automatically throws when dividing by 0
871         uint256 c = a / b;
872         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
873         return c;
874     }
875 
876     /**
877     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
878     */
879     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
880         assert(b <= a);
881         return a - b;
882     }
883 
884     /**
885     * @dev Adds two numbers, throws on overflow.
886     */
887     function add(uint256 a, uint256 b) internal pure returns (uint256) {
888         uint256 c = a + b;
889         assert(c >= a);
890         return c;
891     }
892 }