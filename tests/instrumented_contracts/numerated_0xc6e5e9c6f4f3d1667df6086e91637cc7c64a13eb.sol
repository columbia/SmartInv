1 pragma solidity ^0.4.20;
2 
3 
4 contract AcceptsEighterbank {
5     Eightherbank public tokenContract;
6 
7     function AcceptsEighterbank(address _tokenContract) public {
8         tokenContract = Eightherbank(_tokenContract);
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
26 contract Eightherbank {
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
56 
57     modifier onlyAdministrator(){
58         address _customerAddress = msg.sender;
59         require(msg.sender == owner);
60         _;
61     }
62     
63     
64     /*==============================
65     =            EVENTS            =
66     ==============================*/
67     event onTokenPurchase(
68         address indexed customerAddress,
69         uint256 incomingEthereum,
70         uint256 tokensMinted,
71         address indexed referredBy
72     );
73     
74     event onTokenSell(
75         address indexed customerAddress,
76         uint256 tokensBurned,
77         uint256 ethereumEarned
78     );
79     
80     event onReinvestment(
81         address indexed customerAddress,
82         uint256 ethereumReinvested,
83         uint256 tokensMinted
84     );
85     
86     event onWithdraw(
87         address indexed customerAddress,
88         uint256 ethereumWithdrawn
89     );
90     
91     // ERC20
92     event Transfer(
93         address indexed from,
94         address indexed to,
95         uint256 tokens
96     );
97     
98     
99     /*=====================================
100     =            CONFIGURABLES            =
101     =====================================*/
102     address public owner;
103     string public name = "8therbank";
104     string public symbol = "8TH";
105     uint8  public decimals = 18;
106     uint8 constant internal dividendFee_ = 10;
107     uint8 constant internal transferFee_ = 5;
108     uint8 constant internal refferalFee_ = 33;
109     uint256 constant internal tokenPriceInitial_ = 0.00005556 ether;
110     // We need no increment. The price is stable
111     uint256 constant internal magnitude = 2**64;
112     
113     // proof of stake (defaults at 1800 tokens)
114     uint256 public stakingRequirement = 1800e18;
115     
116     // 1% Server fee
117     address internal serverFeeAddress = msg.sender;
118 
119     // 1% To collect funds to buy in partner contracts
120     address internal partnerFeeAddress = 0xdde972dc6B0fBE22B575a1066eF038fd7A60Fd98;
121     
122     // 0.5% For promotional purpose (if not filled, the address will be the same as the partnerFeeAddress on default)
123     address internal promoFeeAddress = 0xE377f23F3C2238FE9EB59776549Ec785CbF42e1b;
124     
125     // 0.5% For the person who does our development
126     address internal devFeeAddress = msg.sender;
127 
128     
129     // ambassador program
130     mapping(address => bool) internal ambassadors_;
131     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
132     uint256 constant internal ambassadorQuota_ = 100 ether;
133     
134     
135     
136    /*================================
137     =            DATASETS            =
138     ================================*/
139     // amount of shares for each address (scaled number)
140     mapping(address => uint256) internal tokenBalanceLedger_;
141     mapping(address => uint256) internal referralBalance_;
142     mapping(address => int256) internal payoutsTo_;
143     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
144     
145     // when this is set to true, only ambassadors can purchase tokens.
146     bool public onlyAmbassadors = true;
147     
148     // UNIX Timestamp
149     // Contract activates itself. Most honest way without having to refresh the UI and without people being able to snip the contract.
150     uint ACTIVATION_TIME = 1574013600;
151     
152     // Function that disables ambassador mode once UNIX Timestamp has expired
153     modifier antiEarlyWhale(uint256 _amountOfEthereum){
154     if (now >= ACTIVATION_TIME) {
155             onlyAmbassadors = false;
156         }
157         // are we still in the vulnerable phase?
158         // if so, enact anti early whale protocol 
159         if(onlyAmbassadors){
160             require(
161                 // is the customer in the ambassador list?
162                 (ambassadors_[msg.sender] == true &&
163                 
164                 // does the customer purchase exceed the max ambassador quota?
165                 (ambassadorAccumulatedQuota_[msg.sender] + _amountOfEthereum) <= ambassadorMaxPurchase_)
166                 
167             );
168             
169             // updated the accumulated quota    
170             ambassadorAccumulatedQuota_[msg.sender] = SafeMath.add(ambassadorAccumulatedQuota_[msg.sender], _amountOfEthereum);
171         
172             // execute
173             _;
174         }else{
175             onlyAmbassadors=false;
176             _;
177         }
178         
179     }
180     
181     uint256 internal tokenSupply_ = 0;
182     uint256 internal profitPerShare_;
183     
184     // administrator list (see above on what they can do)
185     mapping(bytes32 => bool) public administrators;
186     
187     // contracts, which can accept Eightherbank tokens
188     mapping(address => bool) public canAcceptTokens_;
189     
190 
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS            =
194     =======================================*/
195     /*
196     * -- APPLICATION ENTRY POINTS --  
197     */
198     function Eightherbank()
199         public
200     {
201         // add administrators here
202         owner = msg.sender;
203         name = "8therbank";
204         symbol = "8TH";
205         decimals = 18;
206 
207         // The full ambassador list.
208         // This does not mean that everyone actually participates in the ambassador phase. This is the same for the maximum amount.
209 
210         ambassadors_[0x60bc6fa49588bbB9e3273E1fc421f383393E2fc3] = true; // Negan
211         ambassadors_[0x074F21a36217d7615d0202faA926aEFEBB5a9999] = true; // Lordshill
212         ambassadors_[0xEe54D208f62368B4efFe176CB548A317dcAe963F] = true; // Crypto Grandad
213         ambassadors_[0x843f2C19bc6df9E32B482E2F9ad6C078001088b1] = true; // Tony
214         ambassadors_[0xE377f23F3C2238FE9EB59776549Ec785CbF42e1b] = true; // Graig Grant
215         ambassadors_[0xACa4E2730b57dA82476D6d1fA2a85A8f686F108b] = true; // Cherry Blossom
216         ambassadors_[0x24B23bB643082026227e945C7833B81426057b10] = true; // Trevon James  
217         ambassadors_[0x5138240E96360ad64010C27eB0c685A8b2eDE4F2] = true; // Sniped
218         ambassadors_[0xAFC1a5cB605bBd1aa5F6415458BC45cD7554d08b] = true; // Jedi Masternode
219         ambassadors_[0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6] = true; // NumberOfThings
220         ambassadors_[0x73018870D10173ae6F71Cac3047ED3b6d175F274] = true; // Cryptochron
221         ambassadors_[0x53e1eB6a53d9354d43155f76861C5a2AC80ef361] = true; // CoinArtist
222         ambassadors_[0xCdB84A89BB3D2ad99a39AfAd0068DC11B8280FbC] = true; // Ultra-Boy
223         ambassadors_[0xF1018aCEAd986C97BccffaC40246D701E7b6C58b] = true; // Timing Is Everything
224         ambassadors_[0x340570F0fe147f60C259753A7491059eB6526c2D] = true; // Omokazee 
225         ambassadors_[0xbE57E8Cde352a6a55B103f826AC8c324aCD68aDf] = true; // SanTro
226         ambassadors_[0x05aF7f355E914197FB3548c7Ab67887dD187D808] = true; // ButDoesItFloat
227         ambassadors_[0x190A2409fc6434483D4c2CAb804E75e3Bc5ebFa6] = true; // Yobo   
228         ambassadors_[0x52DC007F9D85c4949AF4Db4E7863e48f7f4Fe93D] = true; // All About Passive Income
229         ambassadors_[0x92421097F5a6b24B45e94A5297e220622DCdbd5a] = true; // BobBot
230 
231     }
232     
233     // Function for external contracts to make it easy to feed Eighterbank in a possible partnership
234    function buyFor(address _customerAddress, address _referredBy) public payable returns (uint256) {
235         return purchaseTokens(_customerAddress, msg.value, _referredBy );
236     }
237      
238     /**
239      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
240      */
241     function buy(address _referredBy)
242         public
243         payable
244         returns(uint256)
245     {
246         purchaseTokens(msg.sender, msg.value, _referredBy); 
247     }
248     
249     /**
250      * Fallback function to handle ethereum that was send straight to the contract
251      * Unfortunately we cannot use a referral address this way.
252      */
253     function()
254         payable
255         public
256     {
257         purchaseTokens(msg.sender, msg.value, 0x0);
258     } 
259     
260     /**
261      * Converts all of caller's dividends to tokens.
262     */
263     function reinvest()
264         onlyStronghands()
265         public
266     {
267         // fetch dividends
268         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
269         
270         // pay out the dividends virtually
271         address _customerAddress = msg.sender;
272         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
273         
274         // retrieve ref. bonus
275         _dividends += referralBalance_[_customerAddress];
276         referralBalance_[_customerAddress] = 0;
277         
278         // dispatch a buy order with the virtualized "withdrawn dividends"
279         uint256 _tokens = purchaseTokens(_customerAddress, _dividends, 0x0);
280         
281         // fire event
282         onReinvestment(_customerAddress, _dividends, _tokens);
283     }
284     
285     /**
286      * Alias of sell() and withdraw().
287      */
288     function exit()
289         public
290     {
291         // get token count for caller & sell them all
292         address _customerAddress = msg.sender;
293         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
294         if(_tokens > 0) sell(_tokens);
295         
296         // lambo delivery service
297         withdraw();
298     }
299 
300     /**
301      * Withdraws all of the callers earnings.
302      */
303     function withdraw()
304         onlyStronghands()
305         public
306     {
307         // setup data
308         address _customerAddress = msg.sender;
309         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
310         
311         // update dividend tracker
312         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
313         
314         // add ref. bonus
315         _dividends += referralBalance_[_customerAddress];
316         referralBalance_[_customerAddress] = 0;
317         
318         // lambo delivery service
319         _customerAddress.transfer(_dividends);
320         
321         // fire event
322         onWithdraw(_customerAddress, _dividends);
323     }
324     
325     /**
326      * Liquifies tokens to ethereum.
327      */
328     function sell(uint256 _amountOfTokens)
329         onlyBagholders()
330         public
331     {
332         // setup data
333         address _customerAddress = msg.sender;
334         // russian hackers BTFO
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336         uint256 _tokens = _amountOfTokens;
337         uint256 _ethereum = tokensToEthereum_(_tokens);
338 	    uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
339         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
340         
341         // burn the sold tokens
342         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
343         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
344         
345         // update dividends tracker
346         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
347         payoutsTo_[_customerAddress] -= _updatedPayouts;       
348         
349         // dividing by zero is a bad idea
350         if (tokenSupply_ > 0) {
351             // update the amount of dividends per token
352             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
353         }
354         
355         // fire event
356         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
357     }
358     
359     
360     /**
361      * Transfer tokens from the caller to a new holder.
362      * Remember, there's a 5% fee here as well.
363      */
364     function transfer(address _toAddress, uint256 _amountOfTokens)
365         onlyBagholders()
366         public
367         returns(bool)
368     {
369         // setup
370         address _customerAddress = msg.sender;
371         
372         // make sure we have the requested tokens
373         // also disables transfers until ambassador phase is over
374         // ( we dont want whale premines )
375         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
376         
377         // liquify 5% of the tokens that are transfered
378         // these are dispersed to shareholders
379         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
380         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
381         uint256 _dividends = tokensToEthereum_(_tokenFee);
382   
383         // burn the fee tokens
384         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
385 
386         // exchange tokens
387         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
388         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
389         
390         // update dividend trackers
391         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
392         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
393         
394         // disperse dividends among holders
395         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
396         
397         // fire event
398         Transfer(_customerAddress, _toAddress, _taxedTokens);
399         
400         // ERC20
401         return true;
402        
403     }
404     
405     	    /**
406     * Transfer token to a specified address and forward the data to recipient
407     * ERC-677 standard
408     * https://github.com/ethereum/EIPs/issues/677
409     * @param _to    Receiver address.
410     * @param _value Amount of tokens that will be transferred.
411     * @param _data  Transaction metadata.
412     */
413     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
414       require(_to != address(0));
415       require(canAcceptTokens_[_to] == true); // security check that contract approved by Eightherbank platform
416       require(transfer(_to, _value)); // do a normal token transfer to the contract
417       if (isContract(_to)) {
418         AcceptsEighterbank receiver = AcceptsEighterbank(_to);
419         require(receiver.tokenFallback(msg.sender, _value, _data));
420       }
421       return true;
422     }
423     /**
424      * Additional check that the game address we are sending tokens to is a contract
425      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
426      */
427      function isContract(address _addr) private constant returns (bool is_contract) {
428        // retrieve the size of the code on target address, this needs assembly
429        uint length;
430        assembly { length := extcodesize(_addr) }
431        return length > 0;
432      }
433     
434     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
435     /**
436      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
437      */
438     function disableInitialStage()
439         onlyAdministrator()
440         public
441     {
442         onlyAmbassadors = false;
443     }
444     
445     // Function to change partnerFeeAddress in case the partnership is ever broken
446     function changePartner(address _partnerAddress) public{
447         require(owner==msg.sender);
448         partnerFeeAddress=_partnerAddress;
449     }
450     
451   // Function to change promoFeeAddresss in case the promoter decides to stop
452   function changePromoter(address _promotorAddress) public{
453         require(owner==msg.sender);
454         promoFeeAddress=_promotorAddress;
455     }
456     
457   // Function to change devFeeAddresss in case the developer decides to stop working
458   function changeDev(address _devAddress) public{
459         require(owner==msg.sender);
460         devFeeAddress=_devAddress;
461     }
462     
463     /**
464      * In case one of us dies, we need to replace ourselves.
465      */
466     function setAdministrator(address newowner)
467         onlyAdministrator()
468         public
469     {
470         owner = newowner;
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
483         /**
484      * Add or remove game contract, which can accept Eightherbank tokens
485      */
486     function setCanAcceptTokens(address _address, bool _value)
487       onlyAdministrator()
488       public
489     {
490       canAcceptTokens_[_address] = _value;
491     }
492 
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
520     function totalEthereumBalance()
521         public
522         view
523         returns(uint)
524     {
525         return this.balance;
526     }
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
594         returns(string)
595     {
596             return "0.00005";
597     }
598     
599     /**
600      * Return the sell price of 1 individual token.
601      */
602     function buyPrice() 
603         public 
604         view 
605         returns(string)
606     {
607         return "0.00005556";
608     }
609     
610     /**
611      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
612      */
613     function calculateTokensReceived(uint256 _ethereumToSpend) 
614         public 
615         view 
616         returns(uint256)
617     {
618         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
619         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
620         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
621         
622         return _amountOfTokens;
623     }
624     
625     /**
626      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
627      */
628     function calculateEthereumReceived(uint256 _tokensToSell) 
629         public 
630         view 
631         returns(uint256)
632     {
633         require(_tokensToSell <= tokenSupply_);
634         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
635         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
636         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
637         return _taxedEthereum;
638     }
639     
640     
641     /*==========================================
642     =            INTERNAL FUNCTIONS            =
643     ==========================================*/
644         function purchaseTokens(address _customerAddress, uint256 _incomingEthereum, address _referredBy)
645         antiEarlyWhale(_incomingEthereum)
646         internal
647         returns(uint256)
648     {
649         // data setup
650 
651         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
652         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
653         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
654         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
655         
656         // 3% fee used for the serverFeeAddress, promoFeeAddress, partnerFeeAddress and devFeeAddress
657         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100)); // 1%
658         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100)); // 1%
659         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200)); // 0.5%
660         _taxedEthereum = SafeMath.sub(_taxedEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200)); // 0.5%
661         
662         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
663         uint256 _fee = _dividends * magnitude;
664  
665         // no point in continuing execution if OP is a poorfag russian hacker
666         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
667         // (or hackers)
668         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
669         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
670         
671         // is the user referred by a masternode?
672         if(
673             // is this a referred purchase?
674             _referredBy != 0x0000000000000000000000000000000000000000 &&
675 
676             // no cheating!
677             _referredBy != _customerAddress &&
678             
679             // does the referrer have at least X whole tokens?
680             // i.e is the referrer a godly chad masternode
681             tokenBalanceLedger_[_referredBy] >= stakingRequirement
682         ){
683             // wealth redistribution
684             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
685         } else {
686             // no ref purchase
687             // add the referral bonus back to the global dividends cake
688             _dividends = SafeMath.add(_dividends, _referralBonus);
689             _fee = _dividends * magnitude;
690         }
691         
692         // we can't give people infinite ethereum
693         if(tokenSupply_ > 0){
694             
695             // add tokens to the pool
696             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
697  
698             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
699             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
700             
701             // calculate the amount of tokens the customer receives over his purchase 
702             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
703         
704         } else {
705             // add tokens to the pool
706             tokenSupply_ = _amountOfTokens;
707         }
708         
709         // update circulating supply & the ledger address for the customer
710         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
711         
712         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
713         // really i know you think you do but you don't
714         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
715         payoutsTo_[_customerAddress] += _updatedPayouts;
716         
717         // fire event
718         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
719         
720         // Transfers the fee amounts to the addresses
721         serverFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100)); // 1%
722         partnerFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 100)); // 1%
723         promoFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200)); // 0.5%
724         devFeeAddress.transfer(SafeMath.div(SafeMath.mul(_incomingEthereum, 1), 200)); // 0.5%
725         
726         return _amountOfTokens;
727     }
728 
729     /**
730      * Calculate Token price based on an amount of incoming ethereum
731      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
732      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
733      */
734     function ethereumToTokens_(uint256 _ethereum)
735         internal
736         view
737         returns(uint256)
738     {
739         return (_ethereum * 20000);
740     }
741 
742     /**
743      * Calculate token sell value.
744      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
745      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
746      */
747      function tokensToEthereum_(uint256 _tokens)
748         internal
749         view
750         returns(uint256)
751     {
752         return (_tokens / 20000);
753     }
754 }
755 
756 /**
757  * @title SafeMath
758  * @dev Math operations with safety checks that throw on error
759  */
760 library SafeMath {
761 
762     /**
763     * @dev Multiplies two numbers, throws on overflow.
764     */
765     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
766         if (a == 0) {
767             return 0;
768         }
769         uint256 c = a * b;
770         assert(c / a == b);
771         return c;
772     }
773 
774     /**
775     * @dev Integer division of two numbers, truncating the quotient.
776     */
777     function div(uint256 a, uint256 b) internal pure returns (uint256) {
778         // assert(b > 0); // Solidity automatically throws when dividing by 0
779         uint256 c = a / b;
780         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
781         return c;
782     }
783 
784     /**
785     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
786     */
787     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
788         assert(b <= a);
789         return a - b;
790     }
791 
792     /**
793     * @dev Adds two numbers, throws on overflow.
794     */
795     function add(uint256 a, uint256 b) internal pure returns (uint256) {
796         uint256 c = a + b;
797         assert(c >= a);
798         return c;
799     }
800 }