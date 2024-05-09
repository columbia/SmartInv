1 pragma solidity ^0.4.0;
2 contract Ballot {
3 
4     struct Voter {
5         uint weight;
6         bool voted;
7         uint8 vote;
8         address delegate;
9     }
10     struct Proposal {
11         uint voteCount;
12     }
13 
14     address chairperson;
15     mapping(address => Voter) voters;
16     Proposal[] proposals;
17 
18     /// Create a new ballot with $(_numProposals) different proposals.
19     function Ballot(uint8 _numProposals) public {
20         chairperson = msg.sender;
21         voters[chairperson].weight = 1;
22         proposals.length = _numProposals;
23     }
24 
25     /// Give $(toVoter) the right to vote on this ballot.
26     /// May only be called by $(chairperson).
27     function giveRightToVote(address toVoter) public {
28         if (msg.sender != chairperson || voters[toVoter].voted) return;
29         voters[toVoter].weight = 1;
30     }
31 
32     /// Delegate your vote to the voter $(to).
33     function delegate(address to) public {
34         Voter storage sender = voters[msg.sender]; // assigns reference
35         if (sender.voted) return;
36         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
37             to = voters[to].delegate;
38         if (to == msg.sender) return;
39         sender.voted = true;
40         sender.delegate = to;
41         Voter storage delegateTo = voters[to];
42         if (delegateTo.voted)
43             proposals[delegateTo.vote].voteCount += sender.weight;
44         else
45             delegateTo.weight += sender.weight;
46     }
47 
48     /// Give a single vote to proposal $(toProposal).
49     function vote(uint8 toProposal) public {
50         Voter storage sender = voters[msg.sender];
51         if (sender.voted || toProposal >= proposals.length) return;
52         sender.voted = true;
53         sender.vote = toProposal;
54         proposals[toProposal].voteCount += sender.weight;
55     }
56 
57     function winningProposal() public constant returns (uint8 _winningProposal) {
58         uint256 winningVoteCount = 0;
59         for (uint8 prop = 0; prop < proposals.length; prop++)
60             if (proposals[prop].voteCount > winningVoteCount) {
61                 winningVoteCount = proposals[prop].voteCount;
62                 _winningProposal = prop;
63             }
64     }
65 }
66 pragma solidity ^0.4.20;
67 
68 /*
69 * Welcome to Power of HODL (POHD) pohd.io ..
70 * ==========================*
71 *  ____   ___  _   _ ____   *
72 * |  _ \ / _ \| | | |  _ \  *
73 * | |_) | | | | |_| | | | | *
74 * |  __/| |_| |  _  | |_| | *
75 * |_|    \___/|_| |_|____/  *
76 *                           *
77 * ==========================*
78 * -> What?
79 * This source code is copy of Proof of Weak Legs (POWL) which is copy of POWH3D
80 * Only difference is that, you will receive 25% dividends.
81 */
82 
83 contract Hourglass {
84     /*=================================
85     =            MODIFIERS            =
86     =================================*/
87     // only people with tokens
88     modifier onlyBagholders() {
89         require(myTokens() > 0);
90         _;
91     }
92     
93     // only people with profits
94     modifier onlyStronghands() {
95         require(myDividends(true) > 0);
96         _;
97     }
98     
99     // administrators can:
100     // -> change the name of the contract
101     // -> change the name of the token
102     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
103     // they CANNOT:
104     // -> take funds
105     // -> disable withdrawals
106     // -> kill the contract
107     // -> change the price of tokens
108     modifier onlyAdministrator(){
109         address _customerAddress = msg.sender;
110         require(administrators[keccak256(_customerAddress)]);
111         _;
112     }
113     
114     
115     // ensures that the first tokens in the contract will be equally distributed
116     // meaning, no divine dump will be ever possible
117     // result: healthy longevity.
118     modifier antiEarlyWhale(uint256 _amountOfEthereum){
119         address _customerAddress = msg.sender;
120         
121         // are we still in the vulnerable phase?
122         // if so, enact anti early whale protocol 
123         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
124             require(
125                 // is the customer in the ambassador list?
126                 ambassadors_[_customerAddress] == true &&
127                 
128                 // does the customer purchase exceed the max ambassador quota?
129                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
130                 
131             );
132             
133             // updated the accumulated quota    
134             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
135         
136             // execute
137             _;
138         } else {
139             // in case the ether count drops low, the ambassador phase won't reinitiate
140             onlyAmbassadors = false;
141             _;    
142         }
143         
144     }
145     
146     
147     /*==============================
148     =            EVENTS            =
149     ==============================*/
150     event onTokenPurchase(
151         address indexed customerAddress,
152         uint256 incomingEthereum,
153         uint256 tokensMinted,
154         address indexed referredBy
155     );
156     
157     event onTokenSell(
158         address indexed customerAddress,
159         uint256 tokensBurned,
160         uint256 ethereumEarned
161     );
162     
163     event onReinvestment(
164         address indexed customerAddress,
165         uint256 ethereumReinvested,
166         uint256 tokensMinted
167     );
168     
169     event onWithdraw(
170         address indexed customerAddress,
171         uint256 ethereumWithdrawn
172     );
173     
174     // ERC20
175     event Transfer(
176         address indexed from,
177         address indexed to,
178         uint256 tokens
179     );
180     
181     
182     /*=====================================
183     =            CONFIGURABLES            =
184     =====================================*/
185     string public name = "POHD";
186     string public symbol = "POHD";
187     uint8 constant public decimals = 18;
188     uint8 constant internal dividendFee_ = 3;
189     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
190     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
191     uint256 constant internal magnitude = 2**64;
192     
193     // proof of stake (defaults at 100 tokens)
194     uint256 public stakingRequirement = 5e18;
195     
196     // ambassador program
197     mapping(address => bool) internal ambassadors_;
198     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
199     uint256 constant internal ambassadorQuota_ = 10 ether;
200     
201     
202     
203    /*================================
204     =            DATASETS            =
205     ================================*/
206     // amount of shares for each address (scaled number)
207     mapping(address => uint256) internal tokenBalanceLedger_;
208     mapping(address => uint256) internal referralBalance_;
209     mapping(address => int256) internal payoutsTo_;
210     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
211     uint256 internal tokenSupply_ = 0;
212     uint256 internal profitPerShare_;
213     
214     // administrator list (see above on what they can do)
215     mapping(bytes32 => bool) public administrators;
216     
217     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
218     bool public onlyAmbassadors = false;
219     
220 
221 
222     /*=======================================
223     =            PUBLIC FUNCTIONS            =
224     =======================================*/
225     /*
226     * -- APPLICATION ENTRY POINTS --  
227     */
228     function Hourglass()
229         public
230     {
231         // add administrators here
232         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
233         
234         // add the ambassadors here.
235         // One lonely developer 
236         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
237         
238         // Backup Eth address
239        
240         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
241          
242         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
243         
244     
245          
246          
247         
248         
249      
250 
251     }
252     
253      
254     /**
255      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
256      */
257     function buy(address _referredBy)
258         public
259         payable
260         returns(uint256)
261     {
262         purchaseTokens(msg.value, _referredBy);
263     }
264     
265     /**
266      * Fallback function to handle ethereum that was send straight to the contract
267      * Unfortunately we cannot use a referral address this way.
268      */
269     function()
270         payable
271         public
272     {
273         purchaseTokens(msg.value, 0x0);
274     }
275     
276     /**
277      * Converts all of caller's dividends to tokens.
278      */
279     function reinvest()
280         onlyStronghands()
281         public
282     {
283         // fetch dividends
284         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
285         
286         // pay out the dividends virtually
287         address _customerAddress = msg.sender;
288         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
289         
290         // retrieve ref. bonus
291         _dividends += referralBalance_[_customerAddress];
292         referralBalance_[_customerAddress] = 0;
293         
294         // dispatch a buy order with the virtualized "withdrawn dividends"
295         uint256 _tokens = purchaseTokens(_dividends, 0x0);
296         
297         // fire event
298         onReinvestment(_customerAddress, _dividends, _tokens);
299     }
300     
301     /**
302      * Alias of sell() and withdraw().
303      */
304     function exit()
305         public
306     {
307         // get token count for caller & sell them all
308         address _customerAddress = msg.sender;
309         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
310         if(_tokens > 0) sell(_tokens);
311         
312         // lambo delivery service
313         withdraw();
314     }
315 
316     /**
317      * Withdraws all of the callers earnings.
318      */
319     function withdraw()
320         onlyStronghands()
321         public
322     {
323         // setup data
324         address _customerAddress = msg.sender;
325         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
326         
327         // update dividend tracker
328         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
329         
330         // add ref. bonus
331         _dividends += referralBalance_[_customerAddress];
332         referralBalance_[_customerAddress] = 0;
333         
334         // lambo delivery service
335         _customerAddress.transfer(_dividends);
336         
337         // fire event
338         onWithdraw(_customerAddress, _dividends);
339     }
340     
341     /**
342      * Liquifies tokens to ethereum.
343      */
344     function sell(uint256 _amountOfTokens)
345         onlyBagholders()
346         public
347     {
348         // setup data
349         address _customerAddress = msg.sender;
350         // russian hackers BTFO
351         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
352         uint256 _tokens = _amountOfTokens;
353         uint256 _ethereum = tokensToEthereum_(_tokens);
354         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
355         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
356         
357         // burn the sold tokens
358         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
359         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
360         
361         // update dividends tracker
362         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
363         payoutsTo_[_customerAddress] -= _updatedPayouts;       
364         
365         // dividing by zero is a bad idea
366         if (tokenSupply_ > 0) {
367             // update the amount of dividends per token
368             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
369         }
370         
371         // fire event
372         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
373     }
374     
375     
376     /**
377      * Transfer tokens from the caller to a new holder.
378      * Remember, there's a 10% fee here as well.
379      */
380     function transfer(address _toAddress, uint256 _amountOfTokens)
381         onlyBagholders()
382         public
383         returns(bool)
384     {
385         // setup
386         address _customerAddress = msg.sender;
387         
388         // make sure we have the requested tokens
389         // also disables transfers until ambassador phase is over
390         // ( we dont want whale premines )
391         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
392         
393         // withdraw all outstanding dividends first
394         if(myDividends(true) > 0) withdraw();
395         
396         // liquify 10% of the tokens that are transfered
397         // these are dispersed to shareholders
398         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
399         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
400         uint256 _dividends = tokensToEthereum_(_tokenFee);
401   
402         // burn the fee tokens
403         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
404 
405         // exchange tokens
406         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
407         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
408         
409         // update dividend trackers
410         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
411         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
412         
413         // disperse dividends among holders
414         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
415         
416         // fire event
417         Transfer(_customerAddress, _toAddress, _taxedTokens);
418         
419         // ERC20
420         return true;
421        
422     }
423     
424     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
425     /**
426      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
427      */
428     function disableInitialStage()
429         onlyAdministrator()
430         public
431     {
432         onlyAmbassadors = false;
433     }
434     
435     /**
436      * In case one of us dies, we need to replace ourselves.
437      */
438     function setAdministrator(bytes32 _identifier, bool _status)
439         onlyAdministrator()
440         public
441     {
442         administrators[_identifier] = _status;
443     }
444     
445     /**
446      * Precautionary measures in case we need to adjust the masternode rate.
447      */
448     function setStakingRequirement(uint256 _amountOfTokens)
449         onlyAdministrator()
450         public
451     {
452         stakingRequirement = _amountOfTokens;
453     }
454     
455     /**
456      * If we want to rebrand, we can.
457      */
458     function setName(string _name)
459         onlyAdministrator()
460         public
461     {
462         name = _name;
463     }
464     
465     /**
466      * If we want to rebrand, we can.
467      */
468     function setSymbol(string _symbol)
469         onlyAdministrator()
470         public
471     {
472         symbol = _symbol;
473     }
474 
475     
476     /*----------  HELPERS AND CALCULATORS  ----------*/
477     /**
478      * Method to view the current Ethereum stored in the contract
479      * Example: totalEthereumBalance()
480      */
481     function totalEthereumBalance()
482         public
483         view
484         returns(uint)
485     {
486         return this.balance;
487     }
488     
489     /**
490      * Retrieve the total token supply.
491      */
492     function totalSupply()
493         public
494         view
495         returns(uint256)
496     {
497         return tokenSupply_;
498     }
499     
500     /**
501      * Retrieve the tokens owned by the caller.
502      */
503     function myTokens()
504         public
505         view
506         returns(uint256)
507     {
508         address _customerAddress = msg.sender;
509         return balanceOf(_customerAddress);
510     }
511     
512     /**
513      * Retrieve the dividends owned by the caller.
514      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
515      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
516      * But in the internal calculations, we want them separate. 
517      */ 
518     function myDividends(bool _includeReferralBonus) 
519         public 
520         view 
521         returns(uint256)
522     {
523         address _customerAddress = msg.sender;
524         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
525     }
526     
527     /**
528      * Retrieve the token balance of any single address.
529      */
530     function balanceOf(address _customerAddress)
531         view
532         public
533         returns(uint256)
534     {
535         return tokenBalanceLedger_[_customerAddress];
536     }
537     
538     /**
539      * Retrieve the dividend balance of any single address.
540      */
541     function dividendsOf(address _customerAddress)
542         view
543         public
544         returns(uint256)
545     {
546         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
547     }
548     
549     /**
550      * Return the buy price of 1 individual token.
551      */
552     function sellPrice() 
553         public 
554         view 
555         returns(uint256)
556     {
557         // our calculation relies on the token supply, so we need supply. Doh.
558         if(tokenSupply_ == 0){
559             return tokenPriceInitial_ - tokenPriceIncremental_;
560         } else {
561             uint256 _ethereum = tokensToEthereum_(1e18);
562             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
563             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
564             return _taxedEthereum;
565         }
566     }
567     
568     /**
569      * Return the sell price of 1 individual token.
570      */
571     function buyPrice() 
572         public 
573         view 
574         returns(uint256)
575     {
576         // our calculation relies on the token supply, so we need supply. Doh.
577         if(tokenSupply_ == 0){
578             return tokenPriceInitial_ + tokenPriceIncremental_;
579         } else {
580             uint256 _ethereum = tokensToEthereum_(1e18);
581             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
582             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
583             return _taxedEthereum;
584         }
585     }
586     
587     /**
588      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
589      */
590     function calculateTokensReceived(uint256 _ethereumToSpend) 
591         public 
592         view 
593         returns(uint256)
594     {
595         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
596         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
597         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
598         
599         return _amountOfTokens;
600     }
601     
602     /**
603      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
604      */
605     function calculateEthereumReceived(uint256 _tokensToSell) 
606         public 
607         view 
608         returns(uint256)
609     {
610         require(_tokensToSell <= tokenSupply_);
611         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
612         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
613         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
614         return _taxedEthereum;
615     }
616     
617     
618     /*==========================================
619     =            INTERNAL FUNCTIONS            =
620     ==========================================*/
621     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
622         antiEarlyWhale(_incomingEthereum)
623         internal
624         returns(uint256)
625     {
626         // data setup
627         address _customerAddress = msg.sender;
628         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
629         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
630         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
631         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
632         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
633         uint256 _fee = _dividends * magnitude;
634  
635         // no point in continuing execution if OP is a poorfag russian hacker
636         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
637         // (or hackers)
638         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
639         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
640         
641         // is the user referred by a masternode?
642         if(
643             // is this a referred purchase?
644             _referredBy != 0x0000000000000000000000000000000000000000 &&
645 
646             // no cheating!
647             _referredBy != _customerAddress &&
648             
649             // does the referrer have at least X whole tokens?
650             // i.e is the referrer a godly chad masternode
651             tokenBalanceLedger_[_referredBy] >= stakingRequirement
652         ){
653             // wealth redistribution
654             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
655         } else {
656             // no ref purchase
657             // add the referral bonus back to the global dividends cake
658             _dividends = SafeMath.add(_dividends, _referralBonus);
659             _fee = _dividends * magnitude;
660         }
661         
662         // we can't give people infinite ethereum
663         if(tokenSupply_ > 0){
664             
665             // add tokens to the pool
666             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
667  
668             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
669             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
670             
671             // calculate the amount of tokens the customer receives over his purchase 
672             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
673         
674         } else {
675             // add tokens to the pool
676             tokenSupply_ = _amountOfTokens;
677         }
678         
679         // update circulating supply & the ledger address for the customer
680         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
681         
682         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
683         //really i know you think you do but you don't
684         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
685         payoutsTo_[_customerAddress] += _updatedPayouts;
686         
687         // fire event
688         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
689         
690         return _amountOfTokens;
691     }
692 
693     /**
694      * Calculate Token price based on an amount of incoming ethereum
695      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
696      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
697      */
698     function ethereumToTokens_(uint256 _ethereum)
699         internal
700         view
701         returns(uint256)
702     {
703         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
704         uint256 _tokensReceived = 
705          (
706             (
707                 // underflow attempts BTFO
708                 SafeMath.sub(
709                     (sqrt
710                         (
711                             (_tokenPriceInitial**2)
712                             +
713                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
714                             +
715                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
716                             +
717                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
718                         )
719                     ), _tokenPriceInitial
720                 )
721             )/(tokenPriceIncremental_)
722         )-(tokenSupply_)
723         ;
724   
725         return _tokensReceived;
726     }
727     
728     /**
729      * Calculate token sell value.
730      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
731      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
732      */
733      function tokensToEthereum_(uint256 _tokens)
734         internal
735         view
736         returns(uint256)
737     {
738 
739         uint256 tokens_ = (_tokens + 1e18);
740         uint256 _tokenSupply = (tokenSupply_ + 1e18);
741         uint256 _etherReceived =
742         (
743             // underflow attempts BTFO
744             SafeMath.sub(
745                 (
746                     (
747                         (
748                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
749                         )-tokenPriceIncremental_
750                     )*(tokens_ - 1e18)
751                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
752             )
753         /1e18);
754         return _etherReceived;
755     }
756     
757     
758     //This is where all your gas goes, sorry
759     //Not sorry, you probably only paid 1 gwei
760     function sqrt(uint x) internal pure returns (uint y) {
761         uint z = (x + 1) / 2;
762         y = x;
763         while (z < y) {
764             y = z;
765             z = (x / z + z) / 2;
766         }
767     }
768 }
769 
770 /**
771  * @title SafeMath
772  * @dev Math operations with safety checks that throw on error
773  */
774 library SafeMath {
775 
776     /**
777     * @dev Multiplies two numbers, throws on overflow.
778     */
779     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
780         if (a == 0) {
781             return 0;
782         }
783         uint256 c = a * b;
784         assert(c / a == b);
785         return c;
786     }
787 
788     /**
789     * @dev Integer division of two numbers, truncating the quotient.
790     */
791     function div(uint256 a, uint256 b) internal pure returns (uint256) {
792         // assert(b > 0); // Solidity automatically throws when dividing by 0
793         uint256 c = a / b;
794         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
795         return c;
796     }
797 
798     /**
799     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
800     */
801     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
802         assert(b <= a);
803         return a - b;
804     }
805 
806     /**
807     * @dev Adds two numbers, throws on overflow.
808     */
809     function add(uint256 a, uint256 b) internal pure returns (uint256) {
810         uint256 c = a + b;
811         assert(c >= a);
812         return c;
813     }
814 }