1 pragma solidity ^0.4.25;
2 
3 contract RunAway {
4     using SafeMath for uint256;
5     using SafeMathInt for int256;
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9     // only people with tokens
10     modifier onlyBagholders() {
11         require(myTokens() > 0);
12         _;
13     }
14 
15     /**
16      * @dev prevents contracts from interacting with me
17      */
18     modifier onlyHuman() {
19         address _addr = msg.sender;
20         uint256 _codeLength;
21 
22         assembly {_codeLength := extcodesize(_addr)}
23         require(_codeLength == 0, "sorry humans only");
24         _;
25     }
26 
27     // administrators can:
28     // -> change the name of the contract
29     // -> change the name of the token
30     // -> start the game(activate)
31     // they CANNOT:
32     // -> take funds
33     // -> disable withdrawals
34     // -> kill the contract
35     // -> change the price of tokens
36     modifier onlyAdministrator(){
37         address _customerAddress = msg.sender;
38         require(administrators[keccak256(abi.encodePacked(_customerAddress))]);
39         _;
40     }
41 
42     modifier onlyComm1(){
43         address _customerAddress = msg.sender;
44         require(keccak256(abi.encodePacked(_customerAddress)) == comm1_);
45         _;
46     }
47 
48     modifier onlyComm2{
49         address _customerAddress = msg.sender;
50         require(keccak256(abi.encodePacked(_customerAddress)) == comm2_);
51         _;
52     }
53 
54     modifier checkRoundStatus()
55     {
56       if(now >= rounds_[currentRoundID_].endTime)
57       {
58         endCurrentRound();
59         startNextRound();
60       }
61       _;
62     }
63 
64     function startNextRound()
65       private
66       {
67         currentRoundID_ ++;
68         rounds_[currentRoundID_].roundID = currentRoundID_;
69         rounds_[currentRoundID_].startTime = now;
70         rounds_[currentRoundID_].endTime = now + roundDuration_;
71         rounds_[currentRoundID_].ended = false;
72       }
73 
74       function endCurrentRound()
75         private
76       {
77         Round storage round = rounds_[currentRoundID_];
78         round.ended = true;
79         if(round.netBuySum>0 && round.dividends>0)
80         {
81           round.profitPerShare = round.dividends.mul(magnitude).div(round.netBuySum);
82         }
83       }
84 
85         modifier isActivated() {
86             require(activated_ == true, "its not ready yet.  check ?eta in discord");
87             _;
88         }
89 
90     // ensures that the first tokens in the contract will be equally distributed
91     // meaning, no divine dump will be ever possible
92     // result: healthy longevity.
93     modifier antiEarlyWhale(uint256 _amountOfEthereum){
94         address _customerAddress = msg.sender;
95 
96         // are we still in the vulnerable phase?
97         // if so, enact anti early whale protocol
98         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
99             require(
100                 // is the customer in the ambassador list?
101                 ambassadors_[_customerAddress] == true &&
102 
103                 // does the customer purchase exceed the max ambassador quota?
104                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
105 
106             );
107 
108             // updated the accumulated quota
109             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
110 
111             // execute
112             _;
113         } else {
114             // in case the ether count drops low, the ambassador phase won't reinitiate
115             onlyAmbassadors = false;
116             _;
117         }
118 
119     }
120 
121 
122     /*==============================
123     =            EVENTS            =
124     ==============================*/
125     event onTokenPurchase(
126         address indexed customerAddress,
127         uint256 incomingEthereum,
128         uint256 tokensMinted
129     );
130 
131     event onTokenSell(
132         address indexed customerAddress,
133         uint256 tokensBurned,
134         uint256 ethereumEarned
135     );
136 
137     event onReinvestment(
138         address indexed customerAddress,
139         uint256 ethereumReinvested,
140         uint256 tokensMinted
141     );
142 
143     event onWithdraw(
144         address indexed customerAddress,
145         uint256 ethereumWithdrawn
146     );
147     event onAcquireDividends(
148         address indexed customerAddress,
149         uint256 dividendsAcquired
150     );
151 
152     // ERC20
153     event Transfer(
154         address indexed from,
155         address indexed to,
156         uint256 tokens
157     );
158 
159     event onWithDrawComm(
160       uint8 indexed comm,
161       uint256 ethereumWithdrawn
162     );
163 
164     event onTransferExpiredDividends(
165       address indexed customerAddress,
166       uint256 roundID,
167       uint256 amount
168     );
169     /*=====================================
170     =            Structs                  =
171     =====================================*/
172     struct Round {
173         uint256 roundID;   // Starting from 1, increasing by 1
174         uint256 netBuySum;   // Sum of all userNetBuy which are > 0
175         uint256 endTime;
176         bool ended;
177         uint256 startTime;
178         uint256 profitPerShare;
179         uint256 dividends;
180         mapping(address=>int256) userNetBuy;
181         mapping(address => uint256) payoutsTo;
182         uint256 totalPayouts;
183     }
184 
185     // Rounds recorder
186     mapping(uint256=>Round) public rounds_;
187 
188     // Fees storage accounts
189     uint256 public comm1Balance_;
190     uint256 public comm2Balance_;
191     bytes32 comm1_=0xc0495b4fc42a03a01bdcd5e2f7b89dfd2e077e19f273ff82d33e9ec642fc7a08;
192     bytes32 comm2_=0xa1bb9d7f7e4c2b049c73772f2cab50235f20a685f798970054b74fbc6d411c1e;
193 
194     // Current round ID
195     uint256 public currentRoundID_;
196     uint256 public roundDuration_ = 1 hours;
197     // Is game started?
198     bool public activated_=false;
199 
200     /*=====================================
201     =            CONFIGURABLES            =
202     =====================================*/
203     string public name = "Run Away";
204     string public symbol = "RUN";
205     uint8 constant public decimals = 18;
206     uint8 constant internal dividendFee_ = 10;
207     uint8 constant internal communityFee_ = 50;
208     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
209     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
210     uint256 constant internal magnitude = 2**64;
211 
212     // ambassador program
213     mapping(address => bool) internal ambassadors_;
214     uint256 constant internal ambassadorMaxPurchase_ = 20 ether;
215     uint256 constant internal ambassadorQuota_ = 120 ether;
216 
217    /*================================
218     =            DATASETS            =
219     ================================*/
220     // amount of shares for each address (scaled number)
221     mapping(address => uint256) internal tokenBalanceLedger_;
222     // Income, including dividends in each round and sale income.
223     mapping(address => uint256) public income_;
224     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
225     uint256 internal tokenSupply_ = 0;
226 
227     // administrator list (see above on what they can do)
228     mapping(bytes32 => bool) public administrators;
229 
230     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
231     bool public onlyAmbassadors = true;
232 
233 
234 
235     /*=======================================
236     =            PUBLIC FUNCTIONS            =
237     =======================================*/
238     /*
239     * -- APPLICATION ENTRY POINTS --
240     */
241     constructor()
242         public
243     {
244         // add administrators here
245         administrators[0x2a94d36a11c723ddffd4bf9352609aed9b400b2be1e9b272421fa7b4e7a40560] = true;
246 
247         // add the ambassadors here.
248         ambassadors_[0x16F2971f677DDCe04FC44bb1A5289f0B96053b2C] = true;
249         ambassadors_[0x579F9608b1fa6aA387BD2a3844469CA8fb10628c] = true;
250         ambassadors_[0x62E691c598D968633EEAB5588b1AF95725E33316] = true;
251         ambassadors_[0x9e3F432dc2CD4EfFB0F0EB060b07DC2dFc574d0D] = true;
252         ambassadors_[0x63735870e79A653aA445d7b7B59DC9c1a7149F39] = true;
253         ambassadors_[0x562DEd82A67f4d2ED3782181f938f2E4232aE02C] = true;
254         ambassadors_[0x22ec2994d77E3Ca929eAc83dEF3958CC547ff028] = true;
255         ambassadors_[0xF2e602645AC91727D75E66231d06F572E133E59F] = true;
256         ambassadors_[0x1AA16F9A2428ceBa2eDeb5D544b3a3D767c1566e] = true;
257         ambassadors_[0x273b270F0eA966a462feAC89C9d4f4D6Dcd1CbdF] = true;
258         ambassadors_[0x7ABe6948E5288a30026EdE239446a0B84d502184] = true;
259         ambassadors_[0xB6Aa76e55564D9dB18cAF61369ff4618F5287f43] = true;
260         ambassadors_[0x3c6c909dB011Af05Dadd706D88a6Cd03D87a4f86] = true;
261         ambassadors_[0x914132fe8075aF2d932cadAa7d603DDfDf70D353] = true;
262         ambassadors_[0x8Be6Aa12746e84e448a18B20013F3AdB9e24e1c6] = true;
263         ambassadors_[0x3595bA9Ab527101B5cc78195Ca043653d96fEEB6] = true;
264         ambassadors_[0x17dBe44d9c91d2c71E33E3fd239BD1574A7f46DF] = true;
265         ambassadors_[0x47Ce514A4392304D9Ccaa7A807776AcB391198D0] = true;
266         ambassadors_[0x96b41F6DE1d579ea5CB87bA04834368727B993e4] = true;
267         ambassadors_[0x0953800A059a9d30BD6E47Ae2D34f3665F8E2b53] = true;
268         ambassadors_[0x497C85EeF12A17D3fEd3aef894ec3273046FdC1D] = true;
269         ambassadors_[0x116febf80104677019ac4C9E693c63c19B26Cf86] = true;
270         ambassadors_[0xFb214AA761CcC1Ccc9D2134a33f4aC77c514d59c] = true;
271         ambassadors_[0x567e3616dE1b217d6004cbE9a84095Ce90E94Bfd] = true;
272         ambassadors_[0x3f054BF8C392F4F28a9B29f911503c6BC58ED4Da] = true;
273         ambassadors_[0x71F658079CaEEDf2270F37c6235D0Ac6B25c9849] = true;
274         ambassadors_[0x0581d2d23A300327678E4497d84d58FF64B9CfDe] = true;
275         ambassadors_[0xFFAE7193dFA6eBff817C47cd2e5Ce4497c082613] = true;
276 
277         ambassadors_[0x18B0f4F11Cb1F2170a6AC594b2Cb0107e2B44821] = true;
278         ambassadors_[0x081c65ff7328ac4cC173D3dA7fD02371760B0cF4] = true;
279         ambassadors_[0xfa698b3242A3a48AadbC64F50dc96e1DE630F39A] = true;
280         ambassadors_[0xAA5BA7930A1B2c14CDad11bECA86bf43779C05c5] = true;
281         ambassadors_[0xa7bF8FF736532f6725c5433190E0852DD1592213] = true;
282 
283 
284     }
285 
286     /**
287      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
288      */
289     function buy()
290         public
291         payable
292         returns(uint256)
293     {
294         purchaseTokens(msg.value);
295     }
296 
297     /**
298      * Fallback function to handle ethereum that was send straight to the contract
299      * Unfortunately we cannot use a referral address this way.
300      */
301     function()
302         payable
303         public
304     {
305         purchaseTokens(msg.value);
306     }
307 
308     /**
309      * Converts all of caller's dividends to tokens.
310      */
311     function reinvest()
312         isActivated()
313         onlyHuman()
314         checkRoundStatus()
315         public
316     {
317         address _customerAddress = msg.sender;
318         uint256 incomeTmp = income_[_customerAddress];
319         //clear income of this user
320         income_[_customerAddress] = 0;
321         uint256 _tokens = purchaseTokens(incomeTmp);
322         // fire event
323         emit onReinvestment(_customerAddress, incomeTmp, _tokens);
324     }
325 
326     /**
327      * Alias of sell(), acquireDividends() and withdraw().
328      */
329     function exit()
330         isActivated()
331         onlyHuman()
332         checkRoundStatus()
333         public
334     {
335         // get token count for caller & sell them all
336         address _customerAddress = msg.sender;
337         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
338         if(_tokens > 0) sell(_tokens);
339         acquireDividends();
340         // lambo delivery service
341         withdraw();
342     }
343 
344     /**
345      * Withdraws all of the caller's dividends in previous round.
346      */
347     function acquireDividends()
348         isActivated()
349         onlyHuman()
350         checkRoundStatus()
351         public
352     {
353         // setup data
354         address _customerAddress = msg.sender;
355         Round storage round = rounds_[currentRoundID_.sub(1)];
356         uint256 _dividends = myDividends(round.roundID); // get ref. bonus later in the code
357 
358         // update dividend tracker
359         round.payoutsTo[_customerAddress] = round.payoutsTo[_customerAddress].add(_dividends);
360         round.totalPayouts = round.totalPayouts.add(_dividends);
361 
362         // Add dividends to income.
363         income_[_customerAddress] = income_[_customerAddress].add(_dividends);
364 
365         // fire event
366         emit onAcquireDividends(_customerAddress, _dividends);
367     }
368 
369     /**
370      * Withdraws all of the caller's income.
371      */
372     function withdraw()
373         isActivated()
374         onlyHuman()
375         checkRoundStatus()
376         public
377     {
378         address _customerAddress = msg.sender;
379         uint256 myIncome = income_[_customerAddress];
380         //clear value
381         income_[_customerAddress]=0;
382         _customerAddress.transfer(myIncome);
383         // fire event
384         emit onWithdraw(_customerAddress, myIncome);
385     }
386 
387     /**
388      * Tax dividends to community.
389     */
390     function taxDividends(uint256 _dividends)
391       internal
392       returns (uint256)
393     {
394       // Taxed dividends
395       uint256 _comm = _dividends.div(communityFee_);
396       uint256 _taxedDividends = _dividends.sub(_comm);
397       // Community fees
398       uint256 _comm_1 = _comm.mul(3).div(10);
399       comm1Balance_ = comm1Balance_.add(_comm_1);
400       comm2Balance_ = comm2Balance_.add(_comm.sub(_comm_1));
401       return _taxedDividends;
402     }
403 
404     /**
405      * Liquifies tokens to ethereum.
406      */
407     function sell(uint256 _amountOfTokens)
408         isActivated()
409         onlyHuman()
410         onlyBagholders()
411         checkRoundStatus()
412         public
413     {
414         require(_amountOfTokens > 0, "Selling 0 token!");
415 
416         Round storage round = rounds_[currentRoundID_];
417         // setup data
418         address _customerAddress = msg.sender;
419         // russian hackers BTFO
420         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
421         uint256 _tokens = _amountOfTokens;
422         uint256 _ethereum = tokensToEthereum_(_tokens);
423         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
424         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
425 
426         // Record income
427         income_[_customerAddress] = income_[_customerAddress].add(_taxedEthereum);
428 
429         // Taxed dividends
430         uint256 _taxedDividends = taxDividends(_dividends);
431         round.dividends = round.dividends.add(_taxedDividends);
432 
433         // burn the sold tokens
434         tokenSupply_ = tokenSupply_.sub(_tokens);
435         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].sub(_tokens);
436 
437         // Calculate net buy of current round
438         int256 _userNetBuyBeforeSale = round.userNetBuy[_customerAddress];
439         round.userNetBuy[_customerAddress] = _userNetBuyBeforeSale.sub(_tokens.toInt256Safe());
440         if( _userNetBuyBeforeSale > 0)
441         {
442           if(_userNetBuyBeforeSale.toUint256Safe() > _tokens)
443           {
444             round.netBuySum = round.netBuySum.sub(_tokens);
445           }
446           else
447           {
448             round.netBuySum = round.netBuySum.sub(_userNetBuyBeforeSale.toUint256Safe());
449           }
450         }
451 
452         // fire event
453         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
454     }
455 
456 
457     /**
458      * Transfer tokens from the caller to a new holder.
459      * Remember, there's a 10% fee here as well.
460      */
461     function transfer(address _toAddress, uint256 _amountOfTokens)
462         isActivated()
463         onlyHuman()
464         checkRoundStatus()
465         onlyBagholders()
466         public
467         returns(bool)
468     {
469         // setup
470         address _customerAddress = msg.sender;
471 
472         // make sure we have the requested tokens
473         // also disables transfers until ambassador phase is over
474         // ( we dont want whale premines )
475         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
476 
477         // liquify 10% of the tokens that are transfered
478         // these are dispersed to shareholders
479         uint256 _tokenFee = _amountOfTokens.div(dividendFee_);
480         uint256 _taxedTokens = _amountOfTokens.sub(_tokenFee);
481         uint256 _dividends = tokensToEthereum_(_tokenFee);
482 
483 
484         // Taxed dividends
485         uint256 _taxedDividends = taxDividends(_dividends);
486         rounds_[currentRoundID_].dividends = rounds_[currentRoundID_].dividends.add(_taxedDividends);
487 
488         // burn the fee tokens
489         tokenSupply_ = tokenSupply_.sub(_tokenFee);
490 
491         // exchange tokens
492         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].sub(_amountOfTokens);
493         tokenBalanceLedger_[_toAddress] = tokenBalanceLedger_[_toAddress].add(_taxedTokens);
494 
495         // fire event
496         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
497 
498         // ERC20
499         return true;
500 
501     }
502 
503     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
504     /**
505      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
506      */
507     function disableInitialStage()
508         onlyAdministrator()
509         public
510     {
511         onlyAmbassadors = false;
512     }
513 
514     /**
515      * In case one of us dies, we need to replace ourselves.
516      */
517     function setAdministrator(bytes32 _identifier, bool _status)
518         onlyAdministrator()
519         public
520     {
521         administrators[_identifier] = _status;
522     }
523 
524     /**
525      * If we want to rebrand, we can.
526      */
527     function setName(string _name)
528         onlyAdministrator()
529         public
530     {
531         name = _name;
532     }
533 
534     /**
535      * If we want to rebrand, we can.
536      */
537     function setSymbol(string _symbol)
538         onlyAdministrator()
539         public
540     {
541         symbol = _symbol;
542     }
543 
544     /**
545       Start this game.
546     */
547     function activate()
548       onlyAdministrator()
549       public
550     {
551       // can only be ran once
552       require(activated_ == false, "Already activated");
553 
554       currentRoundID_ = 1;
555       rounds_[currentRoundID_].roundID = currentRoundID_;
556       rounds_[currentRoundID_].startTime = now;
557       rounds_[currentRoundID_].endTime = now + roundDuration_;
558 
559       activated_ = true;
560     }
561 
562     /*----------  HELPERS AND CALCULATORS  ----------*/
563     /**
564      * Method to view the current Ethereum stored in the contract
565      * Example: totalEthereumBalance()
566      */
567     function totalEthereumBalance()
568         public
569         view
570         returns(uint)
571     {
572         return address(this).balance;
573     }
574 
575     /**
576      * Retrieve the total token supply.
577      */
578     function totalSupply()
579         public
580         view
581         returns(uint256)
582     {
583         return tokenSupply_;
584     }
585 
586     /**
587      * Retrieve the tokens owned by the caller.
588      */
589     function myTokens()
590         public
591         view
592         returns(uint256)
593     {
594         address _customerAddress = msg.sender;
595         return balanceOf(_customerAddress);
596     }
597 
598     /**
599      * Retrieve the dividends owned by the caller.
600      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
601      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
602      * But in the internal calculations, we want them separate.
603      */
604     function myDividends(uint256 _roundID)
605         public
606         view
607         returns(uint256)
608     {
609         return dividendsOf(msg.sender, _roundID);
610     }
611 
612     /**
613      * Retrieve the token balance of any single address.
614      */
615     function balanceOf(address _customerAddress)
616         view
617         public
618         returns(uint256)
619     {
620         return tokenBalanceLedger_[_customerAddress];
621     }
622 
623     /**
624      * Retrieve the dividend balance of any single address.
625      */
626     function dividendsOf(address _customerAddress, uint256 _roundID)
627         view
628         public
629         returns(uint256)
630     {
631       if(_roundID<1) return 0;
632       if (_roundID > currentRoundID_) return 0;
633       Round storage round = rounds_[_roundID];
634       // Sold >= bought
635       if(round.userNetBuy[_customerAddress] <= 0)
636       {
637         return 0;
638       }
639 
640       // Nobody sold.
641       if(round.dividends <= 0)
642       {
643         return 0;
644       }
645       return round.profitPerShare.mul(round.userNetBuy[_customerAddress].toUint256Safe()).div(magnitude).sub(round.payoutsTo[_customerAddress]);
646     }
647 
648     /**
649      * Estimate user dividends in current round.
650     */
651     function estimateDividends(address _customerAddress)
652         view
653         public
654         returns(uint256)
655     {
656       Round storage round = rounds_[currentRoundID_];
657       // Sold >= bought
658       if(round.userNetBuy[_customerAddress] <= 0)
659       {
660         return 0;
661       }
662 
663       // Nobody sold.
664       if(round.dividends <= 0)
665       {
666         return 0;
667       }
668 
669       return round.dividends.mul(magnitude).div(round.netBuySum).mul(round.userNetBuy[_customerAddress].toUint256Safe()).div(magnitude);
670     }
671 
672     /**
673      * Return the buy price of 1 individual token.
674      */
675     function sellPrice()
676         public
677         view
678         returns(uint256)
679     {
680         // our calculation relies on the token supply, so we need supply. Doh.
681         if(tokenSupply_ == 0){
682             return tokenPriceInitial_ - tokenPriceIncremental_;
683         } else {
684             uint256 _ethereum = tokensToEthereum_(1e18);
685             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
686             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
687             return _taxedEthereum;
688         }
689     }
690 
691     /**
692      * Return the sell price of 1 individual token.
693      */
694     function buyPrice()
695         public
696         view
697         returns(uint256)
698     {
699         // our calculation relies on the token supply, so we need supply. Doh.
700         if(tokenSupply_ == 0){
701             return tokenPriceInitial_ + tokenPriceIncremental_;
702         } else {
703             uint256 _ethereum = tokensToEthereum_(1e18);
704             return _ethereum;
705         }
706     }
707 
708     /**
709      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
710      */
711     function calculateTokensReceived(uint256 _ethereumToSpend)
712         public
713         view
714         returns(uint256)
715     {
716         uint256 _amountOfTokens = ethereumToTokens_(_ethereumToSpend);
717         return _amountOfTokens;
718     }
719 
720     /**
721      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
722      */
723     function calculateEthereumReceived(uint256 _tokensToSell)
724         public
725         view
726         returns(uint256)
727     {
728         require(_tokensToSell <= tokenSupply_);
729         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
730         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
731         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
732         return _taxedEthereum;
733     }
734 
735     function roundNetBuySum(uint256 _roundID)
736       public view returns(uint256)
737     {
738         if(_roundID <1 || _roundID > currentRoundID_) return 0;
739         return rounds_[_roundID].netBuySum;
740     }
741 
742     function roundEndTime(uint256 _roundID)
743       public view returns(uint256)
744     {
745       if(_roundID <1 || _roundID > currentRoundID_) return 0;
746       return rounds_[_roundID].endTime;
747     }
748     function roundEnded(uint256 _roundID)
749       public view returns(bool)
750     {
751       if(_roundID <1 || _roundID > currentRoundID_) return true;
752       return rounds_[_roundID].ended;
753     }
754 
755     function roundStartTime(uint256 _roundID)
756       public view returns(uint256)
757     {
758       if(_roundID <1 || _roundID > currentRoundID_) return 0;
759       return rounds_[_roundID].startTime;
760     }
761 
762     function roundProfitPerShare(uint256 _roundID)
763       public view returns(uint256)
764     {
765       if(_roundID <1 || _roundID > currentRoundID_) return 0;
766       return rounds_[_roundID].profitPerShare;
767     }
768     function roundDividends(uint256 _roundID)
769       public view returns(uint256)
770     {
771       if(_roundID <1 || _roundID > currentRoundID_) return 0;
772       return rounds_[_roundID].dividends;
773     }
774 
775     function roundUserNetBuy(uint256 _roundID, address addr)
776       public view returns(int256)
777     {
778       if(_roundID <1 || _roundID > currentRoundID_) return 0;
779       return rounds_[_roundID].userNetBuy[addr];
780     }
781 
782     function roundPayoutsTo(uint256 _roundID, address addr)
783       public view returns(uint256)
784     {
785       if(_roundID <1 || _roundID > currentRoundID_) return 0;
786       return rounds_[_roundID].payoutsTo[addr];
787     }
788     function roundTotalPayouts(uint256 _roundID)
789       public view returns(uint256)
790     {
791       if(_roundID <1 || _roundID > currentRoundID_) return 0;
792       return rounds_[_roundID].totalPayouts;
793     }
794 
795     /*==========================================
796     =            INTERNAL FUNCTIONS            =
797     ==========================================*/
798     function purchaseTokens(uint256 _incomingEthereum)
799         isActivated()
800         antiEarlyWhale(_incomingEthereum)
801         onlyHuman()
802         checkRoundStatus()
803         internal
804         returns(uint256)
805     {
806         require(_incomingEthereum > 0, "0 eth buying.");
807         Round storage round = rounds_[currentRoundID_];
808         // data setup
809         address _customerAddress = msg.sender;
810         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum);
811 
812         // no point in continuing execution if OP is a poorfag russian hacker
813         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
814         // (or hackers)
815         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
816         require(_amountOfTokens > 0 && (tokenSupply_.add(_amountOfTokens) > tokenSupply_));
817 
818         // we can't give people infinite ethereum
819         if(tokenSupply_ > 0){
820             // add tokens to the pool
821             tokenSupply_ = tokenSupply_.add(_amountOfTokens);
822         } else {
823             // add tokens to the pool
824             tokenSupply_ = _amountOfTokens;
825         }
826 
827         int256 _userNetBuy = round.userNetBuy[_customerAddress];
828         int256 _userNetBuyAfterPurchase = _userNetBuy.add(_amountOfTokens.toInt256Safe());
829         round.userNetBuy[_customerAddress] = _userNetBuyAfterPurchase;
830         if(_userNetBuy >= 0)
831         {
832           round.netBuySum = round.netBuySum.add(_amountOfTokens);
833         }
834         else
835         {
836           if( _userNetBuyAfterPurchase > 0)
837           {
838             round.netBuySum = round.netBuySum.add(_userNetBuyAfterPurchase.toUint256Safe());
839           }
840         }
841 
842         // update circulating supply & the ledger address for the customer
843         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].add(_amountOfTokens);
844 
845         // fire event
846         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens);
847 
848         return _amountOfTokens;
849     }
850 
851     /**
852      * Calculate Token price based on an amount of incoming ethereum
853      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
854      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
855      */
856     function ethereumToTokens_(uint256 _ethereum)
857         internal
858         view
859         returns(uint256)
860     {
861         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
862         uint256 _tokensReceived =
863          (
864             (
865                 // underflow attempts BTFO
866                 SafeMath.sub(
867                     (sqrt
868                         (
869                             (_tokenPriceInitial**2)
870                             +
871                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
872                             +
873                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
874                             +
875                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
876                         )
877                     ), _tokenPriceInitial
878                 )
879             )/(tokenPriceIncremental_)
880         )-(tokenSupply_)
881         ;
882 
883         return _tokensReceived;
884     }
885 
886     /**
887      * Calculate token sell value.
888      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
889      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
890      */
891      function tokensToEthereum_(uint256 _tokens)
892         internal
893         view
894         returns(uint256)
895     {
896 
897         uint256 tokens_ = (_tokens + 1e18);
898         uint256 _tokenSupply = (tokenSupply_ + 1e18);
899         uint256 _etherReceived =
900         (
901             // underflow attempts BTFO
902             SafeMath.sub(
903                 (
904                     (
905                         (
906                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
907                         )-tokenPriceIncremental_
908                     )*(tokens_ - 1e18)
909                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
910             )
911         /1e18);
912         return _etherReceived;
913     }
914 
915     /*==========================================
916     =           COMMUNITY FUNCTIONS            =
917     ==========================================*/
918     function withdrawComm1()
919       isActivated()
920       onlyComm1()
921       onlyHuman()
922       checkRoundStatus()
923       public
924     {
925       uint256 bal = comm1Balance_;
926       comm1Balance_ = 0;
927       msg.sender.transfer(bal);
928       emit onWithDrawComm(1, bal);
929     }
930 
931     function withdrawComm2()
932       isActivated()
933       onlyComm2()
934       onlyHuman()
935       checkRoundStatus()
936       public
937     {
938       uint256 bal = comm2Balance_;
939       comm2Balance_ = 0;
940       msg.sender.transfer(bal);
941       emit onWithDrawComm(2, bal);
942     }
943 
944     function transferExpiredDividends(uint256 _roundID)
945       isActivated()
946       onlyHuman()
947       checkRoundStatus()
948       public
949     {
950       require(_roundID > 0 && _roundID < currentRoundID_.sub(1), "Invalid round number");
951       Round storage round = rounds_[_roundID];
952       uint256 _unpaid = round.dividends.sub(round.totalPayouts);
953       require(_unpaid>0, "No expired dividends.");
954       uint256 comm1 = _unpaid.mul(3).div(10);
955       comm1Balance_ = comm1Balance_.add(comm1);
956       comm2Balance_ = comm2Balance_.add(_unpaid.sub(comm1));
957       round.totalPayouts = round.totalPayouts.add(_unpaid);
958       emit onTransferExpiredDividends(msg.sender, _roundID, _unpaid);
959     }
960 
961     //This is where all your gas goes, sorry
962     //Not sorry, you probably only paid 1 gwei
963     function sqrt(uint x) internal pure returns (uint y) {
964         uint z = (x + 1) / 2;
965         y = x;
966         while (z < y) {
967             y = z;
968             z = (x / z + z) / 2;
969         }
970     }
971 
972 }
973 
974 // From https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMath.sol
975 /**
976  * @title SafeMath
977  * @dev Math operations with safety checks that throw on error
978  */
979 library SafeMath {
980   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
981     uint256 c = a * b;
982 
983     assert(a == 0 || c / a == b);
984     return c;
985   }
986 
987   function div(uint256 a, uint256 b) internal pure returns (uint256) {
988     // assert(b > 0); // Solidity automatically throws when dividing by 0
989     uint256 c = a / b;
990     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
991     return c;
992   }
993 
994   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
995     assert(b <= a);
996     return a - b;
997   }
998 
999   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1000     uint256 c = a + b;
1001     assert(c >= a);
1002     return c;
1003   }
1004 
1005   function toInt256Safe(uint256 a) internal pure returns (int256) {
1006     int256 b = int256(a);
1007     assert(b >= 0);
1008     return b;
1009   }
1010 }
1011 
1012 // From: https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
1013 /**
1014  * @title SafeMathInt
1015  * @dev Math operations with safety checks that throw on error
1016  * @dev SafeMath adapted for int256
1017  */
1018 library SafeMathInt {
1019   function mul(int256 a, int256 b) internal pure returns (int256) {
1020     // Prevent overflow when multiplying INT256_MIN with -1
1021     // https://github.com/RequestNetwork/requestNetwork/issues/43
1022     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
1023 
1024     int256 c = a * b;
1025     assert((b == 0) || (c / b == a));
1026     return c;
1027   }
1028 
1029   function div(int256 a, int256 b) internal pure returns (int256) {
1030     // Prevent overflow when dividing INT256_MIN by -1
1031     // https://github.com/RequestNetwork/requestNetwork/issues/43
1032     assert(!(a == - 2**255 && b == -1));
1033 
1034     // assert(b > 0); // Solidity automatically throws when dividing by 0
1035     int256 c = a / b;
1036     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1037     return c;
1038   }
1039 
1040   function sub(int256 a, int256 b) internal pure returns (int256) {
1041     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
1042 
1043     return a - b;
1044   }
1045 
1046   function add(int256 a, int256 b) internal pure returns (int256) {
1047     int256 c = a + b;
1048     assert((b >= 0 && c >= a) || (b < 0 && c < a));
1049     return c;
1050   }
1051 
1052   function toUint256Safe(int256 a) internal pure returns (uint256) {
1053     assert(a>=0);
1054     return uint256(a);
1055   }
1056 }