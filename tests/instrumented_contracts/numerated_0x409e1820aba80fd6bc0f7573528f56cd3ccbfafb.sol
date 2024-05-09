1 pragma solidity ^0.4.23;
2 
3 /*
4 * Team PoPnD presents
5 
6 * ====================================*
7 * -> What?
8 * The original autonomous pyramid, improved:
9 * We left everything the same as the original P3D contract
10 *
11 *Except we increased the token increment to 0.001 ether which means 
12 *a massive price increase which wil lead to lots of Pump and Dumps.
13 *
14 *Div rate 20% in and out
15 *
16 *
17 *Proof of Crazyness ;)
18 *
19 * Enjoy the ride
20 */
21 
22 contract Linamyd {
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26     // only people with tokens
27     modifier onlyBagholders() {
28         require(myTokens() > 0);
29         _;
30     }
31     
32     // only people with profits
33     modifier onlyStronghands() {
34         require(myDividends(true) > 0);
35         _;
36     }
37     
38     // administrators can:
39     // -> change the name of the contract
40     // -> change the name of the token
41     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
42     // they CANNOT:
43     // -> take funds
44     // -> disable withdrawals
45     // -> kill the contract
46     // -> change the price of tokens
47     modifier onlyAdministrator(){
48         address _customerAddress = msg.sender;
49         require(administrators[keccak256(_customerAddress)]);
50         _;
51     }
52     
53     
54     // ensures that the first tokens in the contract will be equally distributed
55     // meaning, no divine dump will be ever possible
56     // result: healthy longevity.
57     modifier antiEarlyWhale(uint256 _amountOfEthereum){
58         address _customerAddress = msg.sender;
59         
60         // are we still in the vulnerable phase?
61         // if so, enact anti early whale protocol 
62         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
63             require(
64                 // is the customer in the ambassador list?
65                 ambassadors_[_customerAddress] == true &&
66                 
67                 // does the customer purchase exceed the max ambassador quota?
68                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
69                 
70             );
71             
72             // updated the accumulated quota    
73             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
74         
75             // execute
76             _;
77         } else {
78             // in case the ether count drops low, the ambassador phase won't reinitiate
79             onlyAmbassadors = false;
80             _;    
81         }
82         
83     }
84     
85     
86     /*==============================
87     =            EVENTS            =
88     ==============================*/
89     event onTokenPurchase(
90         address indexed customerAddress,
91         uint256 incomingEthereum,
92         uint256 tokensMinted,
93         address indexed referredBy
94     );
95     
96     event onTokenSell(
97         address indexed customerAddress,
98         uint256 tokensBurned,
99         uint256 ethereumEarned
100     );
101     
102     event onReinvestment(
103         address indexed customerAddress,
104         uint256 ethereumReinvested,
105         uint256 tokensMinted
106     );
107     
108     event onWithdraw(
109         address indexed customerAddress,
110         uint256 ethereumWithdrawn
111     );
112     
113     // ERC20
114     event Transfer(
115         address indexed from,
116         address indexed to,
117         uint256 tokens
118     );
119     
120     
121     /*=====================================
122     =            CONFIGURABLES            =
123     =====================================*/
124     string public name = "Proof of Crazyness";
125     string public symbol = "C4T";
126     uint8 constant public decimals = 18;
127     uint8 constant internal dividendFee_ = 20;
128     uint256 constant internal tokenPriceInitial_ = 0.0001 ether;
129     uint256 constant internal tokenPriceIncremental_ = 0.001 ether;
130     uint256 constant internal magnitude = 2**64;
131     
132     // proof of stake (defaults at 100 tokens)
133     uint256 public stakingRequirement = 100e18;
134     
135     // ambassador program
136     mapping(address => bool) internal ambassadors_;
137     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
138     uint256 constant internal ambassadorQuota_ = 2 ether;
139     
140     
141     
142    /*================================
143     =            DATASETS            =
144     ================================*/
145     // amount of shares for each address (scaled number)
146     mapping(address => uint256) internal tokenBalanceLedger_;
147     mapping(address => uint256) internal referralBalance_;
148     mapping(address => int256) internal payoutsTo_;
149     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
150     uint256 internal tokenSupply_ = 0;
151     uint256 internal profitPerShare_;
152     
153     // administrator list (see above on what they can do)
154     mapping(bytes32 => bool) public administrators;
155     
156     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
157     bool public onlyAmbassadors = true;
158     
159 
160 
161     /*=======================================
162     =            PUBLIC FUNCTIONS            =
163     =======================================*/
164     /*
165     * -- APPLICATION ENTRY POINTS --  
166     */
167     function Linamyd()
168         public
169     {
170         // add administrators here
171         administrators[keccak256(0xca35b7d915458ef540ade6068dfe2f44e8fa733c)] = true;
172         
173         // add the ambassadors here.
174         // mantso - lead solidity dev & lead web dev. 
175         ambassadors_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = true;
176         
177 
178     }
179     
180      
181     /**
182      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
183      */
184     function buy(address _referredBy)
185         public
186         payable
187         returns(uint256)
188     {
189         purchaseTokens(msg.value, _referredBy);
190     }
191     
192     /**
193      * Fallback function to handle ethereum that was send straight to the contract
194      * Unfortunately we cannot use a referral address this way.
195      */
196     function()
197         payable
198         public
199     {
200         purchaseTokens(msg.value, 0x0);
201     }
202     
203     /**
204      * Converts all of caller's dividends to tokens.
205      */
206     function reinvest()
207         onlyStronghands()
208         public
209     {
210         // fetch dividends
211         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
212         
213         // pay out the dividends virtually
214         address _customerAddress = msg.sender;
215         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
216         
217         // retrieve ref. bonus
218         _dividends += referralBalance_[_customerAddress];
219         referralBalance_[_customerAddress] = 0;
220         
221         // dispatch a buy order with the virtualized "withdrawn dividends"
222         uint256 _tokens = purchaseTokens(_dividends, 0x0);
223         
224         // fire event
225         onReinvestment(_customerAddress, _dividends, _tokens);
226     }
227     
228     /**
229      * Alias of sell() and withdraw().
230      */
231     function exit()
232         public
233     {
234         // get token count for caller & sell them all
235         address _customerAddress = msg.sender;
236         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
237         if(_tokens > 0) sell(_tokens);
238         
239         // lambo delivery service
240         withdraw();
241     }
242 
243     /**
244      * Withdraws all of the callers earnings.
245      */
246     function withdraw()
247         onlyStronghands()
248         public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
253         
254         // update dividend tracker
255         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
256         
257         // add ref. bonus
258         _dividends += referralBalance_[_customerAddress];
259         referralBalance_[_customerAddress] = 0;
260         
261         // lambo delivery service
262         _customerAddress.transfer(_dividends);
263         
264         // fire event
265         onWithdraw(_customerAddress, _dividends);
266     }
267     
268     /**
269      * Liquifies tokens to ethereum.
270      */
271     function sell(uint256 _amountOfTokens)
272         onlyBagholders()
273         public
274     {
275         // setup data
276         address _customerAddress = msg.sender;
277         // russian hackers BTFO
278         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279         uint256 _tokens = _amountOfTokens;
280         uint256 _ethereum = tokensToEthereum_(_tokens);
281         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
282         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
283         
284         // burn the sold tokens
285         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
286         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
287         
288         // update dividends tracker
289         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
290         payoutsTo_[_customerAddress] -= _updatedPayouts;       
291         
292         // dividing by zero is a bad idea
293         if (tokenSupply_ > 0) {
294             // update the amount of dividends per token
295             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
296         }
297         
298         // fire event
299         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
300     }
301     
302     
303     /**
304      * Transfer tokens from the caller to a new holder.
305      * Remember, there's a 10% fee here as well.
306      */
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyBagholders()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314         
315         // make sure we have the requested tokens
316         // also disables transfers until ambassador phase is over
317         // ( we dont want whale premines )
318         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
319         
320         // withdraw all outstanding dividends first
321         if(myDividends(true) > 0) withdraw();
322         
323         // liquify 10% of the tokens that are transfered
324         // these are dispersed to shareholders
325         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
326         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
327         uint256 _dividends = tokensToEthereum_(_tokenFee);
328   
329         // burn the fee tokens
330         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
331 
332         // exchange tokens
333         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
334         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
335         
336         // update dividend trackers
337         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
338         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
339         
340         // disperse dividends among holders
341         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
342         
343         // fire event
344         Transfer(_customerAddress, _toAddress, _taxedTokens);
345         
346         // ERC20
347         return true;
348        
349     }
350     
351     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
352     /**
353      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
354      */
355     function disableInitialStage()
356         onlyAdministrator()
357         public
358     {
359         onlyAmbassadors = false;
360     }
361     
362     /**
363      * In case one of us dies, we need to replace ourselves.
364      */
365     function setAdministrator(bytes32 _identifier, bool _status)
366         onlyAdministrator()
367         public
368     {
369         administrators[_identifier] = _status;
370     }
371     
372     /**
373      * Precautionary measures in case we need to adjust the masternode rate.
374      */
375     function setStakingRequirement(uint256 _amountOfTokens)
376         onlyAdministrator()
377         public
378     {
379         stakingRequirement = _amountOfTokens;
380     }
381     
382     /**
383      * If we want to rebrand, we can.
384      */
385     function setName(string _name)
386         onlyAdministrator()
387         public
388     {
389         name = _name;
390     }
391     
392     /**
393      * If we want to rebrand, we can.
394      */
395     function setSymbol(string _symbol)
396         onlyAdministrator()
397         public
398     {
399         symbol = _symbol;
400     }
401 
402     
403     /*----------  HELPERS AND CALCULATORS  ----------*/
404     /**
405      * Method to view the current Ethereum stored in the contract
406      * Example: totalEthereumBalance()
407      */
408     function totalEthereumBalance()
409         public
410         view
411         returns(uint)
412     {
413         return this.balance;
414     }
415     
416     /**
417      * Retrieve the total token supply.
418      */
419     function totalSupply()
420         public
421         view
422         returns(uint256)
423     {
424         return tokenSupply_;
425     }
426     
427     /**
428      * Retrieve the tokens owned by the caller.
429      */
430     function myTokens()
431         public
432         view
433         returns(uint256)
434     {
435         address _customerAddress = msg.sender;
436         return balanceOf(_customerAddress);
437     }
438     
439     /**
440      * Retrieve the dividends owned by the caller.
441      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
442      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
443      * But in the internal calculations, we want them separate. 
444      */ 
445     function myDividends(bool _includeReferralBonus) 
446         public 
447         view 
448         returns(uint256)
449     {
450         address _customerAddress = msg.sender;
451         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
452     }
453     
454     /**
455      * Retrieve the token balance of any single address.
456      */
457     function balanceOf(address _customerAddress)
458         view
459         public
460         returns(uint256)
461     {
462         return tokenBalanceLedger_[_customerAddress];
463     }
464     
465     /**
466      * Retrieve the dividend balance of any single address.
467      */
468     function dividendsOf(address _customerAddress)
469         view
470         public
471         returns(uint256)
472     {
473         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
474     }
475     
476     /**
477      * Return the buy price of 1 individual token.
478      */
479     function sellPrice() 
480         public 
481         view 
482         returns(uint256)
483     {
484         // our calculation relies on the token supply, so we need supply. Doh.
485         if(tokenSupply_ == 0){
486             return tokenPriceInitial_ - tokenPriceIncremental_;
487         } else {
488             uint256 _ethereum = tokensToEthereum_(1e18);
489             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
490             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
491             return _taxedEthereum;
492         }
493     }
494     
495     /**
496      * Return the sell price of 1 individual token.
497      */
498     function buyPrice() 
499         public 
500         view 
501         returns(uint256)
502     {
503         // our calculation relies on the token supply, so we need supply. Doh.
504         if(tokenSupply_ == 0){
505             return tokenPriceInitial_ + tokenPriceIncremental_;
506         } else {
507             uint256 _ethereum = tokensToEthereum_(1e18);
508             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
509             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
510             return _taxedEthereum;
511         }
512     }
513     
514     /**
515      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
516      */
517     function calculateTokensReceived(uint256 _ethereumToSpend) 
518         public 
519         view 
520         returns(uint256)
521     {
522         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
523         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
524         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
525         
526         return _amountOfTokens;
527     }
528     
529     /**
530      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
531      */
532     function calculateEthereumReceived(uint256 _tokensToSell) 
533         public 
534         view 
535         returns(uint256)
536     {
537         require(_tokensToSell <= tokenSupply_);
538         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
539         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
540         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
541         return _taxedEthereum;
542     }
543     
544     
545     /*==========================================
546     =            INTERNAL FUNCTIONS            =
547     ==========================================*/
548     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
549         antiEarlyWhale(_incomingEthereum)
550         internal
551         returns(uint256)
552     {
553         // data setup
554         address _customerAddress = msg.sender;
555         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
556         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
557         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
558         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
559         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
560         uint256 _fee = _dividends * magnitude;
561  
562         // no point in continuing execution if OP is a poorfag russian hacker
563         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
564         // (or hackers)
565         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
566         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
567         
568         // is the user referred by a masternode?
569         if(
570             // is this a referred purchase?
571             _referredBy != 0x0000000000000000000000000000000000000000 &&
572 
573             // no cheating!
574             _referredBy != _customerAddress &&
575             
576             // does the referrer have at least X whole tokens?
577             // i.e is the referrer a godly chad masternode
578             tokenBalanceLedger_[_referredBy] >= stakingRequirement
579         ){
580             // wealth redistribution
581             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
582         } else {
583             // no ref purchase
584             // add the referral bonus back to the global dividends cake
585             _dividends = SafeMath.add(_dividends, _referralBonus);
586             _fee = _dividends * magnitude;
587         }
588         
589         // we can't give people infinite ethereum
590         if(tokenSupply_ > 0){
591             
592             // add tokens to the pool
593             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
594  
595             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
596             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
597             
598             // calculate the amount of tokens the customer receives over his purchase 
599             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
600         
601         } else {
602             // add tokens to the pool
603             tokenSupply_ = _amountOfTokens;
604         }
605         
606         // update circulating supply & the ledger address for the customer
607         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
608         
609         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
610         //really i know you think you do but you don't
611         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
612         payoutsTo_[_customerAddress] += _updatedPayouts;
613         
614         // fire event
615         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
616         
617         return _amountOfTokens;
618     }
619 
620     /**
621      * Calculate Token price based on an amount of incoming ethereum
622      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
623      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
624      */
625     function ethereumToTokens_(uint256 _ethereum)
626         internal
627         view
628         returns(uint256)
629     {
630         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
631         uint256 _tokensReceived = 
632          (
633             (
634                 // underflow attempts BTFO
635                 SafeMath.sub(
636                     (sqrt
637                         (
638                             (_tokenPriceInitial**2)
639                             +
640                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
641                             +
642                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
643                             +
644                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
645                         )
646                     ), _tokenPriceInitial
647                 )
648             )/(tokenPriceIncremental_)
649         )-(tokenSupply_)
650         ;
651   
652         return _tokensReceived;
653     }
654     
655     /**
656      * Calculate token sell value.
657      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
658      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
659      */
660      function tokensToEthereum_(uint256 _tokens)
661         internal
662         view
663         returns(uint256)
664     {
665 
666         uint256 tokens_ = (_tokens + 1e18);
667         uint256 _tokenSupply = (tokenSupply_ + 1e18);
668         uint256 _etherReceived =
669         (
670             // underflow attempts BTFO
671             SafeMath.sub(
672                 (
673                     (
674                         (
675                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
676                         )-tokenPriceIncremental_
677                     )*(tokens_ - 1e18)
678                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
679             )
680         /1e18);
681         return _etherReceived;
682     }
683     
684     
685     //This is where all your gas goes, sorry
686     //Not sorry, you probably only paid 1 gwei
687     function sqrt(uint x) internal pure returns (uint y) {
688         uint z = (x + 1) / 2;
689         y = x;
690         while (z < y) {
691             y = z;
692             z = (x / z + z) / 2;
693         }
694     }
695 }
696 
697 /**
698  * @title SafeMath
699  * @dev Math operations with safety checks that throw on error
700  */
701 library SafeMath {
702 
703     /**
704     * @dev Multiplies two numbers, throws on overflow.
705     */
706     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
707         if (a == 0) {
708             return 0;
709         }
710         uint256 c = a * b;
711         assert(c / a == b);
712         return c;
713     }
714 
715     /**
716     * @dev Integer division of two numbers, truncating the quotient.
717     */
718     function div(uint256 a, uint256 b) internal pure returns (uint256) {
719         // assert(b > 0); // Solidity automatically throws when dividing by 0
720         uint256 c = a / b;
721         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
722         return c;
723     }
724 
725     /**
726     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
727     */
728     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
729         assert(b <= a);
730         return a - b;
731     }
732 
733     /**
734     * @dev Adds two numbers, throws on overflow.
735     */
736     function add(uint256 a, uint256 b) internal pure returns (uint256) {
737         uint256 c = a + b;
738         assert(c >= a);
739         return c;
740     }
741 }