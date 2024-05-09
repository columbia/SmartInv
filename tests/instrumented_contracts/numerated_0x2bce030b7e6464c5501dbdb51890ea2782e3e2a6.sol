1 pragma solidity ^0.4.20;
2  
3 /*
4 * Proof of Crypto Yoda
5 * ====================================*
6                     ____
7                  _.' :  `._
8              .-.'`.  ;   .'`.-.
9     __      / : ___\ ;  /___ ; \      __
10   ,'_ ""--.:__;".-.";: :".-.":__;.--"" _`,
11   :' `.t""--.. '<@.`;_  ',@>` ..--""j.' `;
12        `:-.._J '-.-'L__ `-- ' L_..-;'
13          "-.__ ;  .-"  "-.  : __.-"
14              L ' /.------.\ ' J
15               "-.   "--"   .-"
16              __.l"-:_JL_;-";.__
17           .-j/'.;  ;""""  / .'\"-.
18         .' /:`. "-.:     .-" .';  `.
19      .-"  / ;  "-. "-..-" .-"  :    "-.
20   .+"-.  : :      "-.__.-"      ;-._   \
21   ; \  `.; ;                    : : "+. ;
22   :  ;   ; ;                    : ;  : \:
23  : `."-; ;  ;                  :  ;   ,/;
24   ;    -: ;  :                ;  : .-"'  :
25   :\     \  : ;             : \.-"      :
26    ;`.    \  ; :            ;.'_..--  / ;
27    :  "-.  "-:  ;          :/."      .'  :
28      \       .-`.\        /t-""  ":-+.   :
29       `.  .-"    `l    __/ /`. :  ; ; \  ;
30         \   .-" .-"-.-"  .' .'j \  /   ;/
31          \ / .-"   /.     .'.' ;_:'    ;
32           :-""-.`./-.'     /    `.___.'
33                 \ `t  ._  /      :F_P:
34                  "-.t-._:'
35 * ====================================*
36 * On twitter, you follow. https://twitter.com/CryptoYoda1338
37 * https://www.pocy.io/
38 * No transfer fees, no bullshit. 1 eth MAX dev premine, public launch, website up and tweet May 4 @ 4:00 am UTC
39 * May the 4th be with you!*/
40  
41 contract POCY {
42     /*=================================
43     =            MODIFIERS            =
44     =================================*/
45     // only people with tokens
46     modifier onlyBagholders() {
47         require(myTokens() > 0);
48         _;
49     }
50  
51     // only people with profits
52     modifier onlyStronghands() {
53         require(myDividends(true) > 0);
54         _;
55     }
56  
57     // administrators can:
58     // -> change the name of the contract
59     // -> change the name of the token
60     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
61     // they CANNOT:
62     // -> take funds
63     // -> disable withdrawals
64     // -> kill the contract
65     // -> change the price of tokens
66     modifier onlyAdministrator(){
67         address _customerAddress = msg.sender;
68         require(administrators[_customerAddress]);
69         _;
70     }
71  
72  
73     // ensures that the first tokens in the contract will be equally distributed
74     // meaning, no divine dump will be ever possible
75     // result: healthy longevity.
76     modifier antiEarlyWhale(uint256 _amountOfEthereum){
77         address _customerAddress = msg.sender;
78  
79         // are we still in the vulnerable phase?
80         // if so, enact anti early whale protocol
81         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
82             require(
83                 // is the customer in the ambassador list?
84                 ambassadors_[_customerAddress] == true &&
85  
86                 // does the customer purchase exceed the max ambassador quota?
87                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
88  
89             );
90  
91             // updated the accumulated quota
92             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
93  
94             // execute
95             _;
96         } else {
97             // in case the ether count drops low, the ambassador phase won't reinitiate
98             onlyAmbassadors = false;
99             _;
100         }
101  
102     }
103  
104  
105     /*==============================
106     =            EVENTS            =
107     ==============================*/
108     event onTokenPurchase(
109         address indexed customerAddress,
110         uint256 incomingEthereum,
111         uint256 tokensMinted,
112         address indexed referredBy
113     );
114  
115     event onTokenSell(
116         address indexed customerAddress,
117         uint256 tokensBurned,
118         uint256 ethereumEarned
119     );
120  
121     event onReinvestment(
122         address indexed customerAddress,
123         uint256 ethereumReinvested,
124         uint256 tokensMinted
125     );
126  
127     event onWithdraw(
128         address indexed customerAddress,
129         uint256 ethereumWithdrawn
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
143     string public name = "POCY";
144     string public symbol = "POCY";
145     uint8 constant public decimals = 18;
146     uint8 constant internal dividendFee_ = 50; // May the dividends be with you.
147     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
148     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
149     uint256 constant internal magnitude = 2**64;
150  
151     // proof of stake (defaults at 100 tokens)
152     uint256 public stakingRequirement = 100e18;
153  
154     // ambassador program
155     mapping(address => bool) internal ambassadors_;
156     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
157     uint256 constant internal ambassadorQuota_ = 3 ether;
158  
159  
160  
161    /*================================
162     =            DATASETS            =
163     ================================*/
164     // amount of shares for each address (scaled number)
165     mapping(address => uint256) internal tokenBalanceLedger_;
166     mapping(address => uint256) internal referralBalance_;
167     mapping(address => int256) internal payoutsTo_;
168     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
169     uint256 internal tokenSupply_ = 0;
170     uint256 internal profitPerShare_;
171  
172     // administrator list (see above on what they can do)
173     mapping(address => bool) public administrators;
174  
175     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
176     bool public onlyAmbassadors = true;
177  
178  
179  
180     /*=======================================
181     =            PUBLIC FUNCTIONS            =
182     =======================================*/
183     /*
184     * -- APPLICATION ENTRY POINTS --
185     */
186     function POCY()
187         public
188     {
189         // add administrators here
190         administrators[0x862dEd83F3652b4c0E6AF26A4e92F25B09def61E] = true;
191     }
192  
193     /**
194      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
195      */
196     function buy(address _referredBy)
197         public
198         payable
199         returns(uint256)
200     {
201         purchaseTokens(msg.value, _referredBy);
202     }
203  
204     /**
205      * Fallback function to handle ethereum that was send straight to the contract
206      * Unfortunately we cannot use a referral address this way.
207      */
208     function()
209         payable
210         public
211     {
212         purchaseTokens(msg.value, 0x0);
213     }
214  
215     /**
216      * Converts all of caller's dividends to tokens.
217     */
218     function reinvest()
219         onlyStronghands()
220         public
221     {
222         // fetch dividends
223         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
224  
225         // pay out the dividends virtually
226         address _customerAddress = msg.sender;
227         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
228  
229         // retrieve ref. bonus
230         _dividends += referralBalance_[_customerAddress];
231         referralBalance_[_customerAddress] = 0;
232  
233         // dispatch a buy order with the virtualized "withdrawn dividends"
234         uint256 _tokens = purchaseTokens(_dividends, 0x0);
235  
236         // fire event
237         onReinvestment(_customerAddress, _dividends, _tokens);
238     }
239  
240     /**
241      * Alias of sell() and withdraw().
242      */
243     function exit()
244         public
245     {
246         // get token count for caller & sell them all
247         address _customerAddress = msg.sender;
248         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
249         if(_tokens > 0) sell(_tokens);
250  
251         // lambo delivery service
252         withdraw();
253     }
254  
255     /**
256      * Withdraws all of the callers earnings.
257      */
258     function withdraw()
259         onlyStronghands()
260         public
261     {
262         // setup data
263         address _customerAddress = msg.sender;
264         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
265  
266         // update dividend tracker
267         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
268  
269         // add ref. bonus
270         _dividends += referralBalance_[_customerAddress];
271         referralBalance_[_customerAddress] = 0;
272  
273         // lambo delivery service
274         _customerAddress.transfer(_dividends);
275  
276         // fire event
277         onWithdraw(_customerAddress, _dividends);
278     }
279  
280     /**
281      * Liquifies tokens to ethereum.
282      */
283     function sell(uint256 _amountOfTokens)
284         onlyBagholders()
285         public
286     {
287         // setup data
288         address _customerAddress = msg.sender;
289         // russian hackers BTFO
290         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
291         uint256 _tokens = _amountOfTokens;
292         uint256 _ethereum = tokensToEthereum_(_tokens);
293         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
294         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
295  
296         // burn the sold tokens
297         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
298         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
299  
300         // update dividends tracker
301         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
302         payoutsTo_[_customerAddress] -= _updatedPayouts;
303  
304         // dividing by zero is a bad idea
305         if (tokenSupply_ > 0) {
306             // update the amount of dividends per token
307             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
308         }
309  
310         // fire event
311         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
312     }
313  
314  
315     /**
316      * Transfer tokens from the caller to a new holder.
317      * Remember, there's a 10% fee here as well.
318      */
319     function transfer(address _toAddress, uint256 _amountOfTokens)
320         onlyBagholders()
321         public
322         returns(bool)
323     {
324         // setup
325         address _customerAddress = msg.sender;
326  
327         // make sure we have the requested tokens
328         // also disables transfers until ambassador phase is over
329         // ( we dont want whale premines )
330         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
331  
332         // withdraw all outstanding dividends first
333         if(myDividends(true) > 0) withdraw();
334  
335         // exchange tokens
336         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
337         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
338  
339         // update dividend trackers
340         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
341         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
342  
343         // fire event
344         Transfer(_customerAddress, _toAddress, _amountOfTokens);
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
365     function setAdministrator(address _identifier, bool _status)
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