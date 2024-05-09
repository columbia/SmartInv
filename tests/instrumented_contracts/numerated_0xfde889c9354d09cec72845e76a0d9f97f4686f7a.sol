1 pragma solidity ^0.4.24;
2 
3 /*    ██████╗  █████╗ ██████╗ ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗      ██╗ ██████╗
4       ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗     ██║██╔═══██╗
5       ██████╔╝███████║██████╔╝██████╔╝██║   ██║   ███████║██║   ██║██████╔╝     ██║██║   ██║
6       ██╔══██╗██╔══██║██╔══██╗██╔══██╗██║   ██║   ██╔══██║██║   ██║██╔══██╗     ██║██║   ██║
7       ██║  ██║██║  ██║██████╔╝██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝ ██╗ ██║╚██████╔╝
8       ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═╝ ╚═╝ ╚═════╝
9 
10                              ______                         _
11                              | ___ \                       | |
12                              | |_/ / __ ___  ___  ___ _ __ | |_ ___
13                              |  __/ '__/ _ \/ __|/ _ \ '_ \| __/ __|
14                              | |  | | |  __/\__ \  __/ | | | |_\__ \
15                              \_|  |_|  \___||___/\___|_| |_|\__|___/
16 
17 
18                 ________            ____        __    __    _ __     __  __      __
19                /_  __/ /_  ___     / __ \____ _/ /_  / /_  (_) /_   / / / /___  / /__
20                 / / / __ \/ _ \   / /_/ / __ `/ __ \/ __ \/ / __/  / /_/ / __ \/ / _ \
21                / / / / / /  __/  / _, _/ /_/ / /_/ / /_/ / / /_   / __  / /_/ / /  __/
22               /_/ /_/ /_/\___/  /_/ |_|\__,_/_.___/_.___/_/\__/  /_/ /_/\____/_/\___/
23 
24 
25  ---------- WHAT DO WE OFFER ------------------------------
26  [1] 19% fee on each Buy & 15% fee on each Sell, which is distributed between all current token holders.
27  [2] 1% fee on each Buy & Sell which is sent to the Bankroll - It will be used to fund future project development with occasional airdrops.
28  [3] 2 Tier deep MLM referral system, earn 10% on tier 1 referrals and 5% on tier 2.
29  [4] Unique anti-botting approach during the launch, locks the contract to be interactable only through the website during the initial bot phase.
30  [5] ERC-223 token distribution delegation - the token can be accepted by other contracts / DAPPs without security risks.
31  [6] New and unique ON-Chain games to grow the ecosystem.
32  [7] Off-chain games platform that will yield dividends to current token holders.
33 
34 
35                             https://github.com/0x566c6164
36 	https://rabbithub.io  https://rabbithub.io  https://rabbithub.io  https://rabbithub.io
37 	https://rabbithub.io  https://rabbithub.io  https://rabbithub.io  https://rabbithub.io
38 
39   AUDITED WITH <3 by independent third party: 8 ฿ł₮ ₮Ɽł₱
40 
41  */
42 
43 
44 contract RabbitHub {
45   using SafeMath for uint;
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
86 
87         if(this.balance <= 50 ether) {
88           // 50 GWEI limit
89           require(tx.gasprice <= 50000000000 wei);
90         }
91 
92         // are we still in the vulnerable phase?
93         // if so, enact anti early whale protocol
94         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
95             require(
96                 // is the customer in the ambassador list?
97                 ambassadors_[msg.sender] == true &&
98 
99                 // does the customer purchase exceed the max ambassador quota?
100                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_
101 
102             );
103 
104             // updated the accumulated quota
105             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
106         }
107 
108         if(this.balance >= 50 ether) {
109           // At 50 eth, disable and never initiate botPhase again.
110           botPhase = false;
111         }
112 
113         _;
114 
115     }
116 
117     /*==============================
118     =            EVENTS            =
119     ==============================*/
120     event onTokenPurchase(
121         address indexed customerAddress,
122         uint256 incomingEthereum,
123         uint256 tokensMinted,
124         address indexed referredBy
125     );
126 
127     event onTokenSell(
128         address indexed customerAddress,
129         uint256 tokensBurned,
130         uint256 ethereumEarned
131     );
132 
133     event onReinvestment(
134         address indexed customerAddress,
135         uint256 ethereumReinvested,
136         uint256 tokensMinted
137     );
138 
139     event onWithdraw(
140         address indexed customerAddress,
141         uint256 ethereumWithdrawn
142     );
143 
144     // ERC20
145      event Transfer(
146         address indexed from,
147         address indexed to,
148         uint256 tokens
149     );
150 
151     // ERC223
152     event Transfer(
153         address indexed from,
154         address indexed to,
155         uint256 tokens,
156         bytes data
157     );
158 
159 
160     /*=====================================
161     =            CONFIGURABLES            =
162     =====================================*/
163     string public name = "Rabbit Hub";
164     string public symbol = "Carrot";
165     uint8 constant public decimals = 18;
166     uint8 constant internal buyDividendFee_ = 19; // 19% dividend fee on each buy
167     uint8 constant internal sellDividendFee_ = 15; // 15% dividend fee on each sell
168     uint8 constant internal bankRollFee_ = 1; // 1% BankRoll Fee
169     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
170     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
171     uint256 constant internal magnitude = 2**64;
172 
173     // BankRoll Pool
174     // https://etherscan.io/address/0x6cd532ffdd1ad3a57c3e7ee43dc1dca75ace901b
175     address constant public giveEthBankRollAddress = 0x6cd532ffdd1ad3a57c3e7ee43dc1dca75ace901b;
176     uint256 public totalEthBankrollReceived; // total ETH bankRoll received from this contract
177     uint256 public totalEthBankrollCollected; // total ETH bankRoll collected in this contract
178 
179     // proof of stake (defaults at 100 tokens)
180     uint256 public stakingRequirement = 10e18;
181 
182     // ambassador program
183     mapping(address => bool) internal ambassadors_;
184     uint256 constant internal ambassadorMaxPurchase_ = 0.6 ether;
185     uint256 constant internal ambassadorQuota_ = 3 ether;
186    /*================================
187     =            DATASETS            =
188     ================================*/
189     // amount of shares for each address (scaled number)
190     mapping(address => uint256) internal tokenBalanceLedger_;
191     mapping(address => uint256) internal referralBalance_;
192     mapping(address => address) internal referralOf_;
193     mapping(address => int256) internal payoutsTo_;
194     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
195     mapping(address => bool) internal alreadyBought;
196     uint256 internal tokenSupply_ = 0;
197     uint256 internal profitPerShare_;
198 
199     // administrator list (see above on what they can do)
200     mapping(address => bool) public administrators;
201 
202     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper game)
203     bool public onlyAmbassadors = true;
204     bool public botPhase;
205 
206 
207 
208     /*=======================================
209     =            PUBLIC FUNCTIONS            =
210     =======================================*/
211     /*
212     * -- APPLICATION ENTRY POINTS --
213     */
214     constructor()
215         public
216     {
217         administrators[0x93B5b8E5AeFd9197305408df1F824B0E58229fD0] = true;
218         administrators[0xAAa2792AC2A60c694a87Cec7516E8CdFE85B0463] = true;
219         administrators[0xE5131Cd7222209D40cdDaE9e95113fC2075918a5] = true;
220 
221         ambassadors_[0x93B5b8E5AeFd9197305408df1F824B0E58229fD0] = true;
222         ambassadors_[0xAAa2792AC2A60c694a87Cec7516E8CdFE85B0463] = true;
223         ambassadors_[0xE5131Cd7222209D40cdDaE9e95113fC2075918a5] = true;
224         ambassadors_[0xEbE8a13C450eC5Fe388B53E88f44eD56933C15bc] = true;
225         ambassadors_[0x2df5671C284d185032f7c2Ffb1A6067eD4d32413] = true;
226     }
227 
228     // Botters & Snipers BTFO!
229     modifier antiBot(bytes32 _seed) {
230       if(botPhase) {
231         require(keccak256(keccak256(msg.sender)) == keccak256(_seed));
232       }
233       _;
234     }
235 
236     /**
237      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
238      */
239     function buy(address _referredBy, bytes32 _seed)
240         antiBot(_seed)
241         public
242         payable
243         returns(uint256)
244     {
245         purchaseInternal(msg.value, _referredBy);
246     }
247 
248     /**
249      * Fallback function to handle ethereum that was send straight to the contract
250      * Unfortunately we cannot use a referral address this way.
251      */
252     function()
253         payable
254         public
255     {
256         // Contract does not accept any transactions here except from the website, have fun botting/sniping that.
257         if(botPhase) {
258           revert();
259         } else {
260           purchaseInternal(msg.value, 0x0);
261         }
262 
263     }
264 
265     /**
266      * The Rabbit Hub Bankroll Pool
267      * Their bankRoll address is here https://etherscan.io/address/0x6cd532ffdd1ad3a57c3e7ee43dc1dca75ace901b
268      */
269     function payBankRoll() payable public {
270       uint256 ethToPay = SafeMath.sub(totalEthBankrollCollected, totalEthBankrollReceived);
271       require(ethToPay > 1);
272       totalEthBankrollReceived = SafeMath.add(totalEthBankrollReceived, ethToPay);
273       if(!giveEthBankRollAddress.call.value(ethToPay).gas(400000)()) {
274          totalEthBankrollReceived = SafeMath.sub(totalEthBankrollReceived, ethToPay);
275       }
276     }
277 
278     /**
279      * Converts all of caller's dividends to tokens.
280      */
281     function reinvest()
282         onlyStronghands()
283         public
284     {
285         // fetch dividends
286         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
287 
288         // pay out the dividends virtually
289         address _customerAddress = msg.sender;
290         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
291 
292         // retrieve ref. bonus
293         _dividends += referralBalance_[_customerAddress];
294         referralBalance_[_customerAddress] = 0;
295 
296         // dispatch a buy order with the virtualized "withdrawn dividends"
297         uint256 _tokens = purchaseTokens(_dividends, 0x0);
298 
299         // fire event
300         emit onReinvestment(_customerAddress, _dividends, _tokens);
301     }
302 
303     /**
304      * Alias of sell() and withdraw().
305      */
306     function exit()
307         public
308     {
309         // get token count for caller & sell them all
310         address _customerAddress = msg.sender;
311         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
312         if(_tokens > 0) sell(_tokens);
313 
314         // lambo delivery service
315         withdraw();
316     }
317 
318     /**
319      * Withdraws all of the callers earnings.
320      */
321     function withdraw()
322         onlyStronghands()
323         public
324     {
325         // setup data
326         address _customerAddress = msg.sender;
327         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
328 
329         // update dividend tracker
330         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
331 
332         // add ref. bonus
333         _dividends += referralBalance_[_customerAddress];
334         referralBalance_[_customerAddress] = 0;
335 
336         // lambo delivery service
337         _customerAddress.transfer(_dividends);
338 
339         // fire event
340         emit onWithdraw(_customerAddress, _dividends);
341     }
342 
343     /**
344      * Liquifies tokens to ethereum.
345      */
346     function sell(uint256 _amountOfTokens)
347         onlyBagholders()
348         public
349     {
350         // setup data
351         address _customerAddress = msg.sender;
352         // russian hackers BTFO
353         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
354         uint256 _tokens = _amountOfTokens;
355         uint256 _ethereum = tokensToEthereum_(_tokens);
356 
357         uint256 _dividends =SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_), 100); // 15% dividendFee_
358          uint256 _bankRollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankRollFee_), 100);
359 
360         // Take out dividends and then _bankrollPayout
361         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankRollPayout);
362 
363         // Add ethereum to send to bankroll
364         totalEthBankrollCollected = SafeMath.add(totalEthBankrollCollected, _bankRollPayout);
365 
366         // burn the sold tokens
367         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
368         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
369 
370         // update dividends tracker
371         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
372         payoutsTo_[_customerAddress] -= _updatedPayouts;
373 
374         // dividing by zero is a bad idea
375         if (tokenSupply_ > 0) {
376             // update the amount of dividends per token
377             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
378         }
379 
380         // fire event
381         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
382     }
383 
384 
385     /**
386      * Transfer tokens from the caller to a new holder.
387      * REMEMBER THIS IS 0% TRANSFER FEE
388      * ERC20 transfer function
389      */
390     function transfer(address _toAddress, uint256 _amountOfTokens)
391         onlyBagholders()
392         public
393         returns(bool)
394     {
395         // disables the option to send tokens to a contract by mistake
396         require(!isContract(_toAddress));
397         // setup
398         address _customerAddress = msg.sender;
399 
400         // make sure we have the requested tokens
401         // also disables transfers until ambassador phase is over
402         // ( we dont want whale premines )
403         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
404 
405         // withdraw all outstanding dividends first
406         if(myDividends(true) > 0) withdraw();
407 
408         // exchange tokens
409         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
410         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
411 
412         // update dividend trackers
413         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
414         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
415 
416 
417         // fire event
418         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
419 
420         // ERC20
421         return true;
422     }
423 
424     // ERC223 compatible transfer function
425     function transfer(address _toAddress, uint256 _amountOfTokens, bytes _data)
426         onlyBagholders()
427         public
428         returns(bool)
429     {
430         // you can send tokens ONLY to a contract with this function
431         require(isContract(_toAddress));
432         // setup
433         address _customerAddress = msg.sender;
434 
435         // make sure we have the requested tokens
436         // also disables transfers until ambassador phase is over
437         // ( we dont want whale premines )
438         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
439 
440         // withdraw all outstanding dividends first
441         if(myDividends(true) > 0) withdraw();
442 
443         // exchange tokens
444         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
445         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
446 
447         // update dividend trackers
448         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
449         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
450 
451         ERC223ReceivingContract _contract = ERC223ReceivingContract(_toAddress);
452         _contract.tokenFallback(msg.sender, _amountOfTokens, _data);
453 
454 
455         // fire event
456         emit Transfer(_customerAddress, _toAddress, _amountOfTokens, _data);
457 
458         // ERC223
459         return true;
460     }
461 
462     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
463     /**
464      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
465      */
466     function openTheRabbitHole()
467         onlyAdministrator()
468         public
469     {
470         onlyAmbassadors = false;
471         botPhase = true;
472     }
473 
474     /**
475      * In case one of us dies, we need to replace ourselves.
476      */
477     function setAdministrator(address _identifier, bool _status)
478         onlyAdministrator()
479         public
480     {
481         administrators[_identifier] = _status;
482     }
483 
484     /**
485      * Precautionary measures in case we need to adjust the masternode rate.
486      */
487     function setStakingRequirement(uint256 _amountOfTokens)
488         onlyAdministrator()
489         public
490     {
491         stakingRequirement = _amountOfTokens;
492     }
493 
494     /**
495      * If we want to rebrand, we can.
496      */
497     function setName(string _name)
498         onlyAdministrator()
499         public
500     {
501         name = _name;
502     }
503 
504     /**
505      * If we want to rebrand, we can.
506      */
507     function setSymbol(string _symbol)
508         onlyAdministrator()
509         public
510     {
511         symbol = _symbol;
512     }
513 
514 
515     /*----------  HELPERS AND CALCULATORS  ----------*/
516     /**
517      * Method to view the current Ethereum stored in the contract
518      * Example: totalEthereumBalance()
519      */
520      function totalEthereumBalance()
521          public
522          view
523          returns(uint)
524      {
525          return this.balance;
526      }
527 
528     /**
529      * Retrieve the total token supply.
530      */
531     function totalSupply()
532         public
533         view
534         returns(uint256)
535     {
536         return tokenSupply_;
537     }
538 
539     /**
540      * Retrieve the tokens owned by the caller.
541      */
542     function myTokens()
543         public
544         view
545         returns(uint256)
546     {
547         address _customerAddress = msg.sender;
548         return balanceOf(_customerAddress);
549     }
550 
551     /**
552      * Retrieve the dividends owned by the caller.
553      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
554      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
555      * But in the internal calculations, we want them separate.
556      */
557     function myDividends(bool _includeReferralBonus)
558         public
559         view
560         returns(uint256)
561     {
562         address _customerAddress = msg.sender;
563         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
564     }
565 
566     /**
567      * Retrieve the token balance of any single address.
568      */
569     function balanceOf(address _customerAddress)
570         view
571         public
572         returns(uint256)
573     {
574         return tokenBalanceLedger_[_customerAddress];
575     }
576 
577     /**
578      * Retrieve the dividend balance of any single address.
579      */
580     function dividendsOf(address _customerAddress)
581         view
582         public
583         returns(uint256)
584     {
585         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
586     }
587 
588     /**
589      * Return the buy price of 1 individual token.
590      */
591     function sellPrice()
592         public
593         view
594         returns(uint256)
595     {
596         // our calculation relies on the token supply, so we need supply. Doh.
597         if(tokenSupply_ == 0){
598             return tokenPriceInitial_ - tokenPriceIncremental_;
599         } else {
600             uint256 _ethereum = tokensToEthereum_(1e18);
601             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_), 100);
602             uint256 _bankRollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankRollFee_), 100);
603             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankRollPayout);
604             return _taxedEthereum;
605         }
606     }
607 
608     /**
609      * Return the sell price of 1 individual token.
610      */
611     function buyPrice()
612         public
613         view
614         returns(uint256)
615     {
616         // our calculation relies on the token supply, so we need supply. Doh.
617         if(tokenSupply_ == 0){
618             return tokenPriceInitial_ + tokenPriceIncremental_;
619         } else {
620             uint256 _ethereum = tokensToEthereum_(1e18);
621             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyDividendFee_), 100);
622             uint256 _bankRollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankRollFee_), 100);
623             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _bankRollPayout);
624             return _taxedEthereum;
625         }
626     }
627 
628     /**
629      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
630      */
631     function calculateTokensReceived(uint256 _ethereumToSpend)
632         public
633         view
634         returns(uint256)
635     {
636         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyDividendFee_), 100);
637         uint256 _bankRollPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, bankRollFee_), 100);
638         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _bankRollPayout);
639         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
640         return _amountOfTokens;
641     }
642 
643     /**
644      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
645      */
646     function calculateEthereumReceived(uint256 _tokensToSell)
647         public
648         view
649         returns(uint256)
650     {
651         require(_tokensToSell <= tokenSupply_);
652         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
653         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, sellDividendFee_), 100);
654         uint256 _bankRollPayout = SafeMath.div(SafeMath.mul(_ethereum, bankRollFee_), 100);
655         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _bankRollPayout);
656         return _taxedEthereum;
657     }
658 
659     /**
660      * Function for the frontend to show ether waiting to be send to bankRoll in contract
661      */
662     function etherToSendBankRoll()
663         public
664         view
665         returns(uint256) {
666         return SafeMath.sub(totalEthBankrollCollected, totalEthBankrollReceived);
667     }
668 
669     // inline assembly function to check if the address is a contract or not
670     function isContract(address _addr) private returns (bool) {
671       uint length;
672       assembly {
673         length := extcodesize(_addr)
674       }
675       return length > 0;
676     }
677 
678 
679     /*==========================================
680     =            INTERNAL FUNCTIONS            =
681     ==========================================*/
682 
683     // Make sure we will send back excess if user sends more then 1 ether before 75 ETH in contract
684     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
685       notContract()// no contracts allowed
686       internal
687       returns(uint256) {
688 
689       uint256 purchaseEthereum = _incomingEthereum;
690       uint256 excess;
691       if(purchaseEthereum > 1 ether) { // check if the transaction is over 1 ether
692           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 75 ether) { // if so check the contract is less then 75 ether
693               purchaseEthereum = 1 ether;
694               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
695           }
696       }
697 
698       if (excess > 0) {
699         msg.sender.transfer(excess);
700       }
701 
702       purchaseTokens(purchaseEthereum, _referredBy);
703     }
704 
705 
706     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
707         antiEarlyWhale(_incomingEthereum)
708         internal
709         returns(uint256)
710     {
711 
712         // data setup
713         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyDividendFee_), 100); // dividendFee_ 19%
714         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_incomingEthereum, 15), 100); // 15% of incoming ETH as potential ref bonus
715         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
716         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), SafeMath.div(SafeMath.mul(_incomingEthereum, bankRollFee_), 100));
717 
718         totalEthBankrollCollected = SafeMath.add(totalEthBankrollCollected, SafeMath.div(SafeMath.mul(_incomingEthereum, bankRollFee_), 100));
719 
720         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
721         uint256 _fee = _dividends * magnitude;
722 
723         // no point in continuing execution if OP is a poorfag russian hacker
724         // prevents overflow in the case that the game somehow magically starts being used by everyone in the world
725         // (or hackers)
726         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
727         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
728 
729         // is the user referred by a masternode?
730         if(
731             // is this a referred purchase?
732             _referredBy != 0x0000000000000000000000000000000000000000 &&
733 
734             // no cheating!
735             _referredBy != msg.sender &&
736 
737             // does the referrer have at least X whole tokens?
738             // i.e is the referrer a godly chad masternode
739             tokenBalanceLedger_[_referredBy] >= stakingRequirement &&
740 
741             referralOf_[msg.sender] == 0x0000000000000000000000000000000000000000 &&
742 
743             alreadyBought[msg.sender] == false
744         ){
745             referralOf_[msg.sender] = _referredBy;
746 
747             // wealth redistribution
748             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_incomingEthereum, 10), 100)); // Tier 1 gets 67% of referrals (10%)
749 
750             address tier2 = referralOf_[_referredBy];
751 
752             if (tier2 != 0x0000000000000000000000000000000000000000 && tokenBalanceLedger_[tier2] >= stakingRequirement) {
753                 referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], SafeMath.div(_referralBonus, 3)); // Tier 2 gets 33% of referrals (5%)
754             }
755             else {
756                 _dividends = SafeMath.add(_dividends, SafeMath.div(_referralBonus, 3));
757                 _fee = _dividends * magnitude;
758             }
759 
760         } else {
761             // no ref purchase
762             // add the referral bonus back to the global dividends cake
763             _dividends = SafeMath.add(_dividends, _referralBonus);
764             _fee = _dividends * magnitude;
765         }
766 
767         // we can't give people infinite ethereum
768         if(tokenSupply_ > 0){
769 
770             // add tokens to the pool
771             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
772 
773             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
774             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
775 
776             // calculate the amount of tokens the customer receives over his purchase
777             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
778 
779         } else {
780             // add tokens to the pool
781             tokenSupply_ = _amountOfTokens;
782         }
783 
784         // update circulating supply & the ledger address for the customer
785         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
786 
787         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
788         //really i know you think you do but you don't
789         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
790         payoutsTo_[msg.sender] += _updatedPayouts;
791         alreadyBought[msg.sender] = true;
792 
793         // fire event
794         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
795 
796         return _amountOfTokens;
797     }
798 
799         /**
800          * Calculate Token price based on an amount of incoming ethereum
801          * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
802          * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
803          */
804         function ethereumToTokens_(uint256 _ethereum)
805             internal
806             view
807             returns(uint256)
808         {
809             uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
810             uint256 _tokensReceived =
811              (
812                 (
813                     // underflow attempts BTFO
814                     SafeMath.sub(
815                         (sqrt
816                             (
817                                 (_tokenPriceInitial**2)
818                                 +
819                                 (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
820                                 +
821                                 (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
822                                 +
823                                 (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
824                             )
825                         ), _tokenPriceInitial
826                     )
827                 )/(tokenPriceIncremental_)
828             )-(tokenSupply_)
829             ;
830 
831             return _tokensReceived;
832         }
833 
834         /**
835          * Calculate token sell value.
836          * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
837          * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
838          */
839          function tokensToEthereum_(uint256 _tokens)
840             internal
841             view
842             returns(uint256)
843         {
844 
845             uint256 tokens_ = (_tokens + 1e18);
846             uint256 _tokenSupply = (tokenSupply_ + 1e18);
847             uint256 _etherReceived =
848             (
849                 // underflow attempts BTFO
850                 SafeMath.sub(
851                     (
852                         (
853                             (
854                                 tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
855                             )-tokenPriceIncremental_
856                         )*(tokens_ - 1e18)
857                     ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
858                 )
859             /1e18);
860             return _etherReceived;
861         }
862 
863 
864 
865 
866         //This is where all your gas goes, sorry
867         //Not sorry, you probably only paid 1 gwei
868         function sqrt(uint x) internal pure returns (uint y) {
869             uint z = (x + 1) / 2;
870             y = x;
871             while (z < y) {
872                 y = z;
873                 z = (x / z + z) / 2;
874             }
875         }
876     }
877 
878     /**
879      * @title SafeMath
880      * @dev Math operations with safety checks that throw on error
881      */
882     library SafeMath {
883 
884         /**
885         * @dev Multiplies two numbers, throws on overflow.
886         */
887         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
888             if (a == 0) {
889                 return 0;
890             }
891             uint256 c = a * b;
892             assert(c / a == b);
893             return c;
894         }
895 
896         /**
897         * @dev Integer division of two numbers, truncating the quotient.
898         */
899         function div(uint256 a, uint256 b) internal pure returns (uint256) {
900             // assert(b > 0); // Solidity automatically throws when dividing by 0
901             uint256 c = a / b;
902             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
903             return c;
904         }
905 
906         /**
907         * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
908         */
909         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
910             assert(b <= a);
911             return a - b;
912         }
913 
914         /**
915         * @dev Adds two numbers, throws on overflow.
916         */
917         function add(uint256 a, uint256 b) internal pure returns (uint256) {
918             uint256 c = a + b;
919             assert(c >= a);
920             return c;
921         }
922     }
923 
924 
925       contract ERC223ReceivingContract {
926       /**
927        * @dev Standard ERC223 function that will handle incoming token transfers.
928        *
929        * @param _from  Token sender address.
930        * @param _value Amount of tokens.
931        * @param _data  Transaction metadata.
932        */
933        function tokenFallback(address _from, uint _value, bytes _data);
934 }